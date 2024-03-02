import 'package:flutter/material.dart';
// import 'package:new_project/4.dart';
import 'package:new_app/currency_report.dart';
import 'package:new_app/slider1.dart';
import 'package:page_transition/page_transition.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:new_app/url.dart';
import 'package:new_app/online_offline.dart';
import 'package:new_app/4.dart';

import 'package:new_app/basic1.dart';

import 'package:new_app/courses_main.dart';

class SecondPage extends StatefulWidget {

  final String courseMode;

  SecondPage({required this.courseMode});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  List<Map<String, dynamic>> courseData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
        Uri.parse('${MyConstants.baseUrl}/course_api/course_data'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

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
    int _currentIndex = 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title:

        Container(
          child: Text("Programs",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black
            ),),
        ),

        backgroundColor:  Color(0xffffc400),
      ),


      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(_currentIndex,  context,widget.courseMode),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

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

          if (index == 3) {

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
            icon: Icon(Icons.info,

              size: 30,),
            label: 'About-Us',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int currentIndex,context,String courseMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    switch (currentIndex) {
      case 0:
        return SingleChildScrollView(
          // Your favorites content goes here
        );

      case 2:
        return SingleChildScrollView(
          // Your favorites content goes here
        );
      case 1:
        return
    ListView.builder(
        shrinkWrap: true,
    itemCount: courseData.length,
    itemBuilder: (context, index) {
      final course = courseData[index];
      if (course['course_mode'] == courseMode) {
        return Padding(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the rectangle
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                      10.0), // Border radius to create rounded corners
                ),
              ),

              child: Column(
                children: [

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    child: Container(
                        width: double.infinity,
                        height: 240,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                    '${MyConstants.imageUrl}/${course['course_image']}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )

                        )


                    ),

                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    courseData.isNotEmpty
                        ? courseData[index]['course_name']
                        : 'N/A',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),


                  SizedBox(
                      height: 10
                  ),

                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.menu_book,),
                      SizedBox(width: 5,),
                      Text(courseData.isNotEmpty
                          ? '${courseData[index]['course_lessons']} Lessons'
                          : 'N/A',),
                      SizedBox(width: screenWidth*0.3,),
                      Icon(Icons.timer),
                      SizedBox(width: 5,),
                      Text(courseData.isNotEmpty
                          ? '${courseData[index]['course_duration']}'
                          : 'N/A',)

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.playlist_add_check_circle),
                      SizedBox(width: 10,),
                      Text("Includes certificate")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(courseData.isNotEmpty
                              ? ' INR ${courseData[index]['course_price']}'
                              : 'N/A',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),)
                        ],
                      ),

                      SizedBox(
                        width: screenWidth*0.15,
                      ),

                      Padding(padding: EdgeInsets.only(left:10,bottom: 10),child:
                      Container(
                        width: screenWidth*0.3,
                        child: ElevatedButton(
                          onPressed: () {
                            if (course != null && course.containsKey('id')) {
                              int selectedId = int.parse(course['id']);
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: basic1(id: selectedId)
                              ));
                            }
                          },
                          child: Text(
                            "View",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffffc400)
                          ),),
                      )
                      )
                    ],
                  ),
                ],
              )

          ),
        );
      }
      else {
        // If the condition is not met, return an empty container or a placeholder
        return Container(); // You might adjust this according to your UI needs
      }
    }

    );








  case 3:
        return SingleChildScrollView(
          // Your favorites content goes here
        );

      default:
        return Container();
    }
  }
}
