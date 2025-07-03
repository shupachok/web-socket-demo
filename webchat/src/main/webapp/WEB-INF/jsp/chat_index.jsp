<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Spring Boot WebSocket Chat</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body { font-family: sans-serif; margin: 20px; }
        #chat-container { border: 1px solid #ccc; padding: 10px; height: 300px; overflow-y: scroll; margin-bottom: 10px; }
        .message { margin-bottom: 5px; }
        .server-message { color: blue; }
        .my-message { color: green; text-align: right; }
    </style>
</head>
<body>
<h1>Spring Boot WebSocket Chat</h1>

<div id="chat-container"></div>

<div>
    <input type="text" id="senderName" placeholder="Your Name" value="Anonymous">
    <input type="text" id="messageInput" placeholder="Type your message..." size="50">
    <button onclick="sendMessage()">Send</button>
</div>
<button onclick="connect()">Connect</button>
<button onclick="disconnect()">Disconnect</button>

<script type="text/javascript">
    var stompClient = null;

    function connect() {
        var socket = new SockJS('http://localhost:8080/ws'); // ใช้ endpoint เดียวกับที่กำหนดใน Spring Boot
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            appendMessage('System', 'Connected to chat.');

            // Subscribe เพื่อรับข้อความจาก server
            stompClient.subscribe('/topic/messages', function (message) {
                var receivedMessage = JSON.parse(message.body);
                appendMessage(receivedMessage.sender, receivedMessage.content);
            });
        });
    }

    function disconnect() {
        if (stompClient !== null) {
            stompClient.disconnect();
        }
        console.log("Disconnected");
        appendMessage('System', 'Disconnected from chat.');
    }

    function sendMessage() {
        var sender = document.getElementById('senderName').value;
        var messageContent = document.getElementById('messageInput').value;
        if (messageContent && sender) {
            // ส่งข้อความไปยัง server
            stompClient.send("/app/chat", {}, JSON.stringify({'sender': sender, 'content': messageContent}));
            appendMessage(sender, messageContent, true); // แสดงข้อความของตัวเองทันที
            document.getElementById('messageInput').value = '';
        }
    }

    function appendMessage(sender, content, isMyMessage = false) {
        var chatContainer = document.getElementById('chat-container');
        var messageDiv = document.createElement('div');
        messageDiv.className = 'message';
        if (sender === 'Server') {
            messageDiv.classList.add('server-message');
        } else if (isMyMessage) {
            messageDiv.classList.add('my-message');
        }
        messageDiv.innerHTML = '<strong>' + sender + ':</strong> ' + content;
        chatContainer.appendChild(messageDiv);
        chatContainer.scrollTop = chatContainer.scrollHeight; // Scroll to bottom
    }

    // เชื่อมต่ออัตโนมัติเมื่อโหลดหน้า
    window.onload = connect;

</script>
</body>
</html>