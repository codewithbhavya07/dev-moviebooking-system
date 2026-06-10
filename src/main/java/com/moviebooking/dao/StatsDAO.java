package com.moviebooking.dao;

import com.moviebooking.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StatsDAO {

    public int getTotalBookings() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public double getTotalRevenue() {
        double total = 0.0;
        String sql = "SELECT SUM(total_amount) FROM bookings";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'USER'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public String getMostPopularMovie() {
        String movieTitle = "N/A";
        String sql = "SELECT m.title, COUNT(b.id) as booking_count " +
                     "FROM bookings b " +
                     "JOIN show_timings st ON b.show_id = st.id " +
                     "JOIN movies m ON st.movie_id = m.id " +
                     "GROUP BY m.title " +
                     "ORDER BY booking_count DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                movieTitle = rs.getString("title");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieTitle;
    }
}
