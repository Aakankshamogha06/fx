import 'package:flutter/material.dart';

import 'package:new_app/view.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/url.dart';
import 'package:new_app/blog_detail.dart';
import 'package:new_app/slider1.dart';
import 'package:new_app/online_offline.dart';
import 'package:new_app/4.dart';
import 'package:new_app/courses_main.dart';


class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {

  List<Map<String, dynamic>> courseData = [];
  bool _isLoading = true;

  // bool isDropdownOpen = false;

  String selectedDateFilter = 'All'; // Default filter for date
  String selectedAssetNameFilter = 'All'; // Default filter for asset name
  // String selectedPairNameFilter = 'All'; // Default filter for pair name
  String selectedTimeZoneFilter = 'All';

  List<String> dateOptions = [];
  List<String> assetNameOptions = [];

  // List<String> pairNameOptions = [];
  List<String> timeZoneOptions = [];

  String extractFirst100Words(String htmlContent) {
    const int maxWords = 20;

    if (htmlContent == null || htmlContent.isEmpty) {
      return '';
    }

    // Remove HTML tags
    // Split the text into words
    List<String> words = htmlContent.split(' ');

    // Take the first 100 words
    List<String> first100Words = words.length > maxWords
        ? words.sublist(0, maxWords)
        : words;

    // Join the words back into a string
    return first100Words.join(' ');
  }

  @override
  void initState() {
    _loadFilterOptions();
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

  Future<void> _loadFilterOptions() async {
    // Fetch filter options for each filter
    // For simplicity, I'm assuming you have methods like fetchDateOptions(), fetchAssetNameOptions(), etc.
    dateOptions = await fetchDateOptions();
    assetNameOptions = await fetchAssetNameOptions();
    // pairNameOptions = await fetchPairNameOptions();
    timeZoneOptions = await fetchTimeZoneOptions();
  }

  Future<List<String>> fetchDateOptions() async {
    // Replace this with your logic to fetch date options from an API or other source
    // await Future.delayed(Duration(seconds: 1)); // Simulate an async operation
    return ['All', '2024-01-04', '2024-01-03', '2024-01-02'];
  }

  Future<List<String>> fetchAssetNameOptions() async {
    // Replace this with your logic to fetch asset name options from an API or other source
    // await Future.delayed(Duration(seconds: 1)); // Simulate an async operation
    return ['All', 'Currencies', 'Commodities'];
  }

  // Future<List<String>> fetchPairNameOptions() async {
  //   // Replace this with your logic to fetch pair name options from an API or other source
  //   // await Future.delayed(Duration(seconds: 1)); // Simulate an async operation
  //   return ['All', 'USD/INR', 'EUR/INR', 'GBP/USD','GBP/INR']; // Include 'All' and other options
  // }

  Future<List<String>> fetchTimeZoneOptions() async {
    // Replace this with your logic to fetch time zone options from an API or other source
    // await Future.delayed(Duration(seconds: 1)); // Simulate an async operation
    return [
      'All',
      'Morning',
      'Afternoon',
      'Evening'
    ]; // Include 'All' and other options
  }


  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/blog_data'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        // Check if jsonData is a list and contains maps
        if (jsonData is List && jsonData.isNotEmpty &&
            jsonData[0] is Map<String, dynamic>) {
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

  List<Map<String, dynamic>> filterData(String filter) {
    if (filter == 'All') {
      // Return all data
      return courseData;
    } else {
      // Return filtered data based on the selected filter
      // Implement your specific filtering logic here
      return courseData.where((item) {
        // Replace 'item' and 'yourFilterCondition' with the actual fields and condition you want to use for filtering
        return item['yourField'] == 'yourFilterCondition';
      }).toList();
    }
  }


  void _filterData(String filter, String value) {
    setState(() {
      switch (filter) {
        case 'Date':
        // Implement filtering logic for Date
        // For example, filter courseData based on the selected date value
          courseData = courseData
              .where((item) => item['date'] == value || value == 'All')
              .toList();
          break;
        case 'AssetName':
        // Implement filtering logic for AssetName
        // For example, filter courseData based on the selected asset name value
          courseData = courseData
              .where((item) => item['assets_name'] == value || value == 'All')
              .toList();
          break;
      // case 'PairName':
      // // Implement filtering logic for PairName
      // // For example, filter courseData based on the selected pair name value
      //   courseData = courseData
      //       .where((item) => item['pair_name'] == value || value == 'All')
      //       .toList();
      //   break;
        case 'TimeZone':
        // Implement filtering logic for TimeZone
        // For example, filter courseData based on the selected time zone value
          courseData = courseData
              .where((item) => item['timezone_name'] == value || value == 'All')
              .toList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Container(
          child: Text(
            "Blog",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Color(0xffffc400),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 10,),
          // Add a filter dropdown
          // Container(
          //   padding: EdgeInsets.all(8.0),
          //   child: DropdownButton<String>(
          //     value: selectedFilter,
          //     onChanged: (String newValue) {
          //       setState(() {
          //         selectedFilter = newValue;
          //         // Call a method to filter the data based on the selected option
          //         _filterData(selectedFilter, newValue);
          //       });
          //     },
          //     items: ['All', 'Filter1', 'Filter2'] // Replace with your filter options
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),

          // // Body content
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust as needed
          //     children: [
          //       _buildFilterOptions('Date', dateOptions, selectedDateFilter, (String newValue) {
          //         setState(() {
          //           selectedDateFilter = newValue;
          //         });
          //         _filterData('Date', newValue);
          //       }),
          //
          //       _buildFilterOptions('AssetName', assetNameOptions, selectedAssetNameFilter, (String newValue) {
          //         setState(() {
          //           selectedAssetNameFilter = newValue;
          //         });
          //         _filterData('AssetName', newValue);
          //       }),
          //
          //       _buildFilterOptions('TimeZone', timeZoneOptions, selectedTimeZoneFilter, (String newValue) {
          //         setState(() {
          //           selectedTimeZoneFilter = newValue;
          //         });
          //         _filterData('TimeZone', newValue);
          //       }),
          //     ],
          //   ),
          // ),

          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(

      // currentIndex: _currentIndex,

      onTap: (int index) {

        if (index == 0) {
          Navigator.push(

            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoursesMain()),
          );
        }

        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FourthPage()),
          );
        }



      },
      selectedItemColor: Colors.black, // Customize the selected label color
      unselectedItemColor: Colors.grey, // Customize the unselected label color
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Customize the selected label style
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Customize the unselected label style
      selectedIconTheme: IconThemeData(color: Colors.black), // Customize the selected icon color
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
            size: 30,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon:Icon(Icons.menu_book,
            size: 30,),

          label: 'Courses',

        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person,

            size: 30,),
          label: 'Profile',
        ),
      ],
    );
  }


  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        final Map<String, dynamic> course = courseData.isNotEmpty
            ? courseData[0]
            : {};
        print(course);
        return ListView.builder(
            shrinkWrap: true,
            itemCount: courseData.length,
            itemBuilder: (context, index) {
              final course = courseData[index];
              if ((selectedDateFilter == 'All' ||
                  course['date'] == selectedDateFilter) &&
                  (selectedAssetNameFilter == 'All' ||
                      course['assets_name'] == selectedAssetNameFilter) &&
                  // (selectedPairNameFilter == 'All' || course['pair_name'] == selectedPairNameFilter) &&
                  (selectedTimeZoneFilter == 'All' ||
                      course['timezone_name'] == selectedTimeZoneFilter)) {
                return
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          if (course != null && course.containsKey('id')) {
                            int selectedId = int.parse(course['id']);
                            Navigator.push(context, PageTransition(
                                type: PageTransitionType.fade,
                                child: BLog_detail(id: selectedId)
                            ));
                          }
                        },
                        child:
                        Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Padding(padding: EdgeInsets.only(
                                  left: 20, right: 20),
                                child:
                                Container(
                                  width: screenWidth * 0.9,
                                  // height: screenHeight * 0.3,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: course.containsKey('blog_image')
                                        ? Image(
                                      image: CachedNetworkImageProvider(
                                        '${MyConstants
                                            .imageUrl}/${course['blog_image']}',
                                      ),
                                      fit: BoxFit.contain,
                                    )
                                        : Placeholder(), // Placeholder or any other widget to show when 'chart' is not available
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align columns at the start
                                children: [
                                  // "exchange-rate" and "candlestick-chart" section
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align items within the column at the start
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: screenWidth * 0.05),
                                          Image(
                                            height: screenHeight * 0.09,
                                            width: screenWidth * 0.09,
                                            image: AssetImage("assets/images/poem.png"),
                                          ),
                                          Container(
                                            child: Text(
                                              courseData.isNotEmpty
                                                  ? courseData[index]['blog_author']
                                                  : 'N/A',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.05,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: screenWidth * 0.05),
                                          // Image(
                                          //   height: screenHeight * 0.09,
                                          //   width: screenWidth * 0.09,
                                          //   image: AssetImage("assets/images/candlestick-chart.png"),
                                          // ),
                                          // Container(
                                          //   child: Text(
                                          //     courseData.isNotEmpty
                                          //         ? courseData[index]['pair_name']
                                          //         : 'N/A',
                                          //     style: TextStyle(
                                          //       fontSize: screenWidth * 0.05,
                                          //       fontWeight: FontWeight.w700,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: screenWidth * 0.05), // Adjust the spacing as needed

                                  // "free-trade" and "calendar" section
                                  Padding(padding: EdgeInsets.only(left: screenWidth * 0.05),
                                    child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align items within the column at the start
                                    children: [
                                      Row(
                                        children: [
                                          // Image(
                                          //   height: screenHeight * 0.09,
                                          //   width: screenWidth * 0.09,
                                          //   image: AssetImage("assets/images/free-trade.png"),
                                          // ),
                                          // Container(
                                          //   child: Text(
                                          //     courseData.isNotEmpty
                                          //         ? courseData[index]['timezone_name']
                                          //         : 'N/A',
                                          //     style: TextStyle(
                                          //       fontSize: screenWidth * 0.05,
                                          //       fontWeight: FontWeight.w700,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image(
                                            height: screenHeight * 0.09,
                                            width: screenWidth * 0.09,
                                            image: AssetImage("assets/images/calendar.png"),
                                          ),
                                          Container(
                                            child: Text(
                                              courseData.isNotEmpty
                                                  ? DateFormat('dd-MM-yy').format(
                                                DateFormat('yyyy-MM-dd').parse(
                                                  courseData[index]['blog_date'],
                                                ),
                                              )
                                                  : 'N/A',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.05,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  )
                                ],
                              ),



                              SizedBox(width: screenWidth * 0.05),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                                child:
                              Text(
                                courseData.isNotEmpty
                                    ? courseData[index]['blog_name']
                                    : 'N/A',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              ),
                              // SizedBox(width: screenWidth * 0.05),
                              // Container(
                              //   child: Html(
                              //     data: '${extractFirst100Words(
                              //         courseData[index]['long_desc'])} ...' ?? 'N/A',
                              //     onLinkTap: (url, attribute,element) {
                              //       // Handle link taps if needed
                              //       print('Tapped on link: $url');
                              //     },
                              //     style: {
                              //       'p': Style(
                              //         // Add the desired text styling for paragraphs
                              //         fontSize: FontSize(14),
                              //         fontFamily: 'SF Pro',
                              //         fontWeight: FontWeight.w400,
                              //         lineHeight: LineHeight(1.4),
                              //         letterSpacing: 0.03,
                              //         textDecoration: TextDecoration.none,
                              //         color: Colors.black.withOpacity(
                              //             0.6399999856948853),
                              //       ),
                              //       // You can add more style rules for other HTML elements as needed
                              //     },
                              //   ),
                              //
                              // ),
                            ],
                          ),
                        ),
                      )
                  );
              }
            }

        );
      },
    );
  }

  Widget _buildFilterOptions(String filter, List<String> options, String selectedValue, Function(String) onChanged) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return
      Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
      Container(
        height: screenHeight*0.05,
        width: screenWidth*0.4,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filter,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options.map((String option) {
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onChanged(option);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      )
      );

  }

}



