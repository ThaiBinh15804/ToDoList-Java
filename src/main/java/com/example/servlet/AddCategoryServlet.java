package com.example.servlet;

import com.example.DAO;
import com.example.model.Category;
import com.example.model.LocalDateTimeAdapter;
import com.example.model.Task;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.BufferedReader;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

@WebServlet("/AddCategory")
public class AddCategoryServlet extends HttpServlet {
    private DAO dao = new DAO();
    private Gson gson;

    public AddCategoryServlet() {
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (BufferedReader reader = request.getReader()) {
            Category category = gson.fromJson(reader, Category.class);

            // Gọi method thêm mới task
            dao.insertCategory(category);

            // Trả về json thành công
            response.getWriter().write("{\"message\": \"Thêm mới thành công\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Lỗi khi thêm task\"}");
        }
    }
}
