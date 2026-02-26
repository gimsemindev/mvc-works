package com.mvc.app.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// 세션에 저장할 정보(사원번호, 이름, 역할(권한) 등)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionInfo {
	private String empId;       // 사원번호 (로그인 ID)
	private String password;
	private String name;
	private String email;
	private int userLevel;
	private String avatar;      // profilePhoto
}
