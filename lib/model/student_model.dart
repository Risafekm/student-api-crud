// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

List<Student> studentFromJson(String str) =>
    List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  String studentName;
  String studentClass;
  String teacherName;
  String parentName;
  String parentPh;
  String id;
  String rollNo;

  Student({
    required this.studentName,
    required this.studentClass,
    required this.teacherName,
    required this.parentName,
    required this.parentPh,
    required this.id,
    required this.rollNo,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        studentName: json["student_name"],
        studentClass: json["student_class"],
        teacherName: json["teacher_name"],
        parentName: json["parent_name"],
        parentPh: json["parent_ph"],
        id: json["id"],
        rollNo: json["roll_no"],
      );

  Map<String, dynamic> toJson() => {
        "student_name": studentName,
        "student_class": studentClass,
        "teacher_name": teacherName,
        "parent_name": parentName,
        "parent_ph": parentPh,
        "id": id,
        "roll_no": rollNo,
      };
}
