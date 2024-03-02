import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<String?> _signIn(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    var uid = credential.user?.uid;
    if (uid == "UQFYFsUXnLbxhLivf7X2XUhuQXC2") {
       Navigator.pushNamed(context,"/staff-home-page");
      print("Staff has Sign In");
    } else if (uid == "gROiWhOTXxYtGgiIU2rJFz0HOYC3") {
      //TODO implement admin app
      print("Admin has Sign In");
    } else {
      //TODO implement go to homepage
      print("User has Sign In");
    }
    return uid;

  } on FirebaseAuthException catch (e) {
    String errorMessage = "An error occurred. Please try again.";
    if (e.code == 'invalid-credential') {
      errorMessage = "Incorrect Email or Password. Please try again.";
    } 
    
    // Show error using SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );

    return null;
  }
}

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSignInText(),
                _buildEmailTextField(),
                _buildPasswordTextField(),
                _buildSignInButton(),
                _buildSignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30, top: 150),
      child: Text(
        "Sign in",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'helloworld@gmail.com',
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(fontSize: 18, color: Colors.black),
          suffixIcon: GestureDetector(
            onTap: _togglePasswordVisibility,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          border: OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2.0,
            ),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppTheme.primaryColor),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () async {
                var uid = await _signIn(
                    _emailController.text, _passwordController.text);
              },
              child: const Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don’t have an account? "),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/sign-up"),
          child: const Text(
            "Sign up",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
