package com.moviebooking.dao;

import com.moviebooking.model.Movie;
import com.moviebooking.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM movies";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                movies.add(new Movie(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("language"),
                    rs.getInt("duration"),
                    rs.getString("image_url")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    public Movie getMovieById(int id) {
        String sql = "SELECT * FROM movies WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Movie(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("language"),
                    rs.getInt("duration"),
                    rs.getString("image_url")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addMovie(Movie movie) {
        String sql = "INSERT INTO movies (title, description, language, duration, image_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getDescription());
            stmt.setString(3, movie.getLanguage());
            stmt.setInt(4, movie.getDuration());
            stmt.setString(5, movie.getImageUrl());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateMovie(Movie movie) {
        String sql = "UPDATE movies SET title=?, description=?, language=?, duration=?, image_url=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getDescription());
            stmt.setString(3, movie.getLanguage());
            stmt.setInt(4, movie.getDuration());
            stmt.setString(5, movie.getImageUrl());
            stmt.setInt(6, movie.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMovie(int id) {
        String sql = "DELETE FROM movies WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
