import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ui elements/constants.dart';

class DateWise extends StatefulWidget {
  @override
  _DateWiseState createState() => _DateWiseState();
}

class _DateWiseState extends State<DateWise> {
  List<String> litems = ["1", "2", "Third", "4"];

  bool isLoading = false;
  dynamic data;
  dynamic initialData;
  String to = "";
  String from = '';
  bool error = false;
  bool isDisposed = false;
  int fromIndex = 0;
  int toEnd = 0;
  List<DropdownMenuItem> dates = [];

  void search(DateTime date) {
    // String fromPre = from;
    // String toPre = to;
    String month = shortMonths[date.month];
    int currdate = date.day;
    String day = (currdate < 10) ? ("0${date.day}") : date.day.toString();
    String year = date.year.toString();
    String finalDate = '$day $month $year';
    print(finalDate);
    bool isFound = false;
    List temp = [];
    for (var i in data[0]) {
      if (i['date'] == finalDate) {
        isFound = true;
        from = finalDate;
        to = finalDate;
        temp.add(i);
        break;
      }
      print(i['date']);
    }
    if (isFound) {
      setState(() {
        initialData = temp;
      });
    }
    if (!isFound) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text(
                'Date not Found',
                style: TextStyle(color: kWhite),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ))
              ],
            );
          });
    }
  }

  void setDatesRange() {
    bool start = false;
    List temp = [];
    for (var i in data[0]) {
      if (i['date'] == from) {
        start = true;
      }
      if (start) {
        temp.add(i);
      }
      if (i['date'] == to) {
        break;
      }
    }

    setState(() {
      initialData = temp;
    });
  }

  void load() async {
    var udata = Provider.of<UserData>(context, listen: false);
    try {
      try {
        dynamic res;
        if (udata.dateWiseData == null) {
          res = await udata.datewise();
          udata.dateWiseData = res;
          udata.notify();
        } else {
          res = udata.dateWiseData;
        }
        if (isDisposed) {
          return;
        }
        setState(() {
          isLoading = false;
          data = res;
          initialData = res[1];
          for (var i in initialData) {
            if (from == null) {
              from = i['date'].toString();
            }
          }
          to = res[1][0]['date'].toString();
        });
      } catch (err) {
        setState(() {
          isLoading = false;
          error = true;
        });
      }
    } catch (err) {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    error = false;

    load();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (isLoading) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text('Date Wise Attendance'),
          backgroundColor: kBackgroundColor,
        ),
        body: const Center(
            child: CircularProgressIndicator(
          color: kLightGreen,
        )),
      );
    }
    if (error) {
      return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: const Text('Date Wise Attendance'),
            backgroundColor: kBackgroundColor,
          ),
          body: const Center(
              child: Icon(
            Icons.error,
            color: Colors.red,
            size: 60,
          )));
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              dynamic date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019, 8),
                lastDate: DateTime(2050, 10),
              );
              search(date);
            } catch (err) {
              print('err');
            }
          },
          child: const Center(
              child: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: kWhite,
          )),
        ),
        appBar: AppBar(
            backgroundColor: kBackgroundColor,
            title: const AutoSizeText(
              'Date Wise Attendance',
              maxLines: 1,
              minFontSize: 0,
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    initialData = List.from(initialData.reversed);
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: const Icon(FontAwesomeIcons.sort),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    from = data[0][0]['date'];
                    to = data[1][0]['date'];
                    initialData = data[1];
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: const Icon(Icons.refresh),
                ),
              ),
            ]),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 100.w),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                // color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.check,
                        color: kLightGreen,
                      ),
                      Text(
                        'Present',
                        style: GoogleFonts.questrial(
                            color: kWhite, fontSize: 48.sp),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      const Icon(
                        Icons.close,
                        color: kLightRed,
                      ),
                      Text(
                        'Absent',
                        style: GoogleFonts.questrial(
                            color: kWhite, fontSize: 48.sp),
                      ),
                    ])),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: ScrollController(),
                  itemCount: initialData.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
                      child: Card(
                        color: kCardBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(
                              color: Color(0x90758AA7), width: 1.5),
                        ),
                        elevation: 6.0,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 50.h, horizontal: 10.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                initialData[index]['date'],
                                style: GoogleFonts.questrial(
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                    letterSpacing: 1.1,
                                    fontSize: 50.sp),
                              ),
                              attendanceWrapper(initialData[index]['data'])
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }

  Widget attendanceWrapper(List dataa) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataa.length,
        padding: EdgeInsets.symmetric(vertical: 25.h),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, int index) {
          return attendance(dataa[index]);
        });
  }

  Widget attendance(dynamic d) {
    String heading = '';
    String value = '';
    d.forEach((key, val) {
      heading = key;
      value = val;
    });
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              heading,
              softWrap: true,
              // overflow: TextOverflow.ellipsis,
              style: GoogleFonts.questrial(fontSize: 48.sp, color: kWhite),
            ),
          ),
          (value == 'P')
              ? const Icon(
                  Icons.check,
                  color: kLightGreen,
                )
              : const Icon(
                  Icons.close,
                  color: kLightRed,
                ),
        ],
      ),
    );
  }
}
