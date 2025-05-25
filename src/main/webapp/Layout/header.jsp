<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
    String currentPath = (String) request.getAttribute("currentPath");
    String pageTitle = "Task Calendar";
    String userAvatar = "/Assets/Khanh/images/avatar.jpg";
    String userFullname = "Người dùng";
    boolean isAuthenticated = false;

    try {
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
        if (user != null && user.user_id != null) {
            isAuthenticated = true;
            userAvatar = user.avatar != null && !user.avatar.isEmpty() ? "/Assets/Khanh/images/" + user.avatar : "/Assets/Khanh/images/avatar.jpg";
            userFullname = user.fullname != null ? user.fullname : "Người dùng";
        }
    } catch (Exception e) {
        System.err.println("Error in header.jsp: " + e.getMessage());
        e.printStackTrace();
    }
%>

<style>
.dropdown, .notification-dropdown {
    position: relative;
    display: inline-block;
    overflow: visible;
}

.dropdown .triangle {
     display: none;
     position: absolute;
     top: 53px;
     left: 50%;
     transform: translateX(-50%);
     border-left: 10px solid transparent;
     border-right: 10px solid transparent;
     border-bottom: 10px solid #e5e7eb;
     z-index: 1002;
     border-bottom: 11px solid #d3d3d3;
}

.dropdown-content, .notification-dropdown-content {
    display: none;
    position: absolute;
    overflow-y: auto;
    background-color: #ffffff;
    box-shadow: 0 6px 16px rgba(0,0,0,0.15);
    z-index: 1001;
    border-radius: 10px;
    border: 1px solid #e0e0e0;
    top: 64px;
    right: 0;
}

.notification-dropdown-content {
    top: 45px;
}

.notification-dropdown .triangle-2 {
    display: none;
    position: absolute;
    top: 34px;
    left: 50%;
    transform: translateX(-50%);
    border-left: 10px solid transparent;
    border-right: 10px solid transparent;
    border-bottom: 10px solid #e5e7eb;
    z-index: 1002;
    border-bottom: 11px solid #d3d3d3;
}

.dropdown-content a:hover, .notification-item:hover {
    background-color: #e5e7eb;
}

 .notification-item:hover .time-info p {
    background-color: #fff;
}

.notification-item button {
    cursor: pointer;
}

.dropdown > div, .notification-dropdown .icon-btn {
    cursor: pointer;
}

.notification-dropdown-content::-webkit-scrollbar {
    width: 8px;
}

.notification-dropdown-content::-webkit-scrollbar-thumb {
    background: #d1d5db;
    border-radius: 4px;
}

.notification-dropdown-content::-webkit-scrollbar-thumb:hover {
    background: #9ca3af;
}

.dropdown-content a, .notification-item {
    color: #333;
    padding: 14px 12px;
    text-decoration: none;
    display: flex;
    flex-direction: column;
    gap: 10px; /* Increased for spacing */
    font-size: 14px;
    font-weight: 500;
    transition: background-color 0.2s ease, transform 0.1s ease;
    border-radius: 6px; /* Rounded items */
}

.dropdown-content a {
    flex-direction: row;
    align-items: center;
}

.notification-item {
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    padding: 12px;
    width: 300px;
}

.notification-item:hover {
    background-color: #e5e7eb; /* Stronger hover effect */
    transform: translateY(-1px); /* Slight lift */
}

.notification-item:last-child {
    border-bottom: none;
}

.notification-item h4 {
    margin: 0;
    font-size: 16px; /* Larger for prominence */
    font-weight: 700; /* Bolder */
    color: #111827; /* Darker for emphasis */
    display: flex;
    align-items: center;
    gap: 8px;
}

.notification-item h4::before {
    content: '📌'; /* Icon for title */
    font-size: 14px;
}

.notification-item p {
    margin: 0;
    font-size: 13px;
    color: #6b7280; /* Softer gray */
    line-height: 1.5;
}

.notification-item p strong {
    color: #374151; /* Darker for labels */
    font-weight: 600;
}

.notification-item .time-info {
    display: grid;
    grid-template-columns: 1fr 1fr; /* Two-column for times */
    gap: 8px;
    font-size: 12px;
    color: #6b7280;
}

.notification-item .time-info p {
    margin: 0;
    padding: 6px 8px;
    background: #e5e7eb; /* Light background */
    border-radius: 4px;
}

.notification-item .time-info p.overdue {
    color: #dc2626; /* Red for overdue */
    font-weight: 600;
}

.notification-item .buttons {
    display: flex;
    justify-content: flex-end; /* Right-align buttons */
    gap: 10px;
}

.notification-item button {
    padding: 8px 12px; /* Larger buttons */
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 600;
    transition: background-color 0.2s ease, transform 0.1s ease;
}

.notification-item button:hover {
    transform: translateY(-1px);
}

.notification-item button.edit {
    background-color: #2563eb;
    color: white;
}

.notification-item button.edit:hover {
    background-color: #1d4ed8;
}

.notification-item button.complete {
    background-color: #16a34a;
    color: white;
    padding: 8px 20px; /* Slightly larger */
    font-weight: 700; /* Emphasize */
}

.notification-item button.complete:hover {
    background-color: #15803d;
}

.notification-item button.delete {
    background-color: #dc2626;
    color: white;
}

.notification-item button.delete:hover {
    background-color: #b91c1c;
}

.notification-item .error-message, .notification-item .success-message {
    padding: 6px 10px;
    border-radius: 4px;
    font-size: 12px;
    margin-top: 8px;
    font-weight: 500;
}

.notification-item .error-message {
    background: #fee2e2; /* Light red background */
    color: #dc2626;
}

.notification-item .success-message {
    background: #dcfce7; /* Light green background */
    color: #16a34a;
}

.dropdown-content a img {
    width: 20px;
    height: 20px;
}

.icon-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
    display: flex;
    align-items: center;
}
</style>

<div class="header">
    <div class="header-left">
        <h1><%= pageTitle %></h1>
    </div>
    <div class="header-middle">
        <form class="form-container" action="<%= contextPath %>/MyTask" method="GET">
            <input type="text" class="form-input" placeholder="Nhập nội dung tìm kiếm..." name="searchQuery" id="searchInput" />
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
        <% if (!isAuthenticated) { %>
            <p style="color: red;">Vui lòng <a href="<%= contextPath %>/Login">đăng nhập</a>.</p>
        <% } else { %>
            <div class="notification-dropdown">
                <span class="triangle-2"></span>
                <button class="icon-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                         class="lucide lucide-bell-icon lucide-bell">
                        <path d="M10.268 21a2 2 0 0 0 3.464 0"/>
                        <path d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326"/>
                    </svg>
                </button>
                <div class="notification-dropdown-content" id="notificationDropdown">
                    <div class="notification-item"><p>Đang tải thông báo...</p></div>
                </div>
            </div>
            <div class="dropdown">
                <div style="background-color: #0466c8; padding: 8px 12px; border-radius: 99px; display: flex; align-items: center; column-gap: 10px; cursor: pointer;">
                    <img src="<%= contextPath + userAvatar %>?t=<%= System.currentTimeMillis() %>" class="avatar" alt="avatar">
                    <div style="display: flex; flex-direction: column;">
                        <span style="font-size: 15px; color: #f2f2f2">Xin chào,</span>
                        <span style="font-size: 15px; color: #f2f2f2; font-weight: 600; display: block"><%= userFullname %></span>
                    </div>
                </div>
                <span class="triangle"></span>
                <div class="dropdown-content">
                    <a href="<%= contextPath %>/Setting">
                        <img src="<%= contextPath %>/Assets/Khanh/images/setting2.svg" alt="Account Icon">
                        Thông tin tài khoản
                    </a>
                    <a href="<%= contextPath %>/logout">
                        <img src="<%= contextPath %>/Assets/Khanh/images/logout2.svg" alt="Logout Icon">
                        Đăng xuất
                    </a>
                </div>
            </div>
        <% } %>
    </div>
</div>
<script src="<%= contextPath %>/scripts.js"></script>
<% if (isAuthenticated) { %>
<script>
    try {
        function toggleDropdown(...selectors) {
            document.querySelectorAll('.dropdown-content, .notification-dropdown-content, .triangle, .triangle-2').forEach(el => {
                el.style.display = 'none';
            });

            // Toggle các selector được truyền vào
            const isOpen = document.querySelector(selectors[0])?.style.display === 'block';
            if (!isOpen) {
                selectors.forEach(selector => {
                    const el = document.querySelector(selector);
                    if (el) el.style.display = 'block';
                });
            }
        }

        // User dropdown
        const userDropdown = document.querySelector('.dropdown');
        if (userDropdown) {
            userDropdown.addEventListener('click', function(event) {
                toggleDropdown('.dropdown-content', '.triangle');
                event.stopPropagation();
            });
        }

        // Notification dropdown
        const notificationDropdown = document.querySelector('.notification-dropdown .icon-btn');
        if (notificationDropdown) {
            notificationDropdown.addEventListener('click', function(event) {
                toggleDropdown('.notification-dropdown-content', '.triangle-2');
                event.stopPropagation();
            });
        }

        // Đóng dropdown khi click bên ngoài
        document.addEventListener('click', function () {
            document.querySelectorAll('.dropdown-content, .notification-dropdown-content, .triangle, .triangle-2').forEach(el => {
                el.style.display = 'none';
            });
        });

        // Sanitize text to prevent HTML/JavaScript injection
        function sanitizeText(text) {
            try {
                if (!text) return '';
                return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
            } catch (error) {
                console.error('Error in sanitizeText:', error);
                return '';
            }
        }

        // Show feedback message
        function showFeedback(notificationDiv, message, isError = false) {
            try {
                const feedbackDiv = document.createElement('div');
                feedbackDiv.className = isError ? 'error-message' : 'success-message';
                feedbackDiv.textContent = message;
                notificationDiv.appendChild(feedbackDiv);
                setTimeout(() => feedbackDiv.remove(), 3000);
            } catch (error) {
                console.error('Error in showFeedback:', error);
            }
        }

        // Format date/time to DD/MM/YYYY, HH:mm
        function formatVietnameseDateTime(date) {
            if (!date || isNaN(date)) return 'N/A';
            return date.toLocaleString('vi-VN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            });
        }

        // Complete task via AJAX
        function completeTask(taskId, notificationDiv) {
            try {
                if (!taskId) {
                    console.error("Task ID is missing or invalid");
                    showFeedback(notificationDiv, "Mã công việc không hợp lệ!", true);
                    return;
                }
                console.log(`Completing task ${taskId}`);
                const taskData = { task_id: taskId, status: "Hoàn thành" };
                fetch('<%= contextPath %>/CompleteTask', {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(taskData)
                })
                    .then(response => {
                        console.log('Complete response status:', response.status);
                        if (!response.ok) {
                            if (response.status === 401) {
                                Toastify({
                                    text: "❌ Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại!",
                                    duration: 2000,
                                    gravity: "top",
                                    position: "right",
                                    close: true,
                                    style: { background: "#bf4342", color: "#fff", borderRadius: "8px", padding: "14px 20px", boxShadow: "0 3px 10px rgba(0,0,0,0.2)" },
                                    stopOnFocus: true
                                }).showToast();
                                setTimeout(() => { window.location.href = `${contextPath}/Login`; }, 2000);
                                return null;
                            }
                            return response.json().then(errData => {
                                throw new Error(errData.error || `HTTP error! Status: ${response.status}`);
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (!data) return;
                        console.log('Complete response:', data);
                        if (data.message && data.message.includes("thành công")) {
                            showFeedback(notificationDiv, 'Công việc đã hoàn thành!', false);
                            setTimeout(fetchNotifications, 1000);
                            window.location.reload();
                        } else {
                            showFeedback(notificationDiv, data.error || 'Lỗi khi hoàn thành công việc', true);
                        }
                    })
                    .catch(error => {
                        console.error('Error completing task:', error);
                        showFeedback(notificationDiv, error.message || 'Lỗi khi hoàn thành công việc', true);
                    });
            } catch (error) {
                console.error('Error in completeTask:', error);
                showFeedback(notificationDiv, 'Lỗi khi hoàn thành công việc', true);
            }
        }

        // Delete task via AJAX
        function deleteTask(taskId, notificationDiv) {
            try {
                console.log(`Deleting task ${taskId}`);
                fetch('<%= contextPath %>/DeleteTask', {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ task_id: taskId })
                })
                    .then(response => {
                        console.log('Delete response status:', response.status);
                        if (!response.ok) {
                            throw new Error(`HTTP error! Status: ${response.status}`);
                        }
                        showFeedback(notificationDiv, 'Công việc đã được xóa!');
                        setTimeout(fetchNotifications, 1000);
                    })
                    .catch(error => {
                        console.error('Error deleting task:', error);
                        showFeedback(notificationDiv, 'Lỗi khi xóa công việc', true);
                    });
            } catch (error) {
                console.error('Error in deleteTask:', error);
                showFeedback(notificationDiv, 'Lỗi khi xóa công việc', true);
            }
        }

        // Edit task via AJAX
        function editTask(taskId, notificationDiv) {
            try {
                console.log(`Editing task ${taskId}`);
                window.location.href = '<%= contextPath %>/MyTask?editTaskId=' + encodeURIComponent(taskId);
            } catch (error) {
                console.error('Error in editTask:', error);
                Toastify({
                    text: "❌ Lỗi khi mở chỉnh sửa công việc!",
                    duration: 2000,
                    gravity: "top",
                    position: "right",
                    close: true,
                    style: {
                        background: "#bf4342",
                        color: "#fff",
                        borderRadius: "8px",
                        padding: "14px 20px",
                        boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                    },
                    stopOnFocus: true
                }).showToast();
            }
        }

        // Fetch notifications and store in localStorage
        function fetchNotifications() {
            try {
                console.log('Fetching notifications');
                fetch('<%= contextPath %>/Notifications', { credentials: 'same-origin' })
                    .then(response => {
                        console.log('Response status:', response.status);
                        if (!response.ok) {
                            throw new Error(`HTTP error! Status: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Notifications data:', data);
                        localStorage.setItem('notifications', JSON.stringify(data || []));
                        displayNotifications();
                    })
                    .catch(error => {
                        console.error('Error fetching notifications:', error);
                        if (document.getElementById('notificationDropdown')) {
                            document.getElementById('notificationDropdown').innerHTML =
                                '<div class="notification-item"><p>Lỗi khi tải thông báo!</p></div>';
                        }
                    });
            } catch (error) {
                console.error('Error in fetchNotifications:', error);
            }
        }

        // Display notifications from localStorage
        function displayNotifications() {
            try {
                console.log('Displaying notifications');
                const notifications = JSON.parse(localStorage.getItem('notifications')) || [];
                console.log('Notifications array:', notifications);
                const dropdown = document.getElementById('notificationDropdown');
                if (!dropdown) {
                    console.error('notificationDropdown element not found');
                    return;
                }
                dropdown.innerHTML = '';
                if (notifications.length === 0) {
                    console.log('No notifications to display');
                    dropdown.innerHTML = '<div class="notification-item"><p style="text-align: center";>Không có thông báo mới.</p></div>';
                    return;
                }
                notifications.forEach((notification, index) => {
                    try {
                        if (!notification) {
                            console.warn(`Notification ${index} is null or undefined`);
                            return;
                        }
                        const div = document.createElement('div');
                        div.className = 'notification-item';
                        const startTime = notification.start_time ? new Date(notification.start_time) : null;
                        const endTime = notification.end_time ? new Date(notification.end_time) : null;
                        if (notification.start_time && isNaN(startTime)) {
                            console.warn(`Invalid start_time for notification ${index}:`, notification.start_time);
                        }
                        if (notification.end_time && isNaN(endTime)) {
                            console.warn(`Invalid end_time for notification ${index}:`, notification.end_time);
                        }
                        let buttonsHtml = '';
                        if (notification.type && notification.type.includes('OVERDUE')) {
                            buttonsHtml += '<button class="edit" onclick="editTask(\'' + sanitizeText(notification.task_id) + '\', this.parentElement.parentElement)">Chỉnh sửa</button>';
                        }
                        if (notification.type === 'OVERDUE_NOT_STARTED') {
                            buttonsHtml += '<button class="delete" onclick="deleteTask(\'' + sanitizeText(notification.task_id) + '\', this.parentElement.parentElement)">Xóa</button>';
                        }
                        if (notification.type === 'OVERDUE_IN_PROGRESS') {
                            buttonsHtml += '<button class="complete" onclick="completeTask(\'' + sanitizeText(notification.task_id) + '\', this.parentElement.parentElement)">Hoàn thành</button>';
                        }
                        div.innerHTML =
                            '<h4>' + (sanitizeText(notification.title) || 'Không có tiêu đề') + '</h4>' +
                            '<p>' + (sanitizeText(notification.description) || 'Không có mô tả') + '</p>' +
                            '<div class="time-info">' +
                            '<p><strong>Bắt đầu:</strong> ' + formatVietnameseDateTime(startTime) + '</p>' +
                            '<p><strong>Kết thúc:</strong> ' + formatVietnameseDateTime(endTime) + '</p>' +
                            '</div>' +
                            (buttonsHtml ? '<div class="buttons">' + buttonsHtml + '</div>' : '');
                        dropdown.appendChild(div);
                    } catch (error) {
                        console.error(`Error processing notification ${index}:`, error);
                    }
                });
            } catch (error) {
                console.error('Error in displayNotifications:', error);
                if (document.getElementById('notificationDropdown')) {
                    document.getElementById('notificationDropdown').innerHTML =
                        '<div class="notification-item"><p>Lỗi khi hiển thị thông báo!</p></div>';
                }
            }
        }

        // Fetch notifications after page load
        window.addEventListener('load', () => setTimeout(fetchNotifications, 1000));
    } catch (error) {
        console.error('Error in header.jsp script:', error);
    }
</script>
<% } %>