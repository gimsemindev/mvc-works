package com.mvc.app.service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.domain.dto.ProjectNoticeFileDto;
import com.mvc.app.mapper.ProjectNoticeMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProjectNoticeServiceImpl implements ProjectNoticeService {

	private final ProjectNoticeMapper mapper;

	@Value("${file.upload-root}")
	private String uploadRoot;

	// 공지 등록
	@Override
	@Transactional
	public void insertNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception {

		mapper.insertNotice(dto);

		if (files != null && !files.isEmpty()) {
			saveFiles(files, dto.getNoticenum());
		}
	}

	// 공지 수정
	@Override
	@Transactional
	public void updateNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception {

		mapper.updateNotice(dto);

		if (files != null && !files.isEmpty()) {
			saveFiles(files, dto.getNoticenum());
		}
	}

	// 공지 삭제
	@Override
	@Transactional
	public void deleteNotice(long noticenum) throws Exception {

		List<ProjectNoticeFileDto> files = mapper.getFiles(noticenum);

		if (files != null && !files.isEmpty()) {
			for (ProjectNoticeFileDto file : files) {

				File f = new File(uploadRoot, file.getSavefilename());

				if (f.exists()) {
					f.delete();
				}

				mapper.deleteFile(file.getFilenum());
			}
		}

		mapper.deleteNotice(noticenum);
	}

	// 공지 목록
	@Override
	public List<ProjectNoticeDto> listNotice(Map<String, Object> param) {
		return mapper.listNotice(param);
	}

	// 공지 개수
	@Override
	public int countNotice(Map<String, Object> param) {
		return mapper.countNotice(param);
	}

	// 공지 단건
	@Override
	@Transactional
	public ProjectNoticeDto getNotice(long noticenum) {

		mapper.increaseHit(noticenum);

		ProjectNoticeDto dto = mapper.getNotice(noticenum);

		if (dto != null) {
			dto.setFiles(mapper.getFiles(noticenum));
		}

		return dto;
	}

	// 내 프로젝트 목록
	@Override
	public List<Map<String, Object>> getMyProjects(String empId) {
		return mapper.getMyProjects(empId);
	}

	@Override
	public List<Map<String, Object>> getMyPmProjects(String empId) {
		return mapper.getMyPmProjects(empId);
	}

	// 파일 삭제
	@Override
	@Transactional
	public void deleteFile(long filenum) throws Exception {

		ProjectNoticeFileDto file = mapper.getFile(filenum);

		if (file == null)
			return;

		File f = new File(uploadRoot, file.getSavefilename());

		if (f.exists()) {
			f.delete();
		}

		mapper.deleteFile(filenum);
	}

	// 파일 조회
	@Override
	public ProjectNoticeFileDto getFile(long filenum) {
		return mapper.getFile(filenum);
	}

	// 첨부파일 목록
	@Override
	public List<ProjectNoticeFileDto> getFiles(long noticenum) {
		return mapper.getFiles(noticenum);
	}

	// 파일 저장
	private void saveFiles(List<MultipartFile> files, long noticenum) throws Exception {

		File dir = new File(uploadRoot);

		if (!dir.exists()) {
			dir.mkdirs();
		}

		for (MultipartFile mf : files) {

			if (mf == null || mf.isEmpty())
				continue;

			String origin = mf.getOriginalFilename();

			if (origin == null)
				continue;

			String ext = "";

			int idx = origin.lastIndexOf(".");
			if (idx != -1) {
				ext = origin.substring(idx);
			}

			String saveName = UUID.randomUUID().toString().replace("-", "") + ext;

			File dest = new File(uploadRoot, saveName);

			mf.transferTo(dest);

			ProjectNoticeFileDto fileDto = new ProjectNoticeFileDto();

			fileDto.setSavefilename(saveName);
			fileDto.setOriginalfilename(origin);
			fileDto.setFilesize(mf.getSize());
			fileDto.setNoticenum(noticenum);

			mapper.insertFile(fileDto);
		}
	}

	public boolean isManager(String empId, long projectid) {
		return mapper.isManager(empId, projectid) > 0;
	}

	@Override
	public ProjectNoticeDto getNoticeDetail(long noticenum) {
		return getNotice(noticenum);
	}

}