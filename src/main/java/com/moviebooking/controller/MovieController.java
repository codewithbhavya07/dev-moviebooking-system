package com.moviebooking.controller;

import com.moviebooking.dao.MovieDAO;
import com.moviebooking.dao.ShowTimingDAO;
import com.moviebooking.dao.SeatDAO;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTiming;
import com.moviebooking.model.Seat;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class MovieController {

    private final MovieDAO movieDAO = new MovieDAO();
    private final ShowTimingDAO showTimingDAO = new ShowTimingDAO();
    private final SeatDAO seatDAO = new SeatDAO();

    @GetMapping("/movies")
    public String viewMovies(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<Movie> movies = movieDAO.getAllMovies();
        model.addAttribute("movies", movies);
        return "movies";
    }

    @GetMapping("/shows")
    public String viewShows(@RequestParam int movieId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        
        Movie movie = movieDAO.getMovieById(movieId);
        List<ShowTiming> shows = showTimingDAO.getShowsForMovie(movieId);
        
        if (movie != null) {
            model.addAttribute("movie", movie);
            model.addAttribute("shows", shows);
            return "shows";
        }
        return "redirect:/movies?error=MovieNotFound";
    }

    @GetMapping("/seats")
    public String viewSeats(@RequestParam int showId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        
        ShowTiming show = showTimingDAO.getShowById(showId);
        if (show != null) {
            List<Seat> seats = seatDAO.getSeatsForShow(showId);
            model.addAttribute("show", show);
            model.addAttribute("seats", seats);
            model.addAttribute("ticketPrice", show.getTicketPrice());
            return "seats";
        }
        return "redirect:/movies?error=ShowNotFound";
    }
}
