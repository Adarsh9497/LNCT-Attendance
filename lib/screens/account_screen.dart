import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/models/sharedpref.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ui elements/webviewscreen.dart';
import 'login_screen.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  String version = '';

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      setState(() {});
    });
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
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 120.w,
                    child: const Image(
                      image: AssetImage('images/lnct_logo.png'),
                    ),
                  ),
                  title: Text(
                    loginProvider.data['name'],
                    textScaleFactor: 1.0,
                    style: GoogleFonts.questrial(
                      fontSize: 60.sp,
                      color: kLightGreen,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      loginProvider.data['username'],
                      style: GoogleFonts.questrial(
                        fontSize: 46.sp,
                        color: kLightYellow,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      GestureDetector(
                        onTap: () async {
                          String url =
                              'https://sites.google.com/view/lnctattendance-privacy-policy/home';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                        url: url,
                                        title: 'Privacy Policy',
                                      )));
                        },
                        child: const UserCards(
                          icon: Icons.document_scanner_rounded,
                          name: 'Privacy Policy',
                          colour: Colors.green,
                          borderColor: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    navigateButton(
                        title: 'Linkedin',
                        url:
                            'https://www.linkedin.com/in/adarsh-soni-7892aa198/',
                        iconData: FontAwesomeIcons.linkedin),
                    navigateButton(
                      title: 'Github',
                      url: 'https://github.com/Adarsh9497/LNCT-Attendance',
                      iconData: FontAwesomeIcons.github,
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              String url =
                                  'https://myattendance.page.link/lnctattendance';
                              await FlutterShare.share(
                                title: 'LNCT Attendance App',
                                text:
                                    'Now check your college attendance status anytime, anywhere with this attendance app!\nDownload now on playstore:\nhttps://myattendance.page.link/lnctattendance',
                              );
                            },
                            icon: Icon(
                              FontAwesomeIcons.shareNodes,
                              color: kWhite,
                              size: 80.sp,
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Share app',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: kWhite, fontSize: 40.sp),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WebViewScreen(
                                            url:
                                                'https://docs.google.com/forms/d/e/1FAIpQLScDmkXUWGhC03BAbkIMG_jaYwyOICSmnqslJigu0l67tXN2Zg/viewform?usp=sf_link',
                                            title: 'Feedback',
                                          )));
                            },
                            icon: Icon(
                              FontAwesomeIcons.bug,
                              color: kWhite,
                              size: 80.sp,
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Feedback',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: kWhite, fontSize: 40.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 200.h,
                ),
                Text(
                  'v $version',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 45.sp,
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navigateButton(
      {required String title,
      required String url,
      required IconData iconData}) {
    return Column(
      children: [
        IconButton(
            onPressed: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch url';
              }
            },
            icon: Icon(
              iconData,
              color: kWhite,
              size: 80.sp,
            )),
        SizedBox(
          height: 10.h,
        ),
        Text(
          title,
          textScaleFactor: 1.0,
          style: TextStyle(color: kWhite, fontSize: 40.sp),
        ),
      ],
    );
  }
}

class UserCards extends StatelessWidget {
  const UserCards(
      {required this.icon,
      required this.name,
      required this.colour,
      this.borderColor});
  final IconData icon;
  final String name;
  final Color colour;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
              color: borderColor ?? kCardBackgroundColor, width: 2.0)),
      child: ListTile(
        leading: Icon(
          icon,
          color: colour,
          size: 60.sp,
        ),
        title: Text(
          name,
          maxLines: 2,
          textScaleFactor: 1.0,
          style: GoogleFonts.questrial(
            fontSize: 46.sp,
            color: colour,
          ),
        ),
      ),
    );
  }
}
