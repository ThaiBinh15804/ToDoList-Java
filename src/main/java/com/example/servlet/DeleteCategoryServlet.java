package com.example.servlet;

import com.example.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/DeleteCategory")
public class DeleteCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Giả sử bạn có class DBService chứa method deleteCategory
    private DAO dao = new DAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy category_id từ request
        String categoryId = request.getParameter("category_id");

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (categoryId == null || categoryId.isEmpty()) {
            out.print("{\"success\":false, \"message\":\"category_id không được để trống\"}");
            return;
        }

        try {
            dao.deleteCategory(categoryId);
            out.print("{\"success\":true, \"message\":\"Xóa danh mục thành công\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false, \"message\":\"Lỗi khi xóa danh mục\"}");
        }
    }

    // Nếu muốn hỗ trợ GET cũng xóa (không khuyến khích), bạn có thể override doGet
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
