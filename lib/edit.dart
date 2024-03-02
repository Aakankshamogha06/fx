import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:new_app/4.dart';
import 'package:new_app/url.dart';


class edit extends StatelessWidget {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String userId,
  }) async {
    final apiUrl = '${MyConstants.baseUrl}/course_api/update_profile';
    print('API URL: $apiUrl');

    final Map<String, dynamic> requestBody = {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'mobile_no': phoneNumber,
      'user_id': userId,
    };
    print('Request Body: $requestBody');


    try {
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        // Profile updated successfully
        print('Profile updated successfully');
      } else {
        // Handle errors
        print('Error updating profile: ${response.statusCode}');

      }
    } catch (error) {
      // Handle network errors
      print('Error updating profile: $error');


    }
  }

  @override
  Widget build(BuildContext context) {
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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: FutureBuilder<Map<String, dynamic>>(
        future: getUsernameFromToken(), // Call the asynchronous function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Update the username variable with the data from the snapshot
            String userId = snapshot.data?['user_id'] ?? '';
            String username = snapshot.data?['username'] ?? '';
            String mobileNumber = snapshot.data?['mobile_no'] ?? '';
            String Email = snapshot.data?['email'] ?? '';


            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Color(0xffffc400),
                leading:BackButton(
                color: Colors.black,
              ),
              ),
              body:Form(
          child:
              SingleChildScrollView(
          child: Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.only(left: 40,bottom: 5),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child:  Text(
                      'Name*',
                      style: TextStyle(
                        color: Color(0xA3222222),
                        fontSize: screenWidth *0.03,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ) ,),

                  SizedBox(
                    width: screenWidth * 0.9,
                    height: 60,
                    child: TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: screenWidth * 0.03,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 0.1,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your username',
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.only(left: 40,bottom: 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child:  Text(
                        'Last Name*',
                        style: TextStyle(
                          color: Color(0xA3222222),
                          fontSize: screenWidth *0.03,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ) ,),


                  SizedBox(
                    width: screenWidth * 0.9,
                    height: 60,
                    child:Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child:   Padding(padding: EdgeInsets.all(6),
                        child: TextFormField(
                          controller: lastNameController,
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: screenWidth *0.03,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 0.1,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: username,
                          ),
                        ) ,),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Padding(padding: EdgeInsets.only(left: 40,bottom: 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child:  Text(
                        'Email*',
                        style: TextStyle(
                          color: Color(0xA3222222),
                          fontSize: screenWidth *0.03,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ) ,),
                  SizedBox(
                    width: screenWidth * 0.9,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      child:
                            Padding(padding: EdgeInsets.all(6),
                        child:
                                TextFormField(
                                  controller: emailController,
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: screenWidth *0.03,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 0.1,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: Email,
                                  ),
                                ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(padding: EdgeInsets.only(left: 40,bottom: 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child:  Text(
                        'Phone number*',
                        style: TextStyle(
                          color: Color(0xA3222222),
                          fontSize: screenWidth *0.03,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ) ,),
                  Row(

                    children: [
                      SizedBox(
                        width: screenWidth*0.04,
                      ),
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            '+91',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth *0.03,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth > 400 ? 10 : 5,
                      ),
                      SizedBox(
                        width: screenWidth*0.5,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {},
                          child:
                                    TextFormField(
                                      controller: mobileNumberController,
                                      style: TextStyle(
                                        color: Color(0xFF222222),
                                        fontSize: screenWidth *0.03,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: mobileNumber,
                                      ),
                                    ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.30),
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async{
      final updatedName = usernameController.text;
      final updatedLastName = lastNameController.text; // You need to get the value for last name
      final updatedEmail = emailController.text;
      final updatedPhoneNumber = mobileNumberController.text;
      if (userId.isNotEmpty) {
        // Call the function to update the user profile
        await updateProfile(
          firstName: updatedName,
          lastName: updatedLastName,
          email: updatedEmail,
          phoneNumber: updatedPhoneNumber,
          userId: userId,
        );
      } else {
        // Handle the case where userId is not available
        print('Error: User ID not available');
        // You can show an error message to the user
      }
    },
    child:
                  Container(
                    width: screenWidth > 400 ? 388 : screenWidth - 40,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: ShapeDecoration(
                      color: Color(0xFFF9C311),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: screenWidth > 400 ? 16 : 14,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
    )
                ],
              ),
              )
              )
            );
          }
        },
      ),
    );
  }
}

