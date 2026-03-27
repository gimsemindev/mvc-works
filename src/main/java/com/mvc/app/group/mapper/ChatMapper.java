package com.mvc.app.group.mapper;

import com.mvc.app.group.dto.ChatFileDto;
import com.mvc.app.group.dto.ChatMessageDto;
import com.mvc.app.group.dto.ChatRoomDto;
import com.mvc.app.group.dto.ChatUserDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMapper {

    //직원 목록
    List<ChatUserDto> listChatUsers(ChatUserDto params);

    //프로젝트 목록
    List<Map<String, Object>> listMyProjects(@Param("empId") String empId);

    //채팅방
    ChatRoomDto findRoomByUsers(@Param("userAid") String userAid,
                                @Param("userBid") String userBid);

    // 채팅방 생성
    void insertRoom(ChatRoomDto dto);

    // 채팅방 참여자 등록
    void insertRoomMember(@Param("memberId") Long memberId,
                          @Param("roomId")   Long roomId,
                          @Param("empId")    String empId);

    // 다음 memberId 시퀀스
    Long nextRoomMemberSeq();

    // 채팅방 참여자 검증 (본인 채팅방인지 확인)
    int countRoomMember(@Param("roomId") Long roomId,
                        @Param("empId")  String empId);

    // 채팅방 마지막 메시지 시각 갱신
    void updateRoomLastMessageAt(@Param("roomId") Long roomId);

    // 다음 roomId 시퀀스
    Long nextRoomSeq();

    //채팅 메시지
    // 메시지 저장
    void insertMessage(ChatMessageDto dto);

    // 다음 messageId 시퀀스
    Long nextMessageSeq();

    // 채팅방 메시지 조회 (최신 20건)
    List<ChatMessageDto> listMessages(@Param("roomId")    Long roomId,
                                      @Param("offset")    int  offset,
                                      @Param("size")      int  size);

    // 상대방이 보낸 미읽음 메시지 일괄 읽음 처리
    void markAsRead(@Param("roomId")   Long   roomId,
                    @Param("empId")    String empId);   // 읽는 사람 empId

    // 특정 메시지 읽음 처리
    void markMessageRead(@Param("messageId") Long messageId);

    // 미읽음 메시지 수 조회
    int countUnread(@Param("roomId") Long   roomId,
                    @Param("empId")  String empId);

    // 전송 실패 상태 업데이트
    void updateMessageStatus(@Param("messageId") Long   messageId,
                             @Param("status")    String status);

    // 7일 만료 메시지 삭제 (스케줄러)
    int deleteExpiredMessages();

    /* ── 채팅 파일 ── */
    // 파일 정보 저장
    void insertFile(ChatFileDto dto);

    // 다음 fileId 시퀀스
    Long nextFileSeq();

    // 파일 단건 조회 (다운로드)
    ChatFileDto findFileById(@Param("fileId") Long fileId);

    // 만료 파일 삭제 (스케줄러)
    int deleteExpiredFiles();

    // 만료된 파일 목록 조회 (물리 파일 삭제용)
    List<ChatFileDto> listExpiredFiles();
}
