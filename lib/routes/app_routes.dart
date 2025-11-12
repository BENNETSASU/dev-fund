// lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login.dart';
import '../screens/signup.dart';
import '../screens/forgot_password.dart';
import '../screens/retirement_goal_screen.dart';
import '../pages/main_scaffold.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String goal = '/goal';

  static List<GetPage> getPages() {
    return [
      GetPage(name: splash, page: () => const SplashScreen()),
      GetPage(name: onboarding, page: () => const OnboardingScreen()),
      GetPage(name: login, page: () => const LoginScreen()),
      GetPage(name: signup, page: () => const SignupScreen()),
      GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
      GetPage(name: home, page: () => const MainScaffold()),
      GetPage(name: goal, page: () => const RetirementGoalScreen()),
    ];
  }
}
