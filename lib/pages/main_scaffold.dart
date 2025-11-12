// lib/pages/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../screens/plan_screen.dart';
import '../screens/contribution_screen.dart';
import '../screens/profile_screen.dart';

class TabController extends GetxController {
  final selectedIndex = 0.obs;
}

class MainScaffold extends GetView<TabController> {
  const MainScaffold({super.key});

  static final List<Widget> _pages = [
    const HomeScreen(),
    const PlanScreen(),
    const ContributionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Controller is already put in main.dart → **no Get.put here**
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (i) => controller.selectedIndex.value = i,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Plan'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Contribute',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
