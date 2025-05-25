package com.example.servlet;
import com.example.DAO;
import com.example.model.Category;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/GetAllCategories")
public class GetAllCategoriesServlet extends HttpServlet {
    private DAO categoryDAO = new DAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        com.example.model.User user = (com.example.model.User) session.getAttribute("user");
        String userId = user.user_id;
        List<Category> categories = categoryDAO.getAllCategoriesByUserId(userId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(categories));
    }
}