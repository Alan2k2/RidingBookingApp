const express = require('express');
const router = express.Router();
const Location = require('../../models/Location');

// Helper to get client IP
const getClientIP = (req) => {
  return (
    req.headers['x-forwarded-for']?.split(',')[0] ||
    req.socket?.remoteAddress ||
    req.ip
  );
};

router.post('/', async (req, res) => {
  const { postalCode, locality, city, userId } = req.body;

  if (!postalCode || !locality || !city) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const ipAddress = getClientIP(req);

  try {
    const newLocation = new Location({
      postalCode,
      locality,
      city,
      userId: userId || null,
      ipAddress, 
    });

    await newLocation.save();
    res.status(200).json({ message: 'Location saved successfully' });
  } catch (err) {
    console.error('Error saving location:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
