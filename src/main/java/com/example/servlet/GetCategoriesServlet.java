package com.example.servlet;

import com.example.DAO;
import com.example.model.Category;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/getCategories")
public class GetCategoriesServlet extends HttpServlet {
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
            // Kiểm tra session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not authenticated\"}");
                return;
            }

            // Lấy user_id
            String user_id = ((com.example.model.User) session.getAttribute("user")).user_id;

            // Lấy danh mục của user
            List<Category> categories = dao.getCategoriesByUser(user_id);

            Gson gson = new Gson();
            String json = gson.toJson(categories);
            response.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to fetch categories: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (dao != null) {
            dao.close();
        }
    }
}