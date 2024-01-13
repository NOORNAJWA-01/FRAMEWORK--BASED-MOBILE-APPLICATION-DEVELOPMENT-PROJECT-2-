import 'package:e_course_app/scheduleCourse_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnrollmentCourse extends StatefulWidget {
  final String username;

  const EnrollmentCourse({Key? key, required this.username}) : super(key: key);

  @override
  State<EnrollmentCourse> createState() => _EnrollmentCourseState();
}

class _EnrollmentCourseState extends State<EnrollmentCourse> {
  List<Map<String, dynamic>> enrollments = [];

  Future<void> fetchEnrollments() async {
    try {
      final response = await http.get(
        Uri.https(
          'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
          'enrollments.json',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Map<String, dynamic>> userEnrollments = [];
          data.forEach((key, value) {
            final enrollmentData = value as Map<String, dynamic>;

            if (enrollmentData['username'] == widget.username) {
              userEnrollments.add({
                'id': key,
                'courseName': enrollmentData['courseName'],
                'lecturerName': enrollmentData['lecturerName'],
                'creditHour': enrollmentData['creditHour'],
              });
            }
          });

          setState(() {
            enrollments = userEnrollments;
          });
        }
      } else {
        throw Exception('Failed to load enrollments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching enrollments: $error');
      // Handle error gracefully, e.g., show an error message to the user
    }
  }

  Future<void> _deleteEnrollment(Map<String, dynamic> enrollment) async {
    try {
      // Perform deletion logic here, e.g., make a DELETE request
      final enrollmentId = enrollment[
          'id']; // Assuming you have an 'id' field in your enrollments
      final url = Uri.https(
        'smartstudyhub-36264-default-rtdb.asia-southeast1.firebasedatabase.app',
        'enrollments/$enrollmentId.json',
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Deletion successful, update UI or show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enrollment Deleted!'),
          ),
        );
        fetchEnrollments();
      } else {
        // Failed to delete, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete enrollment. Please try again.'),
          ),
        );
      }
    } catch (error) {
      print('Error deleting enrollment: $error');
      // Handle error gracefully, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Enrolled Course',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Background3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: enrollments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 163, 147, 147),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.school), // Book icon
                        SizedBox(width: 10.0),
                        Text(enrollments[index]['courseName']),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lecturer: ${enrollments[index]['lecturerName']}'),
                        Text(
                            'Credit Hours: ${enrollments[index]['creditHour']}'),
                        SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            _viewSchedule(enrollments[index]);
                          },
                          icon: Icon(Icons.remove_red_eye_rounded),
                          label: Text('View Schedule'),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteEnrollment(enrollments[index]);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
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
                );
              },
              child: Text('Enroll'),
            ),
          ],
        );
      },
    );
  }

  void _viewSchedule(Map<String, dynamic> enrollment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleCourse(),
      ),
    );
  }

  // Call fetchEnrollments when the screen is created
  @override
  void initState() {
    super.initState();
    fetchEnrollments();
  }

  Future<void> _handleEnrollment(
    String courseName,
    String lecturerName,
    String creditHour,
  ) async {
    try {
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
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Enrollment Successful!'),
            ),
          );
          fetchEnrollments();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to enroll. Please try again.'),
            ),
          );
        }
      } else {
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
}
