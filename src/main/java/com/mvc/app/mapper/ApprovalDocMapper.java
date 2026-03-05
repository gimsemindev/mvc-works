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
    public List<ApprovalDocDto> listRef(Map<String, Object> map) throws SQLException;
    public int countRef(Map<String, Object> map) throws SQLException;
    public List<ApprovalDocDto> listAll(Map<String, Object> map) throws SQLException;
    public int countAll(Map<String, Object> map) throws SQLException;
    public ApprovalDocDto getDoc(long docId) throws SQLException;
    public List<ApprovalLineDto> getLines(long docId) throws SQLException;
    public List<ApprovalFileDto> getFiles(long docId) throws SQLException;
    public List<ApprovalRefDto> getRefs(long docId) throws SQLException;
    public void deleteFiles(long docId) throws SQLException;
    public void deleteRefs(long docId) throws SQLException;
    public void deleteLines(long docId) throws SQLException;
    public void deleteDoc(long docId) throws SQLException;
    public int cancelDoc(Map<String, Object> map) throws SQLException;
}