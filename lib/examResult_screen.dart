import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExamResult extends StatefulWidget {
  final String username;

  const ExamResult({Key? key, required this.username}) : super(key: key);

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  TextEditingController courseController = TextEditingController();
  TextEditingController lecturerController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  List<Map<String, String>> examResults = [];

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
        }
      }
    } catch (error) {
      print('Error fetching enrollments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Exam Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Background5.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter Exam Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: courseController,
                    decoration: InputDecoration(labelText: 'Course Name'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: lecturerController,
                    decoration: InputDecoration(labelText: 'Lecturer Name'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: marksController,
                    decoration: InputDecoration(labelText: 'Marks'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle saving the entered data
                          String courseName = courseController.text;
                          String lecturerName = lecturerController.text;
                          String marks = marksController.text;

                          // Save the data to the list
                          examResults.add({
                            'Course Name': courseName,
                            'Lecturer Name': lecturerName,
                            'Marks': marks,
                          });

                          // Update the UI to reflect the changes
                          setState(() {
                            // Clear the text fields after saving
                            courseController.clear();
                            lecturerController.clear();
                            marksController.clear();
                          });
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle updating the entered data
                          String updatedCourse = courseController.text;
                          String updatedLecturer = lecturerController.text;
                          String updatedMarks = marksController.text;

                          // Find the index of the entry to update
                          int index = examResults.indexWhere((result) =>
                              result['Course Name'] == updatedCourse);

                          if (index != -1) {
                            // Update the data in the list
                            examResults[index]['Lecturer Name'] =
                                updatedLecturer;
                            examResults[index]['Marks'] = updatedMarks;

                            // Update the UI to reflect the changes
                            setState(() {
                              // Clear the text fields after updating
                              courseController.clear();
                              lecturerController.clear();
                              marksController.clear();
                            });
                          }
                        },
                        child: Text('Update'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle deleting the entered data
                          String courseToDelete = courseController.text;

                          // Find the index of the entry to delete
                          int index = examResults.indexWhere((result) =>
                              result['Course Name'] == courseToDelete);

                          if (index != -1) {
                            // Delete the data from the list
                            examResults.removeAt(index);

                            // Update the UI to reflect the changes
                            setState(() {
                              // Clear the text fields after deleting
                              courseController.clear();
                              lecturerController.clear();
                              marksController.clear();
                            });
                          }
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Exam Results List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display the current exam results
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: examResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            'Course: ${examResults[index]['Course Name']}'),
                        subtitle: Text(
                            'Lecturer: ${examResults[index]['Lecturer Name']}, Marks: ${examResults[index]['Marks']}'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Enable editing by setting the controllers to be editable
          courseController
            ..text = "Previous Course"; // Set with the student's existing data
          lecturerController
            ..text =
                "Previous Lecturer"; // Set with the student's existing data
          marksController
            ..text = "Previous Marks"; // Set with the student's existing data

          // Update the UI to reflect the changes
          setState(() {});
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExamResult(username: "sample_username"), // Provide a sample username
  ));
}
