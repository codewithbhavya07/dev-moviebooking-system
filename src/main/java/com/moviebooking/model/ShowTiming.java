package com.moviebooking.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ShowTiming implements Serializable {
    private int id;
    private int movieId;
    private Timestamp showTime;
    private String screenName;
    private double ticketPrice; // Keeping for backward compatibility or default
    private double silverPrice;
    private double goldPrice;
    private double platinumPrice;
    private Movie movie; // For joining details
    private int availableSeats;

    public ShowTiming() {}

    // Getters and Setters
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }
    public Timestamp getShowTime() { return showTime; }
    public void setShowTime(Timestamp showTime) { this.showTime = showTime; }
    public String getScreenName() { return screenName; }
    public void setScreenName(String screenName) { this.screenName = screenName; }
    public double getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(double ticketPrice) { this.ticketPrice = ticketPrice; }
    public double getSilverPrice() { return silverPrice; }
    public void setSilverPrice(double silverPrice) { this.silverPrice = silverPrice; }
    public double getGoldPrice() { return goldPrice; }
    public void setGoldPrice(double goldPrice) { this.goldPrice = goldPrice; }
    public double getPlatinumPrice() { return platinumPrice; }
    public void setPlatinumPrice(double platinumPrice) { this.platinumPrice = platinumPrice; }
    public Movie getMovie() { return movie; }
    public void setMovie(Movie movie) { this.movie = movie; }
}
