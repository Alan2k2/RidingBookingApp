// models/Location.js
const mongoose = require('mongoose');

const LocationSchema = new mongoose.Schema({
  postalCode: {
    type: String,
    required: true,
  },
  locality: String,
  city: String,
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  ipAddress: { 
    type: String, 
    unique: true, 
  },
});

module.exports = mongoose.model('Location', LocationSchema);
