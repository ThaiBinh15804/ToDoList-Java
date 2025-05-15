package com.example.servlet;

import com.example.DBConnect;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
//import org.mindrot.jbcrypt.BCrypt;

public class SignUpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu khớp
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
            return;
        }

        DBConnect dbConnect = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Sử dụng DBConnect để kết nối
            dbConnect = new DBConnect();
            conn = dbConnect.getConnection();

            // Tạo user_id (UXXX)
            String userId = "U";
            String sqlCount = "SELECT COUNT(*) FROM users";
            pstmt = conn.prepareStatement(sqlCount);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                userId += String.format("%03d", count); // U001, U002, ...
            }

            // Mã hóa mật khẩu
//            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Lưu vào bảng users
            String sqlInsert = "INSERT INTO users (user_id, username, password, email, fullname, phone, avatar, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, userId);
            pstmt.setString(2, username);
            pstmt.setString(3, password);
            pstmt.setString(4, email);
            pstmt.setString(5, firstName + " " + lastName); // fullname
            pstmt.setString(6, null); // phone
            pstmt.setString(7, null); // avatar
            pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis())); // created_at
            pstmt.setTimestamp(9, null); // updated_at (để null vì vừa tạo)

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/Pages/Login/Login.jsp");
            } else {
                request.setAttribute("error", "Registration failed!");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (dbConnect != null) dbConnect.closeConnection();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}