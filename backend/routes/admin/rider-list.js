// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const User = require('../../models/User');

// Example route
router.get('/riders', async (req, res) => {
  try {
    const riders = await User.find({ category: 'Rider' });
    res.json(riders);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
});

router.patch('/verify-rider/:id', async (req, res) => {
    const userId = req.params.id;
    const { isVerified } = req.body;
  
    if (typeof isVerified !== 'boolean') {
      return res.status(400).json({ error: 'isVerified must be a boolean' });
    }
  
    try {
      const user = await User.findById(userId);
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      if (user.category !== 'Rider') {
        return res.status(400).json({ error: 'User is not a rider' });
      }
  
      user.isVerified = isVerified;
      await user.save();
  
      res.status(200).json({ message: 'Verification status updated', user });
    } catch (err) {
      console.error('Error updating verification status:', err);
      res.status(500).json({ error: 'Server error' });
    }
});


module.exports = router; 
