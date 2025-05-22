package com.example;


import com.example.model.*;

import com.example.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.sql.*;

import java.nio.charset.StandardCharsets;

public class DAO {
    public DBConnect dbConnect;

    public DAO() {
        dbConnect = new DBConnect();
    }

    public TaskStatistics getTaskStatisticsByUserId(String userId) {
        String sql = "SELECT status, COUNT(*) as count FROM tasks WHERE user_id = ? GROUP BY status";
        int notStarted = 0;
        int inProgress = 0;
        int completed = 0;
        int total = 0;

        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(sql)) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                total += count;

                switch (status) {
                    case "Chưa bắt đầu":
                        notStarted = count;
                        break;
                    case "Đang thực hiện":
                        inProgress = count;
                        break;
                    case "Hoàn thành":
                        completed = count;
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new TaskStatistics(total, notStarted, inProgress, completed);
    }

    public List<TaskWithCategory> getTasksForToday(String userId) throws SQLException {
        List<TaskWithCategory> tasks = new ArrayList<>();

        // Lấy ngày hiện tại tự động
        LocalDate today = LocalDate.now(); // Lấy ngày hiện tại (22/05/2025)
        LocalDateTime startOfDay = today.atStartOfDay(); // 00:00:00
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX); // 23:59:59.999999999

        String query = "SELECT t.task_id, t.user_id, t.category_id, t.title, t.description, t.status, " +
                       "t.priority, t.start_time, t.end_time, t.created_at, t.updated_at, c.name AS category_name " +
                       "FROM tasks t " +
                       "LEFT JOIN categories c ON t.category_id = c.category_id " +
                       "WHERE t.user_id = ? AND t.start_time >= ? AND t.start_time <= ?" +
                       "AND t.status IN (N'Chưa bắt đầu', N'Đang thực hiện')";

        try (Connection conn = dbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            stmt.setObject(2, startOfDay); // Sử dụng LocalDateTime cho start_time
            stmt.setObject(3, endOfDay);   // Sử dụng LocalDateTime cho end_time

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getObject("start_time", LocalDateTime.class);
                    task.end_time = rs.getObject("end_time", LocalDateTime.class);
                    task.created_at = rs.getObject("created_at", LocalDateTime.class);
                    task.updated_at = rs.getObject("updated_at", LocalDateTime.class);

                    String categoryName = rs.getString("category_name");
                    TaskWithCategory taskWithCategory = new TaskWithCategory();
                    taskWithCategory.task = task;
                    taskWithCategory.category_name = categoryName != null ? categoryName : "N/A";
                    tasks.add(taskWithCategory);
                }
            }
        }
        return tasks;
    }

    public List<TaskWithCategory> getCompletedTasks(String userId) throws SQLException {
        List<TaskWithCategory> tasks = new ArrayList<>();

        String query = "SELECT t.task_id, t.user_id, t.category_id, t.title, t.description, t.status, " +
                       "t.priority, t.start_time, t.end_time, t.created_at, t.updated_at, c.name AS category_name " +
                       "FROM tasks t " +
                       "LEFT JOIN categories c ON t.category_id = c.category_id " +
                       "WHERE t.user_id = ? AND t.status = N'Hoàn thành'";

        try (Connection conn = dbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getObject("start_time", LocalDateTime.class);
                    task.end_time = rs.getObject("end_time", LocalDateTime.class);
                    task.created_at = rs.getObject("created_at", LocalDateTime.class);
                    task.updated_at = rs.getObject("updated_at", LocalDateTime.class);

                    String categoryName = rs.getString("category_name");
                    TaskWithCategory taskWithCategory = new TaskWithCategory();
                    taskWithCategory.task = task;
                    taskWithCategory.category_name = categoryName != null ? categoryName : "N/A";
                    tasks.add(taskWithCategory);
                }
            }
        }
        return tasks;
    }

    // --- User CRUD Operations ---

    // Create: Insert a new user
    public void insertUser(User user) {
        String query = "INSERT INTO users (user_id, username, password, email, fullname, phone, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user.user_id);
            stmt.setString(2, user.username);
            stmt.setString(3, user.password);
            stmt.setString(4, user.email);
            stmt.setString(5, user.fullname);
            stmt.setString(6, user.phone);
            stmt.setTimestamp(7, java.sql.Timestamp.valueOf(user.created_at));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Read: Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.user_id = rs.getString("user_id");
                user.username = rs.getString("username");
                user.password = rs.getString("password");
                user.email = rs.getString("email");
                user.fullname = rs.getString("fullname");
                user.phone = rs.getString("phone");
                user.avatar = rs.getString("avatar");
                user.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                user.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Read: Get user by ID
    public User getUserById(String user_id) {
        User user = null;
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.user_id = rs.getString("user_id");
                    user.username = rs.getString("username");
                    user.password = rs.getString("password");
                    user.email = rs.getString("email");
                    user.fullname = rs.getString("fullname");
                    user.phone = rs.getString("phone");
                    user.avatar = rs.getString("avatar");
                    user.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                    user.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // Update: Update user information
    public void updateUser(User user) {
        String query = "UPDATE users SET username = ?, password = ?, email = ?, fullname = ?, phone = ?, updated_at = ?, avatar = ? WHERE user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user.username);
            stmt.setString(2, user.password);
            stmt.setString(3, user.email);
            stmt.setString(4, user.fullname);
            stmt.setString(5, user.phone);
            stmt.setTimestamp(6, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(7, user.avatar);
            stmt.setString(8, user.user_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete: Delete a user
    public void deleteUser(String user_id) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Category CRUD Operations ---

    // Create: Insert a new category
    public void insertCategory(Category category) {
        String selectLastIdQuery = "SELECT TOP 1 category_id FROM categories WITH (UPDLOCK, HOLDLOCK) ORDER BY CAST(SUBSTRING(category_id, 2, LEN(category_id) - 1) AS INT) DESC";
        String insertQuery = "INSERT INTO categories (category_id, user_id, name) VALUES (?, ?, ?)";

        try (Connection conn = dbConnect.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            String newCategoryId = "C001"; // Mặc định nếu chưa có bản ghi nào
            try (PreparedStatement selectStmt = conn.prepareStatement(selectLastIdQuery)) {
                ResultSet rs = selectStmt.executeQuery();
                if (rs.next()) {
                    String lastId = rs.getString("category_id"); // Ví dụ: "C007"
                    int number = Integer.parseInt(lastId.substring(1));
                    newCategoryId = String.format("C%03d", number + 1); // => "C008"
                }
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setString(1, newCategoryId);
                insertStmt.setString(2, category.user_id);
                insertStmt.setString(3, category.name);

                int rowsInserted = insertStmt.executeUpdate();
                System.out.println("Rows inserted: " + rowsInserted);
            }

            conn.commit(); // Hoàn tất transaction

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Read: Get all categories
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.category_id = rs.getString("category_id");
                category.user_id = rs.getString("user_id");
                category.name = rs.getString("name");
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Category> getAllCategoriesByUserId(String user_id) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories WHERE user_id = ?";

        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.category_id = rs.getString("category_id");
                    category.user_id = rs.getString("user_id");
                    category.name = rs.getString("name");
                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }


    // Read: Get category by ID
    public Category getCategoryById(String category_id) {
        Category category = null;
        String query = "SELECT * FROM categories WHERE category_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, category_id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    category = new Category();
                    category.category_id = rs.getString("category_id");
                    category.user_id = rs.getString("user_id");
                    category.name = rs.getString("name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    // Update: Update category information
    public void updateCategory(Category category) {
        String query = "UPDATE categories SET user_id = ?, name = ? WHERE category_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, category.user_id);
            stmt.setString(2, category.name);
            stmt.setString(3, category.category_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isCategoryNameExistsForOther(String name, String userId) {
        String query = "SELECT COUNT(*) FROM categories WHERE name = ? AND user_id = ? ";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCategoryInUseTask(String categoryId, String userId) {
        String query = "SELECT COUNT(*) FROM tasks WHERE category_id = ? AND user_id = ? ";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, categoryId);
            stmt.setString(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0; // nếu có ít nhất 1 task dùng category này
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete: Delete a category
    public void deleteCategory(String category_id) {
        String query = "DELETE FROM categories WHERE category_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, category_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Task CRUD Operations ---

    // Create: Insert a new task
    public void insertTask(Task task) {
        String query = "INSERT INTO tasks (task_id, user_id, category_id, title, description, status, priority, start_time, end_time, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, task.task_id);
            stmt.setString(2, task.user_id);
            stmt.setString(3, task.category_id);
            stmt.setString(4, task.title);
            stmt.setString(5, task.description);
            stmt.setString(6, task.status);
            stmt.setString(7, task.priority);
            stmt.setTimestamp(8, task.start_time != null ? java.sql.Timestamp.valueOf(task.start_time) : null);
            stmt.setTimestamp(9, task.end_time != null ? java.sql.Timestamp.valueOf(task.end_time) : null);
            stmt.setTimestamp(10, java.sql.Timestamp.valueOf(task.created_at));
            stmt.executeUpdate();
        } catch (SQLException e) {
            // In đối tượng task để debug
            System.err.println("Task: " + task);
            // In câu lệnh với giá trị thực tế
            String debugQuery = query.replace("?", "'%s'").replace("N?", "N'%s'");
            String formattedQuery = String.format(debugQuery,
                    task.task_id != null ? task.task_id.replace("'", "''") : "NULL",
                    task.user_id != null ? task.user_id.replace("'", "''") : "NULL",
                    task.category_id != null ? task.category_id.replace("'", "''") : "NULL",
                    task.title != null ? new String(task.title.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8).replace("'", "''") : "NULL",
                    task.description != null ? new String(task.description.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8).replace("'", "''") : "NULL",
                    task.status != null ? new String(task.status.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8).replace("'", "''") : "NULL",
                    task.priority != null ? new String(task.priority.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8).replace("'", "''") : "NULL",
                    task.start_time != null ? task.start_time.toString() : "NULL",
                    task.end_time != null ? task.end_time.toString() : "NULL",
                    task.created_at != null ? task.created_at.toString() : "NULL"
            );
            System.err.println("Failed query: " + formattedQuery);
            System.err.println("SQL Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            e.printStackTrace();
            throw new RuntimeException("Failed to insert task: " + e.getMessage(), e);
        }
    }

    // Read: Get all tasks
    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM tasks";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.task_id = rs.getString("task_id");
                task.user_id = rs.getString("user_id");
                task.category_id = rs.getString("category_id");
                task.title = rs.getString("title");
                task.description = rs.getString("description");
                task.status = rs.getString("status");
                task.priority = rs.getString("priority");
                task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // Read: Get task by ID
    public Task getTaskById(String task_id) {
        Task task = null;
        String query = "SELECT * FROM tasks WHERE task_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, task_id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                    task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                    task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                    task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return task;
    }

    public String getNextTaskId() {
        String query = "SELECT MAX(task_id) AS max_id FROM tasks";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String maxId = rs.getString("max_id");
                if (maxId != null && maxId.matches("T\\d{3}")) {
                    int number = Integer.parseInt(maxId.substring(1));
                    number++;
                    return String.format("T%03d", number);
                }
            }
            return "T001";
        } catch (SQLException e) {
            e.printStackTrace();
            return "T001";
        }
    }

    //Read: Get task by user
    public List<Task> getTasksByUser(String user_id) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM tasks WHERE user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                    task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                    task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                    task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // Update: Update task information
    public void updateTask(Task task) {
        String query = "UPDATE tasks SET user_id = ?, category_id = ?, title = ?, description = ?, status = ?, priority = ?, start_time = ?, end_time = ?, updated_at = ? WHERE task_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, task.user_id);
            stmt.setString(2, task.category_id);
            stmt.setString(3, task.title);
            stmt.setString(4, task.description);
            stmt.setString(5, task.status);
            stmt.setString(6, task.priority);
            stmt.setTimestamp(7, task.start_time != null ? java.sql.Timestamp.valueOf(task.start_time) : null);
            stmt.setTimestamp(8, task.end_time != null ? java.sql.Timestamp.valueOf(task.end_time) : null);
            stmt.setTimestamp(9, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(10, task.task_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete: Delete a task
    public void deleteTask(String task_id) {
        String query = "DELETE FROM tasks WHERE task_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, task_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertTask2(Task task) {
        String selectLastIdQuery = "SELECT TOP 1 task_id FROM tasks WITH (UPDLOCK, HOLDLOCK) ORDER BY CAST(SUBSTRING(task_id, 2, LEN(task_id) - 1) AS INT) DESC";
        String insertQuery = "INSERT INTO tasks (task_id, user_id, category_id, title, description, status, priority, start_time, end_time, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnect.getConnection()) {
            conn.setAutoCommit(false); // bắt đầu transaction
            String newTaskId = "T001"; // Mặc định nếu chưa có task nào
            try (PreparedStatement selectStmt = conn.prepareStatement(selectLastIdQuery)) {
                ResultSet rs = selectStmt.executeQuery();
                if (rs.next()) {
                    String lastTaskId = rs.getString("task_id");
                    int number = Integer.parseInt(lastTaskId.substring(1));
                    newTaskId = String.format("T%03d", number + 1);
                }
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setString(1, newTaskId);
                insertStmt.setString(2, task.user_id);
                insertStmt.setString(3, task.category_id);
                insertStmt.setString(4, task.title);
                insertStmt.setString(5, task.description);
                insertStmt.setString(6, task.status);
                insertStmt.setString(7, task.priority);
                insertStmt.setTimestamp(8, task.start_time != null ? Timestamp.valueOf(task.start_time) : null);
                insertStmt.setTimestamp(9, task.end_time != null ? Timestamp.valueOf(task.end_time) : null);
                insertStmt.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));

                int rowsInserted = insertStmt.executeUpdate();
                System.out.println("Rows inserted: " + rowsInserted);
            }

            conn.commit(); // commit transaction
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Read: Get tasks with category names (joined query)
    public List<TaskWithCategory> getTasksWithCategoryNames(String user_id) {
        List<TaskWithCategory> tasksWithCategories = new ArrayList<>();
        String query = "SELECT t.*, c.name AS category_name FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id WHERE t.user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Task task = new Task();
                task.task_id = rs.getString("task_id");
                task.user_id = rs.getString("user_id");
                task.category_id = rs.getString("category_id");
                task.title = rs.getString("title");
                task.description = rs.getString("description");
                task.status = rs.getString("status");
                task.priority = rs.getString("priority");
                task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;

                TaskWithCategory taskWithCategory = new TaskWithCategory();
                taskWithCategory.task = task;
                taskWithCategory.category_id = rs.getString("category_id");
                taskWithCategory.category_name = rs.getString("category_name");
                tasksWithCategories.add(taskWithCategory);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasksWithCategories;
    }

    public List<Category> getCategoriesByUser(String user_id) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories WHERE user_id = ?";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, user_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.category_id = rs.getString("category_id");
                    category.user_id = rs.getString("user_id");
                    category.name = rs.getString("name");
                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<TaskWithCategory> getTasksWithCategoryNamesFilterAndSort(String user_id, List<String> categoryIds, String sortBy) {
        List<TaskWithCategory> tasksWithCategories = new ArrayList<>();

        StringBuilder query = new StringBuilder();
        query.append("SELECT t.*, c.name AS category_name ")
                .append("FROM tasks t ")
                .append("JOIN categories c ON t.category_id = c.category_id ")
                .append("WHERE t.user_id = ? ");

        if (!categoryIds.isEmpty()) {
            String placeholders = String.join(",", Collections.nCopies(categoryIds.size(), "?"));
            query.append("AND t.category_id IN (").append(placeholders).append(") ");
        }

        // Thêm phần sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            if ("priority".equals(sortBy)) {
                query.append(" ORDER BY ")
                        .append("CASE t.priority ")
                        .append("WHEN N'Cao' THEN 1 ")
                        .append("WHEN N'Trung bình' THEN 2 ")
                        .append("WHEN N'Thấp' THEN 3 ")
                        .append("ELSE 4 END, t.status ");
            } else if ("oldest".equals(sortBy)) {
                query.append(" ORDER BY t.start_time ASC ");
            }
        }

        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query.toString())) {
            stmt.setString(1, user_id);

            // Set categoryIds (nếu có)
            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (int i = 0; i < categoryIds.size(); i++) {
                    stmt.setString(i + 2, categoryIds.get(i)); // Bắt đầu từ index 2
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                    task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                    task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                    task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;

                    TaskWithCategory taskWithCategory = new TaskWithCategory();
                    taskWithCategory.task = task;
                    taskWithCategory.category_name = rs.getString("category_name");
                    tasksWithCategories.add(taskWithCategory);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasksWithCategories;
    }

    public TaskWithCategory getTaskWithCategoryById(String task_id) {
        TaskWithCategory taskWithCategory = null;
        String query = "SELECT t.*, c.name AS category_name FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id WHERE t.task_id = ?";

        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, task_id); // Gán task_id vào dấu ?

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Task task = new Task();
                    task.task_id = rs.getString("task_id");
                    task.user_id = rs.getString("user_id");
                    task.category_id = rs.getString("category_id");
                    task.title = rs.getString("title");
                    task.description = rs.getString("description");
                    task.status = rs.getString("status");
                    task.priority = rs.getString("priority");
                    task.start_time = rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toLocalDateTime() : null;
                    task.end_time = rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null;
                    task.created_at = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                    task.updated_at = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;

                    // Tạo đối tượng TaskWithCategory và gán giá trị
                    taskWithCategory = new TaskWithCategory();
                    taskWithCategory.task = task;
                    taskWithCategory.category_name = rs.getString("category_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return taskWithCategory;
    }

    // Close the database connection
    public void close() {
        dbConnect.closeConnection();
    }
}
