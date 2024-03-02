import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_app/online_offline.dart';
import 'package:new_app/slider1.dart';
import 'package:new_app/currency_report.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:new_app/edit.dart';
// import 'package:new_project/wallet.dart';
// import 'package:new_project/chat_support.dart';
import 'package:new_app/account.dart';
import 'package:new_app/about.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:new_app/disclaimer.dart';
import 'package:new_app/privacy.dart';
import 'package:new_app/refund.dart';
import 'package:new_app/terms.dart';
import 'package:new_app/courses_main.dart';
import 'package:new_app/edit_profile.dart';
import 'package:new_app/url.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {

  final storage = FlutterSecureStorage();
  File? _pickedImage;
  String userName='';
  String user='';
  String phoneNumber='';

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    fetchCourseData();
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }

  Future<File?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      return _pickedImage!;
    }

    return null;
  }

  Future<Map<String, dynamic>> getUsernameFromStorage() async {
    // Fetch the username and mobile number from storage
    String? username = await storage.read(key: 'username');
    String? mobileNumber = await storage.read(key: 'mobile_no');

    // Return a map with the retrieved values
    return {
      'username': username,
      'mobile_no': mobileNumber,
    };
  }

  Future<Map<String, dynamic>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      user= decodedToken['uid'] ?? ''; // Assu

      print('D: $decodedToken');
    }

    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/user_data/$user'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      print('${MyConstants.baseUrl}/course_api/user_data/$user');
      print('Res: $response');
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print("new data: $responseData");

        if (responseData is List) {
          // Handle the case where the response is a list
          // For example, you might want to extract data from the first item
          if (responseData.isNotEmpty) {
            final Map<String, dynamic> jsonData = responseData[0];

            // Extracting specific data
            String firstName = jsonData['firstname'] ?? '';
            String lastName = jsonData['lastname'] ?? '';
            userName = jsonData['username'];
            phoneNumber=jsonData['mobile_no'];
            // Print or use the extracted data
            print("First Name: $firstName");
            print("Last Name: $lastName");

            // Set the values to the corresponding TextEditingController
            // Rest of your code...
          }
        } else if (responseData is Map<String, dynamic>) {
          // Handle the case where the response is a map
          String firstName = responseData['firstname'] ?? '';
          String lastName = responseData['lastname'] ?? '';
          String email = responseData['email'] ?? '';
          String phoneNumber = responseData['mobile_no'] ?? '';
          user = responseData['uid'] ?? '';
          userName=responseData['username'];

          print("Email: $email");
          print("user id: $user");

          // Set the values to the corresponding TextEditingController

          // Rest of your code...
        }
        else if (responseData is int) {
          // Handle the case where the response is an unexpected integer
          print('Unexpected response format: $responseData');
          return {};
        }

      }

      throw Exception('Failed to fetch course data. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error fetching course data: $e');
      // Return an empty map or throw an exception based on your requirements
      return {};
    }
  }


  @override
  Widget build(BuildContext context) {
    int _currentIndex = 2;


    Future<Map<String, dynamic>> getUsernameFromToken() async {
      // Fetch the access token from storage (assuming you have stored it)
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        // Decode the access token to get user information
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

        // Extract the username (replace 'username_key' with the actual key in your token)
        return decodedToken;
      }
      return {}; // Return an empty string if the username cannot be obtained
    }


    return Scaffold(


      body: _buildBody(_currentIndex,context,getUsernameFromToken),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        onTap: (int index) {

          if (index == 0) {
            Navigator.push(

              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CoursesMain()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FourthPage()),
            );
          }



        },
        selectedItemColor: Colors.black, // Customize the selected label color
        unselectedItemColor: Colors.grey, // Customize the unselected label color
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Customize the selected label style
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Customize the unselected label style
        selectedIconTheme: IconThemeData(color: Colors.black), // Customize the selected icon color
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        items: [
           BottomNavigationBarItem(
            icon:  Icon(Icons.home,
              size: 30,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.menu_book,
              size: 30,),

            label: 'Courses',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.info_rounded,

              size: 30,),
            label: 'About-Us', // inside the settings
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int currentIndex,BuildContext context,getUsernameFromToken) {
    final double screenHeight = MediaQuery.of(context).size.height;

    switch (currentIndex) {

      case 0:
        return SingleChildScrollView(
          // Your favorites content goes here
        );

      case 1:
        return SingleChildScrollView(
          // Your favorites content goes here
        );

      case 3:
        return SingleChildScrollView(
          // Your favorites content goes here
        );

      case 2:
        return  Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
    leading: BackButton(
    color: Colors.black,
    ),
    title:

    const Text('About-Us',
    textAlign: TextAlign.start,
    style: TextStyle(
    color: Colors.black
    ),),

    backgroundColor: Color(0xffffc400),

    ),


    body:SingleChildScrollView(
          child:Container(
            width: 1000,
          color: Colors.white,
          child: Column(
            children: [

    //           Container(
    //             width: 428,
    //             height: 116,
    //             padding: const EdgeInsets.all(20),
    //             decoration: BoxDecoration(color: Colors.white),
    //               child: FutureBuilder<Map<String, dynamic>>(
    //                   future: fetchCourseData(),
    //                   builder: (context, snapshot) {
    //                     if (snapshot.connectionState == ConnectionState.waiting) {
    //                       return CircularProgressIndicator();
    //                     } else if (snapshot.hasError) {
    //                       return Text('Error: ${snapshot.error}');
    //                     } else {
    //                       // Check if the 'username' key is present
    //                       bool hasUsername = snapshot.data?.containsKey('username') ?? false;
    //
    //                       // Display the username or an empty string
    //                       String username = hasUsername ? snapshot.data!['username'] ?? '' : '';
    //
    //                       // Display the mobile number if available
    //                       String mobileNumber = snapshot.data?['mobile_no'] ?? '';
    //
    //                       return Row(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         //                 GestureDetector(
    //         //                 onTap: () {
    //         //               _pickImage().then((pickedImage) {
    //         //                 if (pickedImage != null) {
    //         //                   // Handle the picked image (e.g., upload it to the server)
    //         //                 }
    //         //               });
    //         //             },
    //         //           child:Container(
    //         //   width: 76,
    //         //   height: 76,
    //         //   decoration: BoxDecoration(
    //         //     image: _pickedImage != null
    //         //         ? DecorationImage(
    //         //       image: FileImage(_pickedImage!),
    //         //       fit: BoxFit.fill,
    //         //     )
    //         //         : const DecorationImage(
    //         //       image: AssetImage(
    //         //           "assets/images/profile.jpg"),
    //         //       fit: BoxFit.fill,
    //         //     ),
    //         //   ),
    //         //           ),
    //         //                 ),
    //         // const SizedBox(width: 20),
    //         // Column(
    //         //   mainAxisSize: MainAxisSize.min,
    //         //   mainAxisAlignment: MainAxisAlignment.start,
    //         //   crossAxisAlignment: CrossAxisAlignment.start,
    //         //   children: [
    //         //     Text(
    //         //     userName,
    //         //       style: TextStyle(
    //         //           color: Color(0xFF222222),
    //         //           fontSize: 18,
    //         //           fontFamily: 'SF Pro',
    //         //           fontWeight: FontWeight.w700,
    //         //           height: 0,
    //         //           decoration: TextDecoration.none
    //         //       ),
    //         //     ),
    //         //     const SizedBox(height: 4),
    //         //     Text(
    //         //       phoneNumber,
    //         //       style: TextStyle(
    //         //           color: Color(0xA3222222),
    //         //           fontSize: 14,
    //         //           fontFamily: 'SF Pro',
    //         //           fontWeight: FontWeight.bold,
    //         //           height: 0,
    //         //           decoration: TextDecoration.none
    //         //       ),
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     );
    //   }
    // }
    // )
    //
    //
    //           ),



              GestureDetector(
                onTap: () {

                },
                child:  Container(
                  width: 428,
                  height: screenHeight*1,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'Settings',
                      //   style: TextStyle(
                      //       color: Color(0xFF222222),
                      //       fontSize: 18,
                      //       fontFamily: 'SF Pro',
                      //       fontWeight: FontWeight.bold,
                      //       height: 0,
                      //       decoration: TextDecoration.none
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: screenHeight*0.8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
    // GestureDetector(
    // onTap: () {
    // Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfilePage()));
    // },
    //                        child: Container(
    //                           width: double.infinity,
    //                           height: 60,
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 16, vertical: 10),
    //                           decoration: ShapeDecoration(
    //                             color: const Color(0xFFF7F9FB),
    //                             shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(8)),
    //                           ),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 width: 20,
    //                                 height: 20,
    //                                 decoration: BoxDecoration(
    //                                     image: DecorationImage(
    //                                         image: AssetImage(
    //                                             "assets/images/profile.jpg"),
    //                                         fit: BoxFit.fill
    //                                     )
    //
    //                                 ),
    //                                 child: Stack(
    //                                   children: [
    //                                     Positioned(
    //                                       left: 3,
    //                                       top: 6,
    //                                       child: Container(
    //                                         width: 14,
    //                                         height: 14,
    //                                         child: Stack(children: [
    //                                         ]),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               const SizedBox(width: 12),
    //
    //                                 const Text(
    //                                   'Edit profile',
    //                                   style: TextStyle(
    //                                       color: Color(0xFF222222),
    //                                       fontSize: 16,
    //                                       fontFamily: 'SF Pro',
    //                                       fontWeight: FontWeight.bold,
    //                                       height: 0,
    //                                       decoration: TextDecoration.none
    //                                   ),
    //                                 ) ,
    //
    //
    //
    //
    //                             ],
    //                           ),
    //                         ),
    // ),
    //                         const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewPage(url: 'https://fxcareers.com/about_app'),
                                  ),
                                );
                              },
                              child:
                            Container(
                              width: double.infinity,
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF7F9FB),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(),
                                    child: const Stack(children: [
                                      Icon(Icons.info_rounded)
                                    ]),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'About us',
                                    style: TextStyle(
                                        color: Color(0xFF222222),
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.bold,
                                        height: 0,
                                        decoration: TextDecoration.none
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                      Navigator.pushNamed(context, '/offers');
                              },
                              child:
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF7F9FB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(),
                                      child: const Stack(children: [
                                        Icon(Icons.card_giftcard)
                                      ]),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Offers',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Disclaimer(url: 'https://www.fxcareers.com/disclaimer_app'),
                                  ),
                                );
                              },
                              child:
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF7F9FB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        Icon(Icons.warning)
                                      ]),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Disclaimer',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Privacy(url: 'https://www.fxcareers.com/privacy_app'),
                                  ),
                                );
                              },
                              child:
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF7F9FB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(),
                                      child: const Stack(children: [
                                        Icon(Icons.privacy_tip)
                                      ]),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Privacy policy',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Refund(url: 'https://www.fxcareers.com/refund_app'),
                                  ),
                                );
                              },
                              child:
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF7F9FB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(),
                                      child: const Stack(children: [
                                        Icon(Icons.refresh)
                                      ]),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Refund policy',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Terms(url:' https://www.fxcareers.com/termsconditions_app'),
                                  ),
                                );
                              },
                              child:
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF7F9FB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        Icon(Icons.note_alt)
                                      ]),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Terms and services',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
    // GestureDetector(
    // onTap: () {
    // // Navigator.push(context,MaterialPageRoute(builder: (context) => ChatSupport()));
    // },
    // child:
    //                        Container(
    //                           width: double.infinity,
    //                           height: 60,
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 16, vertical: 10),
    //                           decoration: ShapeDecoration(
    //                             color: Color(0xFFF7F9FB),
    //                             shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(8)),
    //                           ),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             // crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 width: 24,
    //                                 height: 24,
    //                                 clipBehavior: Clip.antiAlias,
    //                                 decoration: BoxDecoration(),
    //                                 child: Stack(children: [
    //                                   Icon(Icons.headset_mic_rounded)
    //                                 ]),
    //                               ),
    //                               const SizedBox(width: 12),
    //                               Text(
    //                                 'Help & support',
    //                                 style: TextStyle(
    //                                     color: Color(0xFF222222),
    //                                     fontSize: 16,
    //                                     fontFamily: 'SF Pro',
    //                                     fontWeight: FontWeight.bold,
    //                                     height: 0,
    //                                     decoration: TextDecoration.none
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    // ),
    //                         const SizedBox(height: 12),

                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //
                            //     GestureDetector(
                            //       onTap: () {
                            //         clearLoginStatus();
                            //         Navigator.pushReplacement(
                            //           context,
                            //           MaterialPageRoute(builder: (context) => login()),
                            //         );
                            //       },
                            //       child:
                            //       Container(
                            //         width: double.infinity,
                            //         height: 60,
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 16, vertical: 10),
                            //         decoration: ShapeDecoration(
                            //           color: Color(0xFFF7F9FB),
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(8)),
                            //         ),
                            //         child: Row(
                            //           mainAxisSize: MainAxisSize.min,
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.center,
                            //           children: [
                            //             Container(
                            //               width: 24,
                            //               height: 24,
                            //               clipBehavior: Clip.antiAlias,
                            //               decoration: BoxDecoration(),
                            //               child: Stack(
                            //                 children: [
                            //                   Positioned(
                            //                     left: 2.60,
                            //                     top: 2,
                            //                     child: Container(
                            //                       width: 18.80,
                            //                       height: 20,
                            //                       child: Stack(children: [
                            //                         Icon(
                            //                           Icons.power_settings_new,
                            //                           color: Color(0xFFE03021),
                            //                         )
                            //                       ]),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             // const SizedBox(width: 12),
                            //             // const Text(
                            //             //   'Log out',
                            //             //   style: TextStyle(
                            //             //       color: Color(0xFFE03021),
                            //             //       fontSize: 16,
                            //             //       fontFamily: 'SF Pro',
                            //             //       fontWeight: FontWeight.w600,
                            //             //       height: 0,
                            //             //       decoration: TextDecoration.none
                            //             //   ),
                            //             // ),
                            //           ],
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // const SizedBox(height: 12),
                            const Text(
                              'Version: 1.0.0',
                              style: TextStyle(
                                  color: Color(0xA3222222),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                  decoration: TextDecoration.none
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          )
    )
        );

      default:
        return Container();
    }
  }
}
