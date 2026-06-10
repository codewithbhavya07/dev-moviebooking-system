<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Show — Admin · MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/admin'">🎬 MovieTime <span style="font-size: 0.7rem; background: var(--primary-dim); color: var(--primary); padding: 3px 10px; border-radius: 999px; border: 1px solid var(--glass-border-s); vertical-align: middle; font-weight: 700; letter-spacing: 1px;">ADMIN</span></h1>
        <nav>
            <a href="/admin">← Dashboard</a>
            <a href="/logout">Logout</a>
        </nav>
    </header>

    <div class="container" style="max-width: 640px; display:flex; flex-direction:column; justify-content:center; min-height: calc(100vh - 140px);">
        <div class="glass-panel" style="max-width: 100%; margin: 0;">
            <h2 style="text-align:left; font-size: 1.6rem;">✏️ Edit Show</h2>
            <p style="color: var(--text-muted); margin-bottom: 28px; font-size: 0.92rem;">
                Editing details for <strong style="color: var(--text-bright);">${show.movie.title}</strong>
            </p>

            <form action="/admin/updateShow" method="post">
                <input type="hidden" name="id" value="${show.id}">

                <label>Movie (Read-Only)</label>
                <input type="text" value="${show.movie.title}" disabled
                    style="opacity: 0.5; cursor: not-allowed;">

                <label>Screen Name</label>
                <input type="text" name="screenName" value="${show.screenName}" required>

                <label>Showtime</label>
                <input type="datetime-local" name="showTime" value="${show.showTime.toString().substring(0,16)}" required>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px;">
                    <div>
                        <label style="color: #94a3b8;">Silver Price (₹)</label>
                        <input type="number" step="0.01" name="silverPrice" value="${show.silverPrice}" required>
                    </div>
                    <div>
                        <label style="color: var(--primary);">Gold Price (₹)</label>
                        <input type="number" step="0.01" name="goldPrice" value="${show.goldPrice}" required>
                    </div>
                    <div>
                        <label style="color: var(--accent-soft);">Platinum Price (₹)</label>
                        <input type="number" step="0.01" name="platinumPrice" value="${show.platinumPrice}" required>
                    </div>
                </div>

                <div style="display: flex; gap: 14px; margin-top: 8px;">
                    <button type="submit" style="flex: 1;">Save Changes</button>
                    <button type="button"
                        onclick="window.location.href='/admin'"
                        style="flex:1; background: transparent; border: 1px solid rgba(244,63,94,0.4); color: #fb7185; font-family: 'Outfit', sans-serif; font-weight: 700; font-size: 0.9rem; padding: 14px; border-radius: var(--radius-sm); cursor: pointer; transition: all var(--transition);"
                        onmouseover="this.style.background='rgba(244,63,94,0.08)'"
                        onmouseout="this.style.background='transparent'">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Admin Panel</p>
    </footer>
</body>
</html>
