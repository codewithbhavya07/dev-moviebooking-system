package com.moviebooking.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL;
    private static final String USERNAME;
    private static final String PASSWORD;
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        // Railway exports both MYSQLHOST and MYSQL_HOST formats — try both
        String host = getEnv("MYSQLHOST",     getEnv("MYSQL_HOST",     "localhost"));
        String port = getEnv("MYSQLPORT",     getEnv("MYSQL_PORT",     "3306"));
        String db   = getEnv("MYSQLDATABASE", getEnv("MYSQL_DATABASE", "movie_booking_system"));
        USERNAME    = getEnv("MYSQLUSER",     getEnv("MYSQL_USER",     "root"));
        PASSWORD    = getEnv("MYSQLPASSWORD", getEnv("MYSQL_PASSWORD", "Bat@123456"));
        URL = "jdbc:mysql://" + host + ":" + port + "/" + db
                + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

        System.out.println("[DBUtil] Connecting to: jdbc:mysql://" + host + ":" + port + "/" + db);

        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load MySQL JDBC Driver: " + e.getMessage());
        }
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}

