package com.mvc.app.mapper;

import java.sql.SQLException;

import org.apache.ibatis.annotations.Mapper;

import com.mvc.app.domain.dto.ApprovalDocDto;
import com.mvc.app.domain.dto.ApprovalFileDto;
import com.mvc.app.domain.dto.ApprovalLineDto;
import com.mvc.app.domain.dto.ApprovalRefDto;

@Mapper
public interface ApprovalDocMapper {
    public void insertDoc(ApprovalDocDto dto) throws SQLException;
    public void insertLine(ApprovalLineDto dto) throws SQLException;
    public void insertRef(ApprovalRefDto dto) throws SQLException;
    public void insertFile(ApprovalFileDto dto) throws SQLException;
}