import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:new_app/url.dart';

class analysis extends StatefulWidget {

  final int id;

  analysis({required this.id});

  @override
  State<analysis> createState() => _analysisState();
}

class _analysisState extends State<analysis> {

  List<Map<String, dynamic>> courseData = [];
  bool _isLoading = true;

  double _imageScale = 1.0;
  Offset _imagePosition = Offset.zero;

  @override
  void initState() {
    _loadCourseData();
  }

  Future<void> _loadCourseData() async {
    try {
      List<Map<String, dynamic>> data = await fetchCourseData();
      setState(() {
        courseData = data;
        print(courseData);
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors here, e.g., show an error message to the user
      print('Error loading course data: $e');
    }
  }



  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/analysis_data/${widget.id}'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        // Check if jsonData is a list and contains maps
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          return jsonData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching course data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading || courseData.isEmpty) {
      // Handle loading state or empty data state
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final Map<String, dynamic> course = courseData[0];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Container(
          child: Text(
            "Currency report",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Color(0xffffc400),
      ),
      body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    // height: screenHeight * 0.3,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: course.containsKey('chart')
                          ? Image(
                        image: CachedNetworkImageProvider(
                          '${MyConstants
                              .imageUrl}/${course['chart']}',
                        ),
                        fit: BoxFit.contain,
                      )
                          : Placeholder(), // Placeholder or any other widget to show when 'chart' is not available
                    ),
                  ),
                  // SizedBox(
                  //   height: screenHeight * 0.05,
                  // ),
                  Row(
                      children: [
                        SizedBox(width: screenWidth * 0.05),
                        Image(
                          height: screenHeight * 0.09,
                          width: screenWidth * 0.09,
                          image: AssetImage("assets/images/exchange-rate.png"),
                        ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      child: Text(
                        courseData.isNotEmpty
                            ? courseData[0]['assets_name']
                            : 'N/A',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,

                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Image(
                      height: screenHeight * 0.09,
                      width: screenWidth * 0.09,
                      image: AssetImage(
                          "assets/images/candlestick-chart.png"),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      child: Text(
                        courseData.isNotEmpty
                            ? courseData[0]['pair_name']
                            : 'N/A',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,

                        ),
                      ),
                    ),
                  ]
              ),
              Row(
                  children: [
                    SizedBox(width: screenWidth * 0.05),
                    Image(
                      height: screenHeight * 0.09,
                      width: screenWidth * 0.09,
                      image: AssetImage(
                          "assets/images/free-trade.png"),

                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      child:
                      Text(
                        courseData.isNotEmpty
                            ? courseData[0]['timezone_name']
                            : 'N/A',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,

                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.11),
                    Image(
                      height: screenHeight * 0.09,
                      width: screenWidth * 0.09,
                      image: AssetImage(
                          "assets/images/calendar.png"),

                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      child: Text(
                        courseData.isNotEmpty
                            ? DateFormat('dd-MM-yy').format(
                            DateFormat('yyyy-MM-dd').parse(
                                courseData[0]['date'])
                        )
                            : 'N/A',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,

                        ),
                      ),

                    ),
                  ]
              ),

              SizedBox(width: screenWidth * 0.05,height: screenHeight*0.03,),
              Container(
                child: Text(
                  courseData.isNotEmpty
                      ? courseData[0]['title']
                      : 'N/A',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05,height: screenHeight*0.03,),
              Container(
                child:          Html(
                  data: (courseData[0]['dis']) ?? 'N/A',
                  onLinkTap: (url, attribute,element ) {
                    // Handle link taps if needed
                    print('Tapped on link: $url');
                  },
                  style: {
                    'p': Style(
                      // Add the desired text styling for paragraphs
                      fontSize: FontSize(14),
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                      lineHeight: LineHeight(1.4),
                      letterSpacing: 0.03,
                      textDecoration: TextDecoration.none,
                      color: Colors.black.withOpacity(0.6399999856948853),
                    ),
                    // You can add more style rules for other HTML elements as needed
                  },
                ),

              ),
            ],
          ),
        ),
        )
      ),
    );
  }
}
