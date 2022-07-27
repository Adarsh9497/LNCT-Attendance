import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_lnctattendance/models/sharedpref.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'attendance_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _lnctu = false;
  bool collegeEnabled = false;
  bool showCollegeError = false;
  String msg = "";
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  _launchURL({String option = 'signup'}) async {
    var url = 'http://portal.lnct.ac.in/Accsoft2/Parents/ParentSingUp.aspx';
    if (_lnctu) {
      url = 'http://portal.lnctu.ac.in/Accsoft2/Parents/ParentSingUp.aspx';
    }
    if (option == 'forgetPass') {
      url = 'http://portal.lnct.ac.in/Accsoft2/ForgetPasswd.aspx?Type=S';
      if (_lnctu) {
        url = 'http://portal.lnctu.ac.in/Accsoft2/ForgetPasswd.aspx?Type=S';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget activity() {
    if (isLoading) {
      return const SpinKitRipple(color: Colors.green);
    }

    return Text(
      msg,
      style: const TextStyle(
          color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  late int accStatusCode;

  void init() async {
    dynamic status = await http
        .get(Uri.parse('http://portal.lnct.ac.in/Accsoft2/studentLogin.aspx'));
    print(status.statusCode);
    setState(() {
      accStatusCode = status.statusCode;
      if (accStatusCode != 200) {
        msg = "Accsoft servers are down at the moment. Please come back later!";
      }
    });
  }

  void login() async {
    if (isLoading == true) return null;
    setState(() => isLoading = true);
    String password = Uri.encodeComponent(_pass.text).toString();
    String lnctu = _lnctu ? 'true' : 'false';
    try {
      dynamic res = await Provider.of<UserData>(context, listen: false)
          .login(_id.text, password, lnctu);
      await MySharedPref.setField(id: _id.text, key: keyUserName);
      await MySharedPref.setField(id: password, key: keyPassword);
      await MySharedPref.setField(id: res['Name'], key: keyName);
      await MySharedPref.setField(id: res['ImageUrl'], key: keyImageURL);
      await MySharedPref.setField(id: lnctu, key: keyLnctu);
      await MySharedPref.setField(id: res['Semseter'], key: keySem);
      await MySharedPref.setField(id: res['Branch'], key: keyBranch);
      await MySharedPref.setField(id: res['Gender'], key: keyGender);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AttendanceScreen()));
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        msg = 'Id or Password is not Valid!';
      });
    }
    setState(() {
      _pass.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
                child: Text(
              'Logging you in...',
              style: TextStyle(
                  fontSize: 60.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )),
          ],
        )),
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'LNCT ATTENDANCE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 50.h),
                padding: EdgeInsets.symmetric(horizontal: 70.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 150.w,
                      child: Image.asset('images/lnct_logo.png'),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    if (msg.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.w, vertical: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade900,
                              size: 55.sp,
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Flexible(
                              child: Text(msg,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 45.sp,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 50.h,
                    ),
                    TextFormField(
                      controller: _id,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'AccSoft id is required!';
                        }
                        if (value.length < 5) {
                          return 'Invalid AccSoft id';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.white, height: 1.5, fontSize: 50.sp),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(
                          Icons.perm_identity_rounded,
                          color: Colors.white,
                          size: 60.sp,
                        ),
                        isDense: true,
                        labelText: 'AccSoft ID',
                        labelStyle: const TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _pass,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Colors.white,
                              height: 1.5,
                              fontSize: 50.sp),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.white,
                              size: 60.sp,
                            ),
                            isDense: true,
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _launchURL(option: 'forgetPass');
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 40.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      'Select College',
                      style: TextStyle(color: Colors.white, fontSize: 50.sp),
                    ),
                    if (showCollegeError == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          const Text(
                            'Please select college',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                collegeEnabled = true;
                                _lnctu = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: (collegeEnabled == true &&
                                          _lnctu == false)
                                      ? Colors.grey.shade500
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  border: (collegeEnabled == true &&
                                          _lnctu == false)
                                      ? null
                                      : Border.all(
                                          color: Colors.grey.shade500)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 20.h),
                              child: Text(
                                'LNCT',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                collegeEnabled = true;

                                _lnctu = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: (collegeEnabled == true &&
                                          _lnctu == true)
                                      ? Colors.grey.shade500
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      (collegeEnabled == true && _lnctu == true)
                                          ? null
                                          : Border.all(
                                              color: Colors.grey.shade500)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 20.h),
                              child: Text(
                                'LNCTU',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50.sp),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kLightGreen,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              collegeEnabled == true) {
                            login();
                          } else if (collegeEnabled == false) {
                            setState(() {
                              showCollegeError = true;
                            });
                          } else {
                            setState(() {
                              showCollegeError = false;
                            });
                          }
                        },
                        child: Text(
                          '      Login      ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                      onPressed: () {
                        _launchURL();
                      },
                      child: Text(
                        'New Student? Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 45.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
