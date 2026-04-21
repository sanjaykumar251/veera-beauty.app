const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Service name is required'],
    trim: true,
  },
  category: {
    type: String,
    required: true,
    enum: ['hair', 'skin', 'grooming', 'makeup', 'mehendi', 'tattoo', 'saree_draping', 'bridal', 'other'],
  },
  description: {
    type: String,
    trim: true,
  },
  duration: {
    type: Number,
    default: 60,
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: 0,
  },
  discountedPrice: {
    type: Number,
    default: null,
  },
  image: {
    type: String,
    default: null,
  },
  isAvailable: {
    type: Boolean,
    default: true,
  },
  isBridalService: {
    type: Boolean,
    default: false,
  },
  sortOrder: {
    type: Number,
    default: 0,
  },
}, { timestamps: true });

serviceSchema.statics.seedData = async function () {
  const services = [
    { name: 'Haircut & Style (Ladies)', category: 'hair', price: 299, duration: 45, description: 'Professional haircut with styling and blow dry', sortOrder: 1 },
    { name: 'Haircut (Gents)', category: 'hair', price: 149, duration: 30, description: 'Clean modern haircut for men', sortOrder: 2 },
    { name: 'Hair Colour (Global)', category: 'hair', price: 999, duration: 120, description: 'Full head global colour with premium dye', sortOrder: 3 },
    { name: 'Hair Colour (Highlights)', category: 'hair', price: 1499, duration: 150, description: 'Highlights and lowlights for dimension', sortOrder: 4 },
    { name: 'Hair Cut & Colour Combo', category: 'hair', price: 1799, duration: 150, description: 'Hair cut with colour refresh and finishing', sortOrder: 5 },
    { name: 'Hair Style', category: 'hair', price: 799, duration: 60, description: 'Soft curls, buns and event-ready styling', sortOrder: 6 },
    { name: 'Hair Spa', category: 'hair', price: 699, duration: 60, description: 'Deep conditioning hair spa treatment', sortOrder: 7 },
    { name: 'Keratin Treatment', category: 'hair', price: 2999, duration: 180, description: 'Smoothening and anti-frizz keratin treatment', sortOrder: 8 },
    { name: 'Basic Facial', category: 'skin', price: 499, duration: 60, description: 'Deep cleansing facial for glowing skin', sortOrder: 9 },
    { name: 'Gold Facial', category: 'skin', price: 999, duration: 75, description: 'Luxury gold facial for radiant skin', sortOrder: 10 },
    { name: 'Advance Treatment Facial', category: 'skin', price: 1999, duration: 90, description: 'Premium skin treatment facial for special care', sortOrder: 11 },
    { name: 'Dtan Cleanup', category: 'skin', price: 349, duration: 45, description: 'Removes tan and brightens skin tone', sortOrder: 12 },
    { name: 'Threading (Eyebrows)', category: 'skin', price: 50, duration: 10, description: 'Precise eyebrow shaping via threading', sortOrder: 13 },
    { name: 'Waxing (Full Arms & Legs)', category: 'skin', price: 699, duration: 60, description: 'Full arms and legs waxing', sortOrder: 14 },
    { name: 'Normal Makeup', category: 'makeup', price: 1499, duration: 75, description: 'Simple and elegant makeup for everyday functions', sortOrder: 15 },
    { name: 'Puberty Makeup', category: 'makeup', price: 2499, duration: 120, description: 'Soft makeup styling for puberty function events', sortOrder: 16 },
    { name: 'Baby Shower Makeup', category: 'makeup', price: 2999, duration: 120, description: 'Fresh and radiant look for baby shower celebrations', sortOrder: 17 },
    { name: 'Party Makeup', category: 'makeup', price: 1499, duration: 90, description: 'Glamorous party-ready makeup look', sortOrder: 18 },
    { name: 'Outdoor Shoot Makeup', category: 'makeup', price: 3499, duration: 120, description: 'Photo-friendly makeup for outdoor shoots', sortOrder: 19 },
    { name: 'Muhoortham Makeup', category: 'bridal', price: 5999, duration: 150, description: 'Traditional wedding morning makeup look', isBridalService: true, sortOrder: 20 },
    { name: 'Christian Wedding Makeup', category: 'bridal', price: 6999, duration: 150, description: 'Elegant bridal styling for Christian weddings', isBridalService: true, sortOrder: 21 },
    { name: 'Semi HD Makeup', category: 'makeup', price: 3999, duration: 120, description: 'Smooth semi HD makeup for events and functions', sortOrder: 22 },
    { name: 'HD Makeup', category: 'makeup', price: 4999, duration: 140, description: 'Camera-friendly HD makeup finish', sortOrder: 23 },
    { name: 'Ultra HD Makeup', category: 'makeup', price: 6999, duration: 150, description: 'High-definition premium studio look', sortOrder: 24 },
    { name: 'Water Proof Makeup', category: 'makeup', price: 5499, duration: 140, description: 'Long-wear waterproof makeup for extended events', sortOrder: 25 },
    { name: 'Sweat Proof Makeup', category: 'makeup', price: 5499, duration: 140, description: 'Sweat-resistant makeup for outdoor and summer events', sortOrder: 26 },
    { name: 'Air Brush Makeup', category: 'makeup', price: 7999, duration: 150, description: 'Air brush finish with premium flawless coverage', sortOrder: 27 },
    { name: 'Engagement Makeup', category: 'bridal', price: 3999, duration: 120, description: 'Elegant look for your engagement day', isBridalService: true, sortOrder: 28 },
    { name: 'Bridal Makeup', category: 'bridal', price: 8999, duration: 180, description: 'Complete bridal makeup and hairstyle', isBridalService: true, sortOrder: 29 },
    { name: 'HD Bridal Makeup', category: 'bridal', price: 14999, duration: 210, description: 'Premium HD bridal makeup with airbrush finish', isBridalService: true, sortOrder: 30 },
    { name: 'Goddess Makeup', category: 'makeup', price: 3999, duration: 130, description: 'Creative goddess-inspired special makeup', sortOrder: 31 },
    { name: 'SFX Makeup', category: 'makeup', price: 4999, duration: 150, description: 'Special effects makeup for themed looks and shoots', sortOrder: 32 },
    { name: 'Classical Dance Makeup', category: 'makeup', price: 2999, duration: 100, description: 'Stage-ready classical dance makeup', sortOrder: 33 },
    { name: 'Bridal Mehendi (Full)', category: 'mehendi', price: 2999, duration: 300, description: 'Intricate bridal mehendi on both hands and feet', isBridalService: true, sortOrder: 34 },
    { name: 'Party Mehendi', category: 'mehendi', price: 499, duration: 60, description: 'Beautiful mehendi designs for celebrations', sortOrder: 35 },
    { name: 'Arabic Mehendi', category: 'mehendi', price: 299, duration: 45, description: 'Trendy Arabic mehendi patterns', sortOrder: 36 },
    { name: 'Mehendi Service', category: 'mehendi', price: 399, duration: 45, description: 'Regular mehendi service for events and festive bookings', sortOrder: 37 },
    { name: 'Organic Mehendi Cone (For Sale)', category: 'mehendi', price: 60, duration: 10, description: 'Organic mehendi cone available for direct sale', sortOrder: 38 },
    { name: 'Small Tattoo (2-4 cm)', category: 'tattoo', price: 999, duration: 60, description: 'Custom small tattoo design', sortOrder: 39 },
    { name: 'Medium Tattoo (5-10 cm)', category: 'tattoo', price: 2499, duration: 120, description: 'Detailed medium-sized tattoo', sortOrder: 40 },
    { name: 'Large Tattoo', category: 'tattoo', price: 4999, duration: 240, description: 'Large artistic tattoo, price on consultation', sortOrder: 41 },
    { name: 'Saree Draping (Basic)', category: 'saree_draping', price: 299, duration: 30, description: 'Classic Nivi style draping', sortOrder: 42 },
    { name: 'Saree Draping (Bridal)', category: 'saree_draping', price: 799, duration: 60, description: 'Elaborate bridal saree draping style', isBridalService: true, sortOrder: 43 },
    { name: 'Saree Pre-Pleating', category: 'saree_draping', price: 499, duration: 45, description: 'Pre-pleating and pin setup for easier draping', sortOrder: 44 },
    { name: 'Full Body Grooming Package', category: 'grooming', price: 1999, duration: 180, description: 'Waxing, facial, cleanup and threading combo', sortOrder: 45 },
    { name: 'Beautician Service Package', category: 'grooming', price: 2499, duration: 180, description: 'Cleanup, threading, waxing and facial service combo', sortOrder: 46 },
    { name: 'Pre-Bridal Package', category: 'grooming', price: 4999, duration: 300, description: 'Complete pre-bridal grooming package with multiple sessions', isBridalService: true, sortOrder: 47 },
  ];

  await this.bulkWrite(
    services.map((service) => ({
      updateOne: {
        filter: { name: service.name },
        update: { $set: service },
        upsert: true,
      },
    })),
  );

  console.log('Services seeded successfully');
};

module.exports = mongoose.model('Service', serviceSchema);
