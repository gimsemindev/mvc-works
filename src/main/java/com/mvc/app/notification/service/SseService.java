package com.mvc.app.notification.service;

import com.mvc.app.notification.dto.NotificationDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class SseService implements SmartLifecycle {

    // 접속 중인 사용자 Emitter 보관 (empId → SseEmitter)
    private final Map<String, SseEmitter> emitterMap = new ConcurrentHashMap<>();

    // SmartLifecycle 실행 상태 플래그
    private volatile boolean running = false;

    //SSE 연결 등록
    public SseEmitter connect(String empId) {
        // 기존 연결이 있으면 먼저 종료
        SseEmitter existing = emitterMap.get(empId);
        if (existing != null) {
            existing.complete();
            emitterMap.remove(empId);
        }

        SseEmitter emitter = new SseEmitter(0L);

        // 연결 종료 / 타임아웃 / 에러 시 Map에서 제거
        emitter.onCompletion(() -> {
            emitterMap.remove(empId);
            log.debug("[SSE] 연결 종료 empId={}", empId);
        });
        emitter.onTimeout(() -> {
            emitterMap.remove(empId);
            log.debug("[SSE] 타임아웃 empId={}", empId);
        });
        emitter.onError(e -> {
            emitterMap.remove(empId);
            log.debug("[SSE] 에러 empId={} error={}", empId, e.getMessage());
        });

        emitterMap.put(empId, emitter);

        // 연결 직후 더미 이벤트 전송 (브라우저 연결 확인용)
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("connected"));
        } catch (IOException e) {
            emitterMap.remove(empId);
        }

        log.debug("[SSE] 연결 등록 empId={} 현재 접속자={}", empId, emitterMap.size());
        return emitter;
    }

    //특정 사용자에게 알림 push

    public void push(String receiverId, NotificationDto dto) {
        SseEmitter emitter = emitterMap.get(receiverId);
        if (emitter == null) {
            log.debug("[SSE] 수신자 미접속 receiverId={}", receiverId);
            return;
        }
        try {
            emitter.send(SseEmitter.event()
                    .name("notification")
                    .data(dto));
            log.debug("[SSE] push 완료 receiverId={} notiType={}", receiverId, dto.getNotiType());
        } catch (IOException e) {
            emitterMap.remove(receiverId);
            log.warn("[SSE] push 실패 receiverId={} error={}", receiverId, e.getMessage());
        }
    }

    //현재 접속 중인 사용자 수 (모니터링용)
    public int getConnectedCount() {
        return emitterMap.size();
    }

    //SmartLifecycle
    //애플리케이션 컨텍스트 시작 시 호출
    @Override
    public void start() {
        running = true;
        log.info("[SSE] SseService 시작");
    }

    @Override
    public void stop() {
        log.info("[SSE] 서버 종료 감지 — SSE 연결 정리 시작, 활성 연결 수: {}", emitterMap.size());
        emitterMap.values().forEach(emitter -> {
            try {
                emitter.complete();
            } catch (Exception ignored) {
                // 이미 닫힌 연결은 무시
            }
        });
        emitterMap.clear();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        running = false;
        log.info("[SSE] SSE 연결 정리 완료");
    }

    @Override
    public boolean isRunning() {
        return running;
    }

    @Override
    public int getPhase() {
        return Integer.MAX_VALUE - 1;
    }
}