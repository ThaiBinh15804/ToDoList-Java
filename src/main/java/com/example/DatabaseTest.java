package com.example;

import com.example.model.Category;
import com.example.model.Task;
import com.example.model.TaskWithCategory;
import com.example.model.User;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;
import com.example.model.*;

public class DatabaseTest {


    public static void main(String[] args) {
        // Initialize DAO
        DAO dao = new DAO();

//        // Test 1: Verify database connection
//        System.out.println("=== Test 1: Verifying Database Connection ===");
//        try {
//            if (dao.dbConnect.getConnection() != null) {
//                System.out.println("Database connection successful!");
//            } else {
//                System.out.println("Database connection failed!");
//                return;
//            }
//        } catch (Exception e) {
//            System.out.println("Connection error: " + e.getMessage());
//            return;
//        }
//
//        // Test 2: Insert a new user
//        System.out.println("\n=== Test 2: Inserting a New User ===");
//        User newUser = new User();
//        newUser.user_id = "U004";
//        newUser.username = "phamthid";
//        newUser.password = "zxcv123@";
//        newUser.email = "phamthid@example.com";
//        newUser.fullname = "Phạm Thị D";
//        newUser.phone = "0934567890";
//        newUser.created_at = LocalDateTime.now();
//        dao.insertUser(newUser);
//        System.out.println("Inserted user: " + newUser.username);
//
//        // Test 3: Retrieve and display all users
//        System.out.println("\n=== Test 3: Retrieving All Users ===");
//        List<User> users = dao.getAllUsers();
//        for (User user : users) {
//            System.out.println("User ID: " + user.user_id + ", Username: " + user.username + ", Email: " + user.email);
//        }
//
//        // Test 4: Update a user
//        System.out.println("\n=== Test 4: Updating a User ===");
//        User userToUpdate = dao.getUserById("U004");
//        if (userToUpdate != null) {
//            userToUpdate.fullname = "Phạm Thị Đ";
//            userToUpdate.phone = "0945678901";
//            dao.updateUser(userToUpdate);
//            System.out.println("Updated user: " + userToUpdate.username);
//        } else {
//            System.out.println("User U004 not found!");
//        }
//
//        // Test 5: Insert a new category
//        System.out.println("\n=== Test 5: Inserting a New Category ===");
//        Category newCategory = new Category();
//        newCategory.category_id = "C005";
//        newCategory.user_id = "U004";
//        newCategory.name = "Gia đình";
//        dao.insertCategory(newCategory);
//        System.out.println("Inserted category: " + newCategory.name);
//
//        // Test 6: Retrieve and display all categories
//        System.out.println("\n=== Test 6: Retrieving All Categories ===");
//        List<Category> categories = dao.getAllCategories();
//        for (Category category : categories) {
//            System.out.println("Category ID: " + category.category_id + ", Name: " + category.name + ", User ID: " + category.user_id);
//        }
//
//        // Test 7: Insert a new task
//        System.out.println("\n=== Test 7: Inserting a New Task ===");
//        Task newTask = new Task();
//        newTask.task_id = "T007";
//        newTask.user_id = "U004";
//        newTask.category_id = "C005";
//        newTask.title = "Tổ chức sinh nhật";
//        newTask.description = "Chuẩn bị tiệc sinh nhật cho gia đình";
//        newTask.status = "Chưa bắt đầu";
//        newTask.priority = "Cao";
//        newTask.created_at = LocalDateTime.now();
//        dao.insertTask(newTask);
//        System.out.println("Inserted task: " + newTask.title);
//
//        // Test 8: Retrieve and display all tasks
//        System.out.println("\n=== Test 8: Retrieving All Tasks ===");
//        List<Task> tasks = dao.getAllTasks();
//        for (Task task : tasks) {
//            System.out.println("Task ID: " + task.task_id + ", Title: " + task.title + ", Status: " + task.status);
//        }
//
//        // Test 9: Retrieve and display tasks with category names
//        System.out.println("\n=== Test 9: Retrieving Tasks with Category Names ===");
//        List<TaskWithCategory> tasksWithCategories = dao.getTasksWithCategoryNames("U001");
//        for (TaskWithCategory twc : tasksWithCategories) {
//            System.out.println("Task ID: " + twc.task.task_id + ", Title: " + twc.task.title + ", Category: " + (twc.category_name != null ? twc.category_name : "None"));
//        }
//
//        // Test 10: Delete a task
//        System.out.println("\n=== Test 10: Deleting a Task ===");
//        dao.deleteTask("T007");
//        System.out.println("Deleted task T007");
//
//        // Test 11: Delete a category
//        System.out.println("\n=== Test 11: Deleting a Category ===");
//        dao.deleteCategory("C005");
//        System.out.println("Deleted category C005");
//
//        // Test 12: Delete a user
//        System.out.println("\n=== Test 12: Deleting a User ===");
//        dao.deleteUser("U004");
//        System.out.println("Deleted user U004");

        // Test 13: Get tasks by user
//        System.out.println("\n=== Test 13: Get task by User ===");
//        System.out.println();
//        List<Task> tasksWithUser = dao.getTasksByUser("U001");
//        for (Task twc : tasksWithUser) {
//            System.out.println("Task ID: " + twc.task_id + ", Title: " + twc.title + ", Category: " );
//        }

        dao.testSearchTasks();

        // Close the database connection
        dao.close();
        System.out.println("\nDatabase connection closed.");
    }

    // Helper method to access the connection for testing (assumes DBConnect has a getConnection method)
    private static Connection getConnection() {
        DBConnect db = new DBConnect();
        return db.getConnection();
    }
}
