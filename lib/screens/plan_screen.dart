// lib/screens/plan_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Retirement Plan",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text("Target: GHS 100,000"),
              subtitle: const Text("Years left: 12"),
              trailing: const Icon(Icons.edit),
              onTap: () => Get.toNamed('/goal'),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Get.toNamed('/goal'),
            child: const Text("Edit Goal"),
          ),
        ],
      ),
    );
  }
}
