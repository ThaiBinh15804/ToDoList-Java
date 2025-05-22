package com.example.model;

import java.time.LocalDateTime;

public class Task {
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