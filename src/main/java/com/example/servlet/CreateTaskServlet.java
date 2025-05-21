package com.example.servlet;

import com.example.DAO;
import com.example.model.Task;
import com.example.servlet.LocalDateTimeTypeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/createTask")
public class CreateTaskServlet extends HttpServlet {
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

        try {
            // Kiểm tra session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not authenticated\"}");
                return;
            }

            // Đọc JSON từ body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            // Khởi tạo Gson với TypeAdapter cho LocalDateTime
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeTypeAdapter())
                    .create();
            Task task = gson.fromJson(sb.toString(), Task.class);

            // Gán user_id và created_at
            task.user_id = ((com.example.model.User) session.getAttribute("user")).user_id;
            task.created_at = LocalDateTime.now();

            // Tạo task_id mới
            task.task_id = dao.getNextTaskId();

            // Kiểm tra dữ liệu đầu vào
            if (task.title == null || task.title.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Tiêu đề công việc không được để trống.\"}");
                return;
            }

            // Lưu task vào database
            dao.insertTask(task);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\":\"Tạo công việc thành công.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tạo công việc: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (dao != null) {
            dao.close();
        }
    }
}