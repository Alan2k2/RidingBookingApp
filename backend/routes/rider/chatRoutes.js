const express = require('express');
const router = express.Router();

const Ride = require('../../models/Route');
const User = require('../../models/User'); 

// POST: Save a ride request (send location to rider)
router.post('/send-location', async (req, res) => {
  const { riderId, sender, location } = req.body;

  if (!riderId || !sender || !location) {
    console.log("❌ Missing fields", req.body);
    return res.status(400).json({ message: "Missing required fields" });
  }

  try {
    const newRide = new Ride({
      riderId,
      sender,
      location,
      createdAt: new Date()
    });

    await newRide.save(); 

    console.log("✅ Ride saved successfully:", newRide);

    res.status(200).json({ message: "Location sent and saved successfully" });
  } catch (err) {
    console.error("🔥 Server error:", err);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET: Fetch all ride requests for a given rider
router.get('/get-rides/:riderId', async (req, res) => {
  const { riderId } = req.params;

  if (!riderId) {
    return res.status(400).json({ message: 'Rider ID is required' });
  }

  try {
    const rides = await Ride.find({ riderId }).sort({ createdAt: -1 });

    if (!rides || rides.length === 0) {
      return res.status(404).json({ message: 'No rides found for this rider' });
    }

    res.status(200).json(rides);
  } catch (err) {
    console.error('Error fetching rides:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
