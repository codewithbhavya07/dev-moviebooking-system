<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .auth-page {
            min-height: calc(100vh - 70px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
        }
        .auth-layout {
            display: flex;
            gap: 72px;
            align-items: center;
            max-width: 1100px;
            width: 100%;
            animation: fadeInUp 0.7s ease;
        }
        .auth-promo {
            flex: 1.3;
            min-width: 0;
        }
        .auth-promo h2 {
            font-size: 3rem;
            font-weight: 900;
            color: var(--text-bright);
            letter-spacing: -2px;
            line-height: 1.1;
            margin-bottom: 14px;
        }
        .auth-promo h2 span {
            background: linear-gradient(135deg, var(--primary), var(--accent-soft));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .auth-promo p {
            color: var(--text-muted);
            font-size: 1.05rem;
            line-height: 1.7;
            margin-bottom: 40px;
            max-width: 420px;
        }
        .poster-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }
        .poster-card {
            aspect-ratio: 2/3;
            border-radius: 14px;
            overflow: hidden;
            border: 1px solid var(--glass-border);
            box-shadow: 0 12px 30px rgba(0,0,0,0.5);
            transition: transform 0.4s var(--transition-spring), box-shadow 0.4s ease;
            background: var(--bg-elevated);
            position: relative;
        }
        .poster-card img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
        }
        .poster-card:hover {
            transform: translateY(-14px) scale(1.04);
            box-shadow: 0 24px 50px rgba(0,0,0,0.7), 0 0 30px var(--primary-glow);
            border-color: var(--glass-border-s);
            z-index: 2;
        }
        .poster-card:nth-child(2) { margin-top: 24px; }
        .auth-form-col {
            flex: 1;
            min-width: 340px;
            max-width: 440px;
        }
        @media (max-width: 860px) {
            .auth-layout { flex-direction: column; gap: 40px; }
            .auth-promo h2 { font-size: 2.2rem; }
            .auth-form-col { max-width: 100%; min-width: 0; width: 100%; }
            .poster-grid { grid-template-columns: repeat(3, 1fr); }
        }
    </style>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/'">🎬 MovieTime</h1>
        <nav>
            <a href="/register">Register</a>
        </nav>
    </header>

    <div class="auth-page">
        <div class="auth-layout">

            <!-- Left: Promo -->
            <div class="auth-promo">
                <h2>Your Cinema,<br><span>Your Way.</span></h2>
                <p>Book tickets for the biggest blockbusters in seconds. Interactive seat selection, instant confirmation, and no queues.</p>
                <div class="poster-grid">
                    <div class="poster-card">
                        <img src="/images/avengers.jpg" alt="Movie Poster" onerror="this.parentElement.style.background='var(--bg-elevated)'">
                    </div>
                    <div class="poster-card">
                        <img src="/images/supergirl.jpg" alt="Movie Poster" onerror="this.parentElement.style.background='var(--bg-elevated)'">
                    </div>
                    <div class="poster-card">
                        <img src="/images/dhurandhar.jpg" alt="Movie Poster" onerror="this.parentElement.style.background='var(--bg-elevated)'">
                    </div>
                </div>
            </div>

            <!-- Right: Login Form -->
            <div class="auth-form-col">
                <div class="glass-panel" style="margin: 0; max-width: 100%;">
                    <h2>Welcome Back 👋</h2>

                    <% if (request.getParameter("logout") != null) { %>
                        <div class="msg success">✓ You've been successfully logged out.</div>
                    <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="msg error">⚠ <%= request.getAttribute("error") %></div>
                    <% } %>
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="msg success">✓ <%= request.getAttribute("success") %></div>
                    <% } %>

                    <form action="/login" method="post">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" placeholder="Enter your username" required autocomplete="username">

                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">

                        <button type="submit" style="margin-top: 4px;">Sign In →</button>
                    </form>

                    <div class="auth-links">
                        <a href="/register">New to MovieTime? Create an account</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <footer>
        <p>© 2026 MovieTime Premium</p>
    </footer>
</body>
</html>
