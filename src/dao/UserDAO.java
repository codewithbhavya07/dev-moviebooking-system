package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public static boolean login(String email, String password) {
        try {
            Connection con = DBConnection.getConnection();

            String query = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            return rs.next(); // true if user exists

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}