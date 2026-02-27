<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%-- ============================================================
     Vue 템플릿 (v-if / v-for / v-model 바인딩)
     기존 더미 tbody를 Vue 렌더링으로 대체
     나머지 레이아웃(wrapper, sidebar, header) 구조는 원본과 동일
============================================================ --%>
<div class="emp-wrapper">

    <!-- ===== 메인 콘텐츠 영역 ===== -->
    <div class="emp-content">
    
        <div class="emp-main">

            <!-- 페이지 타이틀 -->
            <div class="emp-page-title">
                <i class="bi bi-people-fill emp-title-icon"></i>
                <h2>직원관리</h2>
                <i class="bi bi-question-circle emp-help-icon" title="도움말"></i>
            </div>

            <!-- ===== 검색 필터 카드 ===== -->
            <div class="emp-filter-card">
                <div class="emp-filter-row">

                    <!-- 이름 -->
                    <div class="emp-filter-group">
                        <label>이름</label>
                        <input type="text" v-model="store.searchParams.name" placeholder="이름 입력">
                    </div>

                    <!-- 사원번호 -->
                    <div class="emp-filter-group">
                        <label>사원번호</label>
                        <input type="text" v-model="store.searchParams.empNo" placeholder="사원번호 입력">
                    </div>

                    <!-- 참여 프로젝트 -->
                    <div class="emp-filter-group" style="min-width:160px;">
                        <label>참여 프로젝트</label>
                        <input type="text" v-model="store.searchParams.project" placeholder="프로젝트명 입력">
                    </div>

                    <!-- 재직상태 -->
                    <div class="emp-filter-group">
                        <label>재직상태</label>
                        <select v-model="store.searchParams.status">
                            <option value="">전체</option>
                            <option value="EMPLOYED">재직</option>
                            <option value="LEAVE">휴직</option>
                            <option value="RESIGNED">퇴직</option>
                        </select>
                    </div>

                    <!-- 권한레벨 -->
                    <div class="emp-filter-group" style="min-width:150px;">
                        <label>권한레벨</label>
                        <select v-model="store.searchParams.role">
                            <option value="">전체</option>
                            <option value="MASTER">MASTER</option>
                            <option value="EXECUTIVE">EXECUTIVE</option>
                            <option value="COORDINATOR">COORDINATOR</option>
                            <option value="PARTICIPANT">PARTICIPANT</option>
                            <option value="WATCHER">WATCHER</option>
                        </select>
                    </div>

                    <!-- PMO 체크박스 -->
                    <div class="emp-filter-check-group">
                        <label class="group-label">PMO</label>
                        <div class="emp-check-items">
                            <label class="emp-check-item">
                                <input type="checkbox" v-model="store.searchParams.pmoY" value="Y"> Y
                            </label>
                            <label class="emp-check-item">
                                <input type="checkbox" v-model="store.searchParams.pmoN" value="N"> N
                            </label>
                        </div>
                    </div>

                    <!-- 검색 버튼 -->
                    <div class="emp-filter-btns">
                        <button class="emp-btn emp-btn-search" @click="store.fetchList(1)">
                            <i class="bi bi-search"></i> 검색
                        </button>
                        <button class="emp-btn emp-btn-reset" @click="store.resetSearch()">
                            <i class="bi bi-arrow-counterclockwise"></i> 초기화
                        </button>
                    </div>

                </div>
            </div>
            <!-- /검색 필터 카드 -->

            <!-- ===== 테이블 툴바 ===== -->
            <div class="emp-toolbar">
                <div class="emp-toolbar-left">
                    전체 <strong class="mx-1">{{ store.pageInfo.totalCount }}</strong>건
                </div>
                <div class="emp-toolbar-right">
                    <button class="emp-btn emp-btn-add" @click="store.addRow()">
                        <i class="bi bi-plus-lg"></i> 행 추가
                    </button>
                    <button class="emp-btn emp-btn-save" @click="store.saveRows()">
                        <i class="bi bi-floppy"></i> 저장
                    </button>
                    <button class="emp-btn emp-btn-delete" @click="store.deleteSelected()">
                        <i class="bi bi-trash3"></i> 삭제
                    </button>
                    <button class="emp-btn emp-btn-cancel" @click="store.cancelEdit()">
                        <i class="bi bi-x-lg"></i> 취소
                    </button>
                    <button class="emp-btn emp-btn-excel-down" @click="store.excelDownload()">
                        <i class="bi bi-file-earmark-arrow-down"></i> 엑셀 다운로드
                    </button>
                    <button class="emp-btn emp-btn-excel-up" @click="store.triggerExcelUpload()">
                        <i class="bi bi-file-earmark-arrow-up"></i> 엑셀 업로드
                    </button>
                    <input type="file" ref="excelInput" accept=".xlsx,.xls"
                           style="display:none;" @change="store.excelUpload($event)">
                </div>
            </div>

            <!-- ===== 테이블 카드 ===== -->
            <div class="emp-table-card">
                <div style="overflow-x:auto;">
                    <table class="emp-table">
                        <thead>
                            <tr>
                                <th class="col-chk">
                                    <input type="checkbox" :checked="store.isAllChecked"
                                           :indeterminate="store.isIndeterminate"
                                           @change="store.toggleAll($event.target.checked)">
                                </th>
                                <th>순번</th>
                                <th class="sortable" @click="store.sortBy('name')">
                                    이름
                                    <span class="sort-icons" :class="store.getSortClass('name')">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th class="sortable" @click="store.sortBy('empNo')">
                                    사원번호
                                    <span class="sort-icons" :class="store.getSortClass('empNo')">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th>참여 프로젝트</th>
                                <th class="sortable" @click="store.sortBy('dept')">
                                    부서
                                    <span class="sort-icons" :class="store.getSortClass('dept')">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th class="sortable" @click="store.sortBy('rank')">
                                    직급
                                    <span class="sort-icons" :class="store.getSortClass('rank')">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th>권한</th>
                                <th>PMO</th>
                                <th class="sortable" @click="store.sortBy('status')">
                                    재직상태
                                    <span class="sort-icons" :class="store.getSortClass('status')">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- 로딩 표시 -->
                            <tr v-if="store.loading">
                                <td colspan="10" style="text-align:center; padding:30px; color:#94a3b8;">
                                    <i class="bi bi-arrow-repeat" style="animation:spin 1s linear infinite;"></i>
                                    &nbsp;불러오는 중...
                                </td>
                            </tr>

                            <!-- 데이터 없음 -->
                            <tr v-else-if="store.list.length === 0">
                                <td colspan="10" style="text-align:center; padding:30px; color:#94a3b8;">
                                    조회된 직원 정보가 없습니다.
                                </td>
                            </tr>

                            <!-- ===== 직원 목록 rows ===== -->
                            <tr v-else
                                v-for="(emp, index) in store.list"
                                :key="emp.empId ?? emp._tempId"
                                :class="{ selected: emp._checked, editing: emp._editing, dirty: emp._dirty }"
                                @dblclick="store.activateRowEdit(emp)">

                                <!-- 체크박스 -->
                                <td class="col-chk">
                                    <input type="checkbox"
                                           :checked="emp._checked"
                                           @change="store.toggleRow(emp, $event.target.checked)"
                                           @click.stop>
                                </td>

                                <!-- 순번 -->
                                <td>{{ store.pageInfo.totalCount - (store.searchParams.page - 1) * store.pageInfo.pageSize - index }}</td>

                                <!-- 이름 (readonly) -->
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <img v-if="emp.avatar"
                                             :src="emp.avatar"
                                             class="emp-avatar"
                                             onerror="this.onerror=null;this.src='/dist/images/avatar.png';">
                                        <span v-else class="emp-avatar-placeholder">
                                            <i class="bi bi-person"></i>
                                        </span>
                                        <!-- 신규 행은 이름 직접 입력 -->
                                        <input v-if="emp._isNew"
                                               type="text" v-model="emp.name"
                                               placeholder="이름"
                                               style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:80px;background:transparent;"
                                               @click.stop>
                                        <span v-else>{{ emp.name }}</span>
                                    </div>
                                </td>

                                <!-- 사원번호 (readonly) -->
                                <td class="emp-readonly">
                                    <input v-if="emp._isNew"
                                           type="text" v-model="emp.empNo"
                                           placeholder="사원번호"
                                           style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:100px;background:transparent;"
                                           @click.stop>
                                    <span v-else>{{ emp.empNo }}</span>
                                </td>

                                <!-- 참여 프로젝트 (readonly) -->
                                <td class="emp-readonly">
                                    <span v-if="emp._isNew" style="color:#94a3b8;font-size:0.8rem;">자동 연동</span>
                                    <span v-else>{{ emp.projectNames || '-' }}</span>
                                </td>

                                <!-- 부서 (편집 가능) -->
                                <td class="emp-editable" @dblclick.stop="store.activateRowEdit(emp)">
                                    <select v-if="emp._editing" class="emp-edit-select"
                                            v-model="emp.dept"
                                            @change="store.markDirty(emp)"
                                            @click.stop>
                                        <option value="">（없음）</option>
                                        <option v-for="d in store.deptOptions" :key="d" :value="d">{{ d }}</option>
                                    </select>
                                    <span v-else>{{ emp.dept || '-' }}</span>
                                </td>

                                <!-- 직급 (편집 가능) -->
                                <td class="emp-editable" @dblclick.stop="store.activateRowEdit(emp)">
                                    <select v-if="emp._editing" class="emp-edit-select"
                                            v-model="emp.rank"
                                            @change="store.markDirty(emp)"
                                            @click.stop>
                                        <option value="">（없음）</option>
                                        <option v-for="r in store.rankOptions" :key="r" :value="r">{{ r }}</option>
                                    </select>
                                    <span v-else>{{ emp.rank || '-' }}</span>
                                </td>

                                <!-- 권한 (편집 가능) -->
                                <td class="emp-editable" @dblclick.stop="store.activateRowEdit(emp)">
                                    <select v-if="emp._editing" class="emp-edit-select"
                                            v-model="emp.role"
                                            @change="store.markDirty(emp)"
                                            @click.stop>
                                        <option v-for="rl in store.roleOptions" :key="rl" :value="rl">{{ rl }}</option>
                                    </select>
                                    <template v-else>
                                        <span class="emp-role-badge" :class="'emp-role-' + emp.role.toLowerCase()">
                                            {{ emp.role }}
                                        </span>
                                    </template>
                                </td>

                                <!-- PMO (편집 가능) -->
                                <td class="emp-editable" @dblclick.stop="store.activateRowEdit(emp)">
                                    <select v-if="emp._editing" class="emp-edit-select"
                                            v-model="emp.pmo"
                                            @change="store.markDirty(emp)"
                                            @click.stop>
                                        <option value="Y">Y</option>
                                        <option value="N">N</option>
                                    </select>
                                    <template v-else>
                                        <span v-if="emp.pmo === 'Y'" class="emp-pmo-yes">
                                            <i class="bi bi-check-circle-fill"></i> Y
                                        </span>
                                        <span v-else class="emp-pmo-no">N</span>
                                    </template>
                                </td>

                                <!-- 재직상태 (편집 가능) -->
                                <td class="emp-editable" @dblclick.stop="store.activateRowEdit(emp)">
                                    <select v-if="emp._editing" class="emp-edit-select"
                                            v-model="emp.status"
                                            @change="store.markDirty(emp)"
                                            @click.stop>
                                        <option value="EMPLOYED">재직</option>
                                        <option value="LEAVE">휴직</option>
                                        <option value="RESIGNED">퇴직</option>
                                    </select>
                                    <template v-else>
                                        <span class="emp-status-badge"
                                              :class="{
                                                  'emp-status-employed': emp.status === 'EMPLOYED',
                                                  'emp-status-leave'   : emp.status === 'LEAVE',
                                                  'emp-status-resigned': emp.status === 'RESIGNED'
                                              }">
                                            <span class="emp-dot"></span>
                                            {{ store.statusLabel(emp.status) }}
                                        </span>
                                    </template>
                                </td>

                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션 -->
                <div class="emp-pagination" v-if="store.pagination">
                    <div>총 <strong>{{ store.pageInfo.totalCount }}</strong>건 / {{ store.pageInfo.totalPage }} 페이지</div>
                    <div class="emp-pagination-pages">
                        <a class="emp-page-btn" :class="{ disabled: !store.pagination.showPrev }"
                           @click="store.fetchList(store.pagination.firstPage)">
                            <i class="bi bi-chevron-double-left"></i>
                        </a>
                        <a class="emp-page-btn" :class="{ disabled: !store.pagination.showPrev }"
                           @click="store.fetchList(store.pagination.prevBlockPage)">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                        <a v-for="p in store.pagination.pages" :key="p"
                           class="emp-page-btn" :class="{ active: store.searchParams.page === p }"
                           @click="store.fetchList(p)">
                            {{ p }}
                        </a>
                        <a class="emp-page-btn" :class="{ disabled: !store.pagination.showNext }"
                           @click="store.fetchList(store.pagination.nextBlockPage)">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                        <a class="emp-page-btn" :class="{ disabled: !store.pagination.showNext }"
                           @click="store.fetchList(store.pagination.lastPage)">
                            <i class="bi bi-chevron-double-right"></i>
                        </a>
                    </div>
                </div>

            </div>
            <!-- /테이블 카드 -->

        </div>
        <!-- /emp-main -->

    </div>
    <!-- /emp-content -->

</div>
<!-- /emp-wrapper -->
