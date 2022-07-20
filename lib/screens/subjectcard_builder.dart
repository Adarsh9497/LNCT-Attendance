import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/screens/subject_cards.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/userdata.dart';

class SubjectCardBuilder extends StatelessWidget {
  int length = 0;

  Color getcolor(double percent) {
    if (percent >= 80.0) {
      return kLightGreen;
    } else if (percent >= 75.0) {
      return kLightYellow;
    } else {
      return kLightRed;
    }
  }

  Widget listViewWidget(List<Subjectdata> data) {
    List<SubjectsCard> subjectcard = [];
    for (int i = 0; i < 2; i++) {
      subjectcard.add(SubjectsCard(
        percent: data[i].percentage,
        subject: data[i].subject,
        msg:
            '${data[i].present} out of ${data[i].totallectures} classes Attended',
        colour: getcolor(data[i].percentage),
      ));
    }

    return Column(
      children: subjectcard,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData loginProvider = Provider.of<UserData>(context);
    length = loginProvider.subjectwisedata.length;
    return ((length != 0)
        ? listViewWidget(loginProvider.subjectwisedata)
        : Container(
            margin: const EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: Text(
              (loginProvider.isSubjecterror == false)
                  ? "Press 'Refresh' to load"
                  : "Error",
              style: GoogleFonts.questrial(
                color: kWhite,
                fontSize: 45.sp,
              ),
            )));
  }
}
