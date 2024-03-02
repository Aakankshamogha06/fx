import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({Key? key}) : super(key: key);

  @override
  State<MyOffers> createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffc400),
        title: const Text('Offers'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15), // Set margin on all sides
          decoration: BoxDecoration(
            shape: BoxShape.rectangle, // Make the container round
            border: Border.all(
              color: Colors.white, // Add a border color if needed
              width: 2, // Add a border width if needed
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/offersData');
            },
            child: ClipRRect(
              child: Image.asset(
                'assets/images/spin.jpeg',
                // width: width * 0.8, // Adjust width as needed
                // height: height * 0.8, // Adjust height as needed
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
