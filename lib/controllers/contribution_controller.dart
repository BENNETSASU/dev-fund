// lib/controllers/contribution_controller.dart
import 'package:get/get.dart';

class ContributionController extends GetxController {
  final RxDouble amount = 0.0.obs;

  void addAmount(double value) => amount.value += value;
  void reset() => amount.value = 0.0;
}