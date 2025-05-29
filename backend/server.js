const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const path = require('path');
// Importing routes
// Importing routes for admin functionalities
const userRoutes = require('./routes/admin/user-list');
const riderRoutes = require('./routes/admin/rider-list');
const locationRoutes = require('./routes/admin/locationRoutes');
const advertisementRoutes = require('./routes/admin/advertisementRoutes');

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/uploads/adds', express.static(path.join(__dirname, 'uploads/adds')));

app.use('/api/auth', require('./routes/auth'));
app.get('/', (req, res) => res.send('API Running'));

//Admin routes
app.use('/api/admin/user-list', userRoutes);
app.use('/api/admin/rider-list', riderRoutes);
app.use('/api/admin/location', locationRoutes);
app.use('/api/admin/advertisement', advertisementRoutes);

//Rider routes

const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0',() => console.log(`Server running on port ${PORT}`));
