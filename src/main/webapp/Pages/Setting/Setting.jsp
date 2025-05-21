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
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-size: 16px;
        font-weight: bold;
    }
    .form-group input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 16px;
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
    .buttons .change-password {
        background-color: #ff4d4d;
        color: white;
    }
    .avatar-upload {
        text-align: center;
        margin: 15px 0;
    }
    .toast {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        z-index: 1000;
        font-size: 18px;
        font-weight: 500;
        min-width: 200px;
        max-width: 400px;
        visibility: visible;
        flex-direction: column;
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
    .toast .message-container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        gap: 20px;
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

<div class="content">
    <h2>THÔNG TIN NGƯỜI DÙNG</h2>
    <img id="avatar-preview" src="<%= contextPath + (user.avatar != null && !user.avatar.isEmpty() ? "/Assets/Khanh/images/" + user.avatar + "?t=" + System.currentTimeMillis() : "/Assets/Khanh/images/avatar.jpg") %>" alt="Avatar" onerror="this.src='<%= contextPath %>/Assets/Khanh/images/haha.jpg';">
    <form action="<%= contextPath %>/UpdateSettings" method="post" enctype="multipart/form-data">
        <div class="avatar-upload">
            <input type="file" id="avatar-input" name="avatar" accept="image/jpeg,image/png,image/gif">
        </div>
        <div class="form-group">
            <label>TÊN NGƯỜI DÙNG</label>
            <input type="text" name="fullname" value="<%= user.fullname %>" required>
        </div>
        <div class="form-group">
            <label>TÊN TÀI KHOẢN</label>
            <input type="text" name="username" value="<%= user.username %>" readonly disabled>
        </div>
        <div class="form-group">
            <label>EMAIL</label>
            <input type="email" name="email" value="<%= user.email %>" required>
        </div>
        <div class="form-group">
            <label>SỐ ĐIỆN THOẠI</label>
            <% String phoneValue = user.phone != null ? user.phone : ""; %>
            <input type="text" name="phone" value="<%= phoneValue %>">
        </div>
        <div class="buttons">
            <button type="submit" class="update">CẬP NHẬT</button>
            <button type="button" class="change-password" onclick="window.location.href='<%= contextPath %>/ChangePassword'">THAY ĐỔI MẬT KHẨU</button>
        </div>
    </form>

    <% String error = (String) request.getAttribute("error"); %>
    <% String success = (String) request.getAttribute("success"); %>
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
    <% } %>
</div>