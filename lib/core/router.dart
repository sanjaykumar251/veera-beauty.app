import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/features/academy/screens/course_detail_screen.dart';
import 'package:veeras_beauty/features/academy/screens/courses_screen.dart';
import 'package:veeras_beauty/features/academy/screens/my_courses_screen.dart';
import 'package:veeras_beauty/features/auth/screens/login_screen.dart';
import 'package:veeras_beauty/features/auth/screens/register_screen.dart';
import 'package:veeras_beauty/features/membership/screens/membership_screen.dart';
import 'package:veeras_beauty/features/parlour/screens/booking_confirm_screen.dart';
import 'package:veeras_beauty/features/parlour/screens/booking_history_screen.dart';
import 'package:veeras_beauty/features/parlour/screens/booking_screen.dart';
import 'package:veeras_beauty/features/parlour/screens/home_screen.dart';
import 'package:veeras_beauty/features/parlour/screens/services_screen.dart';
import 'package:veeras_beauty/features/profile/screens/profile_screen.dart';
import 'package:veeras_beauty/shared/screens/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => ServicesScreen(
              initialCategory: state.uri.queryParameters['category'],
            ),
          ),
          GoRoute(
            path: '/academy',
            builder: (context, state) => CoursesScreen(
              initialCategory: state.uri.queryParameters['category'],
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/membership',
        builder: (context, state) => const MembershipScreen(),
      ),
      GoRoute(
        path: '/book/:serviceId',
        builder: (context, state) => BookingScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
      GoRoute(
        path: '/booking-confirm/:bookingId',
        builder: (context, state) => BookingConfirmScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const BookingHistoryScreen(),
      ),
      GoRoute(
        path: '/my-courses',
        builder: (context, state) => const MyCoursesScreen(),
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) => CourseDetailScreen(
          courseId: state.pathParameters['courseId']!,
        ),
      ),
    ],
  );
});
