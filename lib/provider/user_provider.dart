// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:studentapi/model/student_model.dart';

class UserProvider extends ChangeNotifier {
  List<Student> _posts = [];
  List<Student> get posts => _posts;
  bool isLoding = false;

  // post controller
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentClassController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentPhController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();

  //update Controller

  TextEditingController editstudentNameController = TextEditingController();
  TextEditingController editstudentClassController = TextEditingController();
  TextEditingController editteacherNameController = TextEditingController();
  TextEditingController editparentNameController = TextEditingController();
  TextEditingController editparentPhController = TextEditingController();
  TextEditingController editrollNoController = TextEditingController();

//post Data

  addData(context) async {
    String apiUrl = 'http://localhost/own/create.php';
    var userdata = Student(
      studentName: studentNameController.text,
      studentClass: studentClassController.text,
      teacherName: teacherNameController.text,
      parentName: parentNameController.text,
      parentPh: parentPhController.text,
      id: '',
      rollNo: rollNoController.text,
    );
    try {
      var bodyy = jsonEncode(userdata);
      var response = await http.post(
        Uri.parse(apiUrl),
        body: bodyy,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('successfully posted');
        var dataa = jsonDecode(response.body);
        snackbar(context, text: "added");
        await getData();
        print('Response body: $dataa');
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

//get Data

  getData() async {
    isLoding = true;
    String getUrl = 'http://localhost/own/read.php';
    try {
      var response = await http.get(Uri.parse(getUrl));
      if (response.statusCode == 200) {
        var data = List<Student>.from(
            jsonDecode(response.body).map((e) => Student.fromJson(e))).toList();
        if (data != null) {
          _posts = data;
          isLoding = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  //update data

  updateData(String i, context) async {
    Uri updateUrl = Uri.parse('http://localhost/own/update.php?id=$i');
    var data = Student(
      studentName: editstudentNameController.text,
      studentClass: editstudentClassController.text,
      teacherName: editteacherNameController.text,
      parentName: editparentNameController.text,
      parentPh: editparentPhController.text,
      id: i,
      rollNo: editrollNoController.text,
    );

    try {
      var response = await http.put(
        updateUrl,
        body: jsonEncode(data.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await getData();
        snackbar(context, text: "updated");
        print(" update success ${response.body}");
      }
    } catch (e) {
      print('Error updated failed: ${e.toString()}');
    }
    notifyListeners();
  }

  //delete

  deleteData(String i, context) async {
    Uri deleteUrl = Uri.parse('http://localhost/own/delete.php?id=$i');

    var response = await http.delete(deleteUrl);
    if (response.statusCode == 200) {
      snackbar(context, text: "deleted");
      getData();

      print('Successfully deleted');
    }
  }

  clear() {
    studentNameController.clear();
    studentClassController.clear();
    teacherNameController.clear();
    parentNameController.clear();
    parentPhController.clear();
    rollNoController.clear();
  }
  //snackBar

  snackbar(context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Row(
          children: [
            Expanded(child: Text('Successfully $text')),
            const SizedBox(
              width: 20,
            ),
            const Icon(Icons.done, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
