package com.example.servlet;

import com.example.DAO;
import com.example.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/ChangePassword")
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        request.setAttribute("currentPath", "/Setting");
        request.setAttribute("contentPage", "/Pages/Setting/ChangePassWord.jsp");
        request.getRequestDispatcher("/Layout/main_layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu mới và xác nhận mật khẩu có khớp không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.setAttribute("currentPath", "/Setting");
            request.setAttribute("contentPage", "/Pages/Setting/ChangePassWord.jsp");
            request.getRequestDispatcher("/Layout/main_layout.jsp").forward(request, response);
            return;
        }

        DAO dao = new DAO();
        try {
            Connection conn = dao.dbConnect.getConnection();
            if (conn == null) {
                request.setAttribute("error", "Không kết nối được cơ sở dữ liệu.");
            } else {
                // Kiểm tra mật khẩu hiện tại
                String checkPasswordQuery = "SELECT password FROM users WHERE user_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkPasswordQuery);
                checkStmt.setString(1, user.user_id);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (!storedPassword.equals(currentPassword)) { // Giả sử mật khẩu chưa mã hóa, nếu mã hóa thì cần so sánh đúng cách
                        request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                    } else {
                        // Cập nhật mật khẩu mới
                        String updateQuery = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
                        PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                        updateStmt.setString(1, newPassword);
                        updateStmt.setString(2, user.user_id);
                        int rows = updateStmt.executeUpdate();
                        if (rows > 0) {
                            session.setAttribute("Success", "Đổi mật khẩu thành công!");
                        } else {
                            request.setAttribute("error", "Đổi mật khẩu thất bại.");
                        }
                    }
                } else {
                    request.setAttribute("error", "Không tìm thấy người dùng.");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        request.setAttribute("currentPath", "/Setting");
        request.setAttribute("contentPage", "/Pages/Setting/ChangePassWord.jsp");
        request.getRequestDispatcher("/Layout/main_layout.jsp").forward(request, response);
    }
}