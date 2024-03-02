import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:new_app/url.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Knowledge_hub extends StatefulWidget {

  @override
  State<Knowledge_hub> createState() => _Knowledge_hubState();
}

class _Knowledge_hubState extends State<Knowledge_hub> {

  List<Map<String, dynamic>> courseData = [];
  bool _isLoading = true;

  @override

  void initState() {
    super.initState();
    _loadCourseData();
  }



  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/knowledge_hub_data'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Check if jsonData is a list and contains maps
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          return jsonData.cast<Map<String, dynamic>>();
        } else if (jsonData is List) {
          // If jsonData is a list but doesn't contain maps, you can handle it accordingly
          print('Invalid data format from the API: $jsonData');
          return [];
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


  Future<void> _viewPdf(String pdfUrl) async {
    try {
      // Navigate to the PDFViewer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SfPdfViewer.network(pdfUrl), // Use SfPdfViewer.asset for local assets
        ),
      );
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle the error as needed, e.g., show an error message to the user
    }
  }



  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title:

        const Row(
            children: [

              Text("Knowledge hub",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black
                ),),
            ]
        ),

        backgroundColor: const Color(0xffffc400),

      ),


      body
          : ListView.builder(
        shrinkWrap: true,
        itemCount: courseData.length,
        itemBuilder: (context, index) {
          final course = courseData[index];
          return GestureDetector(
            // onTap: () {
            //   if (course.containsKey('pdf')) {
            //     String pdfUrl = '${MyConstants.imageUrl}/${course['pdf']}';
            //     _viewPdf(pdfUrl);
            //   }
            // },
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Container(
                // width: screenWidth * 0.9,
                // height: screenHeight * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // SizedBox(
                    //   width: double.infinity,
                    //   height: screenHeight * 0.3,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(15),
                    //     child: Center(
                    //       child: FittedBox(
                    //         fit: BoxFit.cover,
                    //         child: Image.network(
                    //           // '${MyConstants.imageUrl}/${course['image']}',
                    //           // fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: screenHeight * 0.02),

                    Text(
                      courseData.isNotEmpty
                          ? courseData[index]['title']
                          : 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 10,)
                    ,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Afternoon Session: Analyzing Gold Price Trends Amidst US Inflation Slowdown, will it fly high?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                    ,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Highlights',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                    ,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Gold prices rise on the back of slowing US inflation and Federal Reserve focus on overall inflation progress Key economic data releases, including Core CPI and ISM Manufacturing PMI, \n hold significance for gold market dynamicsSupport and resistance levels for Gold (2028-2060) and Gold MCX (62280-62820) offer crucial insights for traders and investors ',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                    ,

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/trading.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Overview',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'In recent market developments, gold prices have experienced an upward trajectory, driven by a combination of factors, including a gradual slowdown in US inflation and the careful scrutiny of comments from various Federal Reserve members. This analysis delves into the recent statistical revelations, shedding light on the dynamics influencing gold prices and the key economic indicators to watch. Additionally, we will explore the support and resistance levels for both Gold and Gold MCX price',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'US Inflation Trends',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'The US Personal Consumption Expenditures (PCE) price index indicated a 0.3% climb in January, with the core PCE price index registering a 0.4% increase. Notably, inflation for the year ending in January reached 2.4%, marking the lowest rate in over three years. Federal Reserve members are adjusting their focus, shifting away from short-term pricing pressures to concentrate on the broader inflation progress. This strategic shift suggests a potential groundwork for interest rate decreases later in the year',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Upcoming Economic \n Data Releasee',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Market participants are eagerly awaiting key economic data releases, which are poised to have a significant impact on gold prices. These include the Core CPI Flash Estimate year-on-year, CPI Flash Estimate year-on-year from the Euro Zone, and the ISM Manufacturing PMI, along with the Revised University of Michigan Consumer Sentiment from the US Zone. Traders will closely monitor these indicators for insights into global economic trends that could influence gold markets',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Support and Resistance Levels',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'Gold prices are exhibiting distinct support and resistance levels. The current analysis suggests that gold is likely to find support at 2028, with resistance at 2060. Meanwhile, Gold MCX prices are anticipated to experience support around 62280 and resistance at 62820. Understanding these levels is crucial for traders and investors seeking to make informed decisions in the volatile precious metals market.',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                          'Conclusion',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // Add margin left and right
                      child: Text(
                        'As gold prices respond to the intricacies of US inflation trends and Federal Reserve comments, staying informed about upcoming economic data releases becomes paramount. The outlined support and resistance levels provide a valuable framework for market participants, guiding them in navigating the dynamic landscape of gold trading. Keep a close eye on these factors to make well-informed decisions in the ever-evolving financial markets',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    // const SizedBox(height: 10),
                    // SizedBox(
                    //   width: screenWidth * 0.8,
                    //   child:
                    //   FloatingActionButton(
                    //     onPressed: () {
                    //       if (course.containsKey('pdf')) {
                    //         String pdfUrl = '${MyConstants.imageUrl}/${course['pdf']}';
                    //         _viewPdf(pdfUrl);
                    //       }
                    //     },
                    //     backgroundColor: const Color(0xffffc400),
                    //     child: const Text(
                    //       "View ",
                    //       style: TextStyle(color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),


    );
  }}
