package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        try {
            String url = "jdbc:mysql://localhost:3306/movie_booking";
            String user = "root";
            String password = "your_password";

            Connection con = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to Database!");
            return con;

        } catch (Exception e) {
            System.out.println(e);
            return null;
        }
    }
}