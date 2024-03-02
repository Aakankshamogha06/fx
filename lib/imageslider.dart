import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_app/url.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<String> imageUrls = [];
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final storage = FlutterSecureStorage();

    // Fetch access token from storage
    final accessToken = await storage.read(key: 'access_token');

    final apiUrl = '${MyConstants.baseUrl}/course_api/slider_data';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);

        // Ensure that 'data' is a list
        if (data is List) {
          final List<String> urls = data
              .map((item) => item['image'].toString())
              .toList();

          setState(() {
            imageUrls = urls;
          });
        } else {
          // Handle the case when 'data' is not a list
          print('Error: The API response is not a list');
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    if (imageUrls.isEmpty) {
      // Handle the case when imageUrls is empty, for example, display a loading indicator or placeholder.
      return const CircularProgressIndicator();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: screenHeight*.26,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: imageUrls.length,
            options: CarouselOptions(
              height: screenHeight*0.2,
              // height: screenHeight*0.24,
              initialPage: _currentPage,
              viewportFraction: 1.0,
              onPageChanged: onPageChanged,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
            ),
            itemBuilder: (BuildContext context, int index, realIndex) {

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight*0.03),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: screenWidth*1,
                    child:Image.network(
                    '${MyConstants.imageUrl}/${imageUrls[index]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          DynamicRoundIcons(
            itemCount: imageUrls.length,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }

  void onPageChanged(int page, CarouselPageChangedReason reason) {
    setState(() {
      _currentPage = page;
    });
  }
}

class DynamicRoundIcons extends StatelessWidget {
  final int itemCount; // Ensure that itemCount is of type int
  final int currentPage; // Ensure that currentPage is of type int

  DynamicRoundIcons({
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (int index) {
        return Container(
          margin:  EdgeInsets.symmetric(horizontal: 4.0),
          width:  screenWidth * .02,
          height: screenHeight * .01,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? const Color(0xffffc400) : Colors.grey,
          ),
        );
      }),
    );
  }
}
