const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  category: { type: String, enum: ['User', 'Rider', 'Admin'], required: true },
  phone: { type: String, required: true },
  pincode: { type: String, required: true },
  place: { type: String, required: true },
  isVerified: { type: Boolean, default: false },
  ipAddress: { type: String },
  vehicle: { type: String, default: null },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
