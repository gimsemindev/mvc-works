package com.mvc.app.notification.listener;

import com.mvc.app.notification.entity.NotificationEntity;
import com.mvc.app.notification.event.NotificationEvent;
import com.mvc.app.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

//알림 이벤트 리스너

@Slf4j
@Component
@RequiredArgsConstructor
public class NotificationEventListener {

    private final NotificationService notificationService;

    //결재 알림
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onApproval(NotificationEvent.Approval event) {
        try {
            String msg;
            switch (event.getActionType()) {
                case "SUBMIT"  -> msg = event.getSenderName() + "님이 결재를 요청했습니다.";
                case "APPROVE"      -> msg = event.getSenderName() + "님이 승인했습니다.";
                case "APPROVE_NEXT" -> msg = event.getSenderName() + "님이 승인했습니다. 결재를 진행해 주세요.";
                case "APPROVE_FINAL" -> msg = event.getSenderName() + "님이 최종 승인했습니다. 결재가 완료되었습니다.";
                case "REJECT"  -> msg = event.getSenderName() + "님이 반려했습니다.";
                case "HOLD"    -> msg = event.getSenderName() + "님이 보류했습니다.";
                case "REF" -> msg = event.getSenderName() + "님이 참조 문서를 보냈습니다.";
                default        -> msg = event.getSenderName() + "님이 결재를 처리했습니다.";
            }
        	 	
            NotificationEntity entity = NotificationEntity.builder()
                    .receiverId (event.getReceiverId())
                    .senderId   (event.getSenderId())
                    .senderName (event.getSenderName())
                    .notiType   ("APPROVAL")
                    .title      ("[결재] " + event.getDocTitle())
                    .message    (msg)
                    .targetType ("APPROVAL_DOC")
                    .targetId   (String.valueOf(event.getDocId()))
                    .targetUrl  ("/approval/view?docId=" + event.getDocId())
                    .moveType   ("VUE")
                    .build();

            notificationService.saveAndPush(entity);
        } catch (Exception e) {
            log.warn("[NotificationEventListener] 결재 알림 실패 error={}", e.getMessage());
        }
    }

    //프로젝트 알림
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onProject(NotificationEvent.Project event) {
        try {
            NotificationEntity entity = NotificationEntity.builder()
                    .receiverId (event.getReceiverId())
                    .senderId   (event.getSenderId())
                    .senderName (event.getSenderName())
                    .notiType   ("PROJECT")
                    .title      ("[프로젝트] " + event.getProjectName())
                    .message    (event.getMessage())
                    .targetType ("PROJECT_GANTT")
                    .targetId   (null)
                    .targetUrl  ("/projects/ganttarticle")
                    .moveType   ("PAGE")
                    .build();

            notificationService.saveAndPush(entity);
        } catch (Exception e) {
            log.warn("[NotificationEventListener] 프로젝트 알림 실패 error={}", e.getMessage());
        }
    }

    //권한 변동 알림
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onAuth(NotificationEvent.Auth event) {
        try {
            NotificationEntity entity = NotificationEntity.builder()
                    .receiverId (event.getReceiverId())
                    .senderId   (event.getSenderId())
                    .senderName (event.getSenderName())
                    .notiType   ("AUTH")
                    .title      ("[권한변경] " + event.getBeforeAuthName() + " → " + event.getAfterAuthName())
                    .message    ("권한이 변경되었습니다.")
                    .targetType (null)
                    .targetId   (null)
                    .targetUrl  (null)
                    .moveType   ("NONE")
                    .build();

            notificationService.saveAndPush(entity);
        } catch (Exception e) {
            log.warn("[NotificationEventListener] 권한 알림 실패 error={}", e.getMessage());
        }
    }

    //보고서 피드백 알림
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onFeedback(NotificationEvent.Feedback event) {
        try {
            NotificationEntity entity = NotificationEntity.builder()
                    .receiverId (event.getReceiverId())
                    .senderId   (event.getSenderId())
                    .senderName (event.getSenderName())
                    .notiType   ("FEEDBACK")
                    .title      ("[피드백] " + event.getReportTitle())
                    .message    (event.getSenderName() + "님이 피드백을 작성했습니다.")
                    .targetType ("WEEKLY_REPORT")
                    .targetId   (String.valueOf(event.getFilenum()))
                    .targetUrl  ("/report/detail?filenum=" + event.getFilenum())
                    .moveType   ("PAGE")
                    .build();

            notificationService.saveAndPush(entity);
        } catch (Exception e) {
            log.warn("[NotificationEventListener] 피드백 알림 실패 error={}", e.getMessage());
        }
    }

    //채팅 알림
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onChat(NotificationEvent.Chat event) {
        try {
            // 채팅 URL 미구현: roomId 있으면 URL 구성, 없으면 null
            String targetUrl = (event.getRoomId() != null)
                    ? "/chat/room/" + event.getRoomId()
                    : null;

            NotificationEntity entity = NotificationEntity.builder()
                    .receiverId (event.getReceiverId())
                    .senderId   (event.getSenderId())
                    .senderName (event.getSenderName())
                    .notiType   ("CHAT")
                    .title      ("[채팅] " + event.getSenderName())
                    .message    (event.getPreview())
                    .targetType ("CHAT_ROOM")
                    .targetId   (event.getRoomId())
                    .targetUrl  (targetUrl)
                    .moveType   ("VUE")
                    .build();

            notificationService.saveAndPush(entity);
        } catch (Exception e) {
            log.warn("[NotificationEventListener] 채팅 알림 실패 error={}", e.getMessage());
        }
    }
}
