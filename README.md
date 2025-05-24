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


![9](https://github.com/user-attachments/assets/737c43fe-ac1b-4b8e-8e55-bd9e1963f97d)
<img src="https://github.com/user-attachments/assets/737c43fe-ac1b-4b8e-8e55-bd9e1963f97d">
![8](https://github.com/user-attachments/assets/a642c4fd-b7e7-4f9c-8883-f8ab8d21d062)
![7](https://github.com/user-attachments/assets/ff939891-6d0a-4886-960a-ec9929f9de82)
![6](https://github.com/user-attachments/assets/2ff3877b-f752-4715-b913-85c0b99f48d6)
![5](https://github.com/user-attachments/assets/23522bb4-2f63-46bc-822c-ef00432ae165)
![4](https://github.com/user-attachments/assets/9e24d41c-2438-4ca2-85b5-c29c1d686bdb)
![3](https://github.com/user-attachments/assets/5e1074c3-5ca2-4eec-8a9d-fb2a2f6b1b55)
![2](https://github.com/user-attachments/assets/e5e66cd0-a499-43ae-9eea-c3ab30e343a8)
![1](https://github.com/user-attachments/assets/797fb53d-6646-488e-94bb-d2028a66be5b)
![10](https://github.com/user-attachments/assets/1a3bd9e3-663f-4810-8632-46ec588c3ee7)
![11](https://github.com/user-attachments/assets/2f0a9fa3-a7cc-4f75-b997-64c9797754e0)
![12](https://github.com/user-attachments/assets/0a7b2807-41cb-4f54-89ea-91f304ad28d2)


https://github.com/user-attachments/assets/c871bcea-e376-44b7-b44c-4dd69885c20c

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

---

## 📦 Installation

### 🔧 Backend Setup

```bash
cd backend
npm install
cp .env.example .env  # Set your MongoDB URI, JWT secret, and API keys
npm run start


