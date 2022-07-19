import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectsCard extends StatelessWidget {
  const SubjectsCard(
      {required this.percent,
      required this.subject,
      required this.msg,
      required this.colour});
  final double percent;
  final String subject;
  final String msg;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Tooltip(
        message: 'Subject Attendance',
        child: Card(
          color: kCardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 6.0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 45.w,
              vertical: 45.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    subject,
                    style: GoogleFonts.questrial(
                      color: kWhite,
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          // width: MediaQuery.of(context).size.width - 150,
                          animation: true,
                          lineHeight: 18.h,
                          animationDuration: 1000,
                          percent: percent / 100,
                          barRadius: const Radius.circular(30),
                          progressColor: colour,
                          backgroundColor: const Color(0xFF212D49),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        '${percent.toStringAsFixed(1)}%',
                        maxLines: 1,
                        style: GoogleFonts.questrial(
                          color: colour,
                          fontSize: 52.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.questrial(
                      color: kWhite,
                      fontSize: 45.sp,
                    ),
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
