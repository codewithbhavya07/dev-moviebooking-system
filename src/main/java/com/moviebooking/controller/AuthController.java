package com.moviebooking.controller;

import com.moviebooking.dao.UserDAO;
import com.moviebooking.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {
    
    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/")
    public String index(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/movies";
        }
        return "index";
    }

    @GetMapping("/login")
    public String showLogin(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/movies";
        }
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session,
                               Model model) {
        User user = userDAO.loginUser(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/movies";
        }
        model.addAttribute("error", "Invalid username or password");
        return "login";
    }

    @GetMapping("/register")
    public String showRegister(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/movies";
        }
        return "register";
    }

    @PostMapping("/register")
    public String processRegister(@RequestParam String username,
                                  @RequestParam String email,
                                  @RequestParam String password,
                                  Model model) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        
        if (userDAO.registerUser(user)) {
            model.addAttribute("success", "Registration successful. Please login.");
            return "login";
        }
        model.addAttribute("error", "Registration failed. Username might exist.");
        return "register";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout=true";
    }
}
