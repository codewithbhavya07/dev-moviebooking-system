package com.moviebooking.dao;

import com.moviebooking.model.Seat;
import com.moviebooking.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {

    public List<Seat> getSeatsForShow(int showId) {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT s.*, st.silver_price, st.gold_price, st.platinum_price " +
                     "FROM seats s JOIN show_timings st ON s.show_id = st.id " +
                     "WHERE s.show_id = ? ORDER BY s.seat_number";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, showId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Seat seat = new Seat();
                seat.setId(rs.getInt("id"));
                seat.setShowId(rs.getInt("show_id"));
                seat.setSeatNumber(rs.getString("seat_number"));
                seat.setBooked(rs.getBoolean("is_booked"));
                String seatType = rs.getString("seat_type");
                if (seatType == null) seatType = "SILVER";
                seat.setSeatType(seatType);
                if ("SILVER".equals(seatType)) seat.setPrice(rs.getDouble("silver_price"));
                else if ("GOLD".equals(seatType)) seat.setPrice(rs.getDouble("gold_price"));
                else if ("PLATINUM".equals(seatType)) seat.setPrice(rs.getDouble("platinum_price"));
                else seat.setPrice(150.0); // Default
                seats.add(seat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seats;
    }

    public int getAvailableSeatCount(int showId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM seats WHERE show_id = ? AND is_booked = FALSE";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, showId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Synchronized method to prevent double booking
    public synchronized boolean bookSeats(int showId, String[] seatNumbers, Connection conn) throws SQLException {
        String checkSql = "SELECT is_booked FROM seats WHERE show_id = ? AND seat_number = ? FOR UPDATE";
        String updateSql = "UPDATE seats SET is_booked = TRUE WHERE show_id = ? AND seat_number = ?";
        
        boolean isLocalConn = false;
        if (conn == null) {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            isLocalConn = true;
        }

        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql);
             PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
            
            for (String seatNo : seatNumbers) {
                checkStmt.setInt(1, showId);
                checkStmt.setString(2, seatNo);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    if (rs.getBoolean("is_booked")) {
                        // Seat already booked, rollback
                        if (isLocalConn) conn.rollback();
                        return false;
                    }
                } else {
                    // Seat doesn't exist
                    if (isLocalConn) conn.rollback();
                    return false;
                }
            }
            
            // If all available, update them
            for (String seatNo : seatNumbers) {
                updateStmt.setInt(1, showId);
                updateStmt.setString(2, seatNo);
                updateStmt.addBatch();
            }
            updateStmt.executeBatch();
            
            if (isLocalConn) conn.commit();
            return true;
        } catch (SQLException e) {
            if (isLocalConn) conn.rollback();
            throw e;
        } finally {
            if (isLocalConn) conn.close();
        }
    }
}
