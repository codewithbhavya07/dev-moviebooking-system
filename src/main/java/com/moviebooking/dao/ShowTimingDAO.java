package com.moviebooking.dao;

import com.moviebooking.model.ShowTiming;
import com.moviebooking.model.Movie;
import com.moviebooking.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShowTimingDAO {

    public List<ShowTiming> getAllShows() {
        List<ShowTiming> shows = new ArrayList<>();
        String sql = "SELECT st.*, m.title, m.description, m.language, m.duration " +
                     "FROM show_timings st JOIN movies m ON st.movie_id = m.id " +
                     "ORDER BY st.show_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            SeatDAO seatDAO = new SeatDAO();
            while (rs.next()) {
                ShowTiming show = new ShowTiming();
                show.setId(rs.getInt("id"));
                show.setMovieId(rs.getInt("movie_id"));
                show.setShowTime(rs.getTimestamp("show_time"));
                show.setScreenName(rs.getString("screen_name"));
                show.setTicketPrice(rs.getDouble("ticket_price"));
                show.setSilverPrice(rs.getDouble("silver_price"));
                show.setGoldPrice(rs.getDouble("gold_price"));
                show.setPlatinumPrice(rs.getDouble("platinum_price"));
                show.setAvailableSeats(seatDAO.getAvailableSeatCount(show.getId()));
                
                Movie movie = new Movie();
                movie.setId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDescription(rs.getString("description"));
                movie.setLanguage(rs.getString("language"));
                movie.setDuration(rs.getInt("duration"));
                show.setMovie(movie);
                shows.add(show);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shows;
    }

    public List<ShowTiming> getShowsForMovie(int movieId) {
        List<ShowTiming> shows = new ArrayList<>();
        String sql = "SELECT st.*, m.title, m.description, m.language, m.duration " +
                     "FROM show_timings st JOIN movies m ON st.movie_id = m.id " +
                     "WHERE st.movie_id = ? AND st.show_time > NOW() ORDER BY st.show_time ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            ResultSet rs = stmt.executeQuery();
            
            SeatDAO seatDAO = new SeatDAO();
            while (rs.next()) {
                ShowTiming show = new ShowTiming();
                show.setId(rs.getInt("id"));
                show.setMovieId(rs.getInt("movie_id"));
                show.setShowTime(rs.getTimestamp("show_time"));
                show.setScreenName(rs.getString("screen_name"));
                show.setTicketPrice(rs.getDouble("ticket_price"));
                show.setSilverPrice(rs.getDouble("silver_price"));
                show.setGoldPrice(rs.getDouble("gold_price"));
                show.setPlatinumPrice(rs.getDouble("platinum_price"));
                show.setAvailableSeats(seatDAO.getAvailableSeatCount(show.getId()));
                
                Movie movie = new Movie();
                movie.setId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDescription(rs.getString("description"));
                movie.setLanguage(rs.getString("language"));
                movie.setDuration(rs.getInt("duration"));
                show.setMovie(movie);
                shows.add(show);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shows;
    }

    public ShowTiming getShowById(int showId) {
        String sql = "SELECT st.*, m.title, m.duration, m.language " +
                     "FROM show_timings st JOIN movies m ON st.movie_id = m.id WHERE st.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, showId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ShowTiming show = new ShowTiming();
                show.setId(rs.getInt("id"));
                show.setMovieId(rs.getInt("movie_id"));
                show.setShowTime(rs.getTimestamp("show_time"));
                show.setScreenName(rs.getString("screen_name"));
                show.setTicketPrice(rs.getDouble("ticket_price"));
                show.setSilverPrice(rs.getDouble("silver_price"));
                show.setGoldPrice(rs.getDouble("gold_price"));
                show.setPlatinumPrice(rs.getDouble("platinum_price"));
                show.setAvailableSeats(new SeatDAO().getAvailableSeatCount(show.getId()));
                
                Movie movie = new Movie();
                movie.setId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                show.setMovie(movie);
                return show;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addShow(ShowTiming show, int silverRows, int goldRows, int platinumRows, int columns) {
        String insertShowSql = "INSERT INTO show_timings (movie_id, show_time, screen_name, ticket_price, silver_price, gold_price, platinum_price) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertSeatSql = "INSERT INTO seats (show_id, seat_number, is_booked, seat_type) VALUES (?, ?, FALSE, ?)";
        
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            int showId = 0;
            // 1. Insert Show
            try (PreparedStatement stmt = conn.prepareStatement(insertShowSql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, show.getMovieId());
                stmt.setTimestamp(2, show.getShowTime());
                stmt.setString(3, show.getScreenName());
                stmt.setDouble(4, show.getTicketPrice());
                stmt.setDouble(5, show.getSilverPrice());
                stmt.setDouble(6, show.getGoldPrice());
                stmt.setDouble(7, show.getPlatinumPrice());
                stmt.executeUpdate();
                
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    showId = rs.getInt(1);
                }
            }
            
            if (showId == 0) throw new SQLException("Failed to get generated show ID.");
            
            // 2. Insert Seats (auto-generate based on rows/cols)
            int totalRows = silverRows + goldRows + platinumRows;
            try (PreparedStatement stmt = conn.prepareStatement(insertSeatSql)) {
                for (int r = 0; r < totalRows; r++) {
                    char rowChar = (char) ('A' + r);
                    String seatType;
                    if (r < silverRows) {
                        seatType = "SILVER";
                    } else if (r < silverRows + goldRows) {
                        seatType = "GOLD";
                    } else {
                        seatType = "PLATINUM";
                    }
                    
                    for (int c = 1; c <= columns; c++) {
                        String seatNum = rowChar + String.valueOf(c);
                        stmt.setInt(1, showId);
                        stmt.setString(2, seatNum);
                        stmt.setString(3, seatType);
                        stmt.addBatch();
                    }
                }
                stmt.executeBatch();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public boolean updateShow(ShowTiming show) {
        String sql = "UPDATE show_timings SET show_time = ?, screen_name = ?, ticket_price = ?, silver_price = ?, gold_price = ?, platinum_price = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, show.getShowTime());
            stmt.setString(2, show.getScreenName());
            stmt.setDouble(3, show.getTicketPrice());
            stmt.setDouble(4, show.getSilverPrice());
            stmt.setDouble(5, show.getGoldPrice());
            stmt.setDouble(6, show.getPlatinumPrice());
            stmt.setInt(7, show.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteShow(int showId) {
        String sql = "DELETE FROM show_timings WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, showId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasBookings(int showId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE show_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, showId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
