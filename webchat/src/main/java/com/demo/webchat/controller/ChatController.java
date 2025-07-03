package com.demo.webchat.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChatController {

    @RequestMapping(value = "chat")
    public String home(HttpServletRequest request, ModelMap model) {
        return "chat_index";
    }
}
