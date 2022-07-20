import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/screens/percentage_card.dart';
import 'package:new_lnctattendance/screens/percentage_loading.dart';
import 'package:new_lnctattendance/screens/subjectcard_builder.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/userdata.dart';
import '../ui elements/constants.dart';
import 'account_screen.dart';
import 'datewise_screen.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = false;
  bool ploading = false;
  bool hideBanner = false;
  bool error = false;
  bool pressed = false;
  DateTime d = DateTime.now();
  String? dbImageURL;
  String? dbImageDataURL;
  bool showCross = false;
  String? imageTitle;

  String getsuperscript(int n) {
    if (n == 1 || n == 21) {
      return 'st';
    } else if (n == 2 || n == 22) {
      return 'nd';
    } else if (n == 3 || n == 23) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  String getUserName(UserData loginProvider) {
    String name = loginProvider.data['name'];
    int i;
    for (i = 0; i < name.length; i++) {
      if (name[i] == ' ') break;
    }

    return name.substring(0, i);
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    error = false;
    ploading = true;
    loadPercent();
    loadSubject();
    init();
  }

  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 30));
    setState(() {
      showCross = true;
    });
  }

  void init() async {
    bool showBanner = true;
    Map<String, dynamic>? data;
    var collection = FirebaseFirestore.instance.collection('admin');
    await collection.doc('banner').get().then((snapshot) {
      data = snapshot.data();
      if (data != null) {
        showBanner = data!['showBanner'] ?? true;
        if (showBanner == false) {
          return;
        }
        imageTitle = data!['title'];
        dbImageURL = data!['imageURL'];
        dbImageDataURL = data!['imageData'];
        startTimer();
        setState(() {});
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('$error');
        print("couldn't fetch data");
      }
    });
  }

  void loadPercent() async {
    try {
      await Provider.of<UserData>(context, listen: false).attendance();
      setState(() {
        ploading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        ploading = false;
      });
    }
  }

  void loadSubject() async {
    try {
      await Provider.of<UserData>(context, listen: false).sunjectwise();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        error = true;
      });
    }
  }

  void load() async {
    try {
      Provider.of<UserData>(context, listen: false).attendance();
      setState(() {
        ploading = false;
      });
      await Provider.of<UserData>(context, listen: false).sunjectwise();
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
        error = true;
        ploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserData loginProvider = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBackgroundColor,
        title: SizedBox(
          width: 0.6.sw,
          child: Text(
            'Welcome, ${getUserName(loginProvider)}',
            textScaleFactor: 1.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(
                Icons.account_circle,
                size: 30.0,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
            controller: ScrollController(),
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //TODO container for showing date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weekdays[d.weekday],
                          textScaleFactor: 1,
                          style: GoogleFonts.questrial(
                              fontSize: 42.sp, color: Colors.white),
                        ),
                        EasyRichText(
                          "${d.day}${getsuperscript(d.day)} ${months[d.month]}  ${d.year}",
                          patternList: [
                            EasyRichTextPattern(
                              targetString: '${d.day}',
                              style: GoogleFonts.questrial(
                                fontSize: 80.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            EasyRichTextPattern(
                              targetString: months[d.month],
                              style: GoogleFonts.questrial(
                                  fontSize: 60.sp, color: Colors.white),
                            ),
                            EasyRichTextPattern(
                              targetString: '${d.year}',
                              style: GoogleFonts.questrial(
                                  fontSize: 60.sp, color: Colors.white),
                            ),
                            EasyRichTextPattern(
                              targetString: getsuperscript(d.day),
                              superScript: true,
                              stringBeforeTarget: '${d.day}',
                              matchWordBoundaries: false,
                              style: GoogleFonts.questrial(
                                color: Colors.white,
                                fontSize: 60.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    if (hideBanner == false && dbImageURL != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30.h),
                                child: GestureDetector(
                                  onTap: () async {
                                    String url = dbImageDataURL ?? '';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch url';
                                    }
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 22 / 9,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(15), // Ima
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kCardBackgroundColor,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: dbImageURL ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (showCross)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hideBanner = true;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                            ],
                          ),
                          if (imageTitle != null)
                            Text(
                              imageTitle ?? '',
                              textScaleFactor: 1,
                              style: GoogleFonts.questrial(
                                fontWeight: FontWeight.w500,
                                color: kWhite,
                                fontSize: 43.sp,
                              ),
                            ),
                        ],
                      ),

                    Padding(
                      padding: EdgeInsets.only(top: 80.h, bottom: 20.h),
                      child: Text(
                        ' Overall Attendance',
                        style: GoogleFonts.questrial(
                          fontSize: 50.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    //TODO percentage Card
                    ((ploading && loginProvider.iserror == false) ||
                            (loginProvider.isViewAttendance &&
                                loginProvider.iserror == false &&
                                loginProvider.isSubjecterror == false))
                        ? const PercentageLoading()
                        : Percentage(),
                    //TODO date wise button
                    FlatButton(
                      color: Colors.indigo[400],
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                DateWise(),
                            transitionDuration: const Duration(seconds: 15),
                          ),
                        );
                      },
                      child: AutoSizeText(
                        'View Datewise Attendance',
                        maxLines: 1,
                        minFontSize: 0,
                        style: TextStyle(
                            fontSize: 45.sp,
                            color: kWhite,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    //TODO subject text
                    Padding(
                      padding: EdgeInsets.only(top: 80.h, bottom: 20.h),
                      child: Text(
                        ' Subjects',
                        style: GoogleFonts.questrial(
                          fontSize: 50.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    //TODO all subjects cards
                    (loginProvider.isViewAttendance &&
                            loginProvider.iserror == false &&
                            loginProvider.isSubjecterror == false)
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: kLightGreen,
                          ))
                        : (isLoading == false)
                            ? ((error)
                                ? Text(
                                    'Error',
                                    style: TextStyle(
                                        fontSize: 50.sp, color: kWhite),
                                  )
                                : SubjectCardBuilder())
                            : const Center(
                                child: CircularProgressIndicator(
                                color: kLightGreen,
                              )),

                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
