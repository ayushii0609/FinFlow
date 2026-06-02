package com.finflow.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        // Use environment variables on server
        // Fall back to localhost for local development
        String envUrl  = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPass = System.getenv("DB_PASS");

        URL      = (envUrl  != null) ? envUrl  : "jdbc:mysql://localhost:3306/finflow_db?useSSL=false&serverTimezone=Asia/Kolkata";
        USER     = (envUser != null) ? envUser : "root";
        PASSWORD = (envPass != null) ? envPass : "ayushi@123#";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}