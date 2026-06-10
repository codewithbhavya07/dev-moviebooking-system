package com.moviebooking.controller;

import com.moviebooking.dao.MovieDAO;
import com.moviebooking.dao.ShowTimingDAO;
import com.moviebooking.dao.StatsDAO;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTiming;
import com.moviebooking.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class AdminController {

    private final MovieDAO movieDAO = new MovieDAO();
    private final ShowTimingDAO showTimingDAO = new ShowTimingDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @GetMapping("/admin")
    public String viewAdminDashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/movies?error=AccessDenied";
        }
        
        List<Movie> movies = movieDAO.getAllMovies();
        model.addAttribute("movies", movies);
        
        List<ShowTiming> shows = showTimingDAO.getAllShows();
        model.addAttribute("shows", shows);
        
        model.addAttribute("totalBookings", statsDAO.getTotalBookings());
        model.addAttribute("totalRevenue", statsDAO.getTotalRevenue());
        model.addAttribute("totalUsers", statsDAO.getTotalUsers());
        model.addAttribute("mostPopularMovie", statsDAO.getMostPopularMovie());
        
        return "admin_dashboard";
    }

    @PostMapping("/admin/addMovie")
    public String addMovie(@RequestParam String title,
                           @RequestParam String description,
                           @RequestParam String language,
                           @RequestParam int duration,
                           @RequestParam(required = false) String imageUrl,
                           HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        Movie movie = new Movie();
        movie.setTitle(title);
        movie.setDescription(description);
        movie.setLanguage(language);
        movie.setDuration(duration);
        movie.setImageUrl(imageUrl);
        
        if (movieDAO.addMovie(movie)) {
            return "redirect:/admin?success=Movie added successfully";
        }
        return "redirect:/admin?error=Failed to add movie";
    }

    @PostMapping("/admin/updateMovie")
    public String updateMovie(@RequestParam int id,
                              @RequestParam String title,
                              @RequestParam String description,
                              @RequestParam String language,
                              @RequestParam int duration,
                              @RequestParam(required = false) String imageUrl,
                              HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        Movie movie = new Movie(id, title, description, language, duration, imageUrl);
        
        if (movieDAO.updateMovie(movie)) {
            return "redirect:/admin?success=Movie updated successfully";
        }
        return "redirect:/admin?error=Failed to update movie";
    }

    @PostMapping("/admin/deleteMovie")
    public String deleteMovie(@RequestParam int id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        if (movieDAO.deleteMovie(id)) {
            return "redirect:/admin?success=Movie deleted successfully";
        }
        return "redirect:/admin?error=Failed to delete movie (Existing bookings may block this)";
    }

    @PostMapping("/admin/addShow")
    public String addShow(@RequestParam int movieId,
                          @RequestParam String screenName,
                          @RequestParam double silverPrice,
                          @RequestParam double goldPrice,
                          @RequestParam double platinumPrice,
                          @RequestParam String showTime,
                          @RequestParam int silverRows,
                          @RequestParam int goldRows,
                          @RequestParam int platinumRows,
                          @RequestParam int columns,
                          HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        try {
            LocalDateTime ldt = LocalDateTime.parse(showTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            Timestamp timestamp = Timestamp.valueOf(ldt);
            
            ShowTiming show = new ShowTiming();
            show.setMovieId(movieId);
            show.setScreenName(screenName);
            show.setShowTime(timestamp);
            show.setTicketPrice(silverPrice); // Default fallback
            show.setSilverPrice(silverPrice);
            show.setGoldPrice(goldPrice);
            show.setPlatinumPrice(platinumPrice);
            
            if (showTimingDAO.addShow(show, silverRows, goldRows, platinumRows, columns)) {
                int totalRows = silverRows + goldRows + platinumRows;
                return "redirect:/admin?success=Show and " + (totalRows * columns) + " seats generated successfully";
            }
            return "redirect:/admin?error=Failed to schedule show";
        } catch (Exception e) {
            return "redirect:/admin?error=Invalid input for show: " + e.getMessage();
        }
    }

    @GetMapping("/admin/editShow")
    public String editShow(@RequestParam int showId, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";
        
        ShowTiming show = showTimingDAO.getShowById(showId);
        if (show == null) {
            return "redirect:/admin?error=Show not found";
        }
        model.addAttribute("show", show);
        return "edit_show";
    }

    @PostMapping("/admin/updateShow")
    public String updateShow(@RequestParam int id,
                             @RequestParam String screenName,
                             @RequestParam double silverPrice,
                             @RequestParam double goldPrice,
                             @RequestParam double platinumPrice,
                             @RequestParam String showTime,
                             HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        try {
            LocalDateTime ldt = LocalDateTime.parse(showTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            Timestamp timestamp = Timestamp.valueOf(ldt);
            
            ShowTiming show = new ShowTiming();
            show.setId(id);
            show.setScreenName(screenName);
            show.setTicketPrice(silverPrice); // Default fallback
            show.setSilverPrice(silverPrice);
            show.setGoldPrice(goldPrice);
            show.setPlatinumPrice(platinumPrice);
            show.setShowTime(timestamp);
            
            if (showTimingDAO.updateShow(show)) {
                return "redirect:/admin?success=Show updated successfully";
            }
            return "redirect:/admin?error=Failed to update show";
        } catch (Exception e) {
            return "redirect:/admin?error=Invalid input: " + e.getMessage();
        }
    }

    @PostMapping("/admin/deleteShow")
    public String deleteShow(@RequestParam int id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/movies?error=AccessDenied";

        if (showTimingDAO.hasBookings(id)) {
            return "redirect:/admin?error=Cannot delete - this show has existing bookings";
        }

        if (showTimingDAO.deleteShow(id)) {
            return "redirect:/admin?success=Show deleted successfully";
        }
        return "redirect:/admin?error=Failed to delete show";
    }

    private boolean isAdmin(HttpSession session) {
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            return "ADMIN".equals(user.getRole());
        }
        return false;
    }
}
