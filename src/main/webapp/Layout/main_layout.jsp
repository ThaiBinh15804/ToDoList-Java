<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<% String currentPath = (String) request.getAttribute("currentPath"); %>

<!DOCTYPE html>
<html>
<head>
    <title>Todo List</title>
    <link rel="stylesheet" href="<%= contextPath %>/styles.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="logo">
                <img src="<%= contextPath %>/Assets/Thuan/images/todo-high-resolution-logo.png" alt="HoPR Logo"
                style="width: 100px;">
            </div>
            <ul class="menu">
                <li>
                    <a href="<%= contextPath %>/DashBoard"
                         class="<%= "/DashBoard".equals(currentPath) ? "active" : "" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24"
                         height="24" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round"
                         class="lucide lucide-layout-dashboard-icon lucide-layout-dashboard"><rect width="7"
                         height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/>
                         <rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7"
                         height="5" x="3" y="16" rx="1"/></svg>
                        <span>Bảng điều khiển</span>
                    </a>
                </li>
                <li>
                      <a href="<%= contextPath %>/MyTask"
                          class="<%= "/MyTask".equals(currentPath) ? "active" : "" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                        class="lucide lucide-square-check-big-icon lucide-square-check-big">
                        <path d="M21 10.5V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h12.5"/>
                        <path d="m9 11 3 3L22 4"/></svg>
                        <span>Công việc của tôi</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/Calendar"
                        class="<%= "/Calendar".equals(currentPath) ? "active" : "" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                            class="lucide lucide-calendar-check-icon lucide-calendar-check">
                            <path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18"
                            x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/>
                        <span>Lịch</span></svg>
                    </a>
                </li>
                <li>
                     <a href="<%= contextPath %>/Setting"
                        class="<%= "/Setting".equals(currentPath) ? "active" : "" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-settings-icon lucide-settings"><path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/></svg>
                    <span>
                        Cài đặt
                    </span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="main-content">
            <jsp:include page="/Layout/header.jsp" />
            <% String cp = (String) request.getAttribute("contentPage"); %>

            <div style="padding: 8px 12px;">
                <% if (cp != null) { %>
                    <jsp:include page="<%= cp %>" />
                <% } else { %>
                    <p>Error: Content page not found.</p>
                <% } %>
            </div>
        </div>
        <div style="position: fixed; bottom: 0; left: 0; padding: 8px;">
            <a href="<%= contextPath %>/logout" style="display: flex; align-items: center; background-color: #1e3a8a; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px;">
                <img src="<%= contextPath %>/Assets/Khanh/images/logout.svg" alt="Logout Icon" style="width: 30px; height: 30px; margin-right: 8px;">
                Đăng xuất
            </a>
        </div>
    </div>
</body>
</html>