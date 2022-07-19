import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/models/sharedpref.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_screen.dart';

class Profile extends StatelessWidget {
  String getTh(String n) {
    if (n == '1') {
      return 'st';
    } else if (n == '2') {
      return 'nd';
    } else if (n == '3') {
      return 'rd';
    } else {
      return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    UserData loginProvider = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBackgroundColor,
        title: const Text('Profile'),
        actions: [
          TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: kBackgroundColor,
                        title: const Text(
                          "Logout of App?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kWhite),
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: const Text("Logout"),
                                onPressed: () async {
                                  MySharedPref.deleteAll();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                      (route) => false);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red, fontSize: 50.sp),
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 150.w,
                  child: const Image(
                    image: AssetImage('images/lnct_logo.png'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  margin: EdgeInsets.symmetric(vertical: 60.h),
                  color: kCardBackgroundColor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserCards(
                        icon: Icons.perm_identity,
                        name: loginProvider.data['name'],
                        colour: kLightGreen,
                      ),
                      UserCards(
                        icon: Icons.verified_user,
                        name: loginProvider.data['username'],
                        colour: kLightYellow,
                      ),
                      UserCards(
                        icon: Icons.school,
                        name: (loginProvider.data['lnctu'] == true)
                            ? 'LNCTU'
                            : 'LNCT',
                        colour: kLightRed,
                      ),
                      UserCards(
                        icon: Icons.menu_book,
                        name:
                            "${loginProvider.data['semester']}${getTh(loginProvider.data['semester'])} Semester",
                        colour: Colors.white70,
                      ),
                      UserCards(
                        icon: Icons.menu_book,
                        name: loginProvider.data['branch'],
                        colour: kLightYellow,
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    String url =
                        'https://www.linkedin.com/in/adarsh-soni-7892aa198/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.link,
                        color: kLightYellow,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          'Developed by Adarsh Soni',
                          maxLines: 1,
                          minFontSize: 0,
                          style: GoogleFonts.questrial(
                            decoration: TextDecoration.underline,
                            color: kLightYellow,
                            fontSize: 50.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserCards extends StatelessWidget {
  const UserCards(
      {required this.icon, required this.name, required this.colour});
  final IconData icon;
  final String name;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: kCardBackgroundColor, width: 2.0)),
      child: ListTile(
        leading: Icon(
          icon,
          color: colour,
          size: 60.sp,
        ),
        title: Text(
          name,
          maxLines: 2,
          style: GoogleFonts.questrial(
            fontSize: 55.sp,
            color: colour,
          ),
        ),
      ),
    );
  }
}
