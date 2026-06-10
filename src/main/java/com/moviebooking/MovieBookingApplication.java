package com.moviebooking;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan // Ensures session management features are loaded properly
public class MovieBookingApplication {
    public static void main(String[] args) {
        SpringApplication.run(MovieBookingApplication.class, args);
    }
}
