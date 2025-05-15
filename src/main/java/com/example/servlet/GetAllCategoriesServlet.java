package com.example.servlet;
import com.example.DAO;
import com.example.model.Category;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/GetAllCategories")
public class GetAllCategoriesServlet extends HttpServlet {
    private DAO categoryDAO = new DAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Category> categories = categoryDAO.getAllCategoriesByUserId("U001");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(categories));
    }
}