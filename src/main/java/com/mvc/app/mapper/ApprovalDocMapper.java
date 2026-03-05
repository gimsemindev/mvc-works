package com.mvc.app.mapper;

import java.sql.SQLException;

import org.apache.ibatis.annotations.Mapper;

import com.mvc.app.domain.dto.ApprovalDocDto;
import com.mvc.app.domain.dto.ApprovalFileDto;
import com.mvc.app.domain.dto.ApprovalLineDto;
import com.mvc.app.domain.dto.ApprovalRefDto;
import java.util.List;
import java.util.Map;

@Mapper
public interface ApprovalDocMapper {
    public void insertDoc(ApprovalDocDto dto) throws SQLException;
    public void insertLine(ApprovalLineDto dto) throws SQLException;
    public void insertRef(ApprovalRefDto dto) throws SQLException;
    public void insertFile(ApprovalFileDto dto) throws SQLException;
    public List<ApprovalDocDto> listDraft(Map<String, Object> map) throws SQLException;
    public int countDraft(Map<String, Object> map) throws SQLException;
    public List<ApprovalDocDto> listSent(Map<String, Object> map) throws SQLException;
    public int countSent(Map<String, Object> map) throws SQLException;
    public List<ApprovalDocDto> listInbox(Map<String, Object> map) throws SQLException;
    public int countInbox(Map<String, Object> map) throws SQLException;
}