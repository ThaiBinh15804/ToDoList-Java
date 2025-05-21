<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.example.model.User user = (com.example.model.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }
    String contextPath = request.getContextPath();
%>

<style>
    .content {
        background-color: white;
        padding: 40px;
        margin: 40px auto;
        border-radius: 12px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        width: 70%;
        max-width: 800px;
    }
    .content img {
        border-radius: 50%;
        width: 100px;
        height: 100px;
        display: block;
        margin: 0 auto 15px;
    }
    .content h2 {
        text-align: center;
        font-size: 24px;
        margin-bottom: 20px;
    }
    .content p {
        text-align: center;
        font-size: 16px;
        margin: 5px 0;
    }
    .form-group {
        margin-bottom: 20px;
        position: relative;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-size: 16px;
        font-weight: bold;
    }
    .form-group input {
        width: 100%;
        padding: 12px 40px 12px 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        box-sizing: border-box;
        font-size: 16px;
    }
    .form-group .eye-icon {
        position: absolute;
        right: 10px;
        top: 70%;
        transform: translateY(-50%);
        cursor: pointer;
        font-size: 18px;
        color: #666;
    }
    .buttons {
        margin-top: 30px;
        display: flex;
        justify-content: center;
        gap: 15px;
    }
    .buttons button {
        padding: 12px 30px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
    }
    .buttons .update {
        background-color: #ff9800;
        color: white;
    }
    .buttons .cancel {
        background-color: #ff4d4d;
        color: white;
    }
    .go-back {
        float: right;
        text-decoration: none;
        color: #007bff;
    }
    .toast {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 15px;
        z-index: 1000;
        font-size: 18px;
        font-weight: 500;
        min-width: 200px;
        max-width: 400px;
        visibility: visible;
        flex-direction: column; /* Đặt flex-direction để thanh tiến trình nằm dưới nội dung */
    }
    .toast.error {
        background-color: #d32f2f;
        color: #ffffff;
    }
    .toast.success {
        background-color: #4caf50;
        color: #ffffff;
    }
    .toast.hidden {
        display: none;
    }
    .toast .close-btn {
        cursor: pointer;
        font-size: 18px;
        font-weight: bold;
        color: #ffffff;
        line-height: 1;
    }
    .toast .close-btn:hover {
        color: #f0f0f0;
    }
    .toast .message-container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        gap: 20px;
    }
    .toast .progress-bar {
        width: 100%;
        height: 4px;
        background-color: rgba(255, 255, 255, 0.3);
        margin-top: 8px;
        border-radius: 2px;
        overflow: hidden;
    }
    .toast .progress-bar .progress {
        height: 100%;
        background-color: #ffffff;
        width: 100%;
        animation: progress 2s linear forwards;
    }
    @keyframes progress {
        from {
            width: 100%;
        }
        to {
            width: 0%;
        }
    }
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<div class="content">
    <a href="<%= contextPath %>/Setting" class="go-back">Quay lại</a>
    <h2>ĐỔI MẬT KHẨU</h2>
    <img id="avatar-preview" src="<%= contextPath + (user.avatar != null && !user.avatar.isEmpty() ? user.avatar + "?t=" + System.currentTimeMillis() : "/Assets/Khanh/images/avatar.jpg") %>" alt="Avatar" onerror="this.src='<%= contextPath %>/Assets/Khanh/images/avatar.jpg';">
    <form action="<%= contextPath %>/ChangePassword" method="post">
        <div class="form-group">
            <label>MẬT KHẨU HIỆN TẠI</label>
            <input type="password" name="currentPassword" id="currentPassword" required>
            <span class="eye-icon" onclick="togglePassword('currentPassword', this)">
                <i class="fas fa-eye"></i>
            </span>
        </div>
        <div class="form-group">
            <label>MẬT KHẨU MỚI</label>
            <input type="password" name="newPassword" id="newPassword" required>
            <span class="eye-icon" onclick="togglePassword('newPassword', this)">
                <i class="fas fa-eye"></i>
            </span>
        </div>
        <div class="form-group">
            <label>XÁC NHẬN MẬT KHẨU</label>
            <input type="password" name="confirmPassword" id="confirmPassword" required>
            <span class="eye-icon" onclick="togglePassword('confirmPassword', this)">
                <i class="fas fa-eye"></i>
            </span>
        </div>
        <div class="buttons">
            <button type="submit" class="update">CẬP NHẬT MẬT KHẨU</button>
            <button type="button" class="cancel" onclick="window.location.href='<%= contextPath %>/Setting'">HỦY</button>
        </div>
    </form>

    <% String error = (String) request.getAttribute("error"); %>
    <% String success = (String) session.getAttribute("Success"); %>
    <% if (error != null) { %>
        <div id="error-toast" class="toast error">
            <div class="message-container">
                <span><%= error %></span>
                <span class="close-btn" onclick="closeToast()">×</span>
            </div>
            <div class="progress-bar">
                <div class="progress"></div>
            </div>
        </div>
    <% } else if (success != null) { %>
        <div id="success-toast" class="toast success">
            <div class="message-container">
                <span><%= success %></span>
                <span class="close-btn" onclick="closeToast('success-toast')">X</span>
            </div>
            <div class="progress-bar">
                <div class="progress"></div>
            </div>
        </div>
        <% session.removeAttribute("Success"); %>
    <% } %>
</div>