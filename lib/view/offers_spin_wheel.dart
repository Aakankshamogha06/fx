import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  String userId = '';
  List<String> items = [
    'Better luck \n next time',
    '30% discount \n on Course Fee',
    'Free a cup of tea',
    'Free a cup of coffee',
    '90 min. \n free session',
    '80% discount \n on Course Fee',
    '50% discount \n on Course Fee',
    'Referral discount 30%'
  ];
  bool spinButtonEnabled = true;
  String? wonData;

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
        print('user id: $userId');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.yellow.shade700, Colors.black],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                child: FortuneWheel(
                  selected: selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0; i < items.length; i++)
                      FortuneItem(
                        child: Text(
                          items[i],
                        ),
                        style: FortuneItemStyle(
                          color: _getItemColor(i),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                  onAnimationEnd: () async {
                    final rewards = items[selected.value];
                    print('You just won $rewards!');
                    setState(() {
                      wonData = rewards;
                      spinButtonEnabled = false;
                    });
                    // Send data to the API
                    await _sendSpinData(rewards);
                  },
                ),
              ),
              const SizedBox(height: 20),
              wonData != null
                  ? const Text(
                'Congratulations! You won:',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              )
                  : SizedBox.shrink(),
              wonData != null
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  wonData!,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
                  : SizedBox.shrink(),
              GestureDetector(
                onTap: spinButtonEnabled
                    ? () {
                  setState(() {
                    selected.add(Random().nextInt(items.length));
                  });
                }
                    : null,
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: spinButtonEnabled ? Colors.white : Colors.grey,
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  // color: spinButtonEnabled ? Colors.white : Colors.grey,
                  child: const Center(
                    child: Text(
                      "SPIN",

                      style: TextStyle(
                        fontSize: 20,
                        // fontFamily: 'Times New Roman',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendSpinData(String rewards) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      if (userId.isNotEmpty && accessToken != null) {
        final response = await http.post(
          Uri.parse(
              'https://fxcareers.com/api/course_api/insert_spin_data'),
          headers: {
            'Authorization': accessToken,
          },
          body: {
            'user_id': userId,
            'question': rewards,
          },
        );

        if (response.statusCode == 200) {
          print('Data sent successfully!');
        } else {
          print(
              'Failed to send data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (error) {
      print('Error sending data: $error');
    }
  }

  Color _getItemColor(int index) {
    return index.isEven ? Colors.yellow.shade700 : Colors.black87;
  }
}
