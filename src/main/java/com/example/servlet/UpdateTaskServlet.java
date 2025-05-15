package com.example.servlet;
import com.example.DAO;
import com.example.model.LocalDateTimeAdapter;
import com.example.model.Task;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/UpdateTask")
public class UpdateTaskServlet extends HttpServlet {
    private DAO dao = new DAO();
    private Gson gson;

    public UpdateTaskServlet() {
        // Khởi tạo Gson với Custom TypeAdapter cho LocalDateTime
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        BufferedReader reader = request.getReader();
        Task task = gson.fromJson(reader, Task.class);

        dao.updateTask(task);

        response.getWriter().write("{\"message\": \"Cập nhật thành công\"}");
    }
}
