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
%>

<div class="header">
    <div class="header-left">
        <h1><%= pageTitle %></h2>
    </div>
    <div class="header-middle">
        <form class="form-container" action="#" method="POST">
              <input type="text" class="form-input" placeholder="Nhập nội dung tìm kiếm..." name="userInput" />
              <button type="submit" class="form-button">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                    fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                    class="lucide lucide-search-icon lucide-search"><path d="m21 21-4.34-4.34"/><circle cx="11" cy="11" r="8"/>
                    </svg>
              </button>
        </form>
    </div>
    <div class="header-right">
        <button class="icon-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-bell-icon lucide-bell"><path d="M10.268 21a2 2 0 0 0 3.464 0"/>
             <path d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326"/>
             </svg>
        </button>
        <div style="background-color: #0466c8; padding: 8px 16px; border-radius: 99px; display: flex; align-items: center; column-gap: 8px;">
            <img src="https://i.pravatar.cc/40" class="avatar" alt="avatar">
            <div style="display: flex; flex-direction: column;">
                 <span style="font-size: 15px; color: #f2f2f2">Xin chào,</span>
                 <span style="font-size: 15px; color: #f2f2f2; font-weight: 600; display: block">Thuan pham</span>
            </div>
        </div>
    </div>
</div>
