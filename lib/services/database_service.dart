import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

class DatabaseService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration _timeout = Duration(seconds: 15);

  // Create a new booking
  static Future<bool> insertBooking(Booking booking) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/bookings'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(booking.toMap()),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      debugPrint('Booking failed: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      debugPrint('HTTP insert error: $e');
      return false;
    }
  }

  // Get all bookings
  static Future<List<Booking>> getAllBookings() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookings'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> bookingsList = data['bookings'] ?? [];
        return bookingsList.map((b) => Booking.fromMap(b)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('HTTP fetch error: $e');
      return [];
    }
  }

  // Get bookings by phone number
  static Future<List<Booking>> getBookingsByPhone(String phone) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookings/phone/$phone'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> bookingsList = data['bookings'] ?? [];
        return bookingsList.map((b) => Booking.fromMap(b)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('HTTP fetch by phone error: $e');
      return [];
    }
  }
}
