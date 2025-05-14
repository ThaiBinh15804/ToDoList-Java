package com.example.servlet;
import com.example.DAO;
import com.example.model.Task;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GetTaskById")
public class MyTaskServlet extends HttpServlet {
    private DAO dao = new DAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        System.out.println("MyTaskServlet is called with task_id: " + request.getParameter("task_id"));
        String taskId = request.getParameter("task_id");
        Task task = dao.getTaskById(taskId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (task != null) {
            response.getWriter().write(gson.toJson(task));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Task not found\"}");
        }
    }
}
