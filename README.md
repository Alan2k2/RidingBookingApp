# 🚖 Nubicus Ride – Uber-like Ride-Hailing App

### 📱 A Smart and Scalable Ride Booking App – Version 1.0

**Developed by:** Alan Shaju  
**Commissioned by:** Nubicus Consultancy  
**Release Date:** May 22, 2025

---

## 📝 Description

**Nubicus Ride** is a modern ride-hailing application designed to offer seamless and reliable transportation, similar to Uber. Built with **Flutter** for the frontend and powered by **Node.js (Express)** and **MongoDB**, this app connects users with drivers in real-time. The integration of **Google Maps APIs** ensures accurate location tracking, route optimization, and map-based ride selection.

This is the **initial production release (v1.0)** and serves as a strong foundation for future feature enhancements.

---

## 🚀 Features

- **User Registration & Authentication**
  - Secure login and signup for passengers and drivers
  - JWT-based token authentication

- **Real-time Ride Booking**
  - Book rides with live location and estimated fare
  - Google Maps for pickup & drop location selection

- **Live Driver Tracking**
  - Real-time driver location updates via GPS
  - Trip progress tracking

- **In-App Communication**
  - Chat or call between user and driver

- **Payments Integration**
  - Cash and card payment options (wallet integration in progress)

- **Ride History & Profiles**
  - Trip history with fare details
  - Profile management for users and drivers

---

## ⚙️ Tech Stack

### Frontend:
- **Flutter**
  - Material Design UI
  - State management (Provider/Bloc – based on your choice)
  - Integration with REST APIs

### Backend:
- **Node.js + Express**
  - RESTful API architecture
  - JWT Authentication
  - Real-time communication (Socket.io – if implemented)

### Database:
- **MongoDB**
  - NoSQL schema for user and ride data
  - Mongoose ODM for data modeling

### Maps & Tracking:
- **Google Maps API**
  - Geolocation services
  - Route calculation and ETA
  - Live location updates

---

## 📂 Project Structure
/nubicus-ride-app/
├── frontend/ # Flutter App Code
├── backend/ # Node.js API
│ ├── controllers/
│ ├── models/
│ ├── routes/
│ ├── utils/
│ └── config/
└── README.md


---

## 📦 Installation

### 🔧 Backend Setup

```bash
cd backend
npm install
cp .env.example .env  # Set your MongoDB URI, JWT secret, and API keys
npm run start


📱 Frontend Setup
cd frontend
flutter pub get
flutter run

🛡 Security
HTTPS-ready API

JWT Authentication for users and drivers

CORS and request validation implemented

🧭 Roadmap
Wallet system with in-app payments

Admin Dashboard for Ride Management

Notifications via Firebase

Ride-sharing (pool) feature

🤝 Contribution
This project is currently maintained privately for Nubicus Consultancy. Contributions are restricted to authorized developers.

📬 Contact
Developer: Alan Shaju
Email: [alanshaju26@gmail.com][alanshaju@cybersecurityspecialist.in]
GitHub: github.com/Alan2k2
