package com.mvc.app.group.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatRoomDto {

    private Long   roomId;
    private String userAid;
    private String userBid;
    private String createdAt;
    private String lastMessageAt;
    private String status;          // ACTIVE / CLOSED

    /* 직원 목록 */
    private String empId;
    private String name;
    private String profilePhoto;
    private String deptCode;
    private String deptName;
    private String gradeCode;
    private String gradeName;
    private String empStatusCode;
    private String empStatusName;
    private String onlineStatus;    // 온라인, 오프라인

    /* 채팅방 요약 */
    private String  lastMessage;        // 가장 최근 메시지 내용
    private String  lastMessageType;    // TEXT / FILE
    private int     unreadCount;        // 자기 자신의 미 읽음 수

    /* 참여 프로젝트 */
    private String projectId;
    private String projectName;
}