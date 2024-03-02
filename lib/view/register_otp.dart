import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'offers_spin_wheel.dart';

class RegisterOtp extends StatefulWidget {
  @override
  _RegisterOtpState createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  late String userId;
  final TextEditingController otpController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        Map<String, dynamic> tokenPayload = JwtDecoder.decode(accessToken);
        userId = tokenPayload['uid'];
        print('User ID: $userId');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('https://fxcareers.com/api/course_api/verify_otp/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          body: {
            'otp': otp,
          },
        );

        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['status'] == 'success') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpinWheel()),
            );
          } else {
            setState(() {
              errorMessage = 'Invalid OTP. Please try again.';
            });
          }
        } else {
          setState(() {
            errorMessage = 'Failed to verify OTP. Please try again later.';
          });
        }
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      setState(() {
        errorMessage = 'An unexpected error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String enteredOTP = otpController.text.trim();
                if (enteredOTP.isNotEmpty) {
                  verifyOTP(enteredOTP);
                } else {
                  setState(() {
                    errorMessage = 'Please enter OTP.';
                  });
                }
              },
              child: Text('Verify'),
            ),
            SizedBox(height: 8.0),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}