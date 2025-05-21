package com.example;


import com.example.model.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

import java.nio.charset.StandardCharsets;

public class DAO {
    public DBConnect dbConnect;

    public DAO() {
        dbConnect = new DBConnect();
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
        String query = "INSERT INTO categories (category_id, user_id, name) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = dbConnect.getConnection().prepareStatement(query)) {
            stmt.setString(1, category.category_id);
            stmt.setString(2, category.user_id);
            stmt.setString(3, category.name);
            stmt.executeUpdate();
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

    // Close the database connection
    public void close() {
        dbConnect.closeConnection();
    }
}
