<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Todo List</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background-color: #E7F7FF;
            background-size: cover;
            background-position: bottom;
        }
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            padding: 20px;
        }
        .login-box {
            display: flex;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-width: 1000px;
            width: 100%;
            overflow: hidden;
        }
        .login-form {
            padding: 50px;
            width: 40%;
        }
        .login-form h2 {
            margin-bottom: 25px;
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group input {
            width: 100%;
            padding: 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            border-color: #FF6F61;
            outline: none;
        }
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        .remember-me input {
            margin-right: 8px;
            width: 18px;
            height: 18px;
        }
        .remember-me label {
            font-size: 16px;
            color: #666;
        }
        .login-button {
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
        .login-button:hover {
            background-color: #FF8C7A;
        }
        .signup-link {
            text-align: center;
            margin-top: 20px; /* Khoảng cách hợp lý so với nút Login */
        }
        .signup-link a {
            color: #1E90FF;
            text-decoration: none;
            font-size: 16px;
        }
        .signup-link a:hover {
            text-decoration: underline;
        }
        .illustration {
            width: 60%;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .illustration img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .error-message {
            color: red;
            font-size: 16px;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-form">
                <h2>Sign In</h2>
                <form action="<%= contextPath %>/Login" method="post">
                    <div class="form-group">
                        <input type="text" id="username" name="username" placeholder="Enter Username" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="password" name="password" placeholder="Enter Password" required>
                    </div>
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember Me</label>
                    </div>
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                        <div class="error-message"><%= error %></div>
                    <% } %>
                    <button type="submit" class="login-button">Login</button>
                    <div class="signup-link">
                        <p>Don't have an account? <a href="<%= contextPath %>/Pages/Login/SignUp.jsp">Create One</a></p>
                    </div>
                </form>
            </div>
            <div class="illustration">
                <img src="<%= contextPath %>/Assets/Khanh/images/background_login.jpg" alt="Illustration">
            </div>
        </div>
    </div>
</body>
</html>