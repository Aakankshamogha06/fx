import 'package:flutter/material.dart';
import 'package:new_app/courses.dart';
import 'package:new_app/courses_main.dart';
import 'package:new_app/economic_calender.dart';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/imageslider.dart';
import '';
import 'package:new_app/blog.dart';
import 'package:new_app/ebook.dart';
import 'package:new_app/currency_report.dart';
import 'package:new_app/knowledge_hub.dart';
import 'package:new_app/online_offline.dart';
import 'package:new_app/4.dart';
import 'package:new_app/live_market_data.dart';
import 'package:new_app/webinar.dart';
import 'package:new_app/wallet.dart';
import 'package:new_app/url.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<Map<String, dynamic>> courseData = [];
  bool _isLoading = true;

  void initState() {
    super.initState();
    _loadCourseData();
  }

  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/market_primer_data'),
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
  Widget build(BuildContext context,
      // int currentIndex
      ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int _currentIndex = 0;
    return WillPopScope(
        onWillPop: () async {
      // Handle the back button press
      // Use SystemNavigator.pop to exit the app
      exit(0);
      return false; // Return false to prevent the app from popping the current route
    },
    child:
      Scaffold(

        appBar: AppBar(
          backgroundColor: const Color(0xffffc400),
          automaticallyImplyLeading: false,
          title: Row(
            // mainAxisAlignment: mainAxisAlignment.center,
            //  mainAxisAlignment: MainAxisAlignment.end,

            children: [
              Image.asset(
                'assets/images/MicrosoftTeams-image166fb87a34f356ec84747339b223195637acc5d9882d988615452c61fc25f37e.png',
                width: screenWidth * 0.22,
                height: screenHeight * 0.22,
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Add your onPressed function here
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(
                Icons.manage_accounts_rounded,
                size: 35,
              ),
            ),
          ],
        ),


    body:SingleChildScrollView(

      // Your home content goes here
        child: Column(
            children: [
              SizedBox(
                height: screenHeight*.03,
              ),
              ImageSlider(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child:
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              // Navigator.push(context, PageTransition(
                              //     type: PageTransitionType.fade,
                              //     child: VideoApp()));

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SecondPage(courseMode: "recorded")),
                              );
                            },
                            child: SizedBox(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/video-player-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Self learning program",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),

                                    ),
                                    ),
                                  ],
                                ),

                              ),


                            )

                        ),),
                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'offline')),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/classroom-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: 10,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Classroom courses",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ),


                            )

                        ),),

                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'online')),
                            );
                          },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/online-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Online courses",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ),


                            )

                        ),),


                      ],
                    ),


                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Ebook()));
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.5,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/audiobook-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "E-books",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),

                              ),


                            )

                        ),),

                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Currency_report()
                              ));
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/bar-chart-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Currency report",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ),


                            )

                        ),),

                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                          onTap: () {
                            final course = courseData[0];
                            if (course!= null && course.containsKey('file_name')) {
                              String pdfUrl = '${MyConstants.pdfUrl}/${course['file_name']}';
                              _viewPdf(pdfUrl);
                            }
                          },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/market-primer-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Market primer",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ),


                            )

                        ),),


                      ],
                    ),


                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Blog()
                              ));
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/blog-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child:
                                      Text(
                                        "Blog",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),

                              ),


                            )

                        ),),
                        SizedBox(width: screenWidth * 0.015,),
                        Flexible(child:

                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Knowledge_hub(),
                                  // Knowledge_hub()
                              ));
                            },
                            child: SizedBox(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/world-book-day-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Knowledge \n Hub",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),

                              ),
                            )
                        ),


                        ),


                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Economic_calender()));
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/payment-day-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Economic calendar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),

                              ),


                            )

                        ),),
                      ],
                    ),


                    SizedBox(height: 20,),
                    Row(
                      children: [

                        // Flexible(child:
                        // GestureDetector(
                        //     onTap: () {
                        //
                        //     },
                        //     child: Container(
                        //       height: screenHeight*0.17,
                        //       width: screenWidth*1.1,
                        //       child:  Card(
                        //         color: Colors.white,
                        //         child:Column(
                        //           children: [
                        //             SizedBox(height: 10,),
                        //             Container(
                        //                 height: screenHeight*0.08,
                        //                 width: screenWidth*0.15,
                        //                 decoration: BoxDecoration(
                        //                   image:  DecorationImage(
                        //                       image: AssetImage('assets/gif/live-classes-unscreen.gif'),
                        //                       fit: BoxFit.fill
                        //                   ),
                        //                 )
                        //
                        //             ) ,
                        //             SizedBox(height: 10,),
                        //             Flexible(child:
                        //             Container(
                        //                 child:  Text(
                        //                   "Live classes",
                        //                   textAlign: TextAlign.center,
                        //                   style: TextStyle(
                        //                       fontSize:  screenHeight*0.018,
                        //                       fontWeight: FontWeight.w600
                        //                   ),
                        //                 ),
                        //             )
                        //             ),
                        //           ],
                        //         ),
                        //
                        //       ),
                        //
                        //
                        //     )
                        //
                        // ),),
                        // SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/Demosession');
                              // Navigator.push(context, PageTransition(
                              //     type: PageTransitionType.fade,
                              //     child: Webinar()));
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/presentation-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Demo \n Session",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                  ],
                                ),

                              ),


                            )

                        ),),
                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              // WalletPage();
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const WalletPage()));
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(builder: (context) =>
                              //       // wallet()
                              //   WalletPage()
                              //   ),
                              // );
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.9,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.1,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/wallet-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Wallet",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),
                                    SizedBox(height: 10,),

                                  ],
                                ),


                              ),


                            )

                        ),),

                        SizedBox(width: screenWidth * 0.02,),
                        Flexible(child:
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Live_market_data()),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 1.1,
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.15,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/gif/stock-market-unscreen.gif'),
                                              fit: BoxFit.fill
                                          ),
                                        )

                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Flexible(child:
                                    Container(
                                      child: Text(
                                        "Live market data",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    ),


                                  ],
                                ),


                              ),


                            )

                        ),),
                      ],
                    ),


                  ],
                ),
              ),
            ]
        )
    ),
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
              icon: Icon(Icons.info_rounded,

                size: 30,),
              label: 'About-Us',
            ),
          ],
        ),
    ));

  }
}



