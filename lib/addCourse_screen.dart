import 'package:e_course_app/model/course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class addCourse extends StatefulWidget {
  final String username;

  const addCourse({Key? key, required this.username}) : super(key: key);

  @override
  State<addCourse> createState() => _addCourseState();
}

class _addCourseState extends State<addCourse> {
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.https(
        'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
        'Course.json',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      if (data != null) {
        List<Course> courses = [];
        data.forEach((key, value) {
          final courseData = value as Map<String, dynamic>;

          courses.add(Course(
            CourseName: courseData['CourseName'],
            LecturerName: courseData['LecturerName'],
            CreditHours: courseData['CreditHours'],
            ClassDay: courseData['ClassDay'],
            ClassTime: courseData['ClassTime'],
            ClassVenue: courseData['ClassVenue'],
          ));
        });

        return courses;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  Future<void> _handleEnrollment(
      String courseName,
      String lecturerName,
      String creditHour,
      String classDay,
      String classTime,
      String classVenue) async {
    try {
      // Perform validation and enrollment logic here
      if (courseName.isNotEmpty &&
          lecturerName.isNotEmpty &&
          creditHour.isNotEmpty &&
          int.tryParse(creditHour) != null) {
        // Perform enrollment logic here, e.g., make a POST request
        final url = Uri.https(
          'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
          'enrollments.json',
        );

        final response = await http.post(
          url,
          body: json.encode({
            'username': widget.username,
            'courseName': courseName,
            'lecturerName': lecturerName, // Include lecturer name
            'creditHour': int.parse(creditHour),
            'classDay': classDay,
            'classTime': classTime,
            'classVenue': classVenue,
          }),
        );

        if (response.statusCode == 200) {
          // Enrollment successful, update UI or show a message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Enrollment Successful!'),
            ),
          );
          // You may want to fetch enrollments again to update the list
          // fetchEnrollments(); // Commented out, as it is not part of addCourse screen
        } else {
          // Failed to enroll, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to enroll. Please try again.'),
            ),
          );
        }
      } else {
        // Show an error message or handle validation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields correctly!'),
          ),
        );
      }
    } catch (error) {
      print('Error handling enrollment: $error');
      // Handle error gracefully, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Course List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Background2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Course> courses = snapshot.data as List<Course>;

              // Debug print to check fetched data
              print('Fetched courses: $courses');

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Icon(Icons.school), // Book icon
                            SizedBox(width: 10.0),
                            Text(courses[index].CourseName),
                          ],
                        ),
                        subtitle: Text('Tap to view details'),
                        initiallyExpanded:
                            false, // Set to false to start collapsed
                        children: [
                          Container(
                            color: Colors.brown[
                                200], // Set your desired background color
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                  'Lecturer: ${courses[index].LecturerName}'),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            color: Colors.brown[
                                200], // Set your desired background color
                            child: ListTile(
                              leading: Icon(Icons.schedule),
                              title: Text(
                                  'Credit Hours: ${courses[index].CreditHours}'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _handleEnrollment(
                                  courses[index].CourseName,
                                  courses[index].LecturerName,
                                  courses[index].CreditHours.toString(),
                                  courses[index].ClassDay,
                                  courses[index].ClassTime.toString(),
                                  courses[index].ClassVenue,
                                );
                              },
                              child: Text('Enroll'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
