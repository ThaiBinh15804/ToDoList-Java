package com.example.servlet;

import com.example.DAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@WebServlet("/checkCategoryName")
public class CheckNameCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Giả sử class chứa method isCategoryNameExistsForOther là CategoryDAO
    private DAO dao = new DAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy params từ query string hoặc form data
        String name = request.getParameter("name");
        String userId = request.getParameter("userId");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (name == null || userId == null ) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing parameters\"}");
            out.flush();
            out.close();
            return;
        }

        boolean exists = dao.isCategoryNameExistsForOther(name, userId);

        // Trả về kết quả JSON: { "exists": true/false }
        out.print("{\"exists\":" + exists + "}");
        out.flush(); // Đảm bảo đẩy toàn bộ dữ liệu ra
        out.close(); // Đóng stream, báo hiệu kết thúc response
    }
}
