package com.example;
import com.example.model.TaskStatistics;
import com.example.model.TaskWithCategory;

import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

    @WebServlet(urlPatterns = {"/MyTask", "/MyTask/", "/Calendar", "/Calendar/", "/DashBoard", "/DashBoard/", "/Setting", "/Setting/"})
    public class Main extends HttpServlet {
        private DAO taskDAO = new DAO();

        protected void doGet(@org.jetbrains.annotations.NotNull HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String uri = request.getRequestURI();  // Lấy URI đầy đủ /ToDoList/MyTask
            String contextPath = request.getContextPath();  // Lấy context path của ứng dụng /TodoList
            String path = uri.substring(contextPath.length());  // Loại bỏ context path khỏi URI để lấy đường dẫn sau context /MyTask

            // Chuẩn hóa path (loại bỏ dấu / thừa ở cuối)
            if (path.endsWith("/")) {
                path = path.substring(0, path.length() - 1);
            }

            String contentPage;
            switch (path) {
                case "/Calendar":
                    contentPage = "/Pages/Calendar/Calendar.jsp";
                    break;
                case "/DashBoard":
                    contentPage = "/Pages/DashBoard/DashBoard.jsp";

                    String userId = "U001"; // Hoặc: (String) request.getSession().getAttribute("user_id");

                    // Gọi DAO để lấy thống kê
                    TaskStatistics stats = taskDAO.getTaskStatisticsByUserId(userId);
                    try {
                        List<TaskWithCategory> tasks = taskDAO.getTasksForToday(userId);
                        request.setAttribute("taskWithCategoryListToday", tasks);

                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                    try {
                        List<TaskWithCategory> tasksComplete = taskDAO.getCompletedTasks(userId);
                        request.setAttribute("taskWithCategoryListCompleted", tasksComplete);

                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                    // Gửi sang JSP để render
                    request.setAttribute("taskStats", stats);
                    break;
                case "/Setting":
                    contentPage = "/Pages/Setting/Setting.jsp";
                    break;
                case "/MyTask":
                default:
                    contentPage = "/Pages/MyTask/MyTask.jsp";
                    List<TaskWithCategory> taskList = taskDAO.getTasksWithCategoryNames("U001");
                    request.setAttribute("tasks", taskList);
                    break;
            }

            // Truyền giá trị path và contentPage vào request
            request.setAttribute("contentPage", contentPage);
            request.setAttribute("currentPath", path);  // Gán path vào request attribute
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Layout/main_layout.jsp");
            dispatcher.forward(request, response);
        }
    }


