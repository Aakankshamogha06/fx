import 'package:flutter/material.dart';
import 'package:new_app/user_model.dart';
import 'package:new_app/url.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ApiService apiService = ApiService();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;

  String user='';

  Future<Map<String, dynamic>> getUsernameFromToken() async {
    // Fetch the access token from storage (assuming you have stored it)
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');

    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      print('Decoded token: $decodedToken');
      // Extract the username (replace 'username_key' with the actual key in your token)
      String firstName = decodedToken['firstname'] ?? '';
      String lastName = decodedToken['lastname'] ?? '';
      String email = decodedToken['email'] ?? '';
      String phoneNumber = decodedToken['mobile_no'] ?? '';
      user =decodedToken['uid'] ?? '';

      print("Email: $email");
      print("user id: $user");

      // Set the values to the corresponding TextEditingController
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      emailController.text = email;
      phoneNumberController.text = phoneNumber;
    }
    return {}; // Return an empty string if the username cannot be obtained
  }

  Future<Map<String, dynamic>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/user_data/$user'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
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

            // Print or use the extracted data
            print("First Name: $firstName");
            print("Last Name: $lastName");

            // Set the values to the corresponding TextEditingController
            firstNameController.text = firstName;
            lastNameController.text = lastName;

            // Rest of your code...
          }
        } else if (responseData is Map<String, dynamic>) {
          // Handle the case where the response is a map
          String firstName = responseData['firstname'] ?? '';
          String lastName = responseData['lastname'] ?? '';
          String email = responseData['email'] ?? '';
          String phoneNumber = responseData['mobile_no'] ?? '';
          user = responseData['uid'] ?? '';

          print("Email: $email");
          print("user id: $user");

          // Set the values to the corresponding TextEditingController
          firstNameController.text = firstName;
          lastNameController.text = lastName;
          emailController.text = email;
          phoneNumberController.text = phoneNumber;

          // Rest of your code...
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
  void initState() {
    super.initState();
    // Initialize the controllers
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    // Fetch user details using the provided function
    getUsernameFromToken();
    fetchCourseData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor:Color(0xFFF9C311),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: screenHeight*0.05),
            ElevatedButton(
              onPressed: () {
                // Call the updateProfile function with the edited details
                apiService.updateProfile(
                  userId: user ,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  phoneNumber: phoneNumberController.text,
                );
              },
              child: Text('Save Changes',
              style: TextStyle(
                color: Colors.black
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF9C311),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
