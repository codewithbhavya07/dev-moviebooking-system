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
        // Read from Railway env vars; fall back to local dev values
        String host = getEnv("MYSQLHOST", "localhost");
        String port = getEnv("MYSQLPORT", "3306");
        String db   = getEnv("MYSQLDATABASE", "movie_booking_system");
        USERNAME    = getEnv("MYSQLUSER", "root");
        PASSWORD    = getEnv("MYSQLPASSWORD", "Bat@123456");
        URL = "jdbc:mysql://" + host + ":" + port + "/" + db
                + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

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

