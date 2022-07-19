import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const baseUrl = 'https://newlnct.herokuapp.com';
const loginUrl = '$baseUrl/login?';
const attendanceUrl = '$baseUrl/?';
const dateWiseUrl = '$baseUrl/dateWise?';
const sujectWiseUrl = '$baseUrl/subjectwise?';
const getAttendaceDateWiseUrl = '$baseUrl/getDateWiseAttendance?';

class UserData with ChangeNotifier {
  Map data = {};
  var totalLectures = 0;
  var present = 0;
  var percentage = 0.0;
  var daysNeeded = 0;
  dynamic dateWiseData;

  bool isViewAttendance = false;
  bool iserror = false;
  bool isSubjecterror = false;

  UserData(this.data);

  void notify() {
    notifyListeners();
  }

  void viewAttendancePressed(bool ans) {
    isViewAttendance = ans;
    notifyListeners();
  }

  void resetErrors() {
    iserror = false;
    isSubjecterror = false;
    notifyListeners();
  }

  List<Subjectdata> subjectwisedata = [];

  dynamic fetch(String url) async {
    try {
      url =
          '${url}username=${data['username']}&password=${data['password']}&token=&';
      if (data['lnctu'] == 'true') {
        url = '${url}lnctu';
      }
      dynamic res = await http.get(Uri.parse(url));
      res = await jsonDecode(res.body);
      return res;
    } catch (err) {
      return throw Exception('sorry not able to connect');
    }
  }

  dynamic login(String username, String password, String lnctu) async {
    String url = loginUrl;
    try {
      url = '${url}username=$username&password=$password&token=&';
      if (lnctu == 'true') {
        url = '${url}lnctu';
      }
      dynamic res = await http.get(Uri.parse(url));
      res = await jsonDecode(res.body);
      data = {
        'name': res['Name'],
        'imageUrl': res['ImageUrl'],
        'username': username,
        'password': password,
        'lnctu': lnctu,
        'branch': res['Branch'],
        'semester': res['Semseter'],
        'gender': res['Gender']
      };
      return res;
    } catch (err) {
      return throw Exception('Error');
    }
  }

  Future<void> attendance() async {
    try {
      dynamic res = await fetch(attendanceUrl);
      dateWiseData = null;
      if (res['Percentage'] != null) {
        present = res['Present '];
        print('1');
        totalLectures = res['Total Lectures'];
        print('12');

        percentage = res['Percentage'].toDouble();
        print('13');

        daysNeeded = res['DaysNeeded'];
        print('14');

        print('percentage received');
      }
      iserror = false;
    } catch (e) {
      print(e);
      print('2');
      isViewAttendance = false;
      iserror = true;
    }
    notifyListeners();
  }

  dynamic datewise() async {
    return await fetch(dateWiseUrl);
  }

  Future<void> sunjectwise() async {
    List<Subjectdata> subjectdata;
    try {
      dynamic res = await fetch(sujectWiseUrl);
      dateWiseData = null;

      var data = res as List;
      print('Subjects data Received');
      subjectdata =
          data.map<Subjectdata>((json) => Subjectdata.fromJson(json)).toList();
      subjectwisedata = subjectdata;
      isSubjecterror = false;
    } catch (e) {
      print(e);
      print('1');
      isViewAttendance = false;
      isSubjecterror = true;
    }
    notifyListeners();
  }

  dynamic getdatewiseattendance() async {
    return await fetch(getAttendaceDateWiseUrl);
  }
}

class Subjectdata {
  var percentage;
  var subject;
  var totallectures;
  var present;

  Subjectdata(
      {this.percentage, this.subject, this.totallectures, this.present});

  factory Subjectdata.fromJson(Map<String, dynamic> json) {
    return Subjectdata(
      percentage: json["Percentage"],
      present: json["Present"],
      subject: json["Subject"],
      totallectures: json["TotalLectures"],
    );
  }
}
