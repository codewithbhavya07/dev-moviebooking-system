package com.moviebooking.model;

import java.io.Serializable;

public class Seat implements Serializable {
    private int id;
    private int showId;
    private String seatNumber;
    private boolean isBooked;
    private String seatType;
    private double price;

    public Seat() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getShowId() { return showId; }
    public void setShowId(int showId) { this.showId = showId; }
    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }
    public boolean isBooked() { return isBooked; }
    public void setBooked(boolean booked) { isBooked = booked; }
    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
