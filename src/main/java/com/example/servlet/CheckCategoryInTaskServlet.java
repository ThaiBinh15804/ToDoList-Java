package com.example.servlet;

import com.example.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/checkCategoryInTask")
public class CheckCategoryInTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Giả sử class chứa method isCategoryNameExistsForOther là CategoryDAO
    private DAO dao = new DAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy params từ query string hoặc form data
        String categoryId = request.getParameter("categoryId");
        String userId = request.getParameter("userId");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (categoryId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing parameters\"}");
            out.flush();
            out.close();
            return;
        }

        boolean exists = dao.isCategoryInUseTask(categoryId, userId);

        // Trả về kết quả JSON: { "exists": true/false }
        out.print("{\"exists\":" + exists + "}");
        out.flush(); // Đảm bảo đẩy toàn bộ dữ liệu ra
        out.close(); // Đóng stream, báo hiệu kết thúc response
    }
}