package com.example.servlet;

import com.example.DAO;
import com.example.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

@WebServlet("/UpdateSettings")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class SettingServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "Assets/Khanh/images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Setting");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String fullname = getPartAsString(request.getPart("fullname"));
        String email = getPartAsString(request.getPart("email"));
        String phone = getPartAsString(request.getPart("phone"));
        String avatarPath = user.avatar;

        // Xử lý tải ảnh
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            if (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("image/gif")) {
                request.setAttribute("error", "Chỉ hỗ trợ định dạng JPG, PNG hoặc GIF.");
                forwardToJsp(request, response);
                return;
            }

            String fileName = extractFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                request.setAttribute("error", "Tên tệp không hợp lệ.");
                forwardToJsp(request, response);
                return;
            }

            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                if (!uploadDir.mkdirs()) {
                    request.setAttribute("error", "Không thể tạo thư mục lưu trữ ảnh.");
                    forwardToJsp(request, response);
                    return;
                }
            }
            if (!uploadDir.canWrite()) {
                request.setAttribute("error", "Không có quyền ghi vào thư mục lưu trữ ảnh.");
                forwardToJsp(request, response);
                return;
            }

            try {
                filePart.write(uploadPath + File.separator + fileName);
                avatarPath = fileName; // Chỉ lưu tên file vào cơ sở dữ liệu
            } catch (IOException e) {
                request.setAttribute("error", "Lỗi tải ảnh: " + e.getMessage());
                forwardToJsp(request, response);
                return;
            }
        }

        // Cập nhật cơ sở dữ liệu
        DAO dao = new DAO();
        try {
            Connection conn = dao.dbConnect.getConnection();
            if (conn == null) {
                request.setAttribute("error", "Không kết nối được cơ sở dữ liệu.");
                forwardToJsp(request, response);
                return;
            }

            // Kiểm tra email trùng lặp
            String checkEmailQuery = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery);
            checkStmt.setString(1, email);
            checkStmt.setString(2, user.user_id);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("error", "Email đã tồn tại.");
                forwardToJsp(request, response);
                return;
            }

            // Cập nhật thông tin người dùng
            String query = "UPDATE users SET fullname = ?, email = ?, phone = ?, avatar = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, fullname);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, avatarPath);
            stmt.setString(5, user.user_id);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                user.fullname = fullname;
                user.email = email;
                user.phone = phone;
                user.avatar = avatarPath;
                session.setAttribute("user", user);
                request.setAttribute("success", "Cập nhật thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
        }

        forwardToJsp(request, response);
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("currentPath", "/Setting");
        request.setAttribute("contentPage", "/Pages/Setting/Setting.jsp");
        request.getRequestDispatcher("/Layout/main_layout.jsp").forward(request, response);
    }

    private String getPartAsString(Part part) throws IOException {
        if (part == null) return null;
        try (Scanner scanner = new Scanner(part.getInputStream()).useDelimiter("\\A")) {
            return scanner.hasNext() ? scanner.next() : null;
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String s : contentDisp.split(";")) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}