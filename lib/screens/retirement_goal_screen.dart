// lib/screens/retirement_goal_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/input_field.dart';
import '../controllers/plan_controller.dart';

class RetirementGoalScreen extends StatefulWidget {
  const RetirementGoalScreen({super.key});
  @override
  State<RetirementGoalScreen> createState() => _RetirementGoalScreenState();
}

class _RetirementGoalScreenState extends State<RetirementGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _planCtrl = Get.find();
  bool _isLoading = false;

  Future<void> _setGoal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final target = double.parse(_targetCtrl.text);
      final years = int.parse(_yearsCtrl.text);
      await _planCtrl.setRetirementGoal(target, years);
      Get.back();
      Get.snackbar('Success', 'Goal saved!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Retirement Goal')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Define your retirement dream',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              InputField(
                controller: _targetCtrl,
                label: 'Target Amount (GHS)',
                prefixIcon: Icons.savings,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null ||
                      double.tryParse(v) == null ||
                      double.parse(v) <= 0) {
                    return 'Enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InputField(
                controller: _targetCtrl,
                label: 'Target Amount (GHS)',
                prefixIcon: Icons.savings,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null ||
                      double.tryParse(v) == null ||
                      double.parse(v) <= 0) {
                    return 'Enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _setGoal,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Goal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
