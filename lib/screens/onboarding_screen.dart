// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingController _onboardingController = Get.find();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Finance Services",
      "description":
          "You can enjoy the seamless finance services Investment and Loan Management, Flexible Approval and Easy Withdrawals",
      "icon": Icons.assessment_outlined,
    },
    {
      "title": "Fast & Reliable Finance Service",
      "subtitle": "How it works",
      "steps": [
        "1. Apply",
        "2. Get Approved",
        "3. Set-up",
        "4. Enroll Members",
        "5. Manage Growth",
      ],
      "icon": Icons.phone_iphone,
    },
    {
      "title": "About Dev Fund",
      "description":
          "Dev Fund revolutionizes provident fund management with cutting-edge technology, providing seamless investment management, flexible withdrawals, and comprehensive loan services. Our platform empowers companies and their employees to build a secure financial future together.",
      "icon": Icons.security_outlined,
    },
  ];

  void _completeOnboarding() {
    _onboardingController.completeOnboarding();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index], index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? Color(0xFF00BCD4)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Next/Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00BCD4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> data, int index) {
    if (index == 1) {
      // Special layout for "How it works" page
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phone illustration
            Container(
              height: 280,
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    data["icon"],
                    size: 100,
                    color: Color(0xFF00BCD4),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.payment,
                    size: 60,
                    color: Color(0xFF00BCD4).withOpacity(0.7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              data["title"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              data["subtitle"] ?? "",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Steps
            ...List.generate(
              data["steps"].length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  data["steps"][i],
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default layout for other pages
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            height: 280,
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                data["icon"],
                size: 120,
                color: Color(0xFF00BCD4),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            data["title"],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            data["description"],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
                  