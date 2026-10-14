const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;

// MongoDB connection string
const MONGO_URI =
  'mongodb+srv://janreyperalta312_db_user:E5mRHicYb9BWsFQM@cluster0.e7z9ccv.mongodb.net/gentleman_barbershop?retryWrites=true&w=majority&appName=Cluster0';

// Connect to MongoDB
mongoose
  .connect(MONGO_URI)
  .then(() => console.log('✅ Connected to MongoDB Atlas'))
  .catch((err) => {
    console.error('❌ MongoDB connection error:', err.message);
    process.exit(1);
  });

// Booking Schema
const bookingSchema = new mongoose.Schema({
  customerName: { type: String, required: true },
  phone: { type: String, required: true },
  email: { type: String, required: true },
  serviceName: { type: String, required: true },
  subServiceName: { type: String, default: null },
  branchName: { type: String, required: true },
  bookingDate: { type: String, required: true },
  bookingTime: { type: String, required: true },
  barberName: { type: String, default: null },
  totalPrice: { type: Number, required: true },
  specialRequests: { type: String, default: null },
  status: { type: String, default: 'pending' },
  createdAt: { type: String, default: () => new Date().toISOString() },
});

const Booking = mongoose.model('Booking', bookingSchema, 'bookings');

// Middleware
app.use(
  cors({
    origin: true,
    credentials: true,
    methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);
app.use(express.json());

// Log all requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Gentleman Barbershop API is running' });
});

// Create a new booking
app.post('/api/bookings', async (req, res) => {
  try {
    const booking = new Booking(req.body);
    const saved = await booking.save();
    res.status(201).json({ success: true, booking: saved });
  } catch (err) {
    console.error('Error creating booking:', err);
    res.status(400).json({ success: false, error: err.message });
  }
});

// Get all bookings
app.get('/api/bookings', async (req, res) => {
  try {
    const bookings = await Booking.find().sort({ createdAt: -1 });
    res.json({ success: true, bookings });
  } catch (err) {
    console.error('Error fetching bookings:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Get bookings by phone number
app.get('/api/bookings/phone/:phone', async (req, res) => {
  try {
    const { phone } = req.params;
    const bookings = await Booking.find({ phone }).sort({ createdAt: -1 });
    res.json({ success: true, bookings });
  } catch (err) {
    console.error('Error fetching bookings by phone:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Get a single booking by ID
app.get('/api/bookings/:id', async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ success: false, error: 'Booking not found' });
    }
    res.json({ success: true, booking });
  } catch (err) {
    console.error('Error fetching booking:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Update booking status
app.patch('/api/bookings/:id/status', async (req, res) => {
  try {
    const { status } = req.body;
    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );
    if (!booking) {
      return res.status(404).json({ success: false, error: 'Booking not found' });
    }
    res.json({ success: true, booking });
  } catch (err) {
    console.error('Error updating booking status:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Delete a booking
app.delete('/api/bookings/:id', async (req, res) => {
  try {
    const booking = await Booking.findByIdAndDelete(req.params.id);
    if (!booking) {
      return res.status(404).json({ success: false, error: 'Booking not found' });
    }
    res.json({ success: true, message: 'Booking deleted' });
  } catch (err) {
    console.error('Error deleting booking:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
