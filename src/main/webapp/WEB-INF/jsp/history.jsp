<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets — MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime</h1>
        <nav>
            <a href="/movies">← Movies</a>
        </nav>
    </header>

    <div class="container">
        <div style="margin-bottom: 32px; animation: fadeInUp 0.5s ease;">
            <h2 class="section-title">My Tickets</h2>
            <p class="section-subtitle">Your complete booking history.</p>
        </div>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <div class="empty-icon">🎟️</div>
                    <h3>No Bookings Yet</h3>
                    <p>You haven't booked any tickets yet. Explore what's showing now and grab your seats!</p>
                    <a href="/movies" class="btn">Browse Movies</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Movie</th>
                            <th>Show Date &amp; Time</th>
                            <th>Screen</th>
                            <th>Total Paid</th>
                            <th>Booked On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td style="font-weight:800; color: var(--primary); font-family: monospace; font-size: 1rem;">#${booking.id}</td>
                                <td style="font-weight:700; color: var(--text-bright);">${booking.showTiming.movie.title}</td>
                                <td><fmt:formatDate value="${booking.showTiming.showTime}" pattern="MMM dd, yyyy · hh:mm a" /></td>
                                <td style="color: var(--text-muted);">${booking.showTiming.screenName}</td>
                                <td><span class="amount">₹${booking.totalAmount}</span></td>
                                <td style="color: var(--text-muted); font-size: 0.85rem;">
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="MMM dd, yyyy" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
