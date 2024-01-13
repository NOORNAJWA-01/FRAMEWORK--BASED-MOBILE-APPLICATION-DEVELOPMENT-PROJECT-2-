import 'package:e_course_app/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _error = '';

  void loginUser() async {
    final url = Uri.https(
      'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var user in data.keys) {
          if (data[user]['Username'] == usernameController.text &&
              data[user]['Password'] == passwordController.text) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    homeScreen(username: usernameController.text),
              ),
            );
            return;
          }
        }

        setState(() {
          _error = 'The Email or Password is incorrect';
        });
      }
    } catch (error) {
      print('Error during login request: $error');
      setState(() {
        _error =
            'An error occurred while trying to log in. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.purple,
            Colors.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screen(),
      ),
    );
  }

  Widget _screen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(
              height: 50,
            ),
            _inputField('Username', usernameController,
                isPassword: false, icon: Icons.person),
            const SizedBox(
              height: 25,
            ),
            _inputField('Password', passwordController,
                isPassword: true, icon: Icons.lock),
            const SizedBox(
              height: 20,
            ),
            // Display error message if it is not an empty string
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
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
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: loginUser,
                    child: Text("Log in"),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      {required bool isPassword, required IconData icon}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      obscureText: isPassword,
    );
  }
}
