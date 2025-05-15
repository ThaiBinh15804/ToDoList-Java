<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký - Todo List</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
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
            max-width: 1200px; /* Tăng chiều rộng */
            width: 100%;
            min-height: 700px; /* Tăng chiều cao */
            overflow: hidden;
        }
        .illustration {
            width: 50%; /* Tăng tỷ lệ để hình lớn hơn */
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
            width: 50%; /* Giảm tỷ lệ để cân đối */
        }
        .signup-form h2 {
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
        .error-message {
            color: red;
            font-size: 16px;
            margin-top: 10px;
            text-align: center;
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
                <h2>Sign Up</h2>
                <form action="<%= contextPath %>/Signup" method="post">
                    <div class="form-group">
                        <input type="text" id="firstName" name="firstName" placeholder="Enter First Name" required>
                    </div>
                    <div class="form-group">
                        <input type="text" id="lastName" name="lastName" placeholder="Enter Last Name" required>
                    </div>
                    <div class="form-group">
                        <input type="text" id="username" name="username" placeholder="Enter Username" required>
                    </div>
                    <div class="form-group">
                        <input type="email" id="email" name="email" placeholder="Enter Email" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="password" name="password" placeholder="Enter Password" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                    </div>
                    <div class="terms">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">I agree to all terms</label>
                    </div>
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                        <div class="error-message"><%= error %></div>
                    <% } %>
                    <button type="submit" class="signup-button">Register</button>
                    <div class="login-link">
                        <p>Already have an account? <a href="<%= contextPath %>/Pages/Login/Login.jsp">Sign In</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>