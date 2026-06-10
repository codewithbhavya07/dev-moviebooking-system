package com.moviebooking.dao;

import com.moviebooking.model.Booking;
import com.moviebooking.model.Seat;
import com.moviebooking.model.ShowTiming;
import com.moviebooking.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    private SeatDAO seatDAO = new SeatDAO();

    public boolean createBooking(int userId, int showId, String[] seatNumbers, double totalAmount) {
        String insertBookingSql = "INSERT INTO bookings (user_id, show_id, total_amount) VALUES (?, ?, ?)";
        String insertBookingSeatSql = "INSERT INTO booking_seats (booking_id, seat_id) SELECT ?, id FROM seats WHERE show_id = ? AND seat_number = ?";
        
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Lock and update seats to booked
            boolean seatsAvailable = seatDAO.bookSeats(showId, seatNumbers, conn);
            if (!seatsAvailable) {
                conn.rollback();
                return false;
            }
            
            // 2. Insert Booking record
            int bookingId = 0;
            try (PreparedStatement stmt = conn.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, showId);
                stmt.setDouble(3, totalAmount);
                stmt.executeUpdate();
                
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    bookingId = rs.getInt(1);
                }
            }
            
            // 3. Link booking and seats
            try (PreparedStatement stmt = conn.prepareStatement(insertBookingSeatSql)) {
                for (String seatNo : seatNumbers) {
                    stmt.setInt(1, bookingId);
                    stmt.setInt(2, showId);
                    stmt.setString(3, seatNo);
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Booking> getUserBookings(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, st.show_time, st.screen_name, m.title " +
                     "FROM bookings b " +
                     "JOIN show_timings st ON b.show_id = st.id " +
                     "JOIN movies m ON st.movie_id = m.id " +
                     "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
                     
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setShowId(rs.getInt("show_id"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                
                ShowTiming st = new ShowTiming();
                st.setShowTime(rs.getTimestamp("show_time"));
                st.setScreenName(rs.getString("screen_name"));
                // Store movie title somewhere... using screenName for now just as a quick fix or create a full Movie obj
                com.moviebooking.model.Movie movie = new com.moviebooking.model.Movie();
                movie.setTitle(rs.getString("title"));
                st.setMovie(movie);
                
                booking.setShowTiming(st);
                
                // Get seats for this booking
                booking.setSeats(getSeatsForBooking(booking.getId(), conn));
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    private List<Seat> getSeatsForBooking(int bookingId, Connection conn) throws SQLException {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT s.seat_number FROM booking_seats bs JOIN seats s ON bs.seat_id = s.id WHERE bs.booking_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Seat seat = new Seat();
                seat.setSeatNumber(rs.getString("seat_number"));
                seats.add(seat);
            }
        }
        return seats;
    }
}
