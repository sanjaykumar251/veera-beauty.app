import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';

final servicesProvider =
    FutureProvider.family<Map<String, dynamic>, String?>((ref, category) async {
  return ref.read(apiServiceProvider).getServices(category: category);
});

class ServicesScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const ServicesScreen({super.key, this.initialCategory});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider(_selectedCategory));
    final isVIP = ref.read(currentUserProvider.notifier).isVIP;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        actions: [
          if (isVIP)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium,
                        color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text('VIP -10%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _CategoryChip(
                    label: 'All',
                    isSelected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null)),
                ...AppConstants.categoryLabels.entries.map((e) => _CategoryChip(
                      label: e.value,
                      emoji: AppConstants.categoryIcons[e.key],
                      isSelected: _selectedCategory == e.key,
                      onTap: () => setState(() => _selectedCategory = e.key),
                    )),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: servicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Services could not be loaded right now. Please try again later.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (data) {
                final services = data['services'] as List? ?? [];
                if (services.isEmpty) {
                  return const Center(child: Text('No services available'));
                }
                final offlineMode = data['offlineMode'] == true;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length + (offlineMode ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    if (offlineMode && i == 0) {
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.info.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppTheme.info.withOpacity(0.35)),
                        ),
                        child: const Text(
                          'Showing saved service catalogue. Live booking needs the studio server to be online.',
                        ),
                      );
                    }
                    final service = services[offlineMode ? i - 1 : i]
                        as Map<String, dynamic>;
                    return _ServiceCard(service: service, isVIP: isVIP);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends ConsumerWidget {
  final Map<String, dynamic> service;
  final bool isVIP;
  const _ServiceCard({required this.service, required this.isVIP});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = service['price'] as num;
    final vipPrice = isVIP ? (price * 0.9).round() : null;
    final isBridal = service['isBridalService'] == true;
    final vipBridalPrice = (isVIP && isBridal) ? (price * 0.85).round() : null;
    final effectiveVipPrice = vipBridalPrice ?? vipPrice;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.categoryIcons[service['category']] ?? '⭐',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(service['name'] ?? '',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          if (isBridal && isVIP)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('-15%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppTheme.accent,
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                        ],
                      ),
                      if (service['description'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(service['description'],
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (service['duration'] != null)
                            _Tag(
                                icon: Icons.access_time,
                                label: '${service['duration']} min'),
                          const SizedBox(width: 8),
                          _Tag(
                            icon: Icons.category_outlined,
                            label: AppConstants
                                    .categoryLabels[service['category']] ??
                                service['category'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF2A2A3A))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isVIP && effectiveVipPrice != null) ...[
                      Text('₹${effectiveVipPrice}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.accent,
                              )),
                      Text('₹${price.toInt()}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.textMuted,
                                  )),
                    ] else
                      Text('₹${price.toInt()}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.primary,
                              )),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => context.push('/book/${service['_id']}'),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppTheme.textMuted),
        const SizedBox(width: 3),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip(
      {required this.label,
      this.emoji,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppTheme.primary : const Color(0xFF2A2A3A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    )),
          ],
        ),
      ),
    );
  }
}
