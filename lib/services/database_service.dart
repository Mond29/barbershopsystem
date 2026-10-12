import 'package:mongo_dart/mongo_dart.dart';
import '../config/mongo_config.dart';
import '../models/booking.dart';

class DatabaseService {
  static Db? _db;

  static Future<Db> get database async {
    if (_db != null && _db!.isConnected) {
      return _db!;
    }
    _db = await Db.create(MongoConfig.connectionString);
    await _db!.open();
    return _db!;
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  static Future<bool> insertBooking(Booking booking) async {
    try {
      final db = await database;
      final collection = db.collection('bookings');
      final result = await collection.insertOne(booking.toMap());
      return result.isSuccess;
    } catch (e) {
      print('MongoDB insert error: $e');
      return false;
    }
  }

  static Future<List<Booking>> getAllBookings() async {
    try {
      final db = await database;
      final collection = db.collection('bookings');
      final docs = await collection.find(
        where.sortBy('createdAt', descending: true),
      ).toList();
      return docs.map((d) => Booking.fromMap(d)).toList();
    } catch (e) {
      print('MongoDB fetch error: $e');
      return [];
    }
  }

  static Future<List<Booking>> getBookingsByPhone(String phone) async {
    try {
      final db = await database;
      final collection = db.collection('bookings');
      final docs = await collection.find(
        where.eq('phone', phone).sortBy('createdAt', descending: true),
      ).toList();
      return docs.map((d) => Booking.fromMap(d)).toList();
    } catch (e) {
      print('MongoDB fetch error: $e');
      return [];
    }
  }
}
