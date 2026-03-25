<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%
String ctxPath = request.getContextPath();
String userLevel = "";
String empId = "";
Object member = session.getAttribute("member");
if (member != null) {
	try {
		userLevel = String.valueOf(member.getClass().getMethod("getUserLevel").invoke(member));
		empId = String.valueOf(member.getClass().getMethod("getEmpId").invoke(member));
	} catch (Exception e) { /* ignore */ }
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC - 탕비실 신청</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<style>
/* --- 기본 레이아웃 --- */
#main-content { margin-left: 240px !important; padding: 28px 32px !important; box-sizing: border-box; min-height: 100vh; background: #f8f9fc; }

/* --- 모달 레이어 (Portal 최적화) --- */
.modal-overlay {
    position: fixed !important;
    top: 0 !important; left: 0 !important; right: 0 !important; bottom: 0 !important;
    width: 100vw !important; height: 100vh !important;
    background: rgba(0, 0, 0, 0.6) !important;
    z-index: 999999 !important; /* 사이드바보다 높은 값 */
    display: flex !important;
    align-items: center; justify-content: center;
    pointer-events: auto !important;
}

.modal {
    background: #fff; border-radius: 16px; width: 550px; max-width: 90%;
    max-height: 90vh; overflow-y: auto; position: relative;
    z-index: 1000000 !important;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    display: flex; flex-direction: column;
}

.modal-header { padding: 20px 24px; border-bottom: 1px solid #f0f2f9; display: flex; justify-content: space-between; align-items: center; }
.modal-body { padding: 24px; flex: 1; }
.modal-footer { padding: 16px 24px; border-top: 1px solid #f0f2f9; display: flex; justify-content: flex-end; gap: 8px; }

/* --- 컴포넌트 스타일 --- */
.snack-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.btn-request { display: inline-flex; align-items: center; gap: 6px; background: #4e73df; color: #fff; border: none; border-radius: 8px; padding: 10px 20px; font-weight: 600; cursor: pointer; }
.snack-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 16px; }
.snack-card { background: #fff; border-radius: 12px; border: 1px solid #e6eaf4; padding: 20px; cursor: pointer; transition: transform 0.2s; }
.snack-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }

.status-badge { font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 12px; margin-left: 8px; }
.status-PENDING { background: #fff4e0; color: #d97706; }
.status-APPROVED { background: #ecfdf5; color: #059669; }
.status-REJECTED { background: #fef2f2; color: #dc2626; }

.form-row { margin-bottom: 16px; }
.form-row label { display: block; font-size: 12px; font-weight: 700; margin-bottom: 6px; color: #4e5968; }
.form-row input, .form-row textarea { width: 100%; padding: 10px; border: 1px solid #d8dde6; border-radius: 8px; box-sizing: border-box; }

.vote-btn { display: inline-flex; align-items: center; gap: 4px; background: #f8f9fa; border: 1px solid #e2e5ef; border-radius: 20px; padding: 6px 14px; font-size: 13px; cursor: pointer; }
.vote-btn.voted { background: #eef2ff; border-color: #4e73df; color: #4e73df; }
.comment-item { background: #f8f9fc; border-radius: 8px; padding: 12px; margin-top: 8px; font-size: 13px; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	<jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

	<main id="main-content">
		<div id="snack-root"></div>
	</main>

	<script src="https://unpkg.com/react@18/umd/react.development.js"></script>
	<script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
	<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>

	<script>
        /* JSP 변수 할당 에러 수정 */
        var SNACK_CTX      = '<%= request.getContextPath() %>';
		var SNACK_IS_ADMIN = <%= "99".equals(userLevel) %>;
		var SNACK_EMP_ID   = '<%= (empId != null) ? empId.trim() : "" %>'; 
	</script>

	<script type="text/babel">
const { useState, useEffect, useCallback } = React;
const { createPortal } = ReactDOM;

const statusLabel = s => ({ PENDING: '대기중', APPROVED: '승인', REJECTED: '반려' }[s] || s);

/* 1. 신청 폼 모달 (Portal 방식) */
function FormModal({ onClose, onSubmit }) {
    const [form, setForm] = useState({ itemName: '', quantity: 1, reason: '' });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await fetch(`\${SNACK_CTX}/api/snack`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(form)
            });
            if (res.ok) {
                alert('신청되었습니다.');
                onSubmit();
            }
        } catch (err) { console.error(err); }
    };

    return createPortal(
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal" onClick={e => e.stopPropagation()}>
                <div className="modal-header">
                    <h3 style={{margin:0}}>비품 신청하기</h3>
                    <button onClick={onClose} style={{background:'none', border:'none', cursor:'pointer'}}>
                        <span className="material-symbols-outlined">close</span>
                    </button>
                </div>
                <form onSubmit={handleSubmit}>
                    <div className="modal-body">
                        <div className="form-row">
                            <label>품목명</label>
                            <input autoFocus value={form.itemName} onChange={e => setForm({...form, itemName: e.target.value})} required placeholder="예: 아메리카노 캡슐" />
                        </div>
                        <div className="form-row">
                            <label>수량</label>
                            <input type="number" min="1" value={form.quantity} onChange={e => setForm({...form, quantity: e.target.value})} />
                        </div>
                        <div className="form-row">
                            <label>신청 이유</label>
                            <textarea value={form.reason} onChange={e => setForm({...form, reason: e.target.value})} required style={{height:'100px'}} />
                        </div>
                    </div>
                    <div className="modal-footer">
                        <button type="button" onClick={onClose} style={{padding:'8px 16px', border:'none', borderRadius:'6px', cursor:'pointer'}}>취소</button>
                        <button type="submit" style={{padding:'8px 16px', background:'#4e73df', color:'#fff', border:'none', borderRadius:'6px', cursor:'pointer'}}>신청하기</button>
                    </div>
                </form>
            </div>
        </div>,
        document.body
    );
}

/* 2. 상세 보기 모달 (Portal 방식) */
function DetailModal({ snackId, onClose, onRefresh }) {
    const [detail, setDetail] = useState(null);
    const [newComment, setNewComment] = useState('');
    const [loading, setLoading] = useState(true);

    const load = useCallback(async () => {
    try {
        setLoading(true);
        const url = `\${SNACK_CTX}/api/snack/\${snackId}`.replace(/\/+/g, '/');
        const res = await fetch(url);

        if (!res.ok) {
            throw new Error('데이터를 불러오지 못했습니다.');
        }

        const text = await res.text();
        if (text.includes("<!DOCTYPE")) {
        
            return;
        }

        const data = JSON.parse(text);
        setDetail(data);
    } catch (err) {
        onClose();
    } finally {
        setLoading(false);
    }
}, [snackId, onClose]);

    useEffect(() => { load(); }, [load]);

    const [adminComment, setAdminComment] = useState('');

    const updateStatus = async (newStatus) => {
        if (newStatus === 'REJECTED' && !adminComment.trim()) {
            alert('반려 사유를 입력해주세요.');
            return;
        }
        if (!confirm(newStatus === 'APPROVED' ? '승인하시겠습니까?' : '반려하시겠습니까?')) return;
        try {
            const res = await fetch(`\${SNACK_CTX}/api/snack/\${snackId}/status`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ status: newStatus, adminComment: adminComment })
            });
            if (res.ok) {
                alert(newStatus === 'APPROVED' ? '승인되었습니다.' : '반려되었습니다.');
                onRefresh();
                load();
            }
        } catch (err) { console.error(err); }
    };

    const toggleVote = async () => {
        try {
            await fetch(`\${SNACK_CTX}/api/snack/\${snackId}/vote`, { method: 'POST' });
            load();
        } catch (err) { console.error(err); }
    };

    const submitComment = async () => {
        if (!newComment.trim()) return;
        try {
            await fetch(`\${SNACK_CTX}/api/snack/\${snackId}/comment`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ content: newComment })
            });
            setNewComment('');
            load();
        } catch (err) { console.error(err); }
    };

    if (loading) return null;
    if (!detail) return null;

    return createPortal(
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal" onClick={e => e.stopPropagation()}>
                <div className="modal-header">
                    <h3 style={{margin:0}}>신청 상세 보기</h3>
                    <button onClick={onClose} style={{background:'none', border:'none', cursor:'pointer', display:'flex'}}>
                        <span className="material-symbols-outlined">close</span>
                    </button>
                </div>
                <div className="modal-body">
                    <div style={{display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:'16px'}}>
                        <span style={{fontWeight:700, fontSize:'16px'}}>{detail.itemName}</span>
                        <span className={`status-badge status-\${detail.status}`}>{statusLabel(detail.status)}</span>
                    </div>
                    <div style={{fontSize:'13px', color:'#667085', marginBottom:'8px'}}>수량: {detail.quantity}개</div>
                    <div style={{fontSize:'13px', color:'#667085', marginBottom:'8px'}}>신청자: {detail.requesterName}</div>
                    <div style={{fontSize:'13px', color:'#667085', marginBottom:'16px'}}>신청일: {detail.regDate}</div>
                    <div style={{background:'#f8f9fc', borderRadius:'8px', padding:'14px', marginBottom:'16px', fontSize:'14px', lineHeight:'1.6'}}>
                        {detail.reason}
                    </div>

                    {detail.adminComment && (
                        <div style={{background:'#fff8f0', borderRadius:'8px', padding:'14px', marginBottom:'16px', fontSize:'13px', border:'1px solid #fde4c8'}}>
                            <strong>관리자 의견:</strong> {detail.adminComment}
                        </div>
                    )}

                    {SNACK_IS_ADMIN && detail.status === 'PENDING' && (
                        <div style={{background:'#f0f4ff', borderRadius:'8px', padding:'16px', marginBottom:'16px', border:'1px solid #d0d9f0'}}>
                            <h4 style={{margin:'0 0 10px', fontSize:'14px', color:'#4e5968'}}>관리자 처리</h4>
                            <textarea
                                value={adminComment}
                                onChange={e => setAdminComment(e.target.value)}
                                placeholder="승인/반려 사유를 입력하세요 (반려 시 필수)"
                                style={{width:'100%', padding:'10px', border:'1px solid #d8dde6', borderRadius:'8px', height:'70px', boxSizing:'border-box', marginBottom:'10px'}}
                            />
                            <div style={{display:'flex', gap:'8px', justifyContent:'flex-end'}}>
                                <button onClick={() => updateStatus('APPROVED')} style={{padding:'8px 20px', background:'#059669', color:'#fff', border:'none', borderRadius:'6px', cursor:'pointer', fontWeight:600}}>승인</button>
                                <button onClick={() => updateStatus('REJECTED')} style={{padding:'8px 20px', background:'#dc2626', color:'#fff', border:'none', borderRadius:'6px', cursor:'pointer', fontWeight:600}}>반려</button>
                            </div>
                        </div>
                    )}

                    <div style={{display:'flex', alignItems:'center', gap:'12px', marginBottom:'20px'}}>
                        <button className={`vote-btn\${detail.voted ? ' voted' : ''}`} onClick={toggleVote}>
                            <span className="material-symbols-outlined" style={{fontSize:'16px'}}>thumb_up</span>
                            공감 {detail.voteCount}
                        </button>
                    </div>

                    <div style={{borderTop:'1px solid #f0f2f9', paddingTop:'16px'}}>
                        <h4 style={{margin:'0 0 12px', fontSize:'14px'}}>댓글 ({detail.comments ? detail.comments.length : 0})</h4>
                        {detail.comments && detail.comments.map(c => (
                            <div key={c.commentId} className="comment-item">
                                <div style={{display:'flex', justifyContent:'space-between', marginBottom:'4px'}}>
                                    <strong style={{fontSize:'12px'}}>{c.authorName}</strong>
                                    <span style={{fontSize:'11px', color:'#9aa0b4'}}>{c.regDate}</span>
                                </div>
                                <div>{c.content}</div>
                            </div>
                        ))}
                        <div style={{display:'flex', gap:'8px', marginTop:'12px'}}>
                            <input
                                value={newComment}
                                onChange={e => setNewComment(e.target.value)}
                                onKeyDown={e => e.key === 'Enter' && submitComment()}
                                placeholder="댓글을 입력하세요"
                                style={{flex:1, padding:'10px', border:'1px solid #d8dde6', borderRadius:'8px'}}
                            />
                            <button onClick={submitComment} style={{padding:'10px 16px', background:'#4e73df', color:'#fff', border:'none', borderRadius:'8px', cursor:'pointer', whiteSpace:'nowrap'}}>등록</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>,
        document.body
    );
}

/* 3. 메인 앱 컴포넌트 */
function SnackApp() {
    const [list, setList] = useState([]);
    const [showForm, setShowForm] = useState(false);
    const [selectedId, setSelectedId] = useState(null);

    const fetchList = useCallback(async () => {
    try {
        const response = await fetch(`${SNACK_CTX}/api/snack/list?pageNo=1&pageSize=12`);
        
        // JSON 파싱 전 텍스트로 먼저 받아보기 (디버깅용)
        const text = await response.text();

        // 만약 응답이 HTML로 시작한다면(404나 500 에러 페이지)
        if (text.trim().startsWith("<!DOCTYPE")) {
            console.error("서버에서 JSON 대신 HTML을 반환했습니다. 경로를 확인하세요.");
            return;
        }

        const data = JSON.parse(text);
        setList(data.list || data); // data.list가 없으면 data 자체가 배열인지 확인
    } catch(e) { 
        console.error("데이터 로딩 중 에러:", e); 
    }
}, []);

    useEffect(() => { fetchList(); }, [fetchList]);

    return (
        <div>
            <div className="snack-header">
                <div>
                    <h2 style={{margin:0}}>탕비실 비품 신청</h2>
                    <p style={{margin:0, color:'#9aa0b4', fontSize:'13px'}}>원하는 비품을 신청하고 동료들의 공감을 얻어보세요.</p>
                </div>
                <button className="btn-request" onClick={() => setShowForm(true)}>
                    <span className="material-symbols-outlined" style={{fontSize:'18px'}}>add</span>
                    신청하기
                </button>
            </div>

            <div className="snack-grid">
                {list.length > 0 ? list.map(item => (
                    <div key={item.snackId} className="snack-card" onClick={() => setSelectedId(item.snackId)}>
                        <div style={{display:'flex', justifyContent:'space-between', alignItems:'flex-start', marginBottom:'12px'}}>
                            <span style={{fontWeight:700}}>{item.itemName}</span>
                            <span className={`status-badge status-\${item.status}`} style={{margin:0}}>{statusLabel(item.status)}</span>
                        </div>
                        <div style={{fontSize:'13px', color:'#667085', overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap'}}>
                            {item.reason}
                        </div>
                        <div style={{marginTop:'16px', display:'flex', justifyContent:'space-between', alignItems:'center'}}>
                            <span style={{fontSize:'12px', color:'#9aa0b4'}}>공감 {item.voteCount}</span>
                            <span style={{fontSize:'12px', color:'#4e73df'}}>{item.requesterName}</span>
                        </div>
                    </div>
                )) : (
                    <div style={{gridColumn:'1/-1', textAlign:'center', padding:'100px', color:'#9aa0b4'}}>
                         등록된 신청이 없습니다.
                    </div>
                )}
            </div>

            {/* Portal 기반 모달들 */}
            {showForm && <FormModal onClose={() => setShowForm(false)} onSubmit={() => { setShowForm(false); fetchList(); }} />}
            {selectedId && <DetailModal snackId={selectedId} onClose={() => setSelectedId(null)} onRefresh={fetchList} />}
        </div>
    );
}

const root = ReactDOM.createRoot(document.getElementById('snack-root'));
root.render(<SnackApp />);
</script>
</body>
</html>