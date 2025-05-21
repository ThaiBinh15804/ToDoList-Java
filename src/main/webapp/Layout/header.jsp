<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String currentPath = (String) request.getAttribute("currentPath");
    String pageTitle = "Task Calendar";

    if ("/MyTask".equals(currentPath)) {
        pageTitle = "Công việc của tôi";
    } else if ("/Calendar".equals(currentPath)) {
        pageTitle = "Lịch";
    } else if ("/DashBoard".equals(currentPath)) {
        pageTitle = "Bảng điều khiển";
    } else if ("/Setting".equals(currentPath)) {
        pageTitle = "Cài đặt";
    }

    com.example.model.User user = (com.example.model.User) session.getAttribute("user");
    String contextPath = request.getContextPath();
    if (user == null) {
        response.sendRedirect(contextPath + "/Login");
        return;
    }
    String userAvatar = user.avatar != null && !user.avatar.isEmpty() ? user.avatar : "/Assets/Khanh/images/avatar.jpg";
    String userFullname = user.fullname != null ? user.fullname : "Người dùng";
%>

<style>
    .dropdown {
        position: relative;
        display: inline-block;
    }
    .dropdown-content {
        display: none;
        position: absolute;
        left: 0;
        width: 100%;
        min-width: 160px;
        background-color: #d3d3d3;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
        overflow: hidden;
    }
    .dropdown-content a {
        color: #333;
        padding: 10px 16px;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        font-weight: 500;
        transition: background-color 0.2s ease;
        border-radius: 8px;
    }
    .dropdown-content a:hover {
        background-color: #a9a9a9;
        color: #333;
    }
    .dropdown-content a img {
        width: 20px;
        height: 20px;
    }
</style>

<div class="header">
    <div class="header-left">
        <h1><%= pageTitle %></h1>
    </div>
    <div>
        <form class="form-container" action="#" method="POST">
            <input type="text" class="form-input" placeholder="Nhập nội dung tìm kiếm..." name="userInput" />
            <button type="submit" class="form-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                     fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                     class="lucide lucide-search-icon lucide-search">
                    <path d="m21 21-4.34-4.34"/>
                    <circle cx="11" cy="11" r="8"/>
                </svg>
            </button>
        </form>
    </div>
    <div class="header-right">
        <button class="icon-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 class="lucide lucide-bell-icon lucide-bell">
                <path d="M10.268 21a2 2 0 0 0 3.464 0"/>
                <path d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326"/>
            </svg>
        </button>
        <div class="dropdown">
            <div style="background-color: #0466c8; padding: 8px 16px; border-radius: 99px; display: flex; align-items: center; column-gap: 20px; cursor: pointer;">
                <img src="<%= contextPath + userAvatar %>?t=<%= System.currentTimeMillis() %>" class="avatar" alt="avatar">
                <div style="display: flex; flex-direction: column;">
                    <span style="font-size: 15px; color: #f2f2f2">Xin chào,</span>
                    <span style="font-size: 15px; color: #f2f2f2; font-weight: 600; display: block"><%= userFullname %></span>
                </div>
            </div>
            <div class="dropdown-content">
                <a href="<%= contextPath %>/logout">
                    <img src="<%= contextPath %>/Assets/Khanh/images/logout.svg" alt="Logout Icon">
                    Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>

<script src="<%= contextPath %>/scripts.js"></script>