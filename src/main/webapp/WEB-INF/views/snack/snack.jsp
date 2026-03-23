<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctxPath   = request.getContextPath();
    String userLevel = "";
    String empId     = "";
    Object member = session.getAttribute("member");
    if (member != null) {
        try {
            userLevel = String.valueOf(member.getClass().getMethod("getUserLevel").invoke(member));
            empId     = String.valueOf(member.getClass().getMethod("getEmpId").invoke(member));
        } catch(Exception e) { /* ignore */ }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC - 탕비실 신청</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<style>
#main-content { margin-left: 240px !important; padding: 28px 32px !important; box-sizing: border-box; min-height: 100vh; background: #f8f9fc; }
.snack-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:24px; }
.snack-header-left h2 { font-size:20px; font-weight:700; color:#1d2939; margin:0 0 4px; display:flex; align-items:center; gap:8px; }
.snack-header-left p { font-size:13px; color:#9aa0b4; margin:0; }
.btn-request { display:inline-flex; align-items:center; gap:6px; background:#4e73df; color:#fff; border:none; border-radius:8px; padding:10px 20px; font-size:14px; font-weight:600; cursor:pointer; }
.btn-request:hover { background:#3a5abf; }
.filter-bar { display:flex; align-items:center; gap:10px; margin-bottom:16px; flex-wrap:wrap; }
.filter-chips { display:flex; gap:6px; }
.chip { padding:6px 14px; border-radius:20px; border:1px solid #e2e5ef; background:#fff; font-size:12px; font-weight:600; color:#667085; cursor:pointer; }
.chip.active { background:#4e73df; border-color:#4e73df; color:#fff; }
.search-box { display:flex; align-items:center; gap:8px; background:#fff; border:1px solid #e2e5ef; border-radius:8px; padding:7px 14px; margin-left:auto; }
.search-box input { border:none; outline:none; font-size:13px; color:#333; width:200px; }
.search-box .material-symbols-outlined { font-size:18px; color:#aaa; cursor:pointer; }
.snack-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:16px; margin-bottom:24px; }
.snack-card { background:#fff; border-radius:12px; border:1px solid #e6eaf4; padding:20px; cursor:pointer; transition:box-shadow .15s,transform .15s; }
.snack-card:hover { box-shadow:0 4px 16px rgba(0,0,0,.08); transform:translateY(-2px); }
.card-top { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:10px; }
.item-name { font-size:16px; font-weight:700; color:#1d2939; }
.status-badge { font-size:11px; font-weight:700; padding:3px 10px; border-radius:12px; flex-shrink:0; }
.status-PENDING  { background:#fff4e0; color:#d97706; }
.status-APPROVED { background:#ecfdf5; color:#059669; }
.status-REJECTED { background:#fef2f2; color:#dc2626; }
.card-meta { font-size:12px; color:#9aa0b4; margin-bottom:8px; }
.card-reason { font-size:13px; color:#3a3f51; line-height:1.6; margin-bottom:14px; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
.card-footer { display:flex; align-items:center; gap:12px; padding-top:12px; border-top:1px solid #f0f2f9; }
.vote-btn { display:inline-flex; align-items:center; gap:4px; background:none; border:1px solid #e2e5ef; border-radius:20px; padding:4px 12px; font-size:12px; font-weight:600; color:#667085; cursor:pointer; }
.vote-btn.voted { background:#eef2ff; border-color:#4e73df; color:#4e73df; }
.vote-btn .material-symbols-outlined { font-size:14px; }
.comment-count { font-size:12px; color:#9aa0b4; display:flex; align-items:center; gap:4px; }
.comment-count .material-symbols-outlined { font-size:14px; }
.card-requester { margin-left:auto; font-size:12px; color:#9aa0b4; }
.empty-state { text-align:center; padding:60px; color:#9aa0b4; background:#fff; border-radius:12px; border:1px solid #e6eaf4; }
.empty-state .material-symbols-outlined { font-size:48px; display:block; margin-bottom:12px; }
.pagination { display:flex; justify-content:center; gap:6px; margin-top:8px; }
.page-btn { background:#fff; border:1px solid #e6eaf4; border-radius:6px; padding:6px 12px; font-size:12px; color:#667085; cursor:pointer; }
.page-btn:hover:not(:disabled) { background:#f0f3ff; border-color:#4e73df; color:#4e73df; }
.page-btn.active { background:#4e73df; border-color:#4e73df; color:#fff; font-weight:700; }
.page-btn:disabled { opacity:.4; cursor:default; }
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.4); z-index:1100; display:flex; align-items:center; justify-content:center; padding:20px; }
.modal { background:#fff; border-radius:16px; width:100%; max-width:600px; max-height:90vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,.15); }
.modal-header { display:flex; align-items:center; justify-content:space-between; padding:20px 24px 16px; border-bottom:1px solid #f0f2f9; position:sticky; top:0; background:#fff; z-index:1; }
.modal-header h3 { font-size:16px; font-weight:700; color:#1d2939; margin:0; }
.modal-close { background:none; border:none; cursor:pointer; color:#9aa0b4; display:flex; align-items:center; }
.modal-close:hover { color:#1d2939; }
.modal-body { padding:20px 24px; }
.modal-footer { display:flex; justify-content:flex-end; gap:8px; padding:16px 24px; border-top:1px solid #f0f2f9; }
.form-row { margin-bottom:16px; }
.form-row label { display:block; font-size:11px; font-weight:700; color:#667085; text-transform:uppercase; letter-spacing:.04em; margin-bottom:6px; }
.form-row input, .form-row textarea { width:100%; border:1px solid #d8dde6; border-radius:8px; padding:9px 14px; font-size:14px; color:#3a3f51; outline:none; box-sizing:border-box; font-family:inherit; }
.form-row input:focus, .form-row textarea:focus { border-color:#4e73df; }
.form-row textarea { resize:vertical; min-height:100px; }
.detail-item-name { font-size:22px; font-weight:700; color:#1d2939; margin-bottom:8px; display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
.detail-meta { font-size:12px; color:#9aa0b4; display:flex; gap:16px; margin-bottom:16px; flex-wrap:wrap; }
.detail-reason { background:#f8f9fc; border-radius:8px; padding:16px; font-size:14px; color:#3a3f51; line-height:1.7; margin-bottom:16px; }
.admin-comment-box { background:#fff4e0; border:1px solid #fcd34d; border-radius:8px; padding:12px 16px; font-size:13px; color:#92400e; margin-bottom:16px; }
.admin-comment-box.approved { background:#ecfdf5; border-color:#6ee7b7; color:#065f46; }
.admin-actions { background:#f8f9fc; border-radius:8px; padding:16px; margin-bottom:16px; }
.admin-actions h4 { font-size:13px; font-weight:700; color:#667085; margin:0 0 10px; text-transform:uppercase; letter-spacing:.04em; }
.admin-btns { display:flex; gap:8px; margin-top:10px; }
.btn-approve { background:#ecfdf5; color:#059669; border:1px solid #6ee7b7; border-radius:6px; padding:7px 16px; font-size:12px; font-weight:700; cursor:pointer; }
.btn-approve:hover { background:#d1fae5; }
.btn-reject { background:#fef2f2; color:#dc2626; border:1px solid #fca5a5; border-radius:6px; padding:7px 16px; font-size:12px; font-weight:700; cursor:pointer; }
.btn-reject:hover { background:#fee2e2; }
.comment-section { margin-top:8px; }
.comment-title { font-size:13px; font-weight:700; color:#1d2939; margin-bottom:12px; display:flex; align-items:center; gap:6px; }
.comment-count-badge { background:#4e73df; color:#fff; border-radius:10px; padding:1px 8px; font-size:11px; }
.comment-write { display:flex; gap:8px; margin-bottom:14px; }
.comment-write textarea { flex:1; border:1px solid #d8dde6; border-radius:8px; padding:10px 14px; font-size:13px; resize:none; height:60px; outline:none; font-family:inherit; }
.comment-write textarea:focus { border-color:#4e73df; }
.btn-comment { background:#4e73df; color:#fff; border:none; border-radius:8px; padding:0 16px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
.btn-comment:hover { background:#3a5abf; }
.comment-item { background:#f8f9fc; border-radius:8px; padding:12px 14px; margin-bottom:8px; }
.comment-item-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:4px; }
.comment-author { font-size:12px; font-weight:700; color:#1d2939; }
.comment-date   { font-size:11px; color:#9aa0b4; }
.comment-text   { font-size:13px; color:#3a3f51; line-height:1.5; }
.btn-del-comment { background:none; border:none; color:#9aa0b4; font-size:11px; cursor:pointer; padding:2px 6px; }
.btn-del-comment:hover { color:#dc2626; }
.btn-cancel { background:#f1f3f9; color:#3a3f51; border:none; border-radius:6px; padding:9px 20px; font-size:13px; font-weight:600; cursor:pointer; }
.btn-cancel:hover { background:#e2e6f0; }
.btn-save { background:#4e73df; color:#fff; border:none; border-radius:6px; padding:9px 20px; font-size:13px; font-weight:600; cursor:pointer; }
.btn-save:hover { background:#3a5abf; }
.btn-delete-item { background:#fef2f2; color:#dc2626; border:1px solid #fca5a5; border-radius:6px; padding:7px 14px; font-size:12px; font-weight:600; cursor:pointer; }
.btn-delete-item:hover { background:#fee2e2; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
    <div id="snack-root"></div>
</main>

<script src="https://unpkg.com/react@18/umd/react.development.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>

<script>
    var SNACK_CTX      = '<%= ctxPath %>';
    var SNACK_IS_ADMIN = '<%= userLevel %>' == '99';
    var SNACK_EMP_ID   = '<%= empId %>';
</script>

<script type="text/babel">
const { useState, useEffect, useCallback } = React;
const ctx       = SNACK_CTX;
const IS_ADMIN  = SNACK_IS_ADMIN;
const MY_EMP_ID = SNACK_EMP_ID;

const statusLabel = s => ({ PENDING: '대기중', APPROVED: '승인', REJECTED: '반려' }[s] || s);

function VoteBtn({ voted, count, onClick }) {
    return (
        <button className={`vote-btn\${voted ? ' voted' : ''}`}
                onClick={e => { e.stopPropagation(); onClick(); }}>
            <span className="material-symbols-outlined">favorite</span>
            {count}
        </button>
    );
}

function StatusBadge({ status }) {
    return <span className={`status-badge status-\${status}`}>{statusLabel(status)}</span>;
}

function SnackCard({ item, onVote, onOpen }) {
    return (
        <div className="snack-card" onClick={() => onOpen(item.snackId)}>
            <div className="card-top">
                <span className="item-name">{item.itemName}</span>
                <StatusBadge status={item.status} />
            </div>
            <div className="card-meta">수량 {item.quantity}개 · {item.regDate} · {item.requesterName}</div>
            <div className="card-reason">{item.reason}</div>
            <div className="card-footer">
                <VoteBtn voted={item.voted} count={item.voteCount} onClick={() => onVote(item)} />
                <span className="comment-count">
                    <span className="material-symbols-outlined">chat_bubble</span>
                    {item.commentCount || 0}
                </span>
                <span className="card-requester">{item.requesterName}</span>
            </div>
        </div>
    );
}

function FormModal({ onClose, onSubmit }) {
    const [form, setForm] = useState({ itemName: '', quantity: 1, reason: '' });
    const set = (k, v) => setForm(p => ({ ...p, [k]: v }));
    const submit = async (e) => {
        e.preventDefault();
        if (!form.itemName.trim()) { alert('품목명을 입력해주세요.'); return; }
        if (!form.reason.trim())   { alert('신청 이유를 입력해주세요.'); return; }
        const res = await fetch(`\${ctx}/api/snack`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(form)
        });
        if (res.ok) { alert('신청이 등록되었습니다!'); onSubmit(); }
        else { alert('등록 실패'); }
    };
    return (
        <div className="modal-overlay" style={{display:'flex'}} onClick={onClose}>
            <div className="modal" onClick={e => e.stopPropagation()}>
                <div className="modal-header">
                    <h3>탕비실 비품 신청</h3>
                    <button className="modal-close" onClick={onClose} type="button">
                        <span className="material-symbols-outlined">close</span>
                    </button>
                </div>
                <form onSubmit={submit}>
                    <div className="modal-body">
                        <div className="form-row">
                            <label>품목명 <span style={{color:'#dc2626'}}>*</span></label>
                            <input value={form.itemName} onChange={e => set('itemName', e.target.value)}
                                   placeholder="예: 허니버터칩, 아메리카노 캡슐" required />
                        </div>
                        <div className="form-row">
                            <label>수량 <span style={{color:'#dc2626'}}>*</span></label>
                            <input type="number" min="1" value={form.quantity}
                                   onChange={e => set('quantity', parseInt(e.target.value) || 1)} required />
                        </div>
                        <div className="form-row">
                            <label>신청 이유 <span style={{color:'#dc2626'}}>*</span></label>
                            <textarea value={form.reason} onChange={e => set('reason', e.target.value)}
                                      placeholder="왜 필요한지 간단히 적어주세요!" required />
                        </div>
                    </div>
                    <div className="modal-footer">
                        <button className="btn-cancel" onClick={onClose} type="button">취소</button>
                        <button className="btn-save" type="submit">신청하기</button>
                    </div>
                </form>
            </div>
        </div>
    );
}

function DetailModal({ snackId, onClose, onRefresh }) {
    const [detail, setDetail]             = useState(null);
    const [adminComment, setAdminComment] = useState('');
    const [newComment, setNewComment]     = useState('');

    const load = useCallback(async () => {
        const res = await fetch(`\${ctx}/api/snack/\${snackId}`);
        const data = await res.json();
        setDetail(data);
    }, [snackId]);

    useEffect(() => { load(); }, [load]);

    if (!detail) return (
        <div className="modal-overlay" style={{display:'flex'}}>
            <div className="modal" style={{padding:'40px', textAlign:'center', color:'#9aa0b4'}}>불러오는 중...</div>
        </div>
    );

    const toggleVote = async () => {
        const res  = await fetch(`\${ctx}/api/snack/\${snackId}/vote`, { method: 'POST' });
        const data = await res.json();
        setDetail(p => ({ ...p, voteCount: data.voteCount, voted: !p.voted }));
        onRefresh();
    };

    const processStatus = async (status) => {
        if (!confirm(status == 'APPROVED' ? '승인하시겠습니까?' : '반려하시겠습니까?')) return;
        const res = await fetch(`\${ctx}/api/snack/\${snackId}/status`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ status, adminComment })
        });
        if (res.ok) { alert(status == 'APPROVED' ? '승인되었습니다.' : '반려되었습니다.'); load(); onRefresh(); }
    };

    const deleteItem = async () => {
        if (!confirm('삭제하시겠습니까?')) return;
        const res = await fetch(`\${ctx}/api/snack/\${snackId}`, { method: 'DELETE' });
        if (res.ok) { alert('삭제되었습니다.'); onClose(); onRefresh(); }
    };

    const submitComment = async () => {
        if (!newComment.trim()) return;
        const res = await fetch(`\${ctx}/api/snack/\${snackId}/comment`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: newComment })
        });
        if (res.ok) { setNewComment(''); load(); onRefresh(); }
    };

    const deleteComment = async (commentId) => {
        if (!confirm('댓글을 삭제하시겠습니까?')) return;
        await fetch(`\${ctx}/api/snack/comment/\${commentId}`, { method: 'DELETE' });
        load();
    };

    return (
        <div className="modal-overlay" style={{display:'flex'}} onClick={onClose}>
            <div className="modal" onClick={e => e.stopPropagation()}>
                <div className="modal-header">
                    <h3>신청 상세</h3>
                    <button className="modal-close" onClick={onClose} type="button">
                        <span className="material-symbols-outlined">close</span>
                    </button>
                </div>
                <div className="modal-body">
                    <div className="detail-item-name">
                        {detail.itemName}
                        <StatusBadge status={detail.status} />
                    </div>
                    <div className="detail-meta">
                        <span>수량: <b>{detail.quantity}개</b></span>
                        <span>신청자: <b>{detail.requesterName}</b></span>
                        <span>신청일: {detail.regDate}</span>
                        {detail.updateDate && <span>처리일: {detail.updateDate}</span>}
                    </div>
                    <div className="detail-reason">{detail.reason}</div>

                    {detail.adminComment && (
                        <div className={`admin-comment-box\${detail.status == 'APPROVED' ? ' approved' : ''}`}>
                            <b>{detail.status == 'APPROVED' ? '✅ 승인' : '❌ 반려'} 사유:</b> {detail.adminComment}
                        </div>
                    )}

                    {IS_ADMIN && detail.status == 'PENDING' && (
                        <div className="admin-actions">
                            <h4>관리자 처리</h4>
                            <div className="form-row">
                                <label>처리 코멘트</label>
                                <input value={adminComment} onChange={e => setAdminComment(e.target.value)}
                                       placeholder="승인/반려 사유를 입력하세요" />
                            </div>
                            <div className="admin-btns">
                                <button className="btn-approve" onClick={() => processStatus('APPROVED')}>✅ 승인</button>
                                <button className="btn-reject"  onClick={() => processStatus('REJECTED')}>❌ 반려</button>
                            </div>
                        </div>
                    )}

                    <div style={{display:'flex', alignItems:'center', gap:'10px', marginBottom:'20px'}}>
                        <VoteBtn voted={detail.voted} count={detail.voteCount} onClick={toggleVote} />
                        {(IS_ADMIN || detail.requesterEmpId == MY_EMP_ID) && (
                            <button className="btn-delete-item" onClick={deleteItem} type="button">삭제</button>
                        )}
                    </div>

                    <div className="comment-section">
                        <div className="comment-title">
                            댓글
                            <span className="comment-count-badge">{detail.comments ? detail.comments.length : 0}</span>
                        </div>
                        <div className="comment-write">
                            <textarea value={newComment} onChange={e => setNewComment(e.target.value)}
                                      onKeyDown={e => { if (e.ctrlKey && e.key == 'Enter') submitComment(); }}
                                      placeholder="댓글을 입력하세요... (Ctrl+Enter)" />
                            <button className="btn-comment" onClick={submitComment} type="button">등록</button>
                        </div>
                        {detail.comments && detail.comments.length > 0
                            ? detail.comments.map(c => (
                                <div key={c.commentId} className="comment-item">
                                    <div className="comment-item-header">
                                        <span className="comment-author">{c.authorName}</span>
                                        <div style={{display:'flex', alignItems:'center', gap:'6px'}}>
                                            <span className="comment-date">{c.regDate}</span>
                                            {(IS_ADMIN || c.authorEmpId == MY_EMP_ID) && (
                                                <button className="btn-del-comment"
                                                        onClick={() => deleteComment(c.commentId)}>삭제</button>
                                            )}
                                        </div>
                                    </div>
                                    <div className="comment-text">{c.content}</div>
                                </div>
                            ))
                            : <div style={{textAlign:'center', padding:'20px', color:'#9aa0b4', fontSize:'13px'}}>
                                첫 번째 댓글을 남겨보세요!
                              </div>
                        }
                    </div>
                </div>
            </div>
        </div>
    );
}

function SnackApp() {
    const [list,         setList]         = useState([]);
    const [total,        setTotal]        = useState(0);
    const [pageNo,       setPageNo]       = useState(1);
    const [keyword,      setKeyword]      = useState('');
    const [filterStatus, setFilterStatus] = useState('');
    const [showForm,     setShowForm]     = useState(false);
    const [detailId,     setDetailId]     = useState(null);
    const pageSize   = 12;

    const fetchList = useCallback(async (pNo, kw, st) => {
        const p = pNo !== undefined ? pNo : pageNo;
        const k = kw  !== undefined ? kw  : keyword;
        const s = st  !== undefined ? st  : filterStatus;
        try {
            const res  = await fetch(`\${ctx}/api/snack/list?pageNo=\${p}&pageSize=\${pageSize}&keyword=\${encodeURIComponent(k)}&status=\${s}`);
            const data = await res.json();
            setList(data.list  || []);
            setTotal(data.total || 0);
        } catch(e) { console.error(e); }
    }, [pageNo, keyword, filterStatus]);

    useEffect(() => { fetchList(1, '', ''); }, []);

    const totalPages = Math.max(1, Math.ceil(total / pageSize));
    const pageRange  = (() => {
        const s = Math.max(1, pageNo - 2);
        const e = Math.min(totalPages, s + 4);
        const range = [];
        for(let i=s; i<=e; i++) range.push(i);
        return range;
    })();

    const setFilter   = (s) => { setFilterStatus(s); setPageNo(1); fetchList(1, keyword, s); };
    const changePage  = (p) => { if (p < 1 || p > totalPages) return; setPageNo(p); fetchList(p, keyword, filterStatus); };
    const handleSearch = ()  => { setPageNo(1); fetchList(1, keyword, filterStatus); };

    const toggleVote = async (item) => {
        const res  = await fetch(`\${ctx}/api/snack/\${item.snackId}/vote`, { method: 'POST' });
        const data = await res.json();
        setList(prev => prev.map(i =>
            i.snackId == item.snackId ? { ...i, voteCount: data.voteCount, voted: !i.voted } : i
        ));
    };

    return (
        <div>
            <div className="snack-header">
                <div className="snack-header-left">
                    <h2>
                        <span className="material-symbols-outlined" style={{color:'#4e73df'}}>local_cafe</span>
                        탕비실 신청
                    </h2>
                    <p>과자·음료 등 탕비실 비품을 신청하고 공감으로 우선순위를 높여보세요!</p>
                </div>
                <button className="btn-request" onClick={() => { console.log("Open Form"); setShowForm(true); }}>
                    <span className="material-symbols-outlined" style={{fontSize:'16px'}}>add</span>
                    신청하기
                </button>
            </div>

            <div className="filter-bar">
                <div className="filter-chips">
                    {[['', '전체'], ['PENDING', '대기중'], ['APPROVED', '승인'], ['REJECTED', '반려']].map(([val, label]) => (
                        <button key={val} className={`chip\${filterStatus == val ? ' active' : ''}`}
                                onClick={() => setFilter(val)}>{label}</button>
                    ))}
                </div>
                <div className="search-box">
                    <span className="material-symbols-outlined" onClick={handleSearch}>search</span>
                    <input value={keyword} onChange={e => setKeyword(e.target.value)}
                           placeholder="품목명 또는 이유 검색"
                           onKeyDown={e => e.key == 'Enter' && handleSearch()} />
                </div>
            </div>

            {list.length > 0
                ? <div className="snack-grid">
                    {list.map(item => (
                        <SnackCard key={item.snackId} item={item}
                                   onVote={toggleVote}
                                   onOpen={id => setDetailId(id)} />
                    ))}
                  </div>
                : <div className="empty-state">
                    <span className="material-symbols-outlined">inventory_2</span>
                    등록된 신청이 없습니다.
                  </div>
            }

            {totalPages > 1 && (
                <div className="pagination">
                    <button className="page-btn" disabled={pageNo <= 1} onClick={() => changePage(1)}>&laquo;</button>
                    <button className="page-btn" disabled={pageNo <= 1} onClick={() => changePage(pageNo - 1)}>&lsaquo;</button>
                    {pageRange.map(p => (
                        <button key={p} className={`page-btn\${p == pageNo ? ' active' : ''}`}
                                onClick={() => changePage(p)}>{p}</button>
                    ))}
                    <button className="page-btn" disabled={pageNo >= totalPages} onClick={() => changePage(pageNo + 1)}>&rsaquo;</button>
                    <button className="page-btn" disabled={pageNo >= totalPages} onClick={() => changePage(totalPages)}>&raquo;</button>
                </div>
            )}

            {showForm && (
                <FormModal
                    onClose={() => setShowForm(false)}
                    onSubmit={() => { setShowForm(false); fetchList(1, keyword, filterStatus); setPageNo(1); }}
                />
            )}

            {detailId && (
                <DetailModal
                    snackId={detailId}
                    onClose={() => setDetailId(null)}
                    onRefresh={() => fetchList(pageNo, keyword, filterStatus)}
                />
            )}
        </div>
    );
}

const root = ReactDOM.createRoot(document.getElementById('snack-root'));
root.render(<SnackApp />);
</script>

</body>
</html>