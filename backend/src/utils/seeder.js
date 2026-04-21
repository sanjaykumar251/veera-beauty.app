require('dotenv').config();
const connectDB = require('../config/database');
const Service = require('../models/Service');

const run = async () => {
  try {
    await connectDB();
    await Service.seedData();
    console.log('Seed completed successfully');
    process.exit(0);
  } catch (error) {
    console.error('Seed failed:', error.message);
    process.exit(1);
  }
};

run();
