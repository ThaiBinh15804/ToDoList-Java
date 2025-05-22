<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký - Todo List</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background-color: #E7F7FF;
            background-size: cover;
            background-position: bottom;
        }
        .signup-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            padding: 20px;
        }
        .signup-box {
            display: flex;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-width: 1200px;
            width: 100%;
            min-height: 700px;
            overflow: hidden;
        }
        .illustration {
            width: 50%;
            background-color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .illustration img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .signup-form {
            padding: 50px;
            width: 50%;
        }
        .signup-form h2 {
            margin-bottom: 25px;
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        .form-group input {
            width: 100%;
            padding: 14px 40px 14px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            border-color: #FF6F61;
            outline: none;
        }
        .form-group .eye-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 18px;
            color: #666;
        }
        .terms {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        .terms input {
            margin-right: 8px;
            width: 18px;
            height: 18px;
        }
        .terms label {
            font-size: 16px;
            color: #666;
        }
        .signup-button {
            width: 100%;
            padding: 14px;
            background-color: #FF6F61;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.2s ease;
        }
        .signup-button:hover {
            background-color: #FF8C7A;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #1E90FF;
            text-decoration: none;
            font-size: 16px;
        }
        .login-link a:hover {
            text-decoration: underline;
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
</head>
<body>
    <div class="signup-container">
        <div class="signup-box">
            <div class="illustration">
                <img src="<%= contextPath %>/Assets/Khanh/images/background_signup.jpg" alt="Illustration">
            </div>
            <div class="signup-form">
                <h2>Đăng ký</h2>
                <form action="<%= contextPath %>/Signup" method="post">
                    <div class="form-group">
                        <input type="text" id="firstName" name="firstName" placeholder="Nhập tên" required>
                    </div>
                    <div class="form-group">
                        <input type="text" id="lastName" name="lastName" placeholder="Nhập họ" required>
                    </div>
                    <div class="form-group">
                        <input type="text" id="username" name="username" placeholder="Nhập tên tài khoản" required>
                    </div>
                    <div class="form-group">
                        <input type="email" id="email" name="email" placeholder="Nhập Email" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required autocomplete="new-password">
                        <span class="eye-icon" onclick="togglePassword('password', this)">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <div class="form-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" required autocomplete="new-password">
                        <span class="eye-icon" onclick="togglePassword('confirmPassword', this)">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <button type="submit" class="signup-button">Đăng ký</button>
                    <div class="login-link">
                        <p>Đã có tài khoản? <a href="<%= contextPath %>/Pages/Login/Login.jsp">Đăng nhập</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>

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

    <script src="<%= contextPath %>/scripts.js"></script>
</body>
</html>