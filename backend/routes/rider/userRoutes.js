// routes/userRoutes.js or similar
const express = require('express');
const router = express.Router();
const User = require('../../models/User');

// Middleware to get IP address from request
function getIp(req) {
  const forwarded = req.headers['x-forwarded-for'];
  return forwarded ? forwarded.split(',')[0] : req.socket.remoteAddress;
}

// GET user by request IP
router.get('/', async (req, res) => {
  try {
    const ip = getIp(req);
    console.log('Request IP:', ip);
    if (!ip) {
      return res.status(400).json({ message: 'IP address not found' });
    }
    const user = await User.findOne({ ipAddress: ip, category: 'User' });

    if (!user) {
      return res.status(404).json({ message: 'User not found for this IP' });
    }

    res.status(200).json({
      username: user.username,
      phone: user.phone,
      ip: user.ipAddress,
    });
  } catch (err) {
    console.error('Error fetching user by IP:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
