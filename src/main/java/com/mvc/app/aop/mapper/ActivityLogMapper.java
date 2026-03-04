package com.mvc.app.aop.mapper;

import com.mvc.app.aop.dto.ActivityLogDto;
import org.apache.ibatis.annotations.Mapper;

/**
 * 활동 로그 MyBatis Mapper
 *  ActivityLogMapper.xml 과 연결
 */
@Mapper
public interface ActivityLogMapper {

    /** 활동 로그 단건 INSERT */
    void insertActivityLog(ActivityLogDto dto);
}
