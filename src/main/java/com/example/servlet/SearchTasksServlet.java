package com.example.servlet;

import com.example.DAO;
import com.example.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/searchTasks")
public class SearchTasksServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SearchTasksServlet.class.getName());
    private DAO dao;

    @Override
    public void init() throws ServletException {
        dao = new DAO(); // Khởi tạo DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            // Đọc JSON từ request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String json = sb.toString();
            LOGGER.info("Received JSON: " + json);

            JSONObject jsonRequest = new JSONObject(json);
            String searchQuery = jsonRequest.optString("searchQuery", "").trim();
            if (searchQuery.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Nội dung tìm kiếm không được để trống.\"}");
                return;
            }

            // Kiểm tra session và user
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not authenticated\"}");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (user.user_id == null) {
                LOGGER.severe("User ID is null for user: " + user);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Invalid user data\"}");
                return;
            }

            LOGGER.info("Searching tasks for user: " + user.user_id + ", query: " + searchQuery);
            List<TaskWithCategory> tasks = dao.searchTasks(user.user_id, searchQuery);

            // Trả kết quả JSON về client
            JSONArray jsonTasks = new JSONArray();
            for (TaskWithCategory item : tasks) {
                JSONObject taskObj = new JSONObject();
                JSONObject taskData = new JSONObject();
                Task task = item.task;

                taskData.put("task_id", task.task_id);
                taskData.put("user_id", task.user_id);
                taskData.put("category_id", task.category_id);
                taskData.put("title", task.title);
                taskData.put("description", task.description);
                taskData.put("status", task.status);
                taskData.put("priority", task.priority);
                taskData.put("start_time", task.start_time != null ? task.start_time.toString() : JSONObject.NULL);
                taskData.put("end_time", task.end_time != null ? task.end_time.toString() : JSONObject.NULL);
                taskData.put("created_at", task.created_at != null ? task.created_at.toString() : JSONObject.NULL);
                taskData.put("updated_at", task.updated_at != null ? task.updated_at.toString() : JSONObject.NULL);

                taskObj.put("task", taskData);
                taskObj.put("category_name", item.category_name);

                jsonTasks.put(taskObj);
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(jsonTasks.toString());
        } catch (Exception e) {
            LOGGER.severe("Error processing search request: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể thực hiện tìm kiếm: " + e.getMessage() + "\"}");
        }
    }
}