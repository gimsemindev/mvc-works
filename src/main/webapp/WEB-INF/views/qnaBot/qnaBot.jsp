<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<main>
	<div class="container py-5">
	    <div class="row justify-content-center">
	        <div class="col-md-8 col-lg-6">
	            <div class="card border-0 shadow-lg" style="border-radius: 7px; overflow: hidden;">
	                <div class="card-header text-center">
	                    <h5>RAG기반 호텔 AI 챗봇 서비스</h5>
	                </div>
	                
	                <div class="card-body chat-box" id="chatBox">
	                    <div class="message assistant">
	                        <div class="message-content">
	                            호텔 챗봇은 고객의 질문에 답변하거나 필요한 정보를 제공하는 AI 기반 서비스입니다.
	                        </div>
	                    </div>
	                </div>
	
	                <div class="card-footer">
	                    <form id="chatForm" class="input-group">
	                        <input type="text" id="messageInput" class="form-control me-2" 
	                               placeholder="문의사항을 입력하세요..." autocomplete="off">
	                        <button class="btn btn-send" type="submit" id="sendButton">전송</button>
	                    </form>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</main>
  
<script type="text/javascript">
const chatBox = document.getElementById('chatBox');
const chatForm = document.getElementById('chatForm');
const messageInput = document.getElementById('messageInput');
const sendButton = document.getElementById('sendButton');

// 메시지 추가 함수
function addMessage(text, sender) {
    const messageDiv = document.createElement('div');
    messageDiv.classList.add('message', sender);
    
    messageDiv.innerHTML = `<div class="message-content">${escapeHtml(text)}</div>`;
    
    chatBox.appendChild(messageDiv);

    chatBox.scrollTo({
        top: chatBox.scrollHeight,
        behavior: 'smooth'
    });
    
    return messageDiv;
}

function escapeHtml(text) {
	const div = document.createElement('div');
	div.textContent = text;
	return div.innerHTML;
}

// 전송 이벤트 핸들러
chatForm.addEventListener('submit', (e) => {
    e.preventDefault();
    sendMessage();
});

async function sendMessage() {
	const question = messageInput.value.trim();
    
    if (question) {
    	addMessage(question, 'user');
        messageInput.value = '';
        sendButton.disabled = true;
        
        try {
			const response = await fetch('${pageContext.request.contextPath}/api/question?question=' 
				+ encodeURIComponent(question));
			
			const reader = response.body.getReader();
			const decoder = new TextDecoder();
			
			const botMessageElement = addMessage('', 'assistant');
			const contentElement = botMessageElement.querySelector('.message-content');
			
			while (true) {
				const { done, value } = await reader.read();
				if (done) break;
				
				const targetText = decoder.decode(value, { stream: true });
				contentElement.innerHTML += targetText;
						
				chatBox.scrollTo({
					top: chatBox.scrollHeight,
					behavior: 'smooth'
				});	
			}
    	} catch(error) {
        	addMessage('오류가 발생했습니다. 다시 시도해주세요.', 'assistant');
			console.error('Error:', error);
        }  finally {
        	sendButton.disabled = false;
        }
    }
}
</script>
  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	
</body>
</html>