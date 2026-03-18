package com.mvc.app.group.service;

import com.mvc.app.group.dto.ChatFileDto;
import com.mvc.app.group.dto.ChatMessageDto;
import com.mvc.app.group.dto.ChatRoomDto;
import com.mvc.app.group.dto.ChatUserDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface ChatService {

    /* ── 직원 목록 ── */
    List<ChatUserDto> listChatUsers(ChatUserDto params);

    /* ── 프로젝트 목록 ── */
    List<Map<String, Object>> listMyProjects(String empId);

    /* ── 채팅방 ── */
    // 두 사용자 간 채팅방 조회 또는 신규 생성
    ChatRoomDto getOrCreateRoom(String myEmpId, String targetEmpId);

    // 채팅방 참여자 검증
    boolean isRoomMember(Long roomId, String empId);

    /* ── 메시지 ── */
    // 텍스트 메시지 저장
    ChatMessageDto saveMessage(ChatMessageDto dto);

    // 메시지 목록 조회 (무한스크롤)
    List<ChatMessageDto> listMessages(Long roomId, int offset, int size);

    // 입장 시 미읽음 일괄 읽음 처리
    void markAsRead(Long roomId, String empId);

    /* ── 파일 ── */
    // 파일 업로드 후 메시지 저장
    ChatMessageDto saveFileMessage(Long roomId, String senderId,
                                   MultipartFile file) throws Exception;

    // 파일 다운로드
    ResponseEntity<?> downloadFile(Long fileId) throws Exception;
}
