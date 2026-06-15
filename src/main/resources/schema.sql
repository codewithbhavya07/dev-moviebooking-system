-- =====================================================
-- Online Movie Booking System - Auto Schema Init
-- Runs on every startup; all statements are idempotent
-- =====================================================

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) DEFAULT 'USER'
);

CREATE TABLE IF NOT EXISTS movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    language VARCHAR(50),
    duration INT COMMENT 'Duration in minutes'
);

CREATE TABLE IF NOT EXISTS show_timings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    screen_name VARCHAR(50),
    price DECIMAL(10,2) DEFAULT 150.00,
    total_rows INT DEFAULT 5,
    total_cols INT DEFAULT 5,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (show_id) REFERENCES show_timings(id) ON DELETE CASCADE,
    UNIQUE(show_id, seat_number)
);

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    show_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (show_id) REFERENCES show_timings(id)
);

CREATE TABLE IF NOT EXISTS booking_seats (
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    PRIMARY KEY (booking_id, seat_id)
);

-- ── Seed Data (INSERT IGNORE = safe to re-run) ──────────────

INSERT IGNORE INTO users (username, password, email, role) VALUES
('admin', 'admin123', 'admin@movietime.com', 'ADMIN'),
('user1', 'user123',  'user1@movietime.com', 'USER');

INSERT IGNORE INTO movies (id, title, description, language, duration) VALUES
(1, 'Inception',    'A thief who steals corporate secrets through the use of dream-sharing technology.', 'English', 148),
(2, 'The Matrix',   'A computer hacker learns from mysterious rebels about the true nature of his reality.', 'English', 136),
(3, 'Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity survival.', 'English', 169);

INSERT IGNORE INTO show_timings (id, movie_id, show_time, screen_name, price, total_rows, total_cols) VALUES
(1, 1, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY) + INTERVAL 10 HOUR, 'Screen 1', 150.00, 5, 5),
(2, 1, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY) + INTERVAL 14 HOUR, 'Screen 1', 150.00, 5, 5),
(3, 2, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY) + INTERVAL 18 HOUR, 'Screen 2', 150.00, 5, 5),
(4, 3, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY) + INTERVAL 20 HOUR, 'Screen 3', 150.00, 5, 5);

INSERT IGNORE INTO seats (show_id, seat_number, is_booked)
SELECT st.id, CONCAT(r.row_name, n.num), FALSE
FROM show_timings st
CROSS JOIN (SELECT 'A' as row_name UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E') r
CROSS JOIN (SELECT 1 as num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n;
