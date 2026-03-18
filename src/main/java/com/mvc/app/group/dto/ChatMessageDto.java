package com.mvc.app.group.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatMessageDto {

    private Long   messageId;
    private Long   roomId;
    private String senderId;
    private String senderName;
    private String senderAvatar;
    private String msgType;         // 텍스트, 파일
    private String content;
    private String sentAt;
    private String isRead;          //읽음(y), 미읽음(n)
    private String status;          // SENT / FAILED / DELETED
    private String expireAt;

    /* 파일 메시지 */
    private Long   fileId;
    private String originalName;
    private String saveName;
    private long   fileSize;
    private String fileExt;

    /* 클라이언트 전송 */
    private String type;            // CHAT / READ / ENTER / LEAVE / ERROR
    private String targetEmpId;     // 상대방 empId (방 생성, 조회용)
}
