package com.example.servlet;

import com.example.DAO;
import com.example.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/DashBoard");
            return;
        }
        request.getRequestDispatcher("/Pages/Login/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authenticateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/DashBoard");
        } else {
            request.setAttribute("error", "Tên người dùng hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/Pages/Login/Login.jsp").forward(request, response);
        }
    }

    private User authenticateUser(String username, String password) {
        DAO dao = new DAO();
        try {
            Connection conn = dao.dbConnect.getConnection();
            if (conn == null) {
                return null;
            }
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.user_id = rs.getString("user_id");
                user.username = rs.getString("username");
                user.email = rs.getString("email");
                user.fullname = rs.getString("fullname");
                user.phone = rs.getString("phone");
//                user.avatar = rs.getString("avatar");
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}