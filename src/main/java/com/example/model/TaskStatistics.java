package com.example.model;

public class TaskStatistics {
    private int total;
    private int notStarted;
    private int inProgress;
    private int completed;

    public TaskStatistics(int total, int notStarted, int inProgress, int completed) {
        this.total = total;
        this.notStarted = notStarted;
        this.inProgress = inProgress;
        this.completed = completed;
    }

    public int getTotal() {
        return total;
    }

    public int getNotStarted() {
        return notStarted;
    }

    public int getInProgress() {
        return inProgress;
    }

    public int getCompleted() {
        return completed;
    }

    public double getNotStartedPercent() {
        return total == 0 ? 0 : Math.round(notStarted * 10000.0 / total) / 100.0;
    }

    public double getInProgressPercent() {
        return total == 0 ? 0 : Math.round(inProgress * 10000.0 / total) / 100.0;
    }

    public double getCompletedPercent() {
        return total == 0 ? 0 : Math.round(completed * 10000.0 / total) / 100.0;
    }
}

