package com.mvc.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class SnackDto {
    private long   snackId;        // 신청 고유번호 (PK)
    private String itemName;       // 품목명
    private int    quantity;       // 수량
    private String reason;         // 신청 이유
    private String status;         // 상태: PENDING / APPROVED / REJECTED
    private String regDate;        // 신청일
    private String updateDate;     // 처리일
    private String requesterEmpId; // 신청자 사원번호
    private String requesterName;  // 신청자 이름 (JOIN)
    private String adminComment;   // 관리자 코멘트 (승인/반려 사유)
    private int    voteCount;      // 공감 수
    private boolean voted;         // 현재 사용자 공감 여부
    private int    commentCount;
    private List<SnackCommentDto> comments; // 댓글 목록
}
