package com.example.servlet;
import com.example.DAO;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/DeleteTask")
public class DeleteTaskServlet extends HttpServlet {
    private DAO dao = new DAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        BufferedReader reader = request.getReader();
        JsonObject json = JsonParser.parseReader(reader).getAsJsonObject();
        String taskId = json.get("task_id").getAsString();

        dao.deleteTask(taskId);

        response.getWriter().write("{\"message\": \"Xóa thành công\"}");
    }
}
