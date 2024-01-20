import 'package:e_course_app/model/course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class addCourse extends StatefulWidget {
  final String username;

  const addCourse({Key? key, required this.username}) : super(key: key);

  @override
  State<addCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<addCourse> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    // Fetch courses when the screen is initialized
    fetchCourses();
  }

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
        List<Course> fetchedCourses = [];
        data.forEach((key, value) {
          final courseData = value as Map<String, dynamic>;

          fetchedCourses.add(Course(
            CourseName: courseData['CourseName'],
            LecturerName: courseData['LecturerName'],
            CreditHours: courseData['CreditHours'],
            ClassDay: courseData['ClassDay'],
            ClassTime: courseData['ClassTime'],
            ClassVenue: courseData['ClassVenue'],
          ));
        });

        // Update the state to trigger a rebuild
        setState(() {
          courses = fetchedCourses;
        });

        return fetchedCourses;
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
    String classVenue,
  ) async {
    try {
      // Perform validation and enrollment logic here
      if (courseName.isNotEmpty &&
          lecturerName.isNotEmpty &&
          creditHour.isNotEmpty &&
          int.tryParse(creditHour) != null) {
        final url = Uri.https(
          'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
          'enrollments.json',
        );

        final response = await http.post(
          url,
          body: json.encode({
            'username': widget.username,
            'courseName': courseName,
            'lecturerName': lecturerName,
            'creditHour': int.parse(creditHour),
            'classDay': classDay,
            'classTime': classTime,
            'classVenue': classVenue,
          }),
        );

        if (response.statusCode == 200) {
          // Enrollment successful, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Enrollment Successful!'),
            ),
          );

          // Fetch the courses again after adding a new one
          await fetchCourses();
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
    }
  }

  void _showEnrollmentForm(BuildContext context) {
    TextEditingController courseNameController = TextEditingController();
    TextEditingController lecturerNameController = TextEditingController();
    TextEditingController creditHourController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enrollment Form'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter enrollment details here...'),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: courseNameController,
                      decoration: InputDecoration(
                        labelText: 'Course Name',
                        // Add validation if needed
                      ),
                    ),
                    TextFormField(
                      controller: lecturerNameController,
                      decoration: InputDecoration(
                        labelText: 'Lecturer Name',
                        // Add validation if needed
                      ),
                    ),
                    TextFormField(
                      controller: creditHourController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Credit Hour',
                        // Add validation if needed
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleEnrollment(
                  courseNameController.text,
                  lecturerNameController.text,
                  creditHourController.text,
                  '', // Add the appropriate values for classDay, classTime, and classVenue
                  '',
                  '',
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Enroll'),
            ),
          ],
        );
      },
    );
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
        child: ListView.builder(
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
                      Icon(Icons.school),
                      SizedBox(width: 10.0),
                      Text(courses[index].CourseName),
                    ],
                  ),
                  subtitle: Text('Tap to view details'),
                  initiallyExpanded: false,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 221, 162, 162),
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Lecturer: ${courses[index].LecturerName}'),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 221, 162, 162),
                      child: ListTile(
                        leading: Icon(Icons.schedule),
                        title:
                            Text('Credit Hours: ${courses[index].CreditHours}'),
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
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEnrollmentForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
