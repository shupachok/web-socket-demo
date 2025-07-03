package com.demo.websocket.controller;

import com.demo.websocket.model.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class MessageController {

    // @MessageMapping กำหนด destination ที่ client จะส่งข้อความมาหา
    // เช่น client ส่งไปที่ /app/chat
    @MessageMapping("/chat")
    // @SendTo กำหนด destination ที่ข้อความจะถูกส่งกลับไปหา client ที่ subscribe
    // เช่น client subscribe /topic/messages
    @SendTo("/topic/messages")
    public Message handleMessage(Message message) {
        // สามารถประมวลผลข้อความได้ที่นี่
        System.out.println("Received message: " + message.getContent() + " from " + message.getSender());
        return new Message("Server", "Hello, " + message.getSender() + "! Your message was: " + message.getContent());
    }
}
