<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Now Showing — MovieTime</title>
    <meta name="description" content="Browse now showing movies and book your tickets online.">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime</h1>
        <nav>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <a href="/admin" class="chip admin">⚡ Admin</a>
            </c:if>
            <a href="/history">My Tickets</a>
            <a href="/logout">Logout · ${sessionScope.user.username}</a>
        </nav>
    </header>

    <div class="container">
        <div style="margin-bottom: 12px; animation: fadeInUp 0.5s ease;">
            <h2 class="section-title">Now Showing</h2>
            <p class="section-subtitle">Choose your movie and book the perfect seat.</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="msg error">⚠ Requested resource not found.</div>
        </c:if>

        <div class="movie-grid">
            <c:forEach var="movie" items="${movies}">
                <div class="movie-card">
                    <c:choose>
                        <c:when test="${not empty movie.imageUrl}">
                            <div class="card-img">
                                <img class="card-img-cover" src="${movie.imageUrl}" alt="${movie.title}" loading="lazy">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-placeholder">🎬</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="movie-info">
                        <h3>${movie.title}</h3>
                        <div class="movie-tags">
                            <span class="tag lang">${movie.language}</span>
                            <span class="tag">⏱ ${movie.duration} min</span>
                        </div>
                        <p class="desc">${movie.description}</p>
                        <a href="/shows?movieId=${movie.id}" class="btn">View Showtimes →</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium · All rights reserved</p>
    </footer>
</body>
</html>
