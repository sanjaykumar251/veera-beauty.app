import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';

class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authStateProvider).value != null;
    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Sign in to view your booking history.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final bookingsAsync = ref.watch(_myBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final bookings = data['bookings'] as List? ?? [];
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 64, color: AppTheme.textMuted),
                  const SizedBox(height: 16),
                  Text('No bookings yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textMuted,
                  )),
                  const SizedBox(height: 8),
                  Text('Book a service to get started!', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _BookingCard(booking: bookings[i]),
          );
        },
      ),
    );
  }
}

final _myBookingsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(apiServiceProvider).getMyBookings();
});

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  const _BookingCard({required this.booking});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed': return AppTheme.success;
      case 'pending': return AppTheme.warning;
      case 'completed': return AppTheme.info;
      case 'cancelled': return AppTheme.error;
      default: return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking['status'] ?? 'pending';
    final date = booking['date'] != null ? DateTime.tryParse(booking['date']) : null;
    final isVIP = booking['isVIPBooking'] == true;
    final isFree = booking['isFreeService'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(booking['serviceName'] ?? 'Service', style: Theme.of(context).textTheme.titleLarge),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor(status).withOpacity(0.4)),
                ),
                child: Text(status.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _statusColor(status), fontWeight: FontWeight.bold,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (date != null)
            _InfoRow(icon: Icons.calendar_today, label: DateFormat('EEE, d MMM yyyy').format(date)),
          if (booking['timeSlot'] != null)
            _InfoRow(icon: Icons.access_time, label: booking['timeSlot']),
          _InfoRow(
            icon: Icons.currency_rupee,
            label: isFree ? 'FREE (VIP 11th Booking! 🎉)' : '₹${booking['finalPrice']}',
            color: isFree ? AppTheme.success : null,
          ),
          if (isVIP)
            Row(
              children: [
                const Icon(Icons.workspace_premium, size: 14, color: AppTheme.accent),
                const SizedBox(width: 4),
                Text('VIP Booking', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.accent)),
                if (booking['discountApplied'] != null && booking['discountApplied'] > 0) ...[
                  const SizedBox(width: 4),
                  Text('• ${booking['discountApplied']}% off', style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.accent,
                  )),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _InfoRow({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color ?? AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
