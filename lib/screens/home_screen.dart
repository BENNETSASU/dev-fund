// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/action_button.dart';
import '../widgets/summary_card.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back, John!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const SummaryCard(),
          const SizedBox(height: 20),
          _quickActions(),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        ActionButton(icon: Icons.flag, label: "Set Goal", route: '/goal'),
        // Switch to tab instead of route
        ActionButton(
          icon: Icons.attach_money,
          label: "Contribute",
          onTap: () => Get.find<TabController>().animateTo(2),
        ),
        ActionButton(
          icon: Icons.show_chart,
          label: "View Plan",
          onTap: () => Get.find<TabController>().animateTo(1),
        ),
        ActionButton(icon: Icons.history, label: "History", route: '/home'),
      ],
    );
  }
}
