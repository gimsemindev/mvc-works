package com.mvc.app.aop.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mvc.app.aop.common.ActionType;
import com.mvc.app.aop.dto.ActivityLogDto;
import com.mvc.app.aop.mapper.ActivityLogMapper;
import com.mvc.app.domain.dto.HrmDto;
import com.mvc.app.domain.dto.SessionInfo;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 직원관리 활동 로그 AOP
 *
 *  	  HrmServiceImpl
 *    	insertEmployee
 *    	updateEmployee
 *    	updateEmployees
 *    	deleteEmployees
 *    	importExcel
 */
@Aspect
@Component
@RequiredArgsConstructor
@Slf4j
public class HrmActivityAspect {

    private final ActivityLogMapper activityLogMapper;
    private final ObjectMapper      objectMapper;       //자동 Bean 등록

    //Pointcut
    private static final String POINTCUT_INSERT  =
            "execution(* com.mvc.app.service.HrmServiceImpl.insertEmployee(..))";
    private static final String POINTCUT_UPDATE  =
            "execution(* com.mvc.app.service.HrmServiceImpl.updateEmployee(..))";
    private static final String POINTCUT_BULK    =
            "execution(* com.mvc.app.service.HrmServiceImpl.updateEmployees(..))";
    private static final String POINTCUT_DELETE  =
            "execution(* com.mvc.app.service.HrmServiceImpl.deleteEmployees(..))";
    private static final String POINTCUT_EXCEL   =
            "execution(* com.mvc.app.service.HrmServiceImpl.importExcel(..))";

    //직원 단건 등록

    @Around(POINTCUT_INSERT)
    public Object logInsert(ProceedingJoinPoint pjp) throws Throwable {
        HrmDto dto = (HrmDto) pjp.getArgs()[0];
        return executeWithLog(pjp, ActionType.INSERT, dto.getEmpId(), null, dto);
    }

    //직원 단건 수정
    @Around(POINTCUT_UPDATE)
    public Object logUpdate(ProceedingJoinPoint pjp) throws Throwable {
        HrmDto dto = (HrmDto) pjp.getArgs()[0];
        return executeWithLog(pjp, ActionType.UPDATE, dto.getEmpId(), null, dto);
    }

    //직원 벌크 수정
    @Around(POINTCUT_BULK)
    public Object logBulkUpdate(ProceedingJoinPoint pjp) throws Throwable {
        @SuppressWarnings("unchecked")
        List<HrmDto> dtoList = (List<HrmDto>) pjp.getArgs()[0];

        // 대상 사원번호 콤마 구분 문자열
        String targetIds = dtoList.stream()
                .map(HrmDto::getEmpId)
                .collect(Collectors.joining(","));

        return executeWithLog(pjp, ActionType.BULK_UPDATE, targetIds, null, dtoList);
    }

    //직원 선택 삭제
    @Around(POINTCUT_DELETE)
    public Object logDelete(ProceedingJoinPoint pjp) throws Throwable {
        @SuppressWarnings("unchecked")
        List<String> ids = (List<String>) pjp.getArgs()[0];
        String targetIds = String.join(",", ids);

        return executeWithLog(pjp, ActionType.DELETE, targetIds, null, null);
    }

    //엑셀 업로드 일괄 등록
    @Around(POINTCUT_EXCEL)
    public Object logExcelImport(ProceedingJoinPoint pjp) throws Throwable {
        return executeWithLog(pjp, ActionType.EXCEL_IMPORT, null, null, null);
    }

    //로그 저장 메서드
    private Object executeWithLog(ProceedingJoinPoint pjp,
                                  String actionType,
                                  String targetEmpIds,
                                  Object beforeObj,
                                  Object afterObj) throws Throwable {

        // 수행자 세션
        SessionInfo actor = getSessionInfo();

        Object result     = null;
        String resultCode = "SUCCESS";
        String errorMsg   = null;
        String afterJson  = null;

        try {
            result = pjp.proceed();

            if (afterObj != null) {
                afterJson = toJson(afterObj);
            }
            if (ActionType.EXCEL_IMPORT.equals(actionType) && result instanceof Integer cnt) {
                afterJson = "{\"importedCount\":" + cnt + "}";
            }

        } catch (Throwable ex) {
            resultCode = "FAIL";
            errorMsg   = truncate(ex.getMessage(), 2000);
            throw ex;

        } finally {
            //로그 저장
            try {
                ActivityLogDto logDto = ActivityLogDto.builder()
                        .actorEmpId (actor != null ? actor.getEmpId()  : "UNKNOWN")
                        .actorName  (actor != null ? actor.getName()   : "UNKNOWN")
                        .actionType (actionType)
                        .targetMenu ("HRM")
                        .targetEmpIds(targetEmpIds)
                        .beforeData (beforeObj != null ? toJson(beforeObj) : null)
                        .afterData  (afterJson)
                        .result     (resultCode)
                        .errorMsg   (errorMsg)
                        .ipAddr     (getClientIp())
                        .build();

                activityLogMapper.insertActivityLog(logDto);

            } catch (Exception logEx) {
                // 로그 저장 실패는 경고만 남기고 무시
                log.warn("[HrmActivityAspect] 활동 로그 저장 실패 action={} error={}",
                        actionType, logEx.getMessage());
            }
        }

        return result;
    }

    //세션에서 현재 로그인 사원 정보 조회
    private SessionInfo getSessionInfo() {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null) return null;

            HttpSession session = attrs.getRequest().getSession(false);
            if (session == null) return null;

            return (SessionInfo) session.getAttribute("member");
        } catch (Exception e) {
            log.warn("[HrmActivityAspect] 세션 조회 실패: {}", e.getMessage());
            return null;
        }
    }

    // ── 클라이언트 IP 조회 Proxy
    private String getClientIp() {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null) return null;

            HttpServletRequest req = attrs.getRequest();

            // X-Forwarded-For > Proxy-Client-IP > WL-Proxy-Client-IP > RemoteAddr
            String[] headers = {
                "X-Forwarded-For", "Proxy-Client-IP",
                "WL-Proxy-Client-IP", "HTTP_CLIENT_IP", "HTTP_X_FORWARDED_FOR"
            };
            for (String header : headers) {
                String ip = req.getHeader(header);
                if (ip != null && !ip.isBlank() && !"unknown".equalsIgnoreCase(ip)) {
                    
                    return ip.split(",")[0].trim();
                }
            }
            return req.getRemoteAddr();

        } catch (Exception e) {
            return null;
        }
    }

    //객체 -> JSON 변환
    private String toJson(Object obj) {
        try {
            String json = objectMapper.writeValueAsString(obj);
            // 비밀번호가 JSON 에 포함되면 마스킹 처리
            return json.replaceAll("(?i)(\"password\"\\s*:\\s*\")([^\"]+)(\")", "$1********$3");
        } catch (Exception e) {
            return "{\"error\":\"직렬화 실패\"}";
        }
    }

    //문자열 길이 제한
    private String truncate(String s, int maxLen) {
        if (s == null) return null;
        return s.length() <= maxLen ? s : s.substring(0, maxLen);
    }
}
