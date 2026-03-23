package com.mvc.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class SnackCommentDto {
    private long   commentId;      // 댓글 고유번호 (PK)
    private long   snackId;        // 신청 번호 (FK)
    private String content;        // 댓글 내용
    private String regDate;        // 작성일
    private String authorEmpId;    // 작성자 사원번호
    private String authorName;     // 작성자 이름 (JOIN)
}
