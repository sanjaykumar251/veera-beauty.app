import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPlayerScreen extends ConsumerWidget {
  final String courseId;
  final String lessonId;
  const VideoPlayerScreen({super.key, required this.courseId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Syllabus')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.menu_book_outlined, size: 52),
              SizedBox(height: 16),
              Text(
                'Videos are removed from the academy.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Please open the course page to view syllabus details and enrollment information.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
