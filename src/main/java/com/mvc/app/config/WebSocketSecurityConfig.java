package com.mvc.app.config;

import com.mvc.app.domain.dto.SessionInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

/**
 * WebSocket + STOMP + SockJS 통합 설정
 * - @EnableWebSocketMessageBroker : SimpMessagingTemplate Bean 등록
 * - registerStompEndpoints        : /ws/chat 엔드포인트 + HTTP 세션 복사
 * - configureMessageBroker        : /topic, /queue, /app prefix 설정
 * - configureClientInboundChannel : CONNECT 시 인증 검증
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketSecurityConfig implements WebSocketMessageBrokerConfigurer {

    /**
     * STOMP 엔드포인트 등록
     * HandshakeInterceptor: HTTP 세션의 member(SessionInfo)를
     * WebSocket 세션 attributes에 복사
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws/chat")
                .setAllowedOriginPatterns("*")
                .addInterceptors(new HandshakeInterceptor() {
                    @Override
                    public boolean beforeHandshake(ServerHttpRequest request,
                                                   ServerHttpResponse response,
                                                   WebSocketHandler wsHandler,
                                                   Map<String, Object> attributes) {
                        if (request instanceof ServletServerHttpRequest servletRequest) {
                            HttpSession httpSession = servletRequest
                                    .getServletRequest().getSession(false);
                            if (httpSession != null) {
                                SessionInfo member =
                                        (SessionInfo) httpSession.getAttribute("member");
                                if (member != null) {
                                    attributes.put("member", member);
                                }
                            }
                        }
                        return true;
                    }

                    @Override
                    public void afterHandshake(ServerHttpRequest request,
                                               ServerHttpResponse response,
                                               WebSocketHandler wsHandler,
                                               Exception exception) {}
                })
                .withSockJS();
    }

    /**
     * 메시지 브로커 설정
     * - /topic : 채팅방별 브로드캐스트 구독
     * - /queue : 개인 메시지 (에러 알림 등)
     * - /app   : 클라이언트 → 서버 전송 prefix
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic", "/queue");
        registry.setApplicationDestinationPrefixes("/app");
        registry.setUserDestinationPrefix("/user");
    }

    /**
     * STOMP CONNECT 시 인증 검증
     * - member 세션이 없으면 연결 거부
     */
    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor =
                        MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

                if (accessor != null && StompCommand.CONNECT.equals(accessor.getCommand())) {
                    Map<String, Object> attrs = accessor.getSessionAttributes();
                    if (attrs == null || attrs.get("member") == null) {
                        throw new IllegalStateException("인증되지 않은 WebSocket 연결입니다.");
                    }
                }
                return message;
            }
        });
    }
}