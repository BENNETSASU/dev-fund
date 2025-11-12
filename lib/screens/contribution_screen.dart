// lib/screens/contribution_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contribution_controller.dart';

class ContributionScreen extends StatelessWidget {
  const ContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContributionController ctrl = Get.find<ContributionController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Contribute')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                'Current: \$${ctrl.amount.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => ctrl.addAmount(10),
              child: const Text('Add \$10'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: ctrl.reset,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
