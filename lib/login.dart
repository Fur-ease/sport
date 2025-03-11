import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();

}

class UserService {
  static String? currentUsername;

  static void setCurrentUsername(String username) {
    currentUsername = username;
  }

  static String getCurrentUsername() {
    return currentUsername ?? "Guest";
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter username";
    }
    final nameRegExp = RegExp(r'^[a-zA-Z]+(?:[-\s][a-zA-Z]+)*$');
    if (nameRegExp.hasMatch(value)) {
      return "Please enter a valid name";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter";
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return "Password must contain at least one lowercase letter";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent[400]!,
                      Colors.green[700]!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.elliptical(80, 80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset(
                  "images/Log.png",
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.sports_soccer);
                  },
                ),
              ),
            ),
            const SizedBox(height: 35),
            inputStyle(
              "Username",
              "Enter your username",
              Icons.person,
              controller: _usernameController,
              validator: validateUsername,
            ),
            const SizedBox(height: 10),
            inputStyle(
              "Password",
              "Enter password",
              Icons.lock,
              controller: _passwordController,
              validator: validatePassword,
              isPassword: true,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    text: "Forgot password ?",
                    style: const TextStyle(color: Colors.greenAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed('/forgotpassword');
                      },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () async {
                  setState(() {
                  });
                  
                  if (_formKey.currentState!.validate()) {
                  
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                        
                    try {
                      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                        email: _usernameController.text, 
                        password: _passwordController.text,
                        );
                      UserService.setCurrentUsername(userCredential.user?.email ?? "Guest");
                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.pop(context);
                      
                      Navigator.of(context).pushReplacementNamed("/home");
                    } catch (e) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login failed: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } 
                    
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: "Register",
                    style: const TextStyle(color: Colors.greenAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed("/register");
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget inputStyle(String title, String hintext, IconData icon,
      {bool isPassword = false,
      VoidCallback? onToggleVisibility,
      bool obscureText = false,
      required String? Function(String?)? validator,
      required TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: isPassword ? obscureText : false,
              validator: validator,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintText: hintext,
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade300),
                errorStyle: const TextStyle(height: 0),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon, color: Colors.grey.shade400),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: onToggleVisibility,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

