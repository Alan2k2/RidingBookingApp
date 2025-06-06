const mongoose = require('mongoose');

const advertisementSchema = new mongoose.Schema({
  postalCode: String,
  locality: String,
  city: String,
  district: String,
  link: String,
  imageUrl: String,
  status: { type: String, enum: ['active', 'inactive'], default: 'inactive' },
}, { timestamps: true });

module.exports = mongoose.model('Advertisement', advertisementSchema);
