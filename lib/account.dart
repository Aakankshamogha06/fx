import 'package:flutter/material.dart';
import 'package:new_app/splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:new_app/slider1.dart';
import 'package:new_app/2a.dart';
import 'package:new_app/url.dart';
import 'forget.dart';
import '2.dart';

import 'dart:async';
import 'package:page_transition/page_transition.dart';

class login extends StatefulWidget {

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  SharedPreferences? prefs;
  Timer? _logoutTimer;

  void saveLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('isLoggedIn', true);
  }

  final storage = FlutterSecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  bool isInputValid = false;

  bool _obscureText = true;


  @override
  void initState() {
    super.initState();
    initializeLogoutTimer();
    checkLoginStatus();
  }

  void initializeLogoutTimer() {
    const logoutDuration = Duration(days: 30);

    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }

  void logout() {
    // Add the logic to perform logout actions here
    clearLoginStatus();
    // Additional logout actions...
    // Navigate to the login screen after logout
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }


  void checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is already logged in, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      _startLogoutTimer(context);
    }
  }



  void _validateInput(String text) {
    setState(() {
      isInputValid = text.isNotEmpty;
    });
  }


  Future<void> login(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConstants.baseUrl}/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        initializeLogoutTimer();
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data: $responseData');

        if (responseData.containsKey('access_token')) {
          final String accessToken = responseData['access_token'];

          // Store the access token securely
          await storage.write(key: 'access_token', value: accessToken);

          print('Response data: $responseData');
          Fluttertoast.showToast(
            msg: "Login successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xffffc400),
            textColor: Colors.black,
            fontSize: 16.0,
          );

          // _startLogoutTimer();

          // Delayed logout after 5 seconds
          // Navigate to the home page
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startLogoutTimer(context);
          });
        } else {
          Fluttertoast.showToast(
            msg: "Login failed: Access token not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Login failed: Server error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e.toString());

      Fluttertoast.showToast(
        msg: "Login failed ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffffc400),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<void> displayTokenDetails() async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      print(accessToken);
      print('Decoded token: $decodedToken');

      // Example: Display the user's name from the decoded token
      final String userName = decodedToken['username'];
      final String mobileNumber = decodedToken['mobile_no'];
      print('Mobile number: $mobileNumber');

      Fluttertoast.showToast(
        msg: 'Welcome! $userName',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffffc400),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Access token not found',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _startLogoutTimer(BuildContext context) {
    // Set the duration for automatic logout (5 seconds in this case)
    const logoutDuration = Duration(hours: 2);

    // Create a new timer
    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;


    return WillPopScope(
        onWillPop: () async {

      Navigator.push(context, PageTransition(
          type: PageTransitionType.fade,
          child: MyImageWithButtonScreen())
      );
      // Handle the back button press here
      // Return true to allow the app to pop the current route, or false to prevent it
      // You can navigate to a different page or perform any custom logic here
      return true;
    },
    child:
      Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          alignment: Alignment.topLeft,

                          child:Image.asset(
                            'assets/images/fx.png',
                            width: width * 0.30, // Adjust the width as needed
                            height: height * 0.20,  // Adjust the height as needed
                          ),


                        ),

                        SizedBox(
                          width: width * 0.5,
                        ),
                      ],

                    ),
                    Text(
                      "Account Login",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                          color: Colors.black
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      width: width * 0.9,
                      height: height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.grey,
                            )
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width:  width * 0.6, // Adjust width as needed
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',

                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    SizedBox(
                      width: width * 0.9,
                      height: height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: isInputValid
                                    ? const Color(0xffffc400)
                                    : Colors.grey
                            )
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width:  width * 0.5, // Adjust width as needed
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  onChanged: (text) {
                                    _validateInput(text); // Call _validateInput here when the text changes
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent), // Set the color to transparent
                                    ),
                                    hintText: 'Password',

                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ]
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: password()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.white,
                    //       side: const BorderSide(
                    //           color: Colors.transparent
                    //       )
                    //   ),
                    //   child: const Text('Forget Password',
                    //     textAlign: TextAlign.left,
                    //     style:TextStyle(
                    //         decoration: TextDecoration.none,
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.bold
                    //     ) ,),
                    // ),



                    SizedBox(height: height * 0.4),

                    Align(
                        alignment: Alignment.bottomCenter,
                        child:SizedBox(
                          width: width * 0.9,
                          height: height * 0.05,
                          child: ElevatedButton(
                            onPressed: ()
                            {saveLoginStatus();

                            Future.delayed(Duration(seconds: 0), () {
                              login(emailController.text.toString(), passwordController.text.toString());
                            });

                            Future.delayed(Duration(seconds: 2),() {
                              displayTokenDetails();
                            });

                            initializeLogoutTimer();
                            },
                            child: Text('Log in ',
                              style:TextStyle(
                                  decoration: TextDecoration.none,
                                  color: isInputValid
                                      ? Colors.black
                                      : Colors.grey
                              ) ,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInputValid
                                  ? Color(0xffffc400) // Change the button color when input is valid
                                  : Colors.white70,
                            ),
                          ),
                        )
                    ),




                  ],
                ),
              )
          )

      )
      );
  }
  @override
  void dispose() {
    // Cancel the logout timer when the widget is disposed
    _logoutTimer?.cancel();
    super.dispose();
  }

}
