import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/database_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _phoneController = TextEditingController();
  List<Booking> _bookings = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _searchBookings() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your phone number.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final bookings = await DatabaseService.getBookingsByPhone(phone);

    if (!mounted) return;
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'booked':
        return const Color(0xFFD4A853);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'completed':
        return const Color(0xFF2196F3);
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF999999);
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return '✓ Confirmed';
      case 'booked':
        return '📋 Booked';
      case 'pending':
        return '⏳ Pending';
      case 'completed':
        return '✓ Completed';
      case 'cancelled':
        return '✕ Cancelled';
      case 'rejected':
        return '✕ Rejected';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text(
          "My Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your phone number to view your appointments.",
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "e.g. 09123456789",
                      hintStyle: const TextStyle(color: Color(0xFF555555)),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color(0xFFD4A853),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0F0F0F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _searchBookings(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _searchBookings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A853),
                      foregroundColor: const Color(0xFF0F0F0F),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF0F0F0F),
                            ),
                          )
                        : const Text(
                            "Search",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A853)),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState(
        icon: Icons.event_note,
        title: "No search yet",
        subtitle: "Enter your phone number above to find your appointments.",
      );
    }

    if (_bookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox_outlined,
        title: "No appointments found",
        subtitle:
            "We couldn't find any bookings for this number. Make sure you used the same phone number when booking.",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(_bookings[index]),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF444444)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (booking.subServiceName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          booking.subServiceName!,
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(booking.status).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    _formatStatus(booking.status),
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFF2A2A2A), height: 1),
            const SizedBox(height: 14),
            _buildDetailRow(
              icon: Icons.person_outline,
              label: "Customer",
              value: booking.customerName,
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.store_outlined,
              label: "Branch",
              value: booking.branchName,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: "Date",
                    value: _formatDate(booking.bookingDate),
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.access_time,
                    label: "Time",
                    value: booking.bookingTime,
                  ),
                ),
              ],
            ),
            if (booking.barberName != null) ...[
              const SizedBox(height: 10),
              _buildDetailRow(
                icon: Icons.content_cut,
                label: "Barber",
                value: booking.barberName!,
              ),
            ],
            if (booking.specialRequests != null &&
                booking.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow(
                icon: Icons.note_outlined,
                label: "Notes",
                value: booking.specialRequests!,
              ),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 13,
                  ),
                ),
                Text(
                  "₱${booking.totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Color(0xFFD4A853),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF666666)),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
