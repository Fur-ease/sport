//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

    Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();
        
        // Validate email format using regex
        if (!_isValidEmail(email)) {
          _showSnackBar('Invalid email format', isError: true);
          return;
        }

        // Check if user exists
        try {
          // Attempt to fetch sign-in methods to verify email existence
          List<String> signInMethods = 
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

          if (signInMethods.isEmpty) {
            // No sign-in methods found, meaning email is not registered
            _showSnackBar('No account found with this email', isError: true);
            return;
          }

          // Send password reset email
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

          _showSnackBar('Password reset email sent successfully', isError: false);

          Navigator.of(context).pushReplacementNamed('/login');

        } on FirebaseAuthException catch (authError) {
          // Handle specific Firebase Auth errors
          String errorMessage;
          switch (authError.code) {
            case 'user-not-found':
              errorMessage = "No account found with this email";
              break;
            case 'invalid-email':
              errorMessage = "Invalid email address format";
              break;
            case 'network-request-failed':
              errorMessage = "Network error. Please check your connection";
              break;
            default:
              errorMessage = authError.message ?? "Authentication failed";
          }

          _showSnackBar(errorMessage, isError: true);
        }
      } catch (e) {
        _showSnackBar('An unexpected error occurred', isError: true);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Custom SnackBar method (remove duplicate)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Email validation method (remove duplicate)
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { 
        setState(() {
          Navigator.of(context).pushReplacementNamed('/login');
        });
        return Future.value(false);
       },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.arrow_back_ios_new
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : resetPassword,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
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