import 'package:e_course_app/model/course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleCourse extends StatefulWidget {
  @override
  State<ScheduleCourse> createState() => _ScheduleCourseState();
}

class _ScheduleCourseState extends State<ScheduleCourse> {
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.https(
        'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
        'enrollments.json',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      print(response.body);
      if (data != null) {
        List<Course> courses = [];
        data.forEach((key, value) {
          final courseData = value as Map<String, dynamic>;

          courses.add(Course(
            CourseName: courseData['courseName'],
            LecturerName: courseData['lecturerName'],
            CreditHours: courseData['creditHour'],
            ClassDay: courseData['classDay'],
            ClassTime: courseData['classTime'],
            ClassVenue: courseData['classVenue'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Scheduled Course',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Background4.jpeg'),
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
                        color: Color.fromARGB(255, 178, 157, 157),
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
                            color: Colors.grey[400],
                            child: ListTile(
                              leading: Icon(Icons.calendar_month),
                              title: Text(
                                  'Day : ${courses[index].ClassDay ?? "N/A"}'),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            color: Colors.grey[400],
                            child: ListTile(
                              leading: Icon(Icons.location_city_outlined),
                              title: Text(
                                  'Venue: ${courses[index].ClassVenue ?? "N/A"}'),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            color: Colors.grey[400],
                            child: ListTile(
                              leading: Icon(Icons.schedule),
                              title: Text(
                                  'Time: ${courses[index].ClassTime ?? "N/A"}'),
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
