// widgets/summary_card.dart
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Text("Current Savings", style: TextStyle(fontSize: 18)),
            Text(
              "GHS 45,200",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.45,
              backgroundColor: Colors.grey,
            ),
            Text("45% to goal", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}