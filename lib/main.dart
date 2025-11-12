// ============================================
// lib/main.dart - FINAL FIXED VERSION
// ============================================
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/onboarding_controller.dart';
import 'controllers/contribution_controller.dart';
import 'pages/main_scaffold.dart' as main_scaffold; // <-- for TabController

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. GetStorage
    await GetStorage.init();
    print('GetStorage initialized');

    // 2. Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized');

    // 3. App Check
    await _setupAppCheck();

    // 4. **ALL** Controllers – put **once**, **permanent**
    Get.put(AuthController(), permanent: true);
    Get.put(OnboardingController(), permanent: true);
    Get.put(main_scaffold.TabController(), permanent: true); // <-- NEW
    Get.put(ContributionController(), permanent: true); // <-- NEW
    print('Controllers initialized');

    await Future.delayed(const Duration(milliseconds: 300));

    runApp(const RetireWiseApp());
  } catch (e, stackTrace) {
    print('Initialization Error: $e');
    print('Stack trace: $stackTrace');
    runApp(ErrorApp(error: e.toString()));
  }
}

Future<void> _setupAppCheck() async {
  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
    );
    print('App Check: DEBUG mode enabled');
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      print('=====================================');
      print('DEBUG TOKEN: $token');
      print('=====================================');
    } catch (e) {
      print('Failed to get debug token: $e');
    }
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
    );
    print('App Check: PRODUCTION mode enabled');
  }
}

class RetireWiseApp extends StatelessWidget {
  const RetireWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RetireWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.getPages(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SelectableText(error, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                const Text(
                  'Check console for full details',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
