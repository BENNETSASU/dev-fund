// lib/model/retirement_plan.dart
class RetirementPlan {
  final String id;
  final double currentSavings;
  final double monthlyContribution;
  final double targetAmount;
  final int yearsToRetirement;

  RetirementPlan({
    required this.id,
    required this.currentSavings,
    required this.monthlyContribution,
    required this.targetAmount,
    required this.yearsToRetirement,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'currentSavings': currentSavings,
    'monthlyContribution': monthlyContribution,
    'targetAmount': targetAmount,
    'yearsToRetirement': yearsToRetirement,
  };
}
