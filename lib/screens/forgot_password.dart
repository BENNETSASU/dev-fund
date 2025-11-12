// ============================================
// lib/screens/forgot_password.dart - UPDATED
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../views/input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _emailSent = false;

  // Get AuthController safely
  AuthController get _auth => Get.find<AuthController>();

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _auth.sendPasswordResetEmail(_emailCtrl.text.trim());

      setState(() => _emailSent = true);

      // Show success message
      Get.snackbar(
        'Success',
        'Password reset email sent! Check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 4),
      );

      // Navigate back after delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Get.back();
      }
    } catch (e) {
      // Error already handled in AuthController
      // Only log in debug mode
      if (kDebugMode) {
        debugPrint('Password reset error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Icon
                Icon(
                  _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                  size: 80,
                  color: _emailSent ? Colors.green : const Color(0xFF2E7D32),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _emailSent ? 'Check Your Email' : 'Forgot Password?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  _emailSent
                      ? 'We\'ve sent password reset instructions to your email address.'
                      : 'Enter your email address and we\'ll send you instructions to reset your password.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  // Email Field
                  InputField(
                    controller: _emailCtrl,
                    label: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Send Button
                  ElevatedButton(
                    onPressed: _loading ? null : _sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Send Reset Link',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Back to Login
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Back to Login'),
                  ),
                ] else ...[
                  // Success State
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 48,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Email Sent Successfully!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your inbox and follow the instructions to reset your password.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resend Button
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _emailSent = false);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Send to Different Email'),
                  ),
                  const SizedBox(height: 12),

                  // Back Button
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Back to Login'),
                  ),
                ],

                const SizedBox(height: 24),

                // Help Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Didn\'t receive the email?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Check your spam or junk folder\n'
                        '• Make sure the email address is correct\n'
                        '• Wait a few minutes and try again',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}