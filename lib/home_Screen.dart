import 'package:e_course_app/addCourse_screen.dart';
import 'package:e_course_app/enrollmentCourse_screen.dart';
import 'package:e_course_app/scheduleCourse_screen.dart';
import 'package:e_course_app/examResult_screen.dart';
import 'package:e_course_app/util/emoticonFace.dart';
import 'package:e_course_app/util/menu_tile.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  final String username;

  const homeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 112, 106),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${widget.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Welcome To Smart E-Course Apps...!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.brown[800],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'How are you feel?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.waving_hand,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),

            //emoji
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //bad
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '😩'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Bad',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  //fine
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '😊'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Fine',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  //well
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '😆'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'well',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  //excellent
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '🥳'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Excellent',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Menu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          menu_tile(
                            icon: Icons.school,
                            menuTile: "Available Course",
                            color: Colors.purple,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addCourse(
                                          username: widget.username,
                                        )),
                              );
                            },
                          ),
                          menu_tile(
                            icon: Icons.how_to_reg,
                            menuTile: "Enrolled Course",
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnrollmentCourse(
                                        username: widget.username)),
                              );
                            },
                          ),
                          menu_tile(
                            icon: Icons.event,
                            menuTile: "Scheduled Course",
                            color: Colors.orange,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScheduleCourse()),
                              );
                            },
                          ),
                          menu_tile(
                            icon: Icons.assignment,
                            menuTile: "Exam Result",
                            color: Colors.redAccent,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/examRslt',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
