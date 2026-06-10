package com.moviebooking.controller;

import com.moviebooking.dao.BookingDAO;
import com.moviebooking.dao.SeatDAO;
import com.moviebooking.dao.ShowTimingDAO;
import com.moviebooking.model.Booking;
import com.moviebooking.model.Seat;
import com.moviebooking.model.ShowTiming;
import com.moviebooking.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class BookingController {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ShowTimingDAO showTimingDAO = new ShowTimingDAO();
    private final SeatDAO seatDAO = new SeatDAO();

    @PostMapping("/book")
    public String processBooking(@RequestParam int showId,
                                 @RequestParam(value = "seat", required = false) String[] selectedSeats,
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (selectedSeats == null || selectedSeats.length == 0) {
            return "redirect:/seats?showId=" + showId + "&error=NoSeatsSelected";
        }

        ShowTiming show = showTimingDAO.getShowById(showId);
        if (show == null) {
            return "redirect:/movies?error=InvalidShow";
        }

        List<Seat> allSeats = seatDAO.getSeatsForShow(showId);
        double totalAmount = 0.0;
        for (String selected : selectedSeats) {
            for (Seat seat : allSeats) {
                if (seat.getSeatNumber().equals(selected)) {
                    totalAmount += seat.getPrice();
                    break;
                }
            }
        }

        boolean success = bookingDAO.createBooking(user.getId(), showId, selectedSeats, totalAmount);

        if (success) {
            model.addAttribute("show", show);
            model.addAttribute("selectedSeats", String.join(", ", selectedSeats));
            model.addAttribute("totalAmount", totalAmount);
            return "booking_confirmation";
        } else {
            return "redirect:/seats?showId=" + showId + "&error=BookingFailed";
        }
    }

    @GetMapping("/history")
    public String viewHistory(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Booking> bookings = bookingDAO.getUserBookings(user.getId());
        model.addAttribute("bookings", bookings);
        return "history";
    }
}
