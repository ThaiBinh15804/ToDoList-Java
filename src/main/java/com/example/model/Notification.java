package com.example.model;

import java.time.LocalDateTime;

public class Notification {
    public String notification_id;
    public String task_id;
    public String user_id;
    public String title;
    public String description;
    public LocalDateTime start_time;
    public LocalDateTime end_time;
    public String type; // e.g., "START", "OVERDUE_NOT_STARTED", "OVERDUE_IN_PROGRESS"
    public LocalDateTime created_at;

    public Notification() {
    }

    public Notification(String notification_id, String task_id, String user_id, String title, String description,
                        LocalDateTime start_time, LocalDateTime end_time, String type, LocalDateTime created_at) {
        this.notification_id = notification_id;
        this.task_id = task_id;
        this.user_id = user_id;
        this.title = title;
        this.description = description;
        this.start_time = start_time;
        this.end_time = end_time;
        this.type = type;
        this.created_at = created_at;
    }
}