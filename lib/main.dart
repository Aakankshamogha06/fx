import 'package:flutter/material.dart';
import 'package:new_app/splash.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenshot_disable/flutter_screenshot_disable.dart';
import 'package:new_app/view/demo_session.dart';
import 'package:new_app/view/my_offers_data.dart';
import 'package:new_app/view/offers.dart';
import 'package:new_app/view/offers_spin_wheel.dart';
import 'package:new_app/view/profile.dart';
import 'package:new_app/view/register_otp.dart';


void main() async{
  // for lock the Portrait view
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(),

    routes: {
        '/profile': (context) => const MyProfile(),
      '/offers': (context) => const MyOffers(),
      '/offersData':(context) => SpinWheel(),
      '/registerOtp' :(context) => RegisterOtp(),
      '/Demosession' : (context) => DemoSession(),
    },
  ));

}
