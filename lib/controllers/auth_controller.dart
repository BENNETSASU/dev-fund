// lib/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GetStorage for local persistence
  final _storage = GetStorage();

  // Observable states
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  // Storage keys
  static const String _rememberMeKey = 'remember_me';
  static const String _emailKey = 'saved_email';

  @override
  void onInit() {
    super.onInit();
    print('🔧 AuthController initialized');

    // Bind Firebase user to observable
    firebaseUser.bindStream(_auth.authStateChanges());

    // Listen to auth state changes
    ever(firebaseUser, _handleAuthChanged);

    // Check initial auth state
    _checkInitialAuthState();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ AuthController ready');
  }

  /// Check if user is already logged in on app start
  void _checkInitialAuthState() {
    final user = _auth.currentUser;
    if (user != null) {
      print('✅ User already logged in: ${user.email}');
      isLoggedIn.value = true;
      firebaseUser.value = user;
    } else {
      print('ℹ️ No user logged in');
      isLoggedIn.value = false;
    }
  }

  /// Handle authentication state changes
  void _handleAuthChanged(User? user) {
    if (user == null) {
      print('🚪 User signed out');
      isLoggedIn.value = false;
    } else {
      print('✅ User signed in: ${user.email}');
      isLoggedIn.value = true;
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      print('🔐 Attempting sign in for: $email');

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        print('✅ Sign in successful: ${result.user!.email}');

        // Save email if remember me is enabled
        if (_storage.read(_rememberMeKey) ?? false) {
          await _storage.write(_emailKey, email);
        }

        isLoggedIn.value = true;
        firebaseUser.value = result.user;
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      _handleAuthException(e);
      rethrow;
    } catch (e) {
      print('❌ Unexpected error during sign in: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign up with email and password
  Future<void> signUp(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      isLoading.value = true;
      print('📝 Attempting sign up for: $email');

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Update display name if provided
        if (displayName != null && displayName.isNotEmpty) {
          await result.user!.updateDisplayName(displayName);
        }

        // Send verification email
        await result.user!.sendEmailVerification();

        print('✅ Sign up successful: ${result.user!.email}');

        Get.snackbar(
          'Success',
          'Account created! Please verify your email.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );

        isLoggedIn.value = true;
        firebaseUser.value = result.user;
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      _handleAuthException(e);
      rethrow;
    } catch (e) {
      print('❌ Unexpected error during sign up: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      print('🚪 Signing out...');

      await _auth.signOut();

      isLoggedIn.value = false;
      firebaseUser.value = null;

      print('✅ Sign out successful');

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Success',
        'Signed out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error during sign out: $e');
      Get.snackbar(
        'Error',
        'Failed to sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      print('📧 Sending password reset email to: $email');

      await _auth.sendPasswordResetEmail(email: email);

      print('✅ Password reset email sent');

      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      _handleAuthException(e);
      rethrow;
    } catch (e) {
      print('❌ Error sending password reset email: $e');
      Get.snackbar(
        'Error',
        'Failed to send reset email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reload current user data
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      firebaseUser.value = _auth.currentUser;
      print('✅ User data reloaded');
    } catch (e) {
      print('❌ Error reloading user: $e');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('✅ Verification email sent');

        Get.snackbar(
          'Success',
          'Verification email sent. Please check your inbox.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error sending verification email: $e');
      Get.snackbar(
        'Error',
        'Failed to send verification email.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) await user.updateDisplayName(displayName);
        if (photoURL != null) await user.updatePhotoURL(photoURL);
        await reloadUser();

        print('✅ Profile updated');
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Change password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user?.email == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      print('✅ Password changed successfully');
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      _handleAuthException(e);
      rethrow;
    } catch (e) {
      print('❌ Error changing password: $e');
      Get.snackbar(
        'Error',
        'Failed to change password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user account
  Future<void> deleteAccount(String password) async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user?.email == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Delete account
      await user.delete();

      print('✅ Account deleted');
      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Success',
        'Account deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      _handleAuthException(e);
      rethrow;
    } catch (e) {
      print('❌ Error deleting account: $e');
      Get.snackbar(
        'Error',
        'Failed to delete account.',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle Firebase Auth exceptions
  void _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No account found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'invalid-email':
        message = 'Invalid email address.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Use at least 6 characters.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      case 'requires-recent-login':
        message = 'Please sign in again to perform this action.';
        break;
      default:
        message = 'Authentication failed: ${e.message}';
    }

    Get.snackbar(
      'Authentication Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  /// Save/load remember me preference
  void setRememberMe(bool value) {
    _storage.write(_rememberMeKey, value);
  }

  bool getRememberMe() {
    return _storage.read(_rememberMeKey) ?? false;
  }

  String? getSavedEmail() {
    return _storage.read(_emailKey);
  }

  /// Check if current user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get current user email
  String? get userEmail => _auth.currentUser?.email;

  /// Get current user display name
  String? get userName => _auth.currentUser?.displayName;

  /// Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // At the very bottom of the file, replace the getter:
  get user =>
      firebaseUser; // <-- ADD THIS LINE (replaces the old `get user => null;`)
  @override
  void onClose() {
    print('🔧 AuthController disposed');
    super.onClose();
  }
}
