<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed — MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body {
            background: radial-gradient(ellipse 80% 60% at 50% -10%, rgba(201, 162, 39, 0.15) 0%, transparent 60%),
                        radial-gradient(ellipse 60% 50% at 20% 110%, rgba(124, 58, 237, 0.1) 0%, transparent 60%),
                        var(--bg-deep);
        }

        .confirm-page {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 48px 24px 80px;
        }

        .success-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(16, 185, 129, 0.12);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #34d399;
            padding: 10px 24px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 0.9rem;
            letter-spacing: 1px;
            margin-bottom: 20px;
            animation: fadeInUp 0.5s ease;
        }

        .success-title {
            font-size: 2.4rem;
            font-weight: 900;
            text-align: center;
            letter-spacing: -1.5px;
            color: var(--text-bright);
            margin-bottom: 40px;
            animation: fadeInUp 0.5s 0.1s ease both;
        }
        .success-title span {
            background: linear-gradient(135deg, var(--primary), #f5d678);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .seats-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 16px;
            align-items: center;
            width: 100%;
            max-width: 440px;
            margin-top: 28px;
            animation: fadeInUp 0.5s 0.5s ease both;
        }

        .download-btn {
            width: 100%;
            background: linear-gradient(135deg, var(--primary) 0%, #8b6914 100%);
            color: #0a0800;
            border: none;
            padding: 17px;
            font-size: 1rem;
            font-weight: 900;
            border-radius: var(--radius-sm);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            transition: all var(--transition);
            cursor: pointer;
            font-family: 'Outfit', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px var(--primary-glow);
        }

        .home-link {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            letter-spacing: 1px;
            transition: color var(--transition);
            text-transform: uppercase;
        }
        .home-link:hover { color: var(--text-bright); }
    </style>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime</h1>
        <nav>
            <a href="/history">My Tickets</a>
        </nav>
    </header>

    <div class="confirm-page">
        <div class="success-badge">✓ &nbsp;Booking Successful</div>

        <h1 class="success-title">Your ticket is <span>confirmed!</span></h1>

        <!-- Ticket Card -->
        <div class="ticket-wrapper" style="animation-delay: 0.2s;">
            <div class="ticket-header">
                <span class="movie-emoji">🎬</span>
                <h2>${show.movie.title}</h2>
            </div>

            <div class="ticket-body">
                <div class="ticket-info-row">
                    <div class="info-group">
                        <div class="info-label">Date &amp; Time</div>
                        <div class="info-value">${show.showTime}</div>
                    </div>
                    <div class="info-group right">
                        <div class="info-label">Screen</div>
                        <div class="info-value">${show.screenName}</div>
                    </div>
                </div>

                <div class="ticket-info-row" style="margin-bottom: 0;">
                    <div class="info-group" style="flex: 1.5;">
                        <div class="info-label">Your Seats</div>
                        <div class="seats-list">
                            <c:set var="seatList" value="${fn:split(selectedSeats, ',')}" />
                            <c:forEach var="seat" items="${seatList}">
                                <span class="seat-badge">${fn:trim(seat)}</span>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="info-group right">
                        <div class="info-label">Total Paid</div>
                        <div class="info-value amount-highlight">₹${totalAmount}</div>
                    </div>
                </div>
            </div>

            <div class="ticket-divider"></div>

            <div class="ticket-footer">
                <div class="info-group">
                    <div class="info-label">Booking Ref</div>
                    <div class="info-value" style="font-family: monospace; letter-spacing: 3px; font-size: 1.2rem;">
                        #MT${fn:substring(show.id, 0, 4)}X9
                    </div>
                </div>
                <div class="info-group right">
                    <div class="barcode"></div>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <button class="download-btn" onclick="alert('🎬 Enjoy your movie!')">
                🎟️ &nbsp;Download Ticket
            </button>
            <a href="/movies" class="home-link">← Back to Movies</a>
        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
