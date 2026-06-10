# 🎬 MovieTime - Online Movie Ticket Booking System

## 📖 Project Overview
MovieTime is a comprehensive web-based Online Movie Ticket Booking System designed and developed as a robust, modern application. Built dynamically using the Java Spring Boot framework, the application empowers end-users to browse upcoming cinema viewings, pick exact seats inside the theater, and securely reserve tickets. 

From an administrative perspective, MovieTime acts as an easy-to-use CMS (Content Management System) that securely handles creating distinct user roles, managing the movie catalog, storing poster images, and scheduling theater showtimes with dynamic seat inventory generation.

---

## ✨ Key Features

### 👤 For Customers (Users)
- **User Authentication:** Secure Sign Up, Login, and Logout functionality.
- **Vibrant UI Catalog:** Browse a visually appealing grid of "Now Showing" and "Coming Soon" movies, complete with dynamic cinematic posters.
- **Showtime Selection:** Users can select a specific movie and pick from available movie timings mapped to various physical theater screens.
- **Interactive Seat Selection:** An interactive UI that lets users visually choose available seats inside the theater room. Seats already booked by others are blocked in real-time.
- **Booking & Tickets:** A seamless booking confirmation page that generates a detailed digital event ticket showing the Movie Name, Screen Room, Seat Numbers, Timings, and the total cost.
- **Booking History:** Users can visit a dynamic "My Tickets" dashboard to review all past digital invoices and seat bookings tied to their account.

### 👑 For Administrators (Management)
- **Role-Based Security:** Specialized "Admin Dashboard" route restricted specifically to users holding the high-privileged `ADMIN` role logic state. 
- **Movie Catalog Manager:** An interface providing total CRUD (Create, Read, Update, Delete) controls to manipulate which movies exist on the platform. Admins can update a movie's Title, Duration, Description, and even assign direct URLs for custom Movie Posters without ever touching the SQL database manually.
- **Showtime Generator:** Specialized input form to create real-world theater timings. Admins can select an active movie, set the time, ticket price, and assign the size of the room (number of rows & columns). **Once scheduled, the system automatically runs batch SQL insert statements to physically map out and populate the database with correct seat coordinates (e.g., A1, B4) instantly.**

---

## 🛠 Technology Stack

### Backend & Frameworks
- **Java 17:** The core programming language powering the application logic.
- **Spring Boot (v3.1.5):** The robust framework scaffolding the web application. Used explicitly for routing inputs, handling HTTP Controller Mappings, and embedding a live functional server instance.
- **Embedded Apache Tomcat:** Handled natively by Spring Boot to run the application server seamlessly on port 8080 without requiring the user to download an external hosting application.
- **JDBC (Java Database Connectivity):** Using robust Data Access Object (DAO) patterns equipped with secure `PreparedStatement` models to map backend operations to MySQL safely.

### Frontend
- **Jasper / JSP (JavaServer Pages):** Renders server-side HTML equipped with dynamic JSTL `<c:forEach>` logic to inject live Java data components cleanly into the frontend.
- **HTML5 & Vanilla CSS3:** Employing complex modern styling like Glassmorphism (translucency and blurs), Flexbox, CSS Grid layouts, and custom web kit animations (like `fadeInSlideUp`) to elevate standard components into a premium, cinematic user experience.

### Database
- **MySQL:** The relational database system utilizing heavily normalized structures to persist Users, Roles, Movies, Show Timings, Bookings, and Individual Seats simultaneously across mapping tables.

---

## 🗄️ Database Architecture

The application scales efficiently by strictly preserving data relations. The schema is comprised of following core relational entities:

- `users`: Tracks User accounts, passwords, emails, and their role status.
- `movies`: Source of truth for all current movies and media links.
- `show_timings`: Bridges real-world screenings to `movies`.
- `seats`: Uniquely generated coordinates specific to an exact `show_timing`. It holds an `is_booked` boolean that changes from False to True the moment a transaction resolves.
- `bookings`: Associates a `user_id` to an aggregate purchase transaction.
- `booking_seats`: The junction table connecting independent `seat` IDs to a singular `booking` invoice transaction.

*(If a showtime is cancelled by an Administrator, cascading foreign keys automatically flush the associated tickets and seats downstream entirely!)*

---

## 🚀 How to Run the Project Locally

1. **Setup MySQL:** Look inside the `database.sql` script at the root directory and evaluate it within your MySQL workbench. It handles provisioning the databases, generating identical schema tables, inserting test movie records, configuring the first showtime batch, and populating dummy User roles.

2. **Configure Spring Boot Application Settings:** Insure that inside the file `src/main/resources/application.properties`, the `spring.datasource` credentials (specifically `username` and `password`) line up cleanly with your local MySQL configurations.

3. **Build & Run via Maven:** This project utilizes Maven as a dependency and build management system. Navigate to the project root in your terminal and execute:
   ```bash
   mvn clean spring-boot:run
   ```
4. **Access the App:** 
   Once the console outputs that the Apache Tomcat server has initialized onto port 8080, launch a web browser and travel to: `http://localhost:8080`.

---

## 🔑 Default Credentials

- **Example End-User Login:** 
  - Username: `user1`
  - Password: `user123`
- **Example Admin Login:** 
  - Username: `admin`
  - Password: `admin123`
*(As provided initialized by the `database.sql` setup scripts!)*
