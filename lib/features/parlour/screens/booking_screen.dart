import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const BookingScreen({super.key, required this.serviceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _service;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _loadService();
    _prefillUser();
  }

  Future<void> _loadService() async {
    try {
      final data =
          await ref.read(apiServiceProvider).getService(widget.serviceId);
      setState(() {
        _service = data['service'];
        _offlineMode = data['offlineMode'] == true;
      });
    } catch (_) {}
  }

  void _prefillUser() {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user != null) {
      _nameCtrl.text = user['name'] ?? '';
      _phoneCtrl.text = user['phone'] ?? '';
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time slot')));
      return;
    }
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your name and phone number')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final data = await ref.read(apiServiceProvider).createBooking({
        'serviceId': widget.serviceId,
        'date': _selectedDay!.toIso8601String(),
        'timeSlot': _selectedTime,
        'guestName': _nameCtrl.text.trim(),
        'guestPhone': _phoneCtrl.text.trim(),
        'specialRequests': _notesCtrl.text.trim(),
      });
      if (data['success'] == true && mounted) {
        context.pushReplacement('/booking-confirm/${data['booking']['_id']}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVIP = ref.read(currentUserProvider.notifier).isVIP;
    final price = _service?['price'] as num?;
    final isBridal = _service?['isBridalService'] == true ||
        _service?['category'] == 'bridal';
    final vipDiscount = isBridal ? 0.85 : 0.90;
    final effectivePrice = (isVIP && price != null)
        ? (price * vipDiscount).round()
        : price?.toInt();

    return Scaffold(
      appBar: AppBar(title: Text(_service?['name'] ?? 'Book Service')),
      body: _service == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_offlineMode)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.info.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: AppTheme.info.withOpacity(0.35)),
                      ),
                      child: const Text(
                        'Showing saved service details. Online booking confirmation needs the studio server.',
                      ),
                    ),
                  // Service summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2A3A)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                              child: Text(
                            AppConstants.categoryIcons[_service!['category']] ??
                                '⭐',
                            style: const TextStyle(fontSize: 26),
                          )),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_service!['name'],
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              Text(_service!['description'] ?? '',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (isVIP) ...[
                                    Text('₹$effectivePrice',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: AppTheme.accent,
                                            )),
                                    const SizedBox(width: 8),
                                    Text('₹${price?.toInt()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: AppTheme.textMuted,
                                            )),
                                  ] else
                                    Text('₹${price?.toInt()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: AppTheme.primary,
                                            )),
                                  if (isVIP) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.goldGradient,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                          isBridal ? 'VIP -15%' : 'VIP -10%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Calendar
                  _SectionLabel(label: '1. Select Date'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2A3A)),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        defaultTextStyle:
                            const TextStyle(color: AppTheme.textPrimary),
                        weekendTextStyle:
                            const TextStyle(color: AppTheme.primary),
                        selectedDecoration: const BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle:
                            const TextStyle(color: AppTheme.primary),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold),
                        leftChevronIcon: Icon(Icons.chevron_left,
                            color: AppTheme.textSecondary),
                        rightChevronIcon: Icon(Icons.chevron_right,
                            color: AppTheme.textSecondary),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle:
                            TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        weekendStyle:
                            TextStyle(color: AppTheme.primary, fontSize: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Time Slots
                  _SectionLabel(label: '2. Select Time'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.timeSlots.map((slot) {
                      final isSelected = _selectedTime == slot;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = slot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected ? AppTheme.primaryGradient : null,
                            color: isSelected ? null : AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : const Color(0xFF2A2A3A),
                            ),
                          ),
                          child: Text(slot,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  )),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Contact Details
                  _SectionLabel(label: '3. Your Details'),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Special Requests (optional)',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                  ),

                  const SizedBox(height: 32),

                  GradientButton(
                    label: _isLoading ? 'Confirming...' : 'Confirm Booking',
                    icon: Icons.check_circle_outline,
                    onPressed: _isLoading ? null : _confirmBooking,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primary,
              )),
    );
  }
}
