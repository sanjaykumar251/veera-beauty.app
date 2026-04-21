const Service = require('../models/Service');

// ─── Get All Services (optionally filtered by category) ───────────────────────
exports.getServices = async (req, res) => {
  try {
    const { category } = req.query;
    const filter = { isAvailable: true };
    if (category) filter.category = category;

    const services = await Service.find(filter).sort({ category: 1, sortOrder: 1, price: 1 });

    // Group by category
    const grouped = services.reduce((acc, service) => {
      const cat = service.category;
      if (!acc[cat]) acc[cat] = [];
      acc[cat].push(service);
      return acc;
    }, {});

    res.json({ success: true, services, grouped });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get Single Service ───────────────────────────────────────────────────────
exports.getService = async (req, res) => {
  try {
    const service = await Service.findById(req.params.id);
    if (!service) return res.status(404).json({ success: false, message: 'Service not found' });
    res.json({ success: true, service });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Create Service ────────────────────────────────────────────────────
exports.createService = async (req, res) => {
  try {
    const service = await Service.create(req.body);
    res.status(201).json({ success: true, service });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// ─── Admin: Update Service ────────────────────────────────────────────────────
exports.updateService = async (req, res) => {
  try {
    const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!service) return res.status(404).json({ success: false, message: 'Service not found' });
    res.json({ success: true, service });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// ─── Admin: Delete Service ────────────────────────────────────────────────────
exports.deleteService = async (req, res) => {
  try {
    await Service.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Service deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Seed default services ────────────────────────────────────────────────────
exports.seedServices = async (req, res) => {
  try {
    await Service.seedData();
    res.json({ success: true, message: 'Services seeded' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
