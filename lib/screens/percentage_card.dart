import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Percentage extends StatefulWidget {
  @override
  _PercentageState createState() => _PercentageState();
}

class _PercentageState extends State<Percentage> {
  bool isSafe = false;
  bool buttonPressed = false;

  Widget getStatus(double percent, int daysNeeded) {
    if (percent >= 75.0) {
      return EasyRichText(
        "Pheww... You're  Safe !",
        defaultStyle: GoogleFonts.questrial(fontSize: 50.sp, color: kWhite),
        patternList: [
          EasyRichTextPattern(
              targetString: ' Safe',
              stringBeforeTarget: "You're",
              style: GoogleFonts.questrial(
                fontSize: 50.sp,
                color: kLightGreen,
                fontWeight: FontWeight.bold,
              )),
        ],
      );
    } else {
      double short = (75.0 - percent);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 13),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: kLightYellow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.dangerous,
              color: Colors.black,
              size: 80.sp,
            ),
            SizedBox(
              width: 25.w,
            ),
            Expanded(
              child: Text(
                  "You're short by ${short.toStringAsFixed(1)}%. You can make it up by attending $daysNeeded ${(daysNeeded == 1) ? 'day' : 'days'} more.",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 46.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ],
        ),
      );
    }
  }

  Widget showMsg() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white.withOpacity(0.6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.dangerous,
            color: Colors.black,
            size: 80.sp,
          ),
          SizedBox(
            width: 25.w,
          ),
          Expanded(
            child: Text(
                "Sorry! There's been an error on server side or classes for this semester haven't started yet. We’ll update this message when classes start. Have a great day!",
                style: TextStyle(
                  fontSize: 45.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData loginProvider = Provider.of<UserData>(context);
    return Column(
      children: [
        //TODO percentage Card widget
        Card(
          color: kCardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 6.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularPercentIndicator(
                      animationDuration: 1000,
                      circularStrokeCap: CircularStrokeCap.butt,
                      animation: true,
                      curve: Curves.decelerate,
                      radius: 1.sw / 4.8,
                      lineWidth: (1.sw / 5) / 3.5,
                      percent: (loginProvider.iserror == false)
                          ? loginProvider.percentage / 100
                          : 0,
                      center: Container(
                        margin: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText(
                              (loginProvider.iserror == false)
                                  ? "${loginProvider.percentage.toStringAsFixed(1)}%"
                                  : "Error",
                              maxLines: 1,
                              minFontSize: 0,
                              style: GoogleFonts.questrial(
                                fontSize: 80.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              'Present',
                              maxLines: 1,
                              minFontSize: 0,
                              style: GoogleFonts.questrial(
                                fontSize: 48.sp,
                                color: kLightGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: kLightRed,
                      progressColor: kLightGreen,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: kLightGreen,
                                ),
                                AutoSizeText(' Attended',
                                    maxLines: 1,
                                    minFontSize: 0,
                                    style: GoogleFonts.questrial(
                                      color: Colors.white,
                                      fontSize: 48.sp,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: kLightRed,
                                ),
                                AutoSizeText(' Skipped',
                                    maxLines: 1,
                                    minFontSize: 0,
                                    style: GoogleFonts.questrial(
                                      color: kWhite,
                                      fontSize: 48.sp,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                        Tooltip(
                          message: 'Refresh',
                          child: RawMaterialButton(
                            shape: const CircleBorder(),
                            elevation: 6.0,
                            fillColor: Colors.indigo[400],
                            onPressed: () async {
                              loginProvider.resetErrors();
                              loginProvider.viewAttendancePressed(true);
                              loginProvider.attendance();
                              await loginProvider.sunjectwise();
                              loginProvider.viewAttendancePressed(false);
                              setState(() {
                                buttonPressed = true;
                              });
                            },
                            constraints: BoxConstraints.tightFor(
                              width: 150.w,
                              height: 150.w,
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: kWhite,
                              size: 80.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.h,
                ),
                (loginProvider.iserror == false)
                    ? getStatus(
                        loginProvider.percentage, loginProvider.daysNeeded)
                    : showMsg(),
              ],
            ),
          ),
        ),

        //TODO Container below percentage Card
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 45.h,
          ),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0x99758AA7),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColumnBelowCard(
                  number: loginProvider.totalLectures, name: 'Total'),
              Container(
                height: 120.h,
                width: 2.0,
                color: const Color(0x95758AA7),
              ),
              ColumnBelowCard(number: loginProvider.present, name: 'Attended'),
              Container(
                height: 120.h,
                width: 2.0,
                color: const Color(0x95758AA7),
              ),
              ColumnBelowCard(
                  number: loginProvider.totalLectures - loginProvider.present,
                  name: 'Skipped'),
            ],
          ),
        ),
      ],
    );
  }
}

class ColumnBelowCard extends StatelessWidget {
  ColumnBelowCard({required this.number, required this.name});
  int number;
  String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$number',
          style: GoogleFonts.questrial(
              color: Colors.white,
              fontSize: 80.sp,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '$name',
          style: GoogleFonts.questrial(
            color: Colors.white,
            fontSize: 38.sp,
          ),
        ),
      ],
    );
  }
}
