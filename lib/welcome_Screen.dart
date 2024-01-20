import 'package:e_course_app/login_Screen.dart';
import 'package:e_course_app/signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: Image.asset(
              "images/Background1.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: height * 0.32,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Lets Start",
                    style: GoogleFonts.lexend(
                      fontSize: width * 0.058,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Success is a series of small things",
                    style: GoogleFonts.lexend(
                      fontSize: width * 0.040,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to login Screen
                      Navigator.pushNamed(
                        context,
                        '/login',
                      );
                    },
                    child: Container(
                      height: height * 0.065,
                      width: width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Log in",
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Don't have account?",
                      style: GoogleFonts.lexend(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up screen
                        Navigator.pushNamed(
                          context,
                          '/signUp',
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.lexend(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: height * 0.02,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
