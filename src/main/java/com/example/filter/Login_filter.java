package com.example.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/MyTask", "/MyTask/", "/Calendar", "/Calendar/", "/DashBoard", "/DashBoard/", "/Setting", "/Setting/"})
public class Login_filter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Người dùng chưa đăng nhập, chuyển hướng đến trang login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login");
        } else {
            // Người dùng đã đăng nhập, cho phép truy cập
            chain.doFilter(request, response);
        }
    }
}