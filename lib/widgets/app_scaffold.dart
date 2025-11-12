// lib/widgets/app_scaffold.dart
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final Widget body;

  const AppScaffold({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (i) => onItemTapped(i),
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
    );
  }
}
