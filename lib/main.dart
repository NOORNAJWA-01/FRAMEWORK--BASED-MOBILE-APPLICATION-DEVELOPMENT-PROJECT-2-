import 'package:e_course_app/addCourse_screen.dart';
import 'package:e_course_app/enrollmentCourse_screen.dart';
import 'package:e_course_app/examResult_screen.dart';
import 'package:e_course_app/home_Screen.dart';
import 'package:e_course_app/login_Screen.dart';

import 'package:e_course_app/scheduleCourse_screen.dart';
import 'package:e_course_app/signUp_screen.dart';
import 'package:e_course_app/welcome_Screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => welcomeScreen(),
      '/signUp': (context) => signUpScreen(),
      '/login': (context) => loginScreen(),
      '/home': (context) => homeScreen(
            username: '',
          ),
      '/addCourse': (context) => addCourse(
            username: '',
          ),
      '/schedule': (context) => ScheduleCourse(),
      '/enrollment': (context) => EnrollmentCourse(username: ''),
      '/examRslt': (context) => ExamResult(),
    });
  }
}
