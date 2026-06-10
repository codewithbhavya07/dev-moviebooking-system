<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieTime — Premium Cinema Experience</title>
    <meta name="description" content="Book movie tickets instantly for premium theaters. Browse showtimes, pick perfect seats, and skip the line.">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/'">🎬 MovieTime</h1>
        <nav>
            <a href="/login">Login</a>
            <a href="/register" class="btn" style="padding: 9px 22px; font-size: 0.82rem; border-radius: 999px;">Join Free</a>
        </nav>
    </header>

    <div class="hero-banner">
        <div class="hero-badge">✨ Now Showing Blockbusters</div>

        <h1>
            Experience Cinema<br>
            <span class="gradient-text">Like Never Before.</span>
        </h1>

        <p>Book your favourite movies instantly at premium theaters near you. Explore showtimes, pick your perfect seat, and skip the line — all in seconds.</p>

        <div class="hero-actions">
            <a href="/movies" class="btn">Browse Movies</a>
            <a href="/register" class="btn btn-outline">Create Free Account</a>
        </div>

        <div class="hero-stats">
            <div class="hero-stat-item">
                <span class="stat-num">50+</span>
                <span class="stat-label">Movies</span>
            </div>
            <div class="hero-stat-item">
                <span class="stat-num">10k+</span>
                <span class="stat-label">Tickets Booked</span>
            </div>
            <div class="hero-stat-item">
                <span class="stat-num">5★</span>
                <span class="stat-label">Rated</span>
            </div>
        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium · Built with ♥ for cinema lovers</p>
    </footer>
</body>
</html>
