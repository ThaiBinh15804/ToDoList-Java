package com.example.servlet;
import com.example.DAO;
import com.example.model.Task;
import com.example.model.TaskWithCategory;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/GetTasksFilterAndSort")
public class GetTasksFilterAndSortServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new DAO(); // đảm bảo bạn đã khởi tạo đúng
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set encoding để tránh lỗi Unicode
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Đọc JSON từ request body
            StringBuilder jsonBuffer = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }

            JSONObject jsonRequest = new JSONObject(jsonBuffer.toString());
            String userId = jsonRequest.getString("user_id");

            List<String> categoryIds = new ArrayList<>();
            if (jsonRequest.has("categoryIds")) {
                JSONArray categoryArray = jsonRequest.getJSONArray("categoryIds");
                for (int i = 0; i < categoryArray.length(); i++) {
                    categoryIds.add(categoryArray.getString(i));
                }
            }

            String sortBy = jsonRequest.optString("sortBy", "");

            // Lấy danh sách nhiệm vụ
            List<TaskWithCategory> tasks = taskDAO.getTasksWithCategoryNamesFilterAndSort(userId, categoryIds, sortBy);

            // Trả kết quả JSON về client
            JSONArray jsonTasks = new JSONArray();
            for (TaskWithCategory item : tasks) {
                System.out.println("Task ID: " + item.task.task_id);
                JSONObject taskObj = new JSONObject();
                JSONObject taskData = new JSONObject();
                Task task = item.task;

                taskData.put("task_id", task.task_id);
                taskData.put("user_id", task.user_id);
                taskData.put("category_id", task.category_id);
                taskData.put("title", task.title);
                taskData.put("description", task.description);
                taskData.put("status", task.status);
                taskData.put("priority", task.priority);
                taskData.put("start_time", task.start_time != null ? task.start_time.toString() : JSONObject.NULL);
                taskData.put("end_time", task.end_time != null ? task.end_time.toString() : JSONObject.NULL);
                taskData.put("created_at", task.created_at != null ? task.created_at.toString() : JSONObject.NULL);
                taskData.put("updated_at", task.updated_at != null ? task.updated_at.toString() : JSONObject.NULL);

                taskObj.put("task", taskData);
                taskObj.put("category_name", item.category_name);

                jsonTasks.put(taskObj);
            }

            response.getWriter().write(jsonTasks.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Đã xảy ra lỗi khi xử lý yêu cầu\"}");
        }
    }
}
