// lib/controllers/onboarding_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final _storage = GetStorage();
  static const String _onboardingKey = 'onboarding_completed';

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding {
    return _storage.read(_onboardingKey) ?? false;
  }

  /// Mark onboarding as completed
  void completeOnboarding() {
    _storage.write(_onboardingKey, true);
    print('✅ Onboarding marked as completed');
  }

  /// Reset onboarding (for testing purposes)
  void resetOnboarding() {
    _storage.remove(_onboardingKey);
    print('🔄 Onboarding reset - will show again on next launch');
  }
}
