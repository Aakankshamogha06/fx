import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ApiService {

  Future<void> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final apiUrl = '${MyConstants.baseUrl}/course_api/update_profile';

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

      print('Response: $response');
      if (response.statusCode == 200) {
        print('Profile updated successfully');

        Fluttertoast.showToast(
          msg: "Profile updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xffffc400),
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
