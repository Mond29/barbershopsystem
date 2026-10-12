import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class Booking {
  final ObjectId? id;
  final String customerName;
  final String phone;
  final String email;
  final String serviceName;
  final String? subServiceName;
  final String branchName;
  final DateTime bookingDate;
  final String bookingTime;
  final String? barberName;
  final double totalPrice;
  final String? specialRequests;
  final String status;
  final DateTime createdAt;

  Booking({
    this.id,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.serviceName,
    this.subServiceName,
    required this.branchName,
    required this.bookingDate,
    required this.bookingTime,
    this.barberName,
    required this.totalPrice,
    this.specialRequests,
    this.status = 'confirmed',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phone': phone,
      'email': email,
      'serviceName': serviceName,
      if (subServiceName != null) 'subServiceName': subServiceName,
      'branchName': branchName,
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': bookingTime,
      if (barberName != null) 'barberName': barberName,
      'totalPrice': totalPrice,
      if (specialRequests != null && specialRequests!.isNotEmpty)
        'specialRequests': specialRequests,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['_id'] as ObjectId?,
      customerName: map['customerName'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      serviceName: map['serviceName'] as String,
      subServiceName: map['subServiceName'] as String?,
      branchName: map['branchName'] as String,
      bookingDate: DateTime.parse(map['bookingDate'] as String),
      bookingTime: map['bookingTime'] as String,
      barberName: map['barberName'] as String?,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      specialRequests: map['specialRequests'] as String?,
      status: map['status'] as String? ?? 'confirmed',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
