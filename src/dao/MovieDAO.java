package dao;

import java.sql.*;
import java.util.*;
import model.Movie;

public class MovieDAO {

    public static List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery("SELECT * FROM movies");

            while (rs.next()) {
                list.add(new Movie(
                    rs.getInt("movie_id"),
                    rs.getString("title")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}