import 'package:flutter/material.dart';
import 'package:new_app/2a.dart';
import 'package:new_app/new.dart';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/2.dart';
import 'package:new_app/forget.dart';

class code extends StatefulWidget {

  @override
  State<code> createState() => _codeState();
}

class _codeState extends State<code> {
  TextEditingController _textEditingController = TextEditingController();
  bool isInputValid = false;

  void _validateInput(String text) {
    setState(() {
      isInputValid = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {

      Navigator.push(context, PageTransition(
          type: PageTransitionType.fade,
          child: password())
      );
      // Handle the back button press here
      // Return true to allow the app to pop the current route, or false to prevent it
      // You can navigate to a different page or perform any custom logic here
      return true;
    },
    child:Container(
      color: Colors.white,
      child:Column(
        children: [
        SizedBox(
        height: 15,
      ),

      Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Container(
            alignment: Alignment.topLeft,
            child:Image.asset(
              'assets/images/MicrosoftTeams-image166fb87a34f356ec84747339b223195637acc5d9882d988615452c61fc25f37e.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ),

          SizedBox(
            width: 200,
          ),
          // Container(
          //   child: FloatingActionButton.small(
          //     onPressed: () {},
          //     child: IconButton(
          //       icon: Icon(Icons.close),
          //       color: Colors.black,
          //       onPressed: () {
          //         Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyImageWithButtonScreen()));
          //       },
          //     ),
          //     backgroundColor: Colors.white,
          //   ),
          //
          // ),
        ],
      ),
          SizedBox(
            height: 15,
          ),

          Container(
            child:Text(
              "Enter the code",
              textAlign: TextAlign.left,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            child:Text(
              "Code sent to ",
              textAlign: TextAlign.left,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: password() ));
              },
              child: Text('Edit email',
                textAlign: TextAlign.left,
                style:TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ) ,),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.transparent
                  )
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child:
          SizedBox(
            width: screenWidth*4,
            height: screenHeight*0.05,
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width:screenWidth*0.7 , // Adjust width as needed
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (text) {
                          _validateInput(text); // Call _validateInput here when the text changes
                        },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent), // Set the color to transparent
                          ),
                          hintText: 'Verification code',

                        ),
                      ),
                    ),
                  ]
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isInputValid
                        ? Color(0xffffc400)
                        : Colors.grey
                  )
              ),
            ),
          ),
      ),
          SizedBox(
            height: 10,
          ),

          Container(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Resend OTP',
                textAlign: TextAlign.left,
                style:TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ) ,),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.transparent
                  )
              ),
            ),
          ),


          SizedBox(
            height: screenHeight*0.4,
          ),


          Padding(padding:EdgeInsets.only(bottom: screenWidth*0.02,left: screenWidth*0.02,right: screenWidth*0.02),
            child: Row(
              children: [
              SizedBox(
                  width: screenWidth*0.95,
                  height: screenHeight*0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: enter()));
                    },
                    child: Text('Continue ',
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

              ],
            ),
          )



        ]
      ),
    )
    );
  }
}
