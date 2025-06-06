const express = require('express');
const multer = require('multer');
const path = require('path');
const Advertisement = require('../../models/Advertisement');

const router = express.Router();

// Multer config
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/adds'),
  filename: (req, file, cb) =>
    cb(null, `${Date.now()}-${file.originalname}`),
});

const upload = multer({ storage });

// ✅ Create Ad
router.post('/', upload.single('image'), async (req, res) => {
  try {
    const { postalCode, locality, city, district, link } = req.body;
<<<<<<< HEAD
    const imageUrl = req.file ? `uploads/adds/${req.file.filename}` : '';
=======
    const imageUrl = req.file ? `uploads/adds${req.file.filename}` : '';
>>>>>>> d6c202511764f4f0d5676b9567822feec8dd93a8
    const ad = await Advertisement.create({ postalCode, locality, city, district, link, imageUrl });
    res.status(200).json({ success: true, data: ad });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 🗑️ Delete Ad
router.delete('/:id', async (req, res) => {
  try {
    await Advertisement.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'Deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✏️ Update Ad
router.put('/:id', upload.single('image'), async (req, res) => {
  try {
    const { postalCode, locality, city, district, link } = req.body;
    const updateData = { postalCode, locality, city, district, link };
    if (req.file) {
      updateData.imageUrl = `/uploads/${req.file.filename}`;
    }

    const updatedAd = await Advertisement.findByIdAndUpdate(req.params.id, updateData, { new: true });
    res.status(200).json({ success: true, data: updatedAd });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 🔁 Update Status
router.patch('/:id/status', async (req, res) => {
  try {
    const { status } = req.body; // active/inactive
    const updated = await Advertisement.findByIdAndUpdate(req.params.id, { status }, { new: true });
    res.status(200).json({ success: true, data: updated });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📄 Get All Ads (optional)
router.get('/', async (req, res) => {
  try {
    const ads = await Advertisement.find().sort({ createdAt: -1 });
    res.status(200).json(ads);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
