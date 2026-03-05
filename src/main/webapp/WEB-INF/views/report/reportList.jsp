<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%-- 주간보고서 목록 (직원 보고서 + 관리자 피드백 탭) --%>

<!-- 페이지 타이틀 -->
<div class="rp-page-title">
    <i class="bi bi-file-earmark-text rp-title-icon"></i>
    <h2>주간보고서</h2>
</div>

<!-- 탭 네비게이션 -->
<div class="rp-tab-nav">
    <button class="rp-tab-item active" id="tabReport" onclick="rpSwitchTab('tabReport','tabContentReport')">
        <i class="bi bi-file-earmark-text"></i> 직원 보고서
    </button>
    <button class="rp-tab-item" id="tabFeedback" onclick="rpSwitchTab('tabFeedback','tabContentFeedback')">
        <i class="bi bi-chat-left-dots"></i> 관리자 피드백
    </button>
</div>

<%-- ===================================================
     직원 보고서 탭
=================================================== --%>
<div id="tabContentReport" class="rp-tab-content active">

    <!-- 검색 필터 -->
    <div class="rp-filter-card">
        <div class="rp-filter-row">
            <div class="rp-filter-group">
                <label>작성자</label>
                <input type="text" name="writerName" placeholder="이름 입력">
            </div>
            <div class="rp-filter-group">
                <label>보고 기간(시작)</label>
                <input type="date" name="periodStart">
            </div>
            <div class="rp-filter-group">
                <label>보고 기간(종료)</label>
                <input type="date" name="periodEnd">
            </div>
            <div class="rp-filter-group">
                <label>피드백 여부</label>
                <select name="feedbackYn">
                    <option value="">전체</option>
                    <option value="Y">완료</option>
                    <option value="N">미작성</option>
                </select>
            </div>
            <div class="rp-filter-group">
                <label>제목 검색</label>
                <input type="text" name="subject" placeholder="제목 입력">
            </div>
            <div class="rp-filter-btns">
                <button class="rp-btn rp-btn-primary">
                    <i class="bi bi-search"></i> 검색
                </button>
                <button class="rp-btn rp-btn-secondary">
                    <i class="bi bi-arrow-counterclockwise"></i> 초기화
                </button>
            </div>
        </div>
    </div>

    <!-- 툴바 -->
    <div class="rp-toolbar">
        <div class="rp-toolbar-left">
            전체 <strong class="mx-1">5</strong>건
        </div>
        <div class="rp-toolbar-right">
            <a href="${pageContext.request.contextPath}/report/write" class="rp-btn rp-btn-primary">
                <i class="bi bi-pencil-square"></i> 보고서 작성
            </a>
        </div>
    </div>

    <!-- 테이블 -->
    <div class="rp-table-card">
        <div style="overflow-x:auto;">
            <table class="rp-table">
                <thead>
                    <tr>
                        <th style="width:55px;">번호</th>
                        <th>제목</th>
                        <th style="width:100px;">작성자</th>
                        <th style="width:130px;">보고 기간</th>
                        <th style="width:105px;">작성일</th>
                        <th style="width:85px;">피드백</th>
                        <th style="width:70px;">조회수</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 실제 구현 시 c:forEach 치환 --%>
                    <tr>
                        <td class="td-center">10</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/detail?filenum=10">
                                2025년 1분기 마케팅 주간보고서
                            </a>
                        </td>
                        <td class="td-center">홍길동</td>
                        <td class="td-center">03/03 ~ 03/07</td>
                        <td class="td-center">2025.03.07</td>
                        <td class="td-center">
                            <span class="rp-result-badge rp-badge-done">
                                <span class="rp-dot"></span> 완료
                            </span>
                        </td>
                        <td class="td-center">24</td>
                    </tr>
                    <tr>
                        <td class="td-center">9</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/detail?filenum=9">
                                신제품 런칭 준비 주간 업무보고
                            </a>
                        </td>
                        <td class="td-center">김영희</td>
                        <td class="td-center">02/24 ~ 02/28</td>
                        <td class="td-center">2025.02.28</td>
                        <td class="td-center">
                            <span class="rp-badge rp-badge-pending">미작성</span>
                        </td>
                        <td class="td-center">17</td>
                    </tr>
                    <tr>
                        <td class="td-center">8</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/detail?filenum=8">
                                개발팀 스프린트 주간보고 (백엔드)
                            </a>
                        </td>
                        <td class="td-center">이철수</td>
                        <td class="td-center">02/17 ~ 02/21</td>
                        <td class="td-center">2025.02.21</td>
                        <td class="td-center">
                            <span class="rp-result-badge rp-badge-done">
                                <span class="rp-dot"></span> 완료
                            </span>
                        </td>
                        <td class="td-center">31</td>
                    </tr>
                    <tr>
                        <td class="td-center">7</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/detail?filenum=7">
                                고객지원팀 2월 3주차 주간보고
                            </a>
                        </td>
                        <td class="td-center">박지수</td>
                        <td class="td-center">02/17 ~ 02/21</td>
                        <td class="td-center">2025.02.21</td>
                        <td class="td-center">
                            <span class="rp-badge rp-badge-pending">미작성</span>
                        </td>
                        <td class="td-center">9</td>
                    </tr>
                    <tr>
                        <td class="td-center">6</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/detail?filenum=6">
                                영업팀 주간보고 - 2월 2주
                            </a>
                        </td>
                        <td class="td-center">최민준</td>
                        <td class="td-center">02/10 ~ 02/14</td>
                        <td class="td-center">2025.02.14</td>
                        <td class="td-center">
                            <span class="rp-result-badge rp-badge-done">
                                <span class="rp-dot"></span> 완료
                            </span>
                        </td>
                        <td class="td-center">45</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 페이지네이션 -->
        <div class="rp-pagination">
            <div>총 <strong>5</strong>건 / 1 페이지</div>
            <div class="rp-pagination-pages">
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-double-left"></i></a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-left"></i></a>
                <a class="rp-page-btn active">1</a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-right"></i></a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-double-right"></i></a>
            </div>
        </div>
    </div>

</div><%-- /tabContentReport --%>

<%-- ===================================================
     관리자 피드백 탭
=================================================== --%>
<div id="tabContentFeedback" class="rp-tab-content">

    <!-- 검색 필터 -->
    <div class="rp-filter-card">
        <div class="rp-filter-row">
            <div class="rp-filter-group">
                <label>대상 직원</label>
                <input type="text" name="targetName" placeholder="이름 입력">
            </div>
            <div class="rp-filter-group">
                <label>작성일(시작)</label>
                <input type="date" name="startDate">
            </div>
            <div class="rp-filter-group">
                <label>작성일(종료)</label>
                <input type="date" name="endDate">
            </div>
            <div class="rp-filter-group">
                <label>제목 검색</label>
                <input type="text" name="subject" placeholder="제목 입력">
            </div>
            <div class="rp-filter-btns">
                <button class="rp-btn rp-btn-primary">
                    <i class="bi bi-search"></i> 검색
                </button>
                <button class="rp-btn rp-btn-secondary">
                    <i class="bi bi-arrow-counterclockwise"></i> 초기화
                </button>
            </div>
        </div>
    </div>

    <!-- 툴바 -->
    <div class="rp-toolbar">
        <div class="rp-toolbar-left">
            전체 <strong class="mx-1">3</strong>건
        </div>
        <div class="rp-toolbar-right"></div>
    </div>

    <!-- 테이블 -->
    <div class="rp-table-card">
        <div style="overflow-x:auto;">
            <table class="rp-table">
                <thead>
                    <tr>
                        <th style="width:55px;">번호</th>
                        <th>원본 보고서 제목</th>
                        <th>피드백 제목</th>
                        <th style="width:100px;">작성자</th>
                        <th style="width:105px;">작성일</th>
                        <th style="width:70px;">조회수</th>
                        <th style="width:60px;">상세</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="td-center">3</td>
                        <td style="color:#64748b; font-size:0.8rem;">2025년 1분기 마케팅 주간보고서</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/feedback/detail?filenum=3">
                                홍길동 3/1주차 보고서 피드백
                            </a>
                        </td>
                        <td class="td-center">관리자</td>
                        <td class="td-center">2025.03.08</td>
                        <td class="td-center">12</td>
                        <td class="td-center">
                            <button class="rp-btn-icon"
                                    onclick="location.href='${pageContext.request.contextPath}/report/feedback/detail?filenum=3'"
                                    title="상세보기">
                                <i class="bi bi-eye"></i>
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td class="td-center">2</td>
                        <td style="color:#64748b; font-size:0.8rem;">개발팀 스프린트 주간보고 (백엔드)</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/feedback/detail?filenum=2">
                                이철수 2/3주차 보고서 피드백
                            </a>
                        </td>
                        <td class="td-center">관리자</td>
                        <td class="td-center">2025.02.22</td>
                        <td class="td-center">8</td>
                        <td class="td-center">
                            <button class="rp-btn-icon"
                                    onclick="location.href='${pageContext.request.contextPath}/report/feedback/detail?filenum=2'"
                                    title="상세보기">
                                <i class="bi bi-eye"></i>
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td class="td-center">1</td>
                        <td style="color:#64748b; font-size:0.8rem;">영업팀 주간보고 - 2월 2주</td>
                        <td class="td-subject">
                            <a href="${pageContext.request.contextPath}/report/feedback/detail?filenum=1">
                                최민준 2/2주차 보고서 피드백
                            </a>
                        </td>
                        <td class="td-center">관리자</td>
                        <td class="td-center">2025.02.15</td>
                        <td class="td-center">19</td>
                        <td class="td-center">
                            <button class="rp-btn-icon"
                                    onclick="location.href='${pageContext.request.contextPath}/report/feedback/detail?filenum=1'"
                                    title="상세보기">
                                <i class="bi bi-eye"></i>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="rp-pagination">
            <div>총 <strong>3</strong>건 / 1 페이지</div>
            <div class="rp-pagination-pages">
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-double-left"></i></a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-left"></i></a>
                <a class="rp-page-btn active">1</a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-right"></i></a>
                <a class="rp-page-btn disabled"><i class="bi bi-chevron-double-right"></i></a>
            </div>
        </div>
    </div>

</div><%-- /tabContentFeedback --%>

<script>
function rpSwitchTab(activeTabId, activeContentId) {
    document.querySelectorAll('.rp-tab-item').forEach(function(btn) {
        btn.classList.remove('active');
    });
    document.querySelectorAll('.rp-tab-content').forEach(function(content) {
        content.classList.remove('active');
    });
    document.getElementById(activeTabId).classList.add('active');
    document.getElementById(activeContentId).classList.add('active');
}
</script>
