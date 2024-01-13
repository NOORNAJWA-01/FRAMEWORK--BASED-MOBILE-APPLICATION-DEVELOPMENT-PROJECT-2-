import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class signUpScreen extends StatefulWidget {
  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    // Check if any of the required fields are empty
    if (usernameController.text.isEmpty ||
        fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Show a SnackBar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.https(
      'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users.json',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Username': usernameController.text,
          'Fullname': fullnameController.text,
          'EmailAddress': emailController.text,
          'Password': passwordController.text,
        }),
      );
      print(response.body.toString());

      if (response.statusCode == 200) {
        // Sign-up successful, navigate to the home screen or perform any desired action
        Navigator.pushNamed(context, '/login');
      } else {
        // Sign-up failed, handle the error (you might want to show an error message)
        print('Failed to sign up. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during sign up: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.red, Colors.blue],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screen(),
      ),
    );
  }

  Widget _screen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon(),
          const SizedBox(height: 10),
          _inputField("Username", usernameController, prefixIcon: Icons.person),
          const SizedBox(height: 10),
          _inputField("Fullname", fullnameController, prefixIcon: Icons.person),
          const SizedBox(height: 10),
          _inputField("Email Address", emailController,
              prefixIcon: Icons.email),
          const SizedBox(height: 10),
          _inputField("Password", passwordController,
              isPassword: true, prefixIcon: Icons.lock),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to welcome screen
                    Navigator.pushNamed(
                      context,
                      '/',
                    );
                  },
                  child: Text("Back"),
                ),
              ),
              const SizedBox(width: 10), // Add spacing between buttons
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: signUp,
                  child: Text('Sign up'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false, IconData? prefixIcon}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.white,
              )
            : null,
      ),
      obscureText: isPassword,
      controller: controller,
    );
  }
}
