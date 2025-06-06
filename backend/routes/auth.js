const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();
const User = require('../models/User');
require('dotenv').config();

// Helper to extract client IP
const getClientIP = (req) => {
  return (
    req.headers['x-forwarded-for']?.split(',')[0] ||
    req.socket?.remoteAddress ||
    req.ip
  );
};

// ✅ Register
router.post('/register', async (req, res) => {
  const { username, password, category, phone, pincode, place, vehicle } = req.body;
  const ipAddress = getClientIP(req);

  if (category === "Rider" && !vehicle) {
    return res.status(400).json({ message: "Vehicle is required for Rider category." });
  }

  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'Username already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({
      username,
      password: hashedPassword,
      category,
      phone,
      pincode,
      place,
      vehicle: category === "Rider" ? vehicle : undefined,
      ipAddress, // Store IP
    });

    await newUser.save();
    res.status(201).json({ message: 'User registered successfully' });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// ✅ Login
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const ipAddress = getClientIP(req);

  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Optional: update IP address on login
    user.ipAddress = ipAddress;
    await user.save();

    const token = jwt.sign(
      { id: user._id, category: user.category },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.status(200).json({
      token,
      username: user.username,
      category: user.category,
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Logout Route
/**
 * @route   POST /api/auth/logout
 * @desc    Logs out user by instructing client to delete token
 * @access  Public
 */
router.post('/logout', (_req, res) => {
  // No server-side token invalidation because JWT is stateless
  res.status(200).json({
    success: true,
    message: 'Logout successful. Please remove the token on the client side.',
  });
});

module.exports = router;