package com.demo.websocket.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // กำหนด prefix สำหรับ destination ที่จะส่งไปหา client (subscribe)
        // เช่น /topic/messages
        config.enableSimpleBroker("/topic");
        // กำหนด prefix สำหรับ destination ที่ client จะส่งมาหา server (send)
        // เช่น /app/chat
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // กำหนด endpoint ที่ client จะใช้ในการเชื่อมต่อ WebSocket
        // และอนุญาตให้เชื่อมต่อจากทุกโดเมน (cross-origin)
        registry.addEndpoint("/ws")
                .setAllowedOrigins("http://localhost:8081")
                .withSockJS();
    }
}