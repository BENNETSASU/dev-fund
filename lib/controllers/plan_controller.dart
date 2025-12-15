// lib/controllers/plan_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';

class PlanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  // Observable variables
  var targetAmount = 0.0.obs;
  var yearsToRetirement = 0.obs;
  var currentSavings = 0.0.obs;
  var monthlyContribution = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔧 PlanController initialized');
    _loadRetirementPlan();
  }

  // Load retirement plan from Firestore
  Future<void> _loadRetirementPlan() async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }

      isLoading.value = true;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('retirement_plan')
          .doc('current_plan')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        targetAmount.value = (data['targetAmount'] ?? 0.0).toDouble();
        yearsToRetirement.value = data['yearsToRetirement'] ?? 0;
        currentSavings.value = (data['currentSavings'] ?? 0.0).toDouble();
        monthlyContribution.value = (data['monthlyContribution'] ?? 0.0).toDouble();
        
        print('✅ Retirement plan loaded');
      } else {
        print('ℹ️ No retirement plan found');
      }
    } catch (e) {
      print('❌ Error loading retirement plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Set retirement goal
  Future<void> setRetirementGoal(double target, int years) async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      isLoading.value = true;

      // Calculate monthly contribution needed
      final monthsToRetirement = years * 12;
      final remainingAmount = target - currentSavings.value;
      final calculatedMonthly = remainingAmount / monthsToRetirement;

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('retirement_plan')
          .doc('current_plan')
          .set({
        'targetAmount': target,
        'yearsToRetirement': years,
        'currentSavings': currentSavings.value,
        'monthlyContribution': calculatedMonthly,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local values
      targetAmount.value = target;
      yearsToRetirement.value = years;
      monthlyContribution.value = calculatedMonthly;

      print('✅ Retirement goal set: GHS $target in $years years');
    } catch (e) {
      print('❌ Error setting retirement goal: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Update current savings
  Future<void> updateSavings(double amount) async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final newSavings = currentSavings.value + amount;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('retirement_plan')
          .doc('current_plan')
          .update({
        'currentSavings': newSavings,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      currentSavings.value = newSavings;

      print('✅ Savings updated: GHS $newSavings');
    } catch (e) {
      print('❌ Error updating savings: $e');
      rethrow;
    }
  }

  // Get progress percentage
  double get progressPercentage {
    if (targetAmount.value == 0) return 0.0;
    return (currentSavings.value / targetAmount.value * 100).clamp(0.0, 100.0);
  }

  // Get remaining amount
  double get remainingAmount {
    return (targetAmount.value - currentSavings.value).clamp(0.0, double.infinity);
  }

  // Get monthly target
  double get monthlyTarget {
    return monthlyContribution.value;
  }

  // Reset plan
  Future<void> resetPlan() async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('retirement_plan')
          .doc('current_plan')
          .delete();

      targetAmount.value = 0.0;
      yearsToRetirement.value = 0;
      currentSavings.value = 0.0;
      monthlyContribution.value = 0.0;

      print('✅ Retirement plan reset');
    } catch (e) {
      print('❌ Error resetting plan: $e');
      rethrow;
    }
  }
}