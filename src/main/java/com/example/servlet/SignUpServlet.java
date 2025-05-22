package com.example.servlet;

import com.example.DBConnect;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/Signup")
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
            request.setAttribute("error", "Mật khẩu không khớp!");
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
            if (conn == null) {
                request.setAttribute("error", "Không thể kết nối đến cơ sở dữ liệu!");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
                return;
            }

            // Kiểm tra username trùng lặp
            String checkUsernameQuery = "SELECT COUNT(*) FROM users WHERE username = ?";
            pstmt = conn.prepareStatement(checkUsernameQuery);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("error", "Tên người dùng đã được sử dụng! Vui lòng chọn tên khác.");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
                return;
            }

            // Kiểm tra email trùng lặp trước khi chèn
            String checkEmailQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
            pstmt = conn.prepareStatement(checkEmailQuery);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("error", "Email đã được sử dụng! Vui lòng chọn email khác.");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
                return;
            }

            // Tạo user_id (UXXX)
            String userId = "U";
            String sqlCount = "SELECT COUNT(*) FROM users";
            pstmt = conn.prepareStatement(sqlCount);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                userId += String.format("%03d", count); // U001, U002, ...
            }

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
            pstmt.setTimestamp(9, null);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                // Đặt thông báo thành công vào request
                request.setAttribute("success", "Đăng ký thành công!");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("/Pages/Login/SignUp.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Xử lý lỗi SQL mà không hiển thị trực tiếp thông báo lỗi SQL
            String errorMessage = "Đã xảy ra lỗi khi đăng ký! Vui lòng thử lại.";
            if (e.getSQLState().equals("23000")) { // Mã lỗi SQL cho vi phạm ràng buộc UNIQUE
                errorMessage = "Email đã được sử dụng! Vui lòng chọn email khác.";
            }
            request.setAttribute("error", errorMessage);
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