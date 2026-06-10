package com.moviebooking.model;

import java.io.Serializable;

public class Movie implements Serializable {
    private int id;
    private String title;
    private String description;
    private String language;
    private int duration;
    private String imageUrl; // New field

    public Movie() {}

    public Movie(int id, String title, String description, String language, int duration, String imageUrl) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.language = language;
        this.duration = duration;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
