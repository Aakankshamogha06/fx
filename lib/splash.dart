import 'package:new_app/2a.dart';
import 'package:new_app/Animations/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_app/slider1.dart';

import 'package:flutter_screenshot_disable/flutter_screenshot_disable.dart';
import 'dart:ui';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  AnimationController? _scaleController;
  AnimationController? _scale2Controller;
  AnimationController? _widthController;
  AnimationController? _positionController;

  Animation<double>? _scaleAnimation;
  Animation<double>? _scale2Animation;
  Animation<double>? _widthAnimation;
  Animation<double>? _positionAnimation;

  bool hideIcon = false;

  SharedPreferences? prefs;
  bool isLoggedIn = false;

  bool _disableScreenshot = false;


  @override
  void dispose() {
    // Dispose of your AnimationControllers here
    _scaleController?.dispose();
    _scale2Controller?.dispose();
    _widthController?.dispose();
    _positionController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeScreenshotSettings();
    checkLoginStatus();

    try {
      _scaleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      // Initialize other controllers here
    } catch (e) {
      // Handle any initialization errors
      print('Error initializing animation controllers: $e');
    }


    _scaleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    );

    _scaleAnimation = Tween<double>(
        begin: 1.0, end: 0.8
    ).animate(_scaleController!)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkLoginStatus();
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyImageWithButtonScreen()));
        _widthController?.forward();
      }
    });

    _widthController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600)
    );

    _widthAnimation = Tween<double>(
        begin: 80.0,
        end: 300.0
    ).animate(_widthController!)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _positionController?.forward();
      }
    });

    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );

    _positionAnimation = Tween<double>(
        begin: 0.0,
        end: 215.0
    ).animate(_positionController!)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          hideIcon = true;
        });
        _scale2Controller?.forward();
      }
    });

    _scale2Controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _scale2Animation = Tween<double>(
        begin: 1.0,
        end: 32.0
    ).animate(_scale2Controller!)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {

      }
    });
  }

  void checkLoginStatus() async {
    prefs = await SharedPreferences?.getInstance();
    bool isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  // void saveLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', true);
  // }


  void _initializeScreenshotSettings() async {
    bool flag = !_disableScreenshot;
    await FlutterScreenshotDisable.disableScreenshot(flag);

    // Use setState to trigger a rebuild of the widget tree
    setState(() {
      _disableScreenshot = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () async {
      // Handle the back button press
      // Use SystemNavigator.pop to exit the app
          exit(0);
      return false; // Return false to prevent the app from popping the current route
    },
    child:
    Scaffold(
      // backgroundColor: Colors.red,
      backgroundColor: const Color(0xffffc400),
      body: SingleChildScrollView(
        child:
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -50,
                left: 0,
                child: FadeAnimation(1, Container(
                  width: width,
                  height: height * .3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/one.png'),
                          fit: BoxFit.cover
                      )
                  ),
                )),
              ),
              Positioned(
                top: -100,
                left: 0,
                child: FadeAnimation(1.3, Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/one.png'),
                          fit: BoxFit.cover
                      )
                  ),
                )),
              ),
              Positioned(
                top: -150,
                left: 0,
                child: FadeAnimation(1.6, Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/one.png'),
                          fit: BoxFit.cover
                      )
                  ),
                )),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(1, Image.asset('assets/images/MicrosoftTeams-image166fb87a34f356ec84747339b223195637acc5d9882d988615452c61fc25f37e.png',width: 200,height: 200,)),
                    SizedBox(height: height*0.2),
                    FadeAnimation(1, const Text("Welcome",
                        style: TextStyle(color: Colors.black, fontSize: 35,fontFamily:'FontMain' ))),
                    const SizedBox(height: 15,),
                    FadeAnimation(1.3, const Text("to FXCareers!",
                      style: TextStyle(color: Colors.black, height: 1.4, fontSize: 35, ),)),
                    SizedBox(height: height*0.1,),
                    FadeAnimation(1.6, AnimatedBuilder(
                      animation: _scaleController!,
                      builder: (context, child) => Transform.scale(
                          scale: _scaleAnimation!.value,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _widthController!,
                              builder: (context, child) => Container(
                                width: _widthAnimation!.value,
                                height: 80,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.black.withOpacity(.4)
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _scaleController?.forward();
                                  },
                                  child: hideIcon == false ? Icon(Icons.arrow_forward, color: Colors.black,) : Container(),

                                ),
                              ),
                            ),
                          )),
                    )),
                    SizedBox(height: 60,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
