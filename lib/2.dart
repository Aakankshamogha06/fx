import 'package:flutter/material.dart';
import 'package:new_app/splash.dart';
import 'package:new_app/account.dart';
import 'package:new_app/profile.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';


class ImageWithButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  ImageWithButton({this.imagePath = '', required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;


    return WillPopScope(
              onWillPop: () async {

                exit(0);
            // Handle the back button press here
            // Return true to allow the app to pop the current route, or false to prevent it
            // You can navigate to a different page or perform any custom logic here
            return true;
          },
          child: Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [

          SizedBox(height: screenHeight * 0.15),
          Image.asset(
            imagePath,
            width: screenWidth * 0.8, // Adjust the width as needed
            height: screenHeight * 0.2,// Adjust the height as needed
          ),

          Text("Get yourself career ready! ",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: screenHeight * 0.03,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),

          Center(
            child: Text("with FXCareers ",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: screenHeight * 0.03,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),),
          ),
          SizedBox(height: screenHeight * 0.01),


          Center(
            child: Text("Embark your journey with  us...",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: screenHeight * 0.02,
                color: Colors.grey,
              ),),
          ),

          SizedBox(
            height: screenHeight * 0.1,
          ),

          Align(
              alignment: Alignment.bottomCenter,
              child:SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.06,
                child: ElevatedButton(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => details()),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc400),
                  ),
                  child: Text('Get Started',
                    style:TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: screenHeight * 0.02,
                        color: Colors.black
                    ) ,),
                ),
              )

          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child:SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: login()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  child: Text('Log in with email',
                    style:TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: screenHeight * 0.02,
                        color: Colors.black
                    ) ,),
                ),
              )
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),

          Text("By signing in you agree to our",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: screenHeight * 0.02,
              color: Colors.grey,
            ),
          ),
          Text("Terms of services & Privacy Policy",
            style:TextStyle(
              decoration: TextDecoration.none,
              fontWeight:FontWeight.bold,
              fontSize: screenHeight * 0.025,
              color: Colors.black,
            ) ,),
          Text("---------------------------------------------------",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.grey,
              fontSize: screenHeight * 0.01,
            ),),
          Text("                                                 ",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.grey,
              fontSize: screenHeight * 0.01,
            ),),
        ],
      ) ,
          )
    );
        });

  }
}



