// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const User = require('../../models/User');

// Example route
router.get('/users', async (req, res) => {
  try {
    const users = await User.find({ category: 'User' });
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router; 
