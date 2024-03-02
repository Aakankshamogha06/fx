import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:new_app/2a.dart';
import 'package:new_app/slider1.dart';
import 'package:new_app/url.dart';

class details extends StatefulWidget {

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details>{
  final storage = FlutterSecureStorage();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobile_noController = TextEditingController();

  TextEditingController _textEditingController = TextEditingController();

  bool isInputValid = false;

  void _validateInput() {
    setState(() {
      isInputValid = firstnameController.text.isNotEmpty &&
          lastnameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          mobile_noController.text.isNotEmpty;
    });
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


  Future<void> registerUser() async {
    final url = Uri.parse('${MyConstants.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        body: {
          'firstname': firstnameController.text,
          'lastname': lastnameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'mobile_no': mobile_noController.text,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check if registration is successful
      if (response.statusCode == 200) {
        // Parse the user information from the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response Data: $responseData');


        if (responseData.containsKey('access_token')) {
          final String accessToken = responseData['access_token'];

          // Store the access token securely
          await storage.write(key: 'access_token', value: accessToken);

          // Save additional user information (e.g., username, mobile number)
          await storage.write(key: 'username', value: responseData['username']);
          await storage.write(key: 'mobile_no', value: responseData['mobile_no']);
          print('Stored Access Token: $accessToken');
          print('Stored Username: ${responseData['username']}');
          print('Stored Mobile Number: ${responseData['mobile_no']}');

          await login(emailController.text, passwordController.text);
        }

        // Fetch additional data or perform other operations if needed

        // Introduce a small delay before navigating to ensure storage is complete
        await Future.delayed(Duration(milliseconds: 500));

        // Navigate to the next screen
        Navigator.push(
          context,
          PageTransition(type: PageTransitionType.fade, child: MyHomePage()),
        );
      } else {
        // Handle registration failure
        // ...
      }
      // Handle the response based on the status code and response body
    } catch (error) {
      // Handle any error that might occur during the HTTP request
      print('Error: $error');
      // Handle the error message or show it to the user
      Fluttertoast.showToast(
        msg: 'Error occurred. Please try again.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> login(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConstants.baseUrl}/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
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
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child:Column(
            children: [
              const SizedBox(
                height: 15,
              ),

              Stack(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child:Image.asset(
                      'assets/images/fx.png',
                      width: 150, // Adjust the width as needed
                      height: 150, // Adjust the height as needed
                    ),
                  ),

                  Positioned(
                      right: 10.0,
                      top: 50,
                      child:
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyImageWithButtonScreen()),
                            );
                          },
                        ),
                      )
                  ),

                ],

              ),
              const Text(
                "Profile details",
                textAlign: TextAlign.left,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              _buildTextField('First Name', firstnameController),
              const SizedBox(height: 18),
              _buildTextField('Last Name', lastnameController),
              const SizedBox(height: 18),
              _buildTextField('Email', emailController),
              const SizedBox(height: 18),
              _buildPhoneNumberField(),
              const SizedBox(height: 18),
              _buildTextField('Password', passwordController),
              SizedBox(
                height: height * 0.1,
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child:SizedBox(
                    width: width * 0.9,
                    height: 50,
                    child: ElevatedButton(

                      onPressed: () async {
                        await registerUser();
                        Future.delayed(const Duration(seconds: 2),() {
                          displayTokenDetails();
                        });
                      // Navigator.pushNamed(context, '/registerOtp');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInputValid
                            ? const Color(0xffffc400) // Change the button color when input is valid
                            : Colors.white70, // Change the button color when input is not vali
                      ),

                       child:  Text('Register ',
                        style:TextStyle(
                            decoration: TextDecoration.none,
                            color: isInputValid
                                ? Colors.black
                                : Colors.grey
                        ) ,),
                    ),
                  )
              ),
            ],
          )
      ),
    )
    );
  }
  Widget _buildTextField(String hintText, TextEditingController controller) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      // height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (text) {
                  _validateInput();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
        child:
        Row(
          children: [
            SizedBox(
              // width: width * 0.10,
              height: height * .06,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                child: const Text(
                  '+91',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Expanded(
            //   child: SizedBox(
            //     height: 50,
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.white,
            //         side: BorderSide(
            //           color: isInputValid ? const Color(0xffffc400) : Colors.grey,
            //         ),
            //       ),
            //       child:
            //       TextField(
            //         controller: mobile_noController,
            //         decoration: const InputDecoration(
            //
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.transparent),
            //           ),
            //
            //           hintText: 'Phone number',
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: SizedBox(
                height: height * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isInputValid ? const Color(0xffffc400) : Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: mobile_noController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),




          ],
        )
    );
  }

}





