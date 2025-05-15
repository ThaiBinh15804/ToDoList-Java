package com.example.servlet;
import com.example.DAO;
import com.example.model.TaskWithCategory;
import com.fatboyindustrial.gsonjavatime.Converters;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/GetTaskById")
public class MyTaskServlet extends HttpServlet {
    private DAO dao = new DAO();
    private Gson gson = new Gson();

    public MyTaskServlet() {
        // Initialize Gson with Java Time serializers
        this.gson = Converters.registerAll(new GsonBuilder()).create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String taskId = request.getParameter("task_id");
        TaskWithCategory taskWithCategory = dao.getTaskWithCategoryById(taskId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (taskWithCategory != null) {
            response.getWriter().write(gson.toJson(taskWithCategory));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Task not found\"}");
        }
    }
}
