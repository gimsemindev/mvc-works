package com.mvc.app.group.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatUserDto {

    /* 직원 기본 정보 */
    private String empId;
    private String name;
    private String profilePhoto;
    private String deptCode;
    private String deptName;
    private String gradeCode;
    private String gradeName;
    private String empStatusCode;
    private String empStatusName;

    /* 채팅 요약 정보 */
    private Long   roomId;
    private String lastMessage;         // 가장 최근 메시지 내용
    private String lastMessageType;     // TEXT / FILE
    private String lastSenderId;        // 가장 최근 메시지 발신자 empId
    private String lastMessageAt;       // 가장 최근 메시지 시각
    private int    unreadCount;         // 미읽음 수 (나 기준)

    /* 온라인 상태 (세션 기반, 서버에서 주입) */
    private String onlineStatus;        // online / offline

    /* 검색 / 필터 파라미터 */
    private String projectId;           // 프로젝트 필터
    private String keyword;             // 이름 or 사원번호 검색
    private String myEmpId;             // 로그인 사원번호 (자신 제외용)

    /* 무한 스크롤 페이징 */
    private int offset;
    private int size;
}