import 'package:flutter/material.dart';

class DemoSession extends StatefulWidget {
  const DemoSession({Key? key}) : super(key: key);

  @override
  State<DemoSession> createState() => _DemoSessionState();
}

class _DemoSessionState extends State<DemoSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Demo Session'),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/images/demo.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space between image and details
              Text(
                'Demo Sessions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildSessionDetails('Anyone can Trade', '9th Feb', '2:00 pm'),
              buildSessionDetails('Financial Freedom', '10th Feb', '5:00 pm'),
              buildSessionDetails('Mastering the Basics', '16th Feb', '2:00 pm'),
              buildSessionDetails('Your Guide to Smart Trading', '17th Feb', '5:00 pm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSessionDetails(String topic, String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topic: $topic',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('🗓 Date: $date'),
          Text('🕔 Time: $time'),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DemoSession(),
  ));
}
