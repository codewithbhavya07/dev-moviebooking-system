package com.moviebooking.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class Booking implements Serializable {
    private int id;
    private int userId;
    private int showId;
    private double totalAmount;
    private Timestamp bookingDate;
    
    private ShowTiming showTiming;
    private List<Seat> seats;

    public Booking() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getShowId() { return showId; }
    public void setShowId(int showId) { this.showId = showId; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }
    public ShowTiming getShowTiming() { return showTiming; }
    public void setShowTiming(ShowTiming showTiming) { this.showTiming = showTiming; }
    public List<Seat> getSeats() { return seats; }
    public void setSeats(List<Seat> seats) { this.seats = seats; }
}
