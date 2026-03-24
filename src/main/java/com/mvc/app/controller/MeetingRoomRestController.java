package com.mvc.app.controller;

import com.mvc.app.domain.dto.MeetingRoomDto;
import com.mvc.app.domain.dto.SessionInfo;
import com.mvc.app.security.LoginMemberUtil;
import com.mvc.app.service.MeetingRoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/meeting/room")
@RequiredArgsConstructor
@Slf4j
public class MeetingRoomRestController {

    private final MeetingRoomService meetingRoomService;

    private boolean isAdmin() {
        SessionInfo info = LoginMemberUtil.getSessionInfo();
        return info != null && info.getUserLevel() == 99;
    }

    @GetMapping
    public ResponseEntity<?> list() {
        try {
            List<MeetingRoomDto> list = meetingRoomService.listRoom();
            return ResponseEntity.ok(Map.of("list", list));
        } catch (Exception e) {
            log.info("list : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "목록 조회에 실패했습니다."));
        }
    }

    @GetMapping("/{roomId}")
    public ResponseEntity<?> get(@PathVariable("roomId") long roomId) {
        try {
            MeetingRoomDto dto = meetingRoomService.getRoom(roomId);
            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            log.info("get : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "조회에 실패했습니다."));
        }
    }

    @PutMapping("/sort")
    public ResponseEntity<?> updateSort(@RequestBody List<MeetingRoomDto> list) {
        try {
            if (!isAdmin()) {
                return ResponseEntity.status(403).body(Map.of("msg", "관리자만 회의실을 관리할 수 있습니다."));
            }
            meetingRoomService.updateSortOrders(list);
            return ResponseEntity.ok(Map.of("msg", "순서 변경 완료"));
        } catch (Exception e) {
            log.info("updateSort : ", e);
            return ResponseEntity.internalServerError().body(Map.of("msg", "순서 변경 실패"));
        }
    }

    @PostMapping
    public ResponseEntity<?> insert(
            @RequestPart("data") MeetingRoomDto dto,
            @RequestPart(value = "photos", required = false) MultipartFile[] photos) {
        try {
            if (!isAdmin()) {
                return ResponseEntity.status(403).body(Map.of("msg", "관리자만 회의실을 관리할 수 있습니다."));
            }
            meetingRoomService.insertRoom(dto, photos);
            return ResponseEntity.ok(Map.of("msg", "등록 완료"));
        } catch (Exception e) {
            log.info("insert : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "등록에 실패했습니다."));
        }
    }

    @PutMapping("/{roomId}")
    public ResponseEntity<?> update(
            @PathVariable("roomId") long roomId,
            @RequestPart("data") MeetingRoomDto dto,
            @RequestPart(value = "photos", required = false) MultipartFile[] photos) {
        try {
            if (!isAdmin()) {
                return ResponseEntity.status(403).body(Map.of("msg", "관리자만 회의실을 관리할 수 있습니다."));
            }
            dto.setRoomId(roomId);
            meetingRoomService.updateRoom(dto, photos);
            return ResponseEntity.ok(Map.of("msg", "수정 완료"));
        } catch (Exception e) {
            log.info("update : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "수정에 실패했습니다."));
        }
    }

    @DeleteMapping("/{roomId}")
    public ResponseEntity<?> delete(@PathVariable("roomId") long roomId) {
        try {
            if (!isAdmin()) {
                return ResponseEntity.status(403).body(Map.of("msg", "관리자만 회의실을 관리할 수 있습니다."));
            }
            meetingRoomService.deleteRoom(roomId);
            return ResponseEntity.ok(Map.of("msg", "삭제 완료"));
        } catch (Exception e) {
            log.info("delete : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "삭제에 실패했습니다."));
        }
    }
}
