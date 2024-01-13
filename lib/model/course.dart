import 'package:flutter/material.dart';

class Course {
  const Course({
    //CONSTUCTOR
    required this.CourseName,
    required this.LecturerName,
    required this.CreditHours,
    required this.ClassDay,
    required this.ClassTime,
    required this.ClassVenue,
  });

  final String CourseName;
  final String LecturerName;
  final int CreditHours;
  final String ClassDay;
  final String ClassTime;
  final String ClassVenue;
}
