import 'package:go_router/go_router.dart';
import 'package:grade_ai/src/features/auth/presentation/screens/login_screen.dart';
import 'package:grade_ai/src/features/dashboard/presentation/screens/teacher_dashboard_screen.dart';
import 'package:grade_ai/src/features/grading/presentation/screens/home_screen.dart';
import 'package:grade_ai/src/features/grading/presentation/screens/upload_grade_screen.dart';
import 'package:grade_ai/src/features/grading/presentation/screens/grade_result_screen.dart';
import 'package:grade_ai/src/features/scan/presentation/screens/scan_screen.dart';
import 'package:grade_ai/src/features/scan/presentation/widgets/capture_preview.dart';
import 'package:grade_ai/src/features/security/presentation/screens/security_settings_screen.dart';

/// App navigation with full scan → grade → results flow.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const TeacherDashboardScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: '/preview',
      name: 'preview',
      builder: (context, state) => const CapturePreview(),
    ),
    GoRoute(
      path: '/upload',
      name: 'upload',
      builder: (context, state) => const UploadGradeScreen(),
    ),
    GoRoute(
      path: '/results',
      name: 'results',
      builder: (context, state) => const GradeResultScreen(),
    ),
    GoRoute(
      path: '/security',
      name: 'security',
      builder: (context, state) => const SecuritySettingsScreen(),
    ),
  ],
);
