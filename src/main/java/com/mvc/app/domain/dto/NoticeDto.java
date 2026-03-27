package com.mvc.app.domain.dto;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class NoticeDto {
    private long   noticenum;
    private String subject;
    private String content;
    private int    hitcount;
    private String regdate;
    private String updateDate;
    private int    isnotice;
    private int    state;

    private String authorEmpId;
    private String authorName;

    private List<NoticeFileDto> files;
    private int fileCount;
    private Long firstFilenum;
}

