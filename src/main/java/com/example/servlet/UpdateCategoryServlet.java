package com.example.servlet;

import com.example.DAO;
import com.example.model.Category;
import com.example.model.LocalDateTimeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.Map;

@WebServlet("/UpdateCategory")
public class UpdateCategoryServlet extends HttpServlet {
    final DAO dao = new DAO();  // DAO đã có updateCategory()
    final Gson gson;

    public UpdateCategoryServlet() {
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

            dao.updateCategory(category);  // Gọi DAO cập nhật
            // Gửi JSON đúng chuẩn
            Map<String, String> msg = Map.of("message", "Cập nhật thành công");
            String json = gson.toJson(msg);

            PrintWriter out = response.getWriter();
            out.write(json);
            out.flush(); // ✅ đảm bảo dữ liệu được gửi đi
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
