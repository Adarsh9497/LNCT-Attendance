import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentageLoading extends StatelessWidget {
  const PercentageLoading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        baseColor: const Color(0x70758AA7),
        highlightColor: const Color(0xff758AA7),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 800.h,
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Center(
                child: AutoSizeText(
                  'Fetching Attendance from Accsoft..',
                  maxLines: 1,
                  minFontSize: 0,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.w),
                      height: 120.h,
                      color: kCardBackgroundColor,
                    ),
                  ),
                  Container(
                    height: 120.h,
                    width: 2.0,
                    color: const Color(0x95758AA7),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.w),
                      height: 120.h,
                      color: kCardBackgroundColor,
                    ),
                  ),
                  Container(
                    height: 120.h,
                    width: 2.0,
                    color: const Color(0x95758AA7),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.w),
                      height: 120.h,
                      color: kCardBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
