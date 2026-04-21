import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';

final coursesProvider =
    FutureProvider.family<Map<String, dynamic>, String?>((ref, category) {
  return ref.read(apiServiceProvider).getCourses(category: category);
});

class CoursesScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const CoursesScreen({super.key, this.initialCategory});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider(_selectedCategory));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Netflix-style Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Veera's Academy",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AppTheme.textPrimary)),
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppTheme.heroGradient),
                child: Stack(
                  children: [
                    Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary.withOpacity(0.1)),
                        )),
                    const Center(
                        child: Text('🎓', style: TextStyle(fontSize: 60))),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.play_circle_outline),
                onPressed: () => context.push('/my-courses'),
                tooltip: 'My Courses',
              ),
            ],
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _CategoryChip(
                      label: 'All',
                      isSelected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null)),
                  ...AppConstants.courseCategoryLabels.entries
                      .map((e) => _CategoryChip(
                            label: e.value,
                            isSelected: _selectedCategory == e.key,
                            onTap: () =>
                                setState(() => _selectedCategory = e.key),
                          )),
                ],
              ),
            ),
          ),

          // Courses Grid
          coursesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Courses could not be loaded right now. Please try again later.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            data: (data) {
              final courses = data['courses'] as List? ?? [];
              final offlineMode = data['offlineMode'] == true;
              if (courses.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                      child:
                          Text('No courses available yet. Check back soon!')),
                );
              }

              // Featured course
              final featured =
                  courses.where((c) => c['isFeatured'] == true).toList();
              final regular =
                  courses.where((c) => c['isFeatured'] != true).toList();

              return SliverList(
                delegate: SliverChildListDelegate([
                  if (offlineMode)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.info.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: AppTheme.info.withOpacity(0.35)),
                      ),
                      child: const Text(
                        'Showing saved academy catalogue. Enrollment and progress tracking need the studio server.',
                      ),
                    ),
                  if (featured.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Text('Featured',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: featured.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (c, i) =>
                            _FeaturedCourseCard(course: featured[i]),
                      ),
                    ),
                  ],
                  if (regular.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Text('All Courses',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: regular.length,
                      itemBuilder: (c, i) => _CourseCard(course: regular[i]),
                    ),
                    const SizedBox(height: 24),
                  ],
                ]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeaturedCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const _FeaturedCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final price = course['effectivePrice'] ?? course['price'];
    return GestureDetector(
      onTap: () => context.push('/course/${course['_id']}'),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppTheme.cardGradient,
          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppTheme.cardDark2,
                child: const Center(
                    child: Text('🎓', style: TextStyle(fontSize: 48))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course['title'] ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(course['instructor'] ?? "Veera's Academy",
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹$price',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.accent,
                              )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Enroll',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final price = course['effectivePrice'] ?? course['price'];
    final category = course['category'] ?? '';

    return GestureDetector(
      onTap: () => context.push('/course/${course['_id']}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.3),
                      AppTheme.cardDark2
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(AppConstants.categoryIcons[category] ?? '🎓',
                      style: const TextStyle(fontSize: 40)),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course['title'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹$price',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.primary,
                                  fontSize: 16,
                                )),
                        const Icon(Icons.arrow_forward_ios,
                            size: 12, color: AppTheme.textMuted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        AppConstants.courseCategoryLabels[category] ?? category,
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppTheme.primary : const Color(0xFF2A2A3A)),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                )),
      ),
    );
  }
}
