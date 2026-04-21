import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  Map<String, dynamic>? _course;
  bool _isEnrolled = false;
  Map<String, dynamic>? _progress;
  bool _loading = true;
  bool _showQR = false;
  String? _qrDataUrl;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    try {
      final data =
          await ref.read(apiServiceProvider).getCourse(widget.courseId);
      if (!mounted) return;
      setState(() {
        _course = data['course'];
        _isEnrolled = data['isEnrolled'] == true;
        _progress = data['progress'];
        _offlineMode = data['offlineMode'] == true;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _purchaseCourse() async {
    setState(() => _showQR = true);
    try {
      final price = _course?['effectivePrice'] ?? _course?['price'] ?? 0;
      final data = await ref.read(apiServiceProvider).getPaymentQR(
            amount: price,
            note: 'Course: ${_course?['title']}',
          );
      if (!mounted) return;
      setState(() => _qrDataUrl = data['qrDataUrl']);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Course not found')),
      );
    }

    final modules = _course!['modules'] as List? ?? [];
    final price = _course!['effectivePrice'] ?? _course!['price'];
    final category = _course!['category'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _course!['title'] ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.6),
                      AppTheme.backgroundDark
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppConstants.categoryIcons[category] ?? 'C',
                        style: const TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 8),
                      if (_isEnrolled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppTheme.success.withOpacity(0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle,
                                  color: AppTheme.success, size: 14),
                              SizedBox(width: 4),
                              Text('Enrolled',
                                  style: TextStyle(
                                      color: AppTheme.success, fontSize: 12)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
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
                        'Showing saved course details. Enrollment and payment need the studio server.',
                      ),
                    ),
                  Row(
                    children: [
                      _InfoBadge(
                        icon: Icons.video_library_outlined,
                        label: '${_course!['totalLessons'] ?? 0} Lessons',
                      ),
                      const SizedBox(width: 8),
                      _InfoBadge(
                        icon: Icons.bar_chart,
                        label: _course!['level'] ?? 'Beginner',
                      ),
                      const SizedBox(width: 8),
                      _InfoBadge(
                        icon: Icons.language,
                        label: _course!['language'] ?? 'Tamil',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_course!['description'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium),
                  if (_isEnrolled && _progress != null) ...[
                    const SizedBox(height: 20),
                    Text('Your Progress',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_progress!['percentageComplete'] ?? 0) / 100,
                        backgroundColor: const Color(0xFF2A2A3A),
                        valueColor:
                            const AlwaysStoppedAnimation(AppTheme.primary),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_progress!['percentageComplete'] ?? 0}% complete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if ((_course!['whatYouLearn'] as List?)?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: 24),
                    Text('What you\'ll learn',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    ...(_course!['whatYouLearn'] as List).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppTheme.success, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(item.toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Course Content',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  ...modules.asMap().entries.map((entry) {
                    final module = entry.value as Map<String, dynamic>;
                    final lessons = module['lessons'] as List? ?? [];
                    return _ModuleExpansion(
                      module: module,
                      moduleIndex: entry.key,
                      lessons: lessons,
                      isEnrolled: _isEnrolled,
                      courseId: widget.courseId,
                      progress: _progress,
                    );
                  }),
                  const SizedBox(height: 32),
                  if (!_isEnrolled) ...[
                    if (!_showQR)
                      Column(
                        children: [
                          GradientButton(
                            label: 'Enroll Now - Rs $price',
                            icon: Icons.school_rounded,
                            onPressed: _purchaseCourse,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pay via GPay / UPI after tapping Enroll',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else
                      _QRPaymentWidget(
                        qrDataUrl: _qrDataUrl,
                        courseName: _course!['title'],
                        price: price,
                      ),
                  ] else
                    GradientButton(
                      label: 'Continue Learning',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () {
                        if (modules.isEmpty) return;
                        final lessons = modules.first['lessons'] as List? ?? [];
                        if (lessons.isEmpty) return;
                        final firstLesson =
                            lessons.first as Map<String, dynamic>;
                        context.push(
                            '/lesson/${widget.courseId}/${firstLesson['_id']}');
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleExpansion extends StatelessWidget {
  final Map<String, dynamic> module;
  final int moduleIndex;
  final List lessons;
  final bool isEnrolled;
  final String courseId;
  final Map<String, dynamic>? progress;

  const _ModuleExpansion({
    required this.module,
    required this.moduleIndex,
    required this.lessons,
    required this.isEnrolled,
    required this.courseId,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text('Module ${moduleIndex + 1}: ${module['title']}',
            style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text('${lessons.length} lessons',
            style: Theme.of(context).textTheme.bodySmall),
        iconColor: AppTheme.primary,
        children: lessons.map((lessonItem) {
          final lesson = lessonItem as Map<String, dynamic>;
          final progressLessons = progress?['lessons'] as List? ?? [];
          Map<String, dynamic>? lessonProgress;

          for (final progressLesson in progressLessons) {
            if (progressLesson is Map<String, dynamic> &&
                progressLesson['lessonId'] == lesson['_id']) {
              lessonProgress = progressLesson;
              break;
            }
          }

          final isCompleted = lessonProgress?['completed'] == true;
          final isAccessible = isEnrolled || lesson['isFreePreview'] == true;

          return ListTile(
            leading: Icon(
              isCompleted
                  ? Icons.check_circle
                  : (isAccessible
                      ? Icons.play_circle_outline
                      : Icons.lock_outline),
              color: isCompleted
                  ? AppTheme.success
                  : (isAccessible ? AppTheme.primary : AppTheme.textMuted),
              size: 20,
            ),
            title: Text(
              lesson['title'] ?? '',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isAccessible
                        ? AppTheme.textPrimary
                        : AppTheme.textMuted,
                  ),
            ),
            trailing: lesson['isFreePreview'] == true
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'FREE',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppTheme.success),
                    ),
                  )
                : null,
            onTap: isAccessible
                ? () => context.push('/lesson/$courseId/${lesson['_id']}')
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Enroll in this course to access this lesson')),
                    ),
          );
        }).toList(),
      ),
    );
  }
}

class _QRPaymentWidget extends StatelessWidget {
  final String? qrDataUrl;
  final String? courseName;
  final dynamic price;

  const _QRPaymentWidget(
      {required this.qrDataUrl, required this.courseName, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            'Pay Rs $price to Enroll',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppTheme.accent),
          ),
          const SizedBox(height: 4),
          Text(courseName ?? '',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          if (qrDataUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(qrDataUrl!.split(',').last),
                width: 200,
                height: 200,
              ),
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'After payment, send your screenshot to WhatsApp +91 83445 49199 with the course name. Access will be granted within 24 hours.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.warning),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
