const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');

const userRoutes = require('./routes/admin/user-list');
const riderRoutes = require('./routes/admin/rider-list');
const locationRoutes = require('./routes/admin/locationRoutes');

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/auth', require('./routes/auth'));
app.get('/', (req, res) => res.send('API Running'));

//Admin routes
app.use('/api/admin/user-list', userRoutes);
app.use('/api/admin/rider-list', riderRoutes);
app.use('/api/admin/location', locationRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
