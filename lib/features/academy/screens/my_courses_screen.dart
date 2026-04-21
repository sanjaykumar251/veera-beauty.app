import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';

final _myCoursesProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(apiServiceProvider).getMyCourses();
});

final _academyPreviewProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(apiServiceProvider).getCourses();
});

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authStateProvider).value != null;

    if (!isLoggedIn) {
      final academyPreview = ref.watch(_academyPreviewProvider);
      return Scaffold(
        appBar: AppBar(title: const Text('My Courses')),
        body: academyPreview.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const _CourseEmptyState(
            title: 'Sign in to view your courses',
            subtitle: 'You can still explore academy courses now.',
            showLogin: true,
          ),
          data: (data) => _CourseEmptyState(
            title: 'Sign in to view your courses',
            subtitle: 'You can still explore academy courses now.',
            showLogin: true,
            previewCourses: (data['courses'] as List? ?? []).take(4).toList(),
          ),
        ),
      );
    }

    final myCoursesAsync = ref.watch(_myCoursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: myCoursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final courses = data['courses'] as List? ?? [];
          if (courses.isEmpty) {
            final academyPreview =
                ref.watch(_academyPreviewProvider).valueOrNull;
            return _CourseEmptyState(
              title: 'No enrolled courses yet',
              subtitle: 'Open academy and pick a course you want to learn.',
              previewCourses:
                  (academyPreview?['courses'] as List? ?? []).take(4).toList(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) =>
                _EnrolledCourseCard(course: courses[i]),
          );
        },
      ),
    );
  }
}

class _CourseEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogin;
  final List previewCourses;

  const _CourseEmptyState({
    required this.title,
    required this.subtitle,
    this.showLogin = false,
    this.previewCourses = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A2A3A)),
          ),
          child: Column(
            children: [
              const Icon(Icons.school_outlined,
                  size: 54, color: AppTheme.primary),
              const SizedBox(height: 12),
              Text(title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.push('/academy'),
                    child: const Text('Browse Academy'),
                  ),
                  if (showLogin)
                    OutlinedButton(
                      onPressed: () => context.push('/login'),
                      child: const Text('Sign In'),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (previewCourses.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Popular Courses',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...previewCourses.map(
            (course) =>
                _PreviewCourseTile(course: course as Map<String, dynamic>),
          ),
        ],
      ],
    );
  }
}

class _PreviewCourseTile extends StatelessWidget {
  final Map<String, dynamic> course;

  const _PreviewCourseTile({required this.course});

  @override
  Widget build(BuildContext context) {
    final category = course['category'] ?? '';
    final price = course['effectivePrice'] ?? course['price'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: ListTile(
        onTap: () => context.push('/course/${course['_id']}'),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.12),
          child: Text(AppConstants.categoryIcons[category] ?? 'C'),
        ),
        title: Text(course['title'] ?? ''),
        subtitle: Text(AppConstants.courseCategoryLabels[category] ?? category),
        trailing: Text(
          'Rs $price',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _EnrolledCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const _EnrolledCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final progress = (course['progress'] as num?)?.toDouble() ?? 0.0;
    final category = course['category'] ?? '';
    final normalizedProgress = (progress / 100).clamp(0.0, 1.0).toDouble();

    return GestureDetector(
      onTap: () => context.push('/course/${course['_id']}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A3A)),
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 32,
              lineWidth: 4,
              percent: normalizedProgress,
              center: Text(
                AppConstants.categoryIcons[category] ?? 'C',
                style: const TextStyle(fontSize: 22),
              ),
              progressColor: AppTheme.primary,
              backgroundColor: const Color(0xFF2A2A3A),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'] ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.courseCategoryLabels[category] ?? category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: normalizedProgress,
                            backgroundColor: const Color(0xFF2A2A3A),
                            valueColor:
                                const AlwaysStoppedAnimation(AppTheme.primary),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${progress.toInt()}%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primary,
                            ),
                      ),
                    ],
                  ),
                  if (progress >= 100) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: AppTheme.accent, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
