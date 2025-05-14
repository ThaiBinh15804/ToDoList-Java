package com.example;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

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
            String userId = "U001";
//            if (userId == null) {
//                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//                response.getWriter().write("{\"error\":\"User not authenticated\"}");
//                return;
//            }

            List<model.Task> tasks = dao.getTasksByUser(userId);
            if (tasks == null || tasks.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"No tasks found for user " + userId + "\"}");
                return;
            }

            List<Event> events = new ArrayList<>();

            for (model.Task task : tasks) {
                if (task.start_time != null && task.end_time != null) {
                    Event event = new Event();
                    event.title = task.title;
                    event.start = task.start_time.toString();
                    event.end = task.end_time.toString();
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
        public String title;
        public String start;
        public String end;
    }
}
