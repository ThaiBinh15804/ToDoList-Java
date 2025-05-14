package com.example;

import java.sql.*;

public class DBConnect {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=TODOListDB;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa"; // Replace with your DB username
    private static final String PASSWORD = "123"; // Replace with your DB password
    private Connection connection;

    public DBConnect() {
        try {
            // Load SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Establish connection
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Kết nối database thành công.");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
