package com.mvc.app.group.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatFileDto {

    private Long   fileId;
    private Long   messageId;
    private Long   roomId;
    private String uploaderId;
    private String originalName;
    private String saveName;
    private long   fileSize;
    private String fileExt;
    private String uploadedAt;
    private String expireAt;
}
