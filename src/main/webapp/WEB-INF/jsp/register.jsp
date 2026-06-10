<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .register-page {
            min-height: calc(100vh - 70px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
        }
        .register-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 24px;
            width: 100%;
        }
        .register-perks {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: center;
            max-width: 500px;
        }
        .perk-chip {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            padding: 10px 18px;
            border-radius: var(--radius-pill);
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 7px;
        }
        .perk-chip span { color: var(--primary); font-size: 1rem; }
    </style>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/'">🎬 MovieTime</h1>
        <nav>
            <a href="/login">Login</a>
        </nav>
    </header>

    <div class="register-page">
        <div class="register-wrapper">
            <div style="text-align:center; animation: fadeInUp 0.5s ease;">
                <h2 style="font-size: 2rem; font-weight: 900; color: var(--text-bright); margin-bottom: 8px;">Join MovieTime Free</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Create your account and start booking in minutes.</p>
            </div>

            <div class="register-perks" style="animation: fadeInUp 0.6s 0.1s ease both;">
                <div class="perk-chip"><span>🎬</span> 50+ Movies</div>
                <div class="perk-chip"><span>💺</span> Seat Selection</div>
                <div class="perk-chip"><span>⚡</span> Instant Booking</div>
                <div class="perk-chip"><span>🎟️</span> Digital Tickets</div>
            </div>

            <div class="glass-panel" style="animation-delay: 0.2s;">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="msg error">⚠ <%= request.getAttribute("error") %></div>
                <% } %>

                <form action="/register" method="post">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Choose a username" required autocomplete="username">

                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="you@example.com" required autocomplete="email">

                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Create a strong password" required autocomplete="new-password">

                    <button type="submit" style="margin-top: 4px;">Create My Account →</button>
                </form>

                <div class="auth-links">
                    <a href="/login">Already have an account? Sign In</a>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
