package com.example.servlet;

import com.example.DAO;
import com.example.model.Task;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/CompleteTask")
public class CompleteTaskServlet extends HttpServlet {
    private DAO dao;

    @Override
    public void init() throws ServletException {
        dao = new DAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Check session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not authenticated\"}");
                return;
            }
            String userId = ((com.example.model.User) session.getAttribute("user")).user_id;

            // Read JSON from body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            // Parse JSON
            Gson gson = new Gson();
            TaskStatusUpdate statusUpdate;
            try {
                statusUpdate = gson.fromJson(sb.toString(), TaskStatusUpdate.class);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid JSON format\"}");
                return;
            }

            // Validate input
            if (statusUpdate.task_id == null || statusUpdate.task_id.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Mã công việc không được để trống.\"}");
                return;
            }
            if (statusUpdate.status == null || statusUpdate.status.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Trạng thái không được để trống.\"}");
                return;
            }
            if (!statusUpdate.status.equals("Chưa bắt đầu") &&
                    !statusUpdate.status.equals("Đang thực hiện") &&
                    !statusUpdate.status.equals("Hoàn thành")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Trạng thái không hợp lệ.\"}");
                return;
            }

            // Check task ownership
            Task existingTask = dao.getTaskById(statusUpdate.task_id);
            if (existingTask == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Công việc không tồn tại.\"}");
                return;
            }
            if (!existingTask.user_id.equals(userId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Bạn không có quyền chỉnh sửa công việc này.\"}");
                return;
            }

            // Update task status
            boolean updated = dao.updateTaskStatus(statusUpdate.task_id, statusUpdate.status);
            if (updated) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\":\"Cập nhật trạng thái công việc thành công.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Công việc không tồn tại.\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể cập nhật trạng thái công việc: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (dao != null) {
            dao.close();
        }
    }

    // Inner class for JSON parsing
    private static class TaskStatusUpdate {
        String task_id;
        String status;
    }
}