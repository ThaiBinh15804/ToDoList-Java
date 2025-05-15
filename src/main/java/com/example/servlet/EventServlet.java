package com.example.servlet;

import com.example.DAO;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.example.model.*;


@WebServlet("/getEvents")
public class EventServlet extends HttpServlet {
    private DAO dao;

    @Override
    public void init() throws ServletException {
        dao = new DAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not authenticated\"}");
                return;
            }

            User user = (User) session.getAttribute("user");

            List<TaskWithCategory> tasks = dao.getTasksWithCategoryNames(user.user_id);
            if (tasks == null || tasks.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"message\":\"Hiện tại bạn chưa có công việc nào.\"}");
                return;
            }

            List<Event> events = new ArrayList<>();

            for (TaskWithCategory taskWithCategory : tasks) {
                Task task = taskWithCategory.task;
                if (task.start_time != null && task.end_time != null) {
                    Event event = new Event();
                    event.id = task.task_id;
                    event.title = task.title + (taskWithCategory.category_name != null ? " (" + taskWithCategory.category_name + ")" : "");
                    event.start = task.start_time.toString();
                    event.end = task.end_time.toString();
                    event.category_name = taskWithCategory.category_name != null ? taskWithCategory.category_name : "No Category";
                    event.status = task.status != null ? task.status : "Unknown";
                    event.priority = task.priority != null ? task.priority : "None";
                    event.description = task.description != null ? task.description : "";
                    events.add(event);
                }
            }

            Gson gson = new Gson();
            String json = gson.toJson(events);
            response.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to fetch events: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (dao != null) {
            dao.close();
        }
    }

    private static class Event {
        public String id;
        public String title;
        public String start;
        public String end;
        public String category_name;
        public String status;
        public String priority;
        public String description;
    }
}
