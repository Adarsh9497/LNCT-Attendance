import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_lnctattendance/models/sharedpref.dart';
import 'package:new_lnctattendance/models/userdata.dart';
import 'package:new_lnctattendance/screens/attendance_screen.dart';
import 'package:new_lnctattendance/screens/login_screen.dart';
import 'package:new_lnctattendance/ui%20elements/colors.dart';
import 'package:provider/provider.dart';

Map data = {};
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPref.init();
  final name = MySharedPref.getField(keyName);
  final imageUrl = MySharedPref.getField(keyImageURL);
  final username = MySharedPref.getField(keyUserName);
  final password = MySharedPref.getField(keyPassword);
  final lnctu = MySharedPref.getField(keyLnctu);
  final branch = MySharedPref.getField(keyBranch);
  final semester = MySharedPref.getField(keySem);
  final gender = MySharedPref.getField(keyGender);
  data = {
    'name': name,
    'imageUrl': imageUrl,
    'username': username,
    'password': password,
    'lnctu': lnctu,
    'branch': branch,
    'semester': semester,
    'gender': gender
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserData(data),
      child: ScreenUtilInit(
        designSize: const Size(1080, 2340),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: kBackgroundColor,
            scaffoldBackgroundColor: kBackgroundColor,
          ),
          home: MySharedPref.getField(keyUserName) == null
              ? const Login()
              : AttendanceScreen(),
        ),
      ),
    );
  }
}
