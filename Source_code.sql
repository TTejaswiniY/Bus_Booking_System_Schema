-- Create schema
DROP SCHEMA IF EXISTS bus_booking;
CREATE SCHEMA bus_booking;
USE bus_booking;

-- Users Table (Passengers)
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    gender ENUM('Male','Female','Other'),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bus Table
DROP TABLE IF EXISTS bus;
CREATE TABLE bus (
    bus_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_number VARCHAR(20) UNIQUE NOT NULL,
    bus_type ENUM('AC','Non-AC','Sleeper','Seater','Volvo') NOT NULL,
    capacity INT NOT NULL,
    operator_name VARCHAR(50) NOT NULL
);

-- Route Table
DROP TABLE IF EXISTS route;
CREATE TABLE route (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    distance_km INT NOT NULL
);

-- Trip Table (A bus running on a route at a time)
DROP TABLE IF EXISTS trip;
CREATE TABLE trip (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_id INT NOT NULL,
    route_id INT NOT NULL,
    departure_date DATE NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES bus(bus_id),
    FOREIGN KEY (route_id) REFERENCES route(route_id)
);

-- Seat Table
DROP TABLE IF EXISTS seat;
CREATE TABLE seat (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_type ENUM('Regular','Sleeper','Luxury') DEFAULT 'Regular',
    FOREIGN KEY (bus_id) REFERENCES bus(bus_id),
    UNIQUE(bus_id, seat_number)
);

-- Booking Table
DROP TABLE IF EXISTS booking;
CREATE TABLE booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    trip_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Booked','Cancelled') DEFAULT 'Booked',
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (trip_id) REFERENCES trip(trip_id)
);

-- Booking Seats (Which seat is reserved in a booking)
DROP TABLE IF EXISTS booking_seat;
CREATE TABLE booking_seat (
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    PRIMARY KEY (booking_id, seat_id),
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
    FOREIGN KEY (seat_id) REFERENCES seat(seat_id)
);

-- Payments Table
DROP TABLE IF EXISTS payment;
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('Credit Card','Debit Card','UPI','Net Banking') NOT NULL,
    status ENUM('Success','Failed','Pending') DEFAULT 'Success',
    paid_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);
