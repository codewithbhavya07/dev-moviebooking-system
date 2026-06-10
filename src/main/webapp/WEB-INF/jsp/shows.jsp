<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${movie.title} — Showtimes · MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .movie-hero {
            display: flex;
            gap: 36px;
            align-items: flex-start;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 40px;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease;
        }
        .movie-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--accent-dim) 0%, transparent 50%, var(--primary-dim) 100%);
            pointer-events: none;
        }
        .movie-hero-poster {
            width: 140px;
            min-width: 140px;
            aspect-ratio: 2/3;
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--glass-border-s);
            box-shadow: 0 16px 40px rgba(0,0,0,0.5);
        }
        .movie-hero-poster img { width:100%; height:100%; object-fit: cover; display: block; }
        .movie-hero-info { flex: 1; position: relative; }
        .movie-hero-info h2 {
            font-size: 2.4rem;
            font-weight: 900;
            color: var(--text-bright);
            margin-bottom: 10px;
            letter-spacing: -1.5px;
            line-height: 1.1;
        }
        .movie-hero-info p {
            color: var(--text-muted);
            font-size: 0.97rem;
            line-height: 1.7;
            max-width: 560px;
            margin-bottom: 20px;
        }
        @media (max-width: 640px) {
            .movie-hero { flex-direction: column; padding: 24px; gap: 20px; }
            .movie-hero-info h2 { font-size: 1.8rem; }
            .movie-hero-poster { width: 100px; min-width: 100px; }
        }
    </style>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime</h1>
        <nav>
            <a href="/movies">← All Movies</a>
        </nav>
    </header>

    <div class="container">

        <!-- Movie hero panel -->
        <div class="movie-hero">
            <div class="movie-hero-poster">
                <c:choose>
                    <c:when test="${not empty movie.imageUrl}">
                        <img src="${movie.imageUrl}" alt="${movie.title}" loading="lazy">
                    </c:when>
                    <c:otherwise>
                        <div style="width:100%;height:100%;background:var(--bg-elevated);display:flex;align-items:center;justify-content:center;font-size:2.5rem;">🎬</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="movie-hero-info">
                <h2>${movie.title}</h2>
                <p>${movie.description}</p>
                <div class="movie-tags">
                    <span class="tag lang">${movie.language}</span>
                    <span class="tag">⏱ ${movie.duration} mins</span>
                </div>
            </div>
        </div>

        <!-- Showtimes -->
        <h3 class="section-title" style="font-size: 1.6rem; margin-bottom: 20px;">Available Showtimes</h3>

        <c:choose>
            <c:when test="${empty shows}">
                <div class="empty-state">
                    <div class="empty-icon">🎭</div>
                    <h3>No Shows Scheduled</h3>
                    <p>There are no showtimes currently available for this movie. Check back soon!</p>
                    <a href="/movies" class="btn">Browse Other Movies</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="shows-list">
                    <c:forEach var="show" items="${shows}">
                        <div class="show-item">
                            <div class="show-details">
                                <div class="show-time">
                                    <fmt:formatDate value="${show.showTime}" pattern="EEEE, MMM dd · hh:mm a" />
                                </div>
                                <div class="show-screen">🎦 ${show.screenName}</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${show.availableSeats > 5}">
                                            <span class="show-badge available">✓ ${show.availableSeats} seats available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="show-badge limited">⚡ Only ${show.availableSeats} left!</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="display:flex; align-items:center; gap:20px; flex-shrink:0;">
                                <div class="show-price">From ₹${show.ticketPrice}</div>
                                <a href="/seats?showId=${show.id}" class="btn">Select Seats →</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
