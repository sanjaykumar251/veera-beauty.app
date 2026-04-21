import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String lessonId;
  const VideoPlayerScreen({super.key, required this.courseId, required this.lessonId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  Map<String, dynamic>? _lesson;
  Map<String, dynamic>? _course;
  bool _loading = true;
  int _lastSavedPosition = 0;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    try {
      final courseData = await ref.read(apiServiceProvider).getCourse(widget.courseId);
      final course = courseData['course'];
      Map<String, dynamic>? lesson;

      for (final module in (course['modules'] as List? ?? [])) {
        for (final l in (module['lessons'] as List? ?? [])) {
          if (l['_id'] == widget.lessonId) {
            lesson = l;
            break;
          }
        }
        if (lesson != null) break;
      }

      if (lesson == null || lesson['youtubeVideoId'] == null) {
        setState(() => _loading = false);
        return;
      }

      // Get last position from progress
      final progress = courseData['progress'];
      final progressLessons = progress?['lessons'] as List? ?? [];
      Map<String, dynamic>? lessonProgress;
      for (final item in progressLessons) {
        if (item is Map<String, dynamic> && item['lessonId'] == widget.lessonId) {
          lessonProgress = item;
          break;
        }
      }
      final lastPos = lessonProgress?['lastPosition'] ?? 0;

      _controller = YoutubePlayerController(
        initialVideoId: lesson['youtubeVideoId'],
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          startAt: lastPos,
          disableDragSeek: false,
          enableCaption: true,
        ),
      );

      _controller!.addListener(_onPlayerUpdate);

      setState(() {
        _lesson = lesson;
        _course = course;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _onPlayerUpdate() {
    if (_controller == null) return;

    final position = _controller!.value.position.inSeconds;

    // Save progress every 10 seconds
    if ((position - _lastSavedPosition).abs() >= 10) {
      _lastSavedPosition = position;
      _saveProgress(position, false);
    }

    // Mark as completed if watched > 90%
    final duration = _controller!.value.metaData.duration.inSeconds;
    if (duration > 0 && position > 0 && position / duration > 0.9) {
      _saveProgress(position, true);
    }
  }

  Future<void> _saveProgress(int position, bool completed) async {
    try {
      await ref.read(apiServiceProvider).updateProgress({
        'courseId': widget.courseId,
        'lessonId': widget.lessonId,
        'moduleId': null, // Could pass module ID here
        'lastPosition': position,
        'completed': completed,
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_controller != null) {
      final position = _controller!.value.position.inSeconds;
      _saveProgress(position, false);
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_lesson == null || _controller == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Lesson not available')),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppTheme.primary,
          handleColor: AppTheme.accent,
          bufferedColor: Color(0xFF4A3A4A),
          backgroundColor: Color(0xFF2A2A3A),
        ),
        onReady: () {},
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(_lesson!['title'] ?? 'Lesson', style: Theme.of(context).textTheme.titleMedium),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player
              player,

              // Lesson Info
              Expanded(
                child: Container(
                  color: AppTheme.backgroundDark,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_lesson!['title'] ?? '', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        if (_lesson!['description'] != null)
                          Text(_lesson!['description'], style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 20),

                        // Course info
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2A2A3A)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.school_outlined, color: AppTheme.primary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From Course', style: Theme.of(context).textTheme.labelMedium),
                                    Text(_course!['title'] ?? '', style: Theme.of(context).textTheme.titleSmall),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
