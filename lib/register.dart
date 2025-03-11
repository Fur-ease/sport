import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _autoValidate = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Future<void> registerUser() async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text);
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
         'name': _nameController.text,
         'secondName': _secondNameController.text,
         'email': _emailController.text,
       });
      //Fluttertoast.showToast(msg: 'Registration Successful');
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

     
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed("/login");
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during registration.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }
      // Fluttertoast.showToast(
      //   msg: errorMessage,
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
   } 

  @override
  void dispose() {
    _nameController.dispose();
    _secondNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    final nameRegExp = RegExp(r'^[a-zA-Z]+(?:[-\s][a-zA-Z]+)*$');
    if (!nameRegExp.hasMatch(value)) {
      return "Please enter a valid name";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm password";
    }
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          Navigator.of(context).pushReplacementNamed('/login');
        });
        return Future.value(true);
      },
      child: Scaffold(
        body: content(),
      ),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate 
            ? AutovalidateMode.onUserInteraction 
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            Container(
              height: 270,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(50, 50)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Image.asset("images/shot.png",
                        width: 250, height: 190),
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            inputStyle(
              "Name :",
              "Enter your name",
              Icons.person,
              controller: _nameController,
              validator: validateName,
            ),
            inputStyle(
              "Second name :",
              "Enter your second name",
              Icons.person,
              controller: _secondNameController,
              validator: validateName,
            ),
            inputStyle(
              "Email :",
              "myemail@gmail.com",
              Icons.mail,
              controller: _emailController,
              validator: validateEmail,
            ),
            inputStyle(
              "Password :",
              "Myword@123",
              Icons.lock,
              isPassword: true,
              controller: _passwordController,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: validatePassword,
            ),
            inputStyle(
              "Confirm :",
              "Myword@123",
              Icons.lock,
              controller: _confirmPasswordController,
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: validateConfirmPassword,
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _autoValidate = true;
                  });
                  // Check if all inputs are valid
                  if (_formKey.currentState!.validate()) {
                    registerUser();
                    // Show loading dialog only when inputs are valid
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    // // Simulate a delay for registration success
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context); 
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Navigate to login after showing snackbar
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      });
                    });
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(color: Colors.greenAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
