<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — MovieTime</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 36px;
            animation: fadeInUp 0.5s ease;
        }
        @media (max-width: 900px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 500px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
        }
        .stat-tile {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 24px 20px;
            text-align: center;
            transition: all var(--transition);
            position: relative;
            overflow: hidden;
        }
        .stat-tile::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            border-radius: var(--radius-md) var(--radius-md) 0 0;
        }
        .stat-tile.green::before { background: linear-gradient(90deg, #10b981, #34d399); }
        .stat-tile.gold::before  { background: linear-gradient(90deg, var(--primary), #f5d678); }
        .stat-tile.blue::before  { background: linear-gradient(90deg, #3b82f6, #93c5fd); }
        .stat-tile.red::before   { background: linear-gradient(90deg, #f43f5e, #fb7185); }
        .stat-tile:hover { background: var(--glass-bg-hover); border-color: var(--glass-border-s); transform: translateY(-3px); }
        .stat-tile .tile-label {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--text-muted);
            margin-bottom: 12px;
        }
        .stat-tile .tile-value {
            font-size: 2.2rem;
            font-weight: 900;
            color: var(--text-bright);
            line-height: 1;
        }
        .stat-tile.green .tile-value { color: #34d399; }
        .stat-tile.gold  .tile-value { color: var(--primary); }
        .stat-tile.blue  .tile-value { color: #93c5fd; }
        .stat-tile.red   .tile-value { color: #fb7185; font-size: 1.5rem; }

        .forms-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 28px;
            margin-bottom: 36px;
        }
        @media (max-width: 860px) { .forms-row { grid-template-columns: 1fr; } }

        .admin-form-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            animation: fadeInUp 0.5s ease both;
            position: relative;
            overflow: hidden;
        }
        .admin-form-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent), var(--primary));
            opacity: 0.7;
        }
        .admin-form-card h2 {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-bright);
            margin-bottom: 24px;
        }
        .admin-form-card form { gap: 0; }
        .admin-form-card form button {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-soft) 100%);
            color: white;
            margin-top: 4px;
        }
        .admin-form-card form button:hover {
            background: linear-gradient(135deg, var(--accent-soft) 0%, var(--accent) 100%);
        }

        .seat-grid-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 16px;
        }

        .admin-table-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 28px;
            animation: fadeInUp 0.5s 0.1s ease both;
            overflow: hidden;
        }
        .admin-table-card h2 {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-bright);
            margin-bottom: 22px;
        }
        .admin-table-card table {
            margin-top: 0;
            border-spacing: 0;
        }
        .admin-table-card th, .admin-table-card td {
            padding: 12px 14px;
        }
        .admin-table-card thead tr {
            border-bottom: 1px solid var(--glass-border);
        }
        .admin-table-card thead th {
            background: none;
        }
        .admin-table-card tbody td {
            background: none;
            border: none;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .admin-table-card tbody td:first-child { border-radius: 0; border-left: none; }
        .admin-table-card tbody td:last-child  { border-radius: 0; border-right: none; }
        .admin-table-card tbody tr:hover td { background: var(--glass-bg-hover); }
        .admin-table-card input[type="text"],
        .admin-table-card input[type="number"] {
            width: 100%;
            padding: 8px 12px;
            margin-bottom: 0;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
        }
        .admin-table-card .action-cell {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .btn-edit {
            padding: 8px 16px;
            font-size: 0.78rem;
            background: linear-gradient(135deg, #3b82f6, #6366f1) !important;
            color: white !important;
            border-radius: var(--radius-sm) !important;
        }
        .btn-delete {
            padding: 8px 16px;
            font-size: 0.78rem;
            background: transparent !important;
            border: 1px solid rgba(244,63,94,0.4) !important;
            color: #fb7185 !important;
            border-radius: var(--radius-sm) !important;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            font-weight: 700;
            transition: all var(--transition);
        }
        .btn-delete:hover {
            background: rgba(244,63,94,0.1) !important;
            border-color: #f43f5e !important;
            transform: none !important;
            box-shadow: none !important;
        }
        .btn-update {
            padding: 8px 16px;
            font-size: 0.78rem;
            background: var(--success-dim) !important;
            border: 1px solid rgba(16,185,129,0.3) !important;
            color: #34d399 !important;
            border-radius: var(--radius-sm) !important;
        }
    </style>
</head>
<body>
    <header>
        <h1 onclick="window.location.href='/movies'">🎬 MovieTime <span style="font-size: 0.7rem; background: var(--primary-dim); color: var(--primary); padding: 3px 10px; border-radius: 999px; border: 1px solid var(--glass-border-s); vertical-align: middle; font-weight: 700; letter-spacing: 1px;">ADMIN</span></h1>
        <nav>
            <a href="/movies">Exit Admin</a>
            <a href="/logout">Logout</a>
        </nav>
    </header>

    <div class="container">

        <!-- Alerts -->
        <% if (request.getParameter("success") != null) { %>
            <div class="msg success">✓ <%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="msg error">⚠ <%= request.getParameter("error") %></div>
        <% } %>

        <!-- Page title -->
        <div style="margin-bottom: 28px; animation: fadeInUp 0.4s ease;">
            <h2 class="section-title">Admin Dashboard</h2>
            <p class="section-subtitle">Manage movies, showtimes, and monitor analytics.</p>
        </div>

        <!-- Stats -->
        <div class="stats-row">
            <div class="stat-tile green">
                <div class="tile-label">Total Bookings</div>
                <div class="tile-value">${totalBookings}</div>
            </div>
            <div class="stat-tile gold">
                <div class="tile-label">Total Revenue</div>
                <div class="tile-value">₹${totalRevenue}</div>
            </div>
            <div class="stat-tile blue">
                <div class="tile-label">Total Users</div>
                <div class="tile-value">${totalUsers}</div>
            </div>
            <div class="stat-tile red">
                <div class="tile-label">Top Movie</div>
                <div class="tile-value">${mostPopularMovie}</div>
            </div>
        </div>

        <!-- Add Movie + Add Show forms -->
        <div class="forms-row">

            <!-- Add Movie -->
            <div class="admin-form-card">
                <h2>🎬 Add New Movie</h2>
                <form action="/admin/addMovie" method="post">
                    <label>Movie Title</label>
                    <input type="text" name="title" placeholder="e.g., Inception" required>

                    <label>Description</label>
                    <input type="text" name="description" placeholder="Short synopsis..." required>

                    <label>Language</label>
                    <input type="text" name="language" placeholder="e.g., English" required>

                    <label>Duration (minutes)</label>
                    <input type="number" name="duration" placeholder="e.g., 148" required>

                    <label>Poster Image URL</label>
                    <input type="text" name="imageUrl" placeholder="https://...poster.jpg">

                    <button type="submit">+ Save Movie</button>
                </form>
            </div>

            <!-- Schedule Show -->
            <div class="admin-form-card" style="animation-delay: 0.1s;">
                <h2>📅 Schedule New Show</h2>
                <form action="/admin/addShow" method="post">
                    <label>Select Movie</label>
                    <select name="movieId" required>
                        <c:forEach var="movie" items="${movies}">
                            <option value="${movie.id}">${movie.title}</option>
                        </c:forEach>
                    </select>

                    <label>Screen Name</label>
                    <input type="text" name="screenName" placeholder="e.g., Screen 1" required>

                    <label>Showtime</label>
                    <input type="datetime-local" name="showTime" required>

                    <div class="seat-grid-inputs">
                        <div>
                            <label style="color: #94a3b8;">Silver Rows</label>
                            <input type="number" name="silverRows" value="3" required>
                        </div>
                        <div>
                            <label style="color: #94a3b8;">Silver Price (₹)</label>
                            <input type="number" step="0.01" name="silverPrice" value="150.00" required>
                        </div>
                        <div>
                            <label style="color: var(--primary);">Gold Rows</label>
                            <input type="number" name="goldRows" value="3" required>
                        </div>
                        <div>
                            <label style="color: var(--primary);">Gold Price (₹)</label>
                            <input type="number" step="0.01" name="goldPrice" value="250.00" required>
                        </div>
                        <div>
                            <label style="color: var(--accent-soft);">Platinum Rows</label>
                            <input type="number" name="platinumRows" value="2" required>
                        </div>
                        <div>
                            <label style="color: var(--accent-soft);">Platinum Price (₹)</label>
                            <input type="number" step="0.01" name="platinumPrice" value="350.00" required>
                        </div>
                    </div>

                    <label>Seats per Row (Columns)</label>
                    <input type="number" name="columns" value="10" required>

                    <button type="submit">⚡ Schedule &amp; Generate Seats</button>
                </form>
            </div>
        </div>

        <!-- Manage Shows Table -->
        <div class="admin-table-card">
            <h2>🎟 Manage Existing Shows</h2>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Movie</th>
                            <th>Screen</th>
                            <th>Showtime</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="show" items="${shows}">
                            <tr>
                                <td style="color: var(--text-muted); font-weight: 700;">#${show.id}</td>
                                <td style="font-weight: 700; color: var(--text-bright);">${show.movie.title}</td>
                                <td>${show.screenName}</td>
                                <td>${show.showTime}</td>
                                <td style="color: var(--primary); font-weight: 800;">₹${show.ticketPrice}</td>
                                <td>
                                    <div class="action-cell">
                                        <button type="button" class="btn btn-edit" onclick="window.location.href='/admin/editShow?showId=${show.id}'">Edit</button>
                                        <form action="/admin/deleteShow" method="post" onsubmit="return confirm('Delete this show? All bookings will also be removed.');" style="display:contents;">
                                            <input type="hidden" name="id" value="${show.id}">
                                            <button type="submit" class="btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Manage Movies Table -->
        <div class="admin-table-card" style="animation-delay: 0.15s;">
            <h2>🛠 Manage Existing Movies</h2>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Poster URL</th>
                            <th>Language</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="movie" items="${movies}">
                            <tr>
                                <form action="/admin/updateMovie" method="post">
                                    <td style="color: var(--text-muted); font-weight:700;">${movie.id}<input type="hidden" name="id" value="${movie.id}"></td>
                                    <td><input type="text" name="title" value="${movie.title}" required><input type="hidden" name="description" value="${movie.description}"></td>
                                    <td><input type="text" name="imageUrl" value="${movie.imageUrl}" placeholder="Image URL"></td>
                                    <td><input type="text" name="language" value="${movie.language}" required></td>
                                    <td><input type="number" name="duration" value="${movie.duration}" required style="width:80px;"> min</td>
                                    <td>
                                        <div class="action-cell">
                                            <button type="submit" class="btn btn-update">Update</button>
                                </form>
                                        <form action="/admin/deleteMovie" method="post" onsubmit="return confirm('Delete this movie? All shows will be removed too.');" style="display:contents;">
                                            <input type="hidden" name="id" value="${movie.id}">
                                            <button type="submit" class="btn-delete">Delete</button>
                                        </form>
                                        </div>
                                    </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <footer>
        <p>© 2026 MovieTime Admin Panel</p>
    </footer>
</body>
</html>
