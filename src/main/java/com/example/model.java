package com.example;

import java.time.LocalDateTime;

public class model {
    public static class User {
        public String user_id;
        public String username;
        public String password;
        public String email;
        public String fullname;
        public String phone;
        public LocalDateTime created_at;
        public LocalDateTime updated_at;
    }

    public static class Task {
        public String task_id;
        public String user_id;
        public String category_id;
        public String title;
        public String description;
        public String status;
        public String priority;
        public LocalDateTime start_time;
        public LocalDateTime end_time;
        public LocalDateTime created_at;
        public LocalDateTime updated_at;
    }

    public static class TaskWithCategory {
        public Task task;
        public String username;
        public String category_name;
    }

    public static class Category {
        public String category_id;
        public String user_id;
        public String name;
    }
}
