<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats — ${show.movie.title} · MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const seats      = document.querySelectorAll('.seat:not(.booked)');
            const costLabel  = document.getElementById('total-cost');
            const countLabel = document.getElementById('seat-count');
            const btnSubmit  = document.getElementById('btn-submit');
            const summaryBar = document.getElementById('booking-summary');

            let selectedCount = 0;
            let totalPrice = 0.0;

            seats.forEach(seat => {
                seat.addEventListener('click', () => {
                    const checkbox = seat.querySelector('input[type="checkbox"]');
                    const seatPrice = parseFloat(seat.dataset.price) || 0;

                    checkbox.checked = !checkbox.checked;
                    seat.classList.toggle('selected');

                    if (checkbox.checked) { selectedCount++; totalPrice += seatPrice; }
                    else                  { selectedCount--; totalPrice -= seatPrice; }

                    updateSummary();
                });
            });

            function updateSummary() {
                countLabel.textContent = selectedCount;
                costLabel.textContent  = totalPrice.toFixed(2);

                if (selectedCount > 0) {
                    summaryBar.classList.add('active');
                    btnSubmit.disabled = false;
                } else {
                    summaryBar.classList.remove('active');
                    btnSubmit.disabled = true;
                }
            }
        });
    </script>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime</h1>
        <nav>
            <a href="/shows?movieId=${show.movieId}">← Back</a>
        </nav>
    </header>

    <div class="container" style="padding-bottom: 120px;">
        <!-- Page heading -->
        <div style="text-align: center; margin-bottom: 8px; animation: fadeInUp 0.5s ease;">
            <h2 style="font-size: 2rem; font-weight: 900; color: var(--text-bright); margin-bottom: 6px;">
                Choose Your Seats
            </h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">
                ${show.movie.title} &nbsp;·&nbsp; ${show.screenName}
            </p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="msg error" style="max-width: 600px; margin: 20px auto;">
                ⚠ Failed to book — those seats may have just been taken. Please try again.
            </div>
        </c:if>

        <form action="/book" method="post" id="bookingForm">
            <input type="hidden" name="showId" value="${show.id}">

            <!-- Screen indicator -->
            <div class="screen-indicator">SCREEN</div>

            <!-- Seats grid -->
            <div class="seats-container">
                <c:set var="prevRow" value="" />
                <c:set var="isFirst" value="true" />

                <c:forEach var="seat" items="${seats}">
                    <c:set var="currentRow" value="${seat.seatNumber.substring(0,1)}" />

                    <c:if test="${currentRow != prevRow}">
                        <c:if test="${!isFirst}">
                            </div><%-- close prev row --%>
                        </c:if>
                        <div class="seat-row">
                            <div class="seat-row-label">${currentRow}</div>
                        <c:set var="prevRow" value="${currentRow}" />
                        <c:set var="isFirst" value="false" />
                    </c:if>

                    <c:choose>
                        <c:when test="${seat.booked}">
                            <div class="seat booked" title="Booked">${seat.seatNumber}</div>
                        </c:when>
                        <c:otherwise>
                            <div class="seat ${fn:toLowerCase(seat.seatType)}"
                                 data-price="${seat.price}"
                                 title="${seat.seatType} · ₹${seat.price}">
                                ${seat.seatNumber}
                                <input type="checkbox" name="seat" value="${seat.seatNumber}" style="display:none;">
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </div><%-- close last row --%>
            </div>

            <!-- Legend -->
            <div class="seat-legend">
                <div class="legend-item"><div class="legend-box silver"></div> Silver (₹${show.silverPrice})</div>
                <div class="legend-item"><div class="legend-box gold"></div> Gold (₹${show.goldPrice})</div>
                <div class="legend-item"><div class="legend-box platinum"></div> Platinum (₹${show.platinumPrice})</div>
                <div class="legend-item"><div class="legend-box selected"></div> Selected</div>
                <div class="legend-item"><div class="legend-box booked"></div> Booked</div>
            </div>

            <!-- Sticky booking bar -->
            <div class="booking-summary" id="booking-summary">
                <div class="summary-info">
                    <div class="seat-count-label">💺 <span id="seat-count">0</span> Seats Selected</div>
                    <div class="amount-label">Total: <span>₹<span id="total-cost">0.00</span></span></div>
                </div>
                <button type="submit" id="btn-submit" disabled class="btn" style="border-radius: 999px; padding: 14px 36px;">
                    Confirm Booking →
                </button>
            </div>
        </form>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
