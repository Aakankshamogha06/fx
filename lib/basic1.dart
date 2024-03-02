import 'package:flutter/material.dart';
import 'package:new_app/buy.dart';
import 'package:new_app/curriculum.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/url.dart';
import 'package:new_app/curriculum2.dart';
import 'package:new_app/language.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class basic1 extends StatefulWidget {
  final int id;

  basic1({required this.id});

  @override
  State<basic1> createState() => _basic1State();
}

class _basic1State extends State<basic1> {
  late Future<List<Map<String, dynamic>>> courseData;
  List<Map<String, dynamic>> courseData1 = [];
  late Future<List<Map<String, dynamic>>> courseDataFuture;
  String courseMode='';
  bool userPurchased = false;

  String? selectedLanguage;

  late Razorpay _razorpay;

  Map<String, dynamic> getCourseDataById(int id) {
    return courseData1.firstWhere((course) => course['id'] == id, orElse: () => {'defaultKey': 'defaultValue'});
  }

  String userId = '';
  String courseId = '';

  Map<String, Object> getCourseName(int id) {
    final course = courseData1.firstWhere((course) => course['id'] == id, orElse: () => {'name': 'N/A'});
    return course['name'];
  }

  String getCoursePrice(int id) {
    final coursep = courseData1.firstWhere(
          (course) => course['id'] == id,
      orElse: () => Map<String, dynamic>.from({'price': 'N/A'}),
    );
    return coursep['price'] ?? 'N/A';
  }

  String getCourseDuration(int id) {
    final coursed = courseData1.firstWhere((course) => course['id'] == id, orElse: () => {'duration': 'N/A'});
    return coursed['duration'];
  }

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    courseDataFuture = fetchCourseData();
    fetchPurchaseData();
  }

  void _initializeRazorpay() {
     _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/course_detail_data/${widget.id}'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
           courseMode = jsonData[0]['course_mode'];

          if (courseMode == 'recorded') {
            // If it's a recorded course, navigate to curriculum

          } else {
            // If it's not a recorded course, navigate to curriculum2

          }

          // Returning the fetched data
          return jsonData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching course data: $e');
      throw e; // Re-throw the exception to propagate it further
    }
  }


  Future<String> fetchCoursePrice() async {
    try {
      final List<Map<String, dynamic>> courseData = await fetchCourseData();

      if (courseData.isNotEmpty) {
        // Assuming 'course_price' is the key for the course price
        String? coursePrice = courseData[0]['course_price'];

        if (coursePrice != null) {
          return coursePrice;
        } else {
          throw Exception('Course price not available');
        }
      } else {
        throw Exception('Empty course data');
      }
    } catch (e) {
      print('Error getting course price: $e');
      throw e; // Re-throw the exception to propagate it further
    }
  }

  // Future<void> _loadCourseData() async {
  //   try {
  //     // List<Topic> topics = await fetchCourseData1();
  //     List<Map<String, dynamic>> convertedData = topics.map((topic) => {
  //       'id': topic.id,
  //       'name': topic.name,
  //       'price': topic.price,
  //       'duration': topic.duration
  //       // Add other necessary fields from the Topic class
  //     }).toList();
  //
  //     setState(() {
  //       courseData1 = convertedData;
  //       print(courseData1);
  //     });
  //   } catch (e) {
  //     // Handle errors here, e.g., show an error message to the user
  //     print('Error loading course data: $e');
  //   }
  // }
  Future<List<Topic>> fetchCourseData1() async {
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
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          return jsonData.map((data) => Topic.fromJson(data)).toList();
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

  Future<Map<String, dynamic>> getUsernameFromToken() async {
    // Fetch the access token from storage (assuming you have stored it)
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');

    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      // Extract the contact number, email, and user ID from the decoded token
      String contact = decodedToken['mobile_no'] ?? '';
      String email = decodedToken['email'] ?? '';
      String userId = decodedToken['uid'] ?? ''; // Assuming 'user_id' is the key for the user ID
      print('User id: $userId' );
      print('Email id: $email' );
      print('Contact: $contact' );

      // String price = getCoursePrice(widget.id);
      // print('Price: $price');

      return {
        'contact': contact,
        'email': email,
        'user_id': userId, // Include the user ID in the returned map
      };
    }
    return {}; // Return an empty map if the contact number, email, or user ID cannot be obtained
  }


  Future<List<String>> fetchLanguageData() async {
    print("fetchLanguageData: Start");

    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/language_data'),
        headers: {
          'Authorization': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Ensure the response body is a string
        String responseBody = response.body;
        print("fetchLanguageData: Response Body: $responseBody");

        // Parse the string into a List<dynamic>
        List<dynamic> data;
        try {
          data = json.decode(responseBody);
        } catch (e) {
          print("fetchLanguageData: Error decoding JSON - $e");
          throw Exception('Failed to decode language data');
        }

        // Extracting language names from the 'Language' key in each map
        List<String> languageOptions = data.map((item) => item['Language'].toString()).toList();
        print("fetchLanguageData: Language Options: $languageOptions");

        return languageOptions;
      } else {
        // Handle error
        print("fetchLanguageData: Failed to load language data. Status code: ${response.statusCode}");
        throw Exception('Failed to load language data');
      }
    } catch (e) {
      print("fetchLanguageData: Error fetching data - $e");
      throw Exception('Failed to fetch language data');
    }
  }




  Future<String?> showLanguageSelectionForm(List<String> languageOptions) async {
    print("showLanguageSelectionForm: Start");

    // Additional parameters you want to pass
    String userId = ''; // Replace with the actual user ID
    String courseId = ''; // Replace with the actual course ID

    // Navigate to LanguageSelectionPage and pass additional parameters
     selectedLanguage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageSelectionPage(
          languageOptions,
        ),
      ),
    );

    print("showLanguageSelectionForm: Returning selected language: $selectedLanguage");
    return selectedLanguage;

  }


  Future<String?> fetchLanguageCode(String selectedLanguageName) async {
    print("fetchLanguageCode: Start");

    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/language_data'),
        headers: {
          'Authorization': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Ensure the response body is a string
        String responseBody = response.body;
        print("fetchLanguageCode: Response Body: $responseBody");

        // Parse the string into a List<dynamic>
        List<dynamic> data;
        try {
          data = json.decode(responseBody);
        } catch (e) {
          print("fetchLanguageCode: Error decoding JSON - $e");
          throw Exception('Failed to decode language data');
        }

        // Find the language code based on the selected language name
        String? selectedLanguageCode;
        for (var item in data) {
          if (item['Language'].toString() == selectedLanguageName) {
            selectedLanguageCode = item['sub_code'].toString();
            break;
          }
        }

        print("fetchLanguageCode: Selected Language Code: $selectedLanguageCode");
        print("fetchLanguageCode: End");
        return selectedLanguageCode;
      } else {
        // Handle error
        print("fetchLanguageCode: Failed to load language data. Status code: ${response.statusCode}");
        throw Exception('Failed to load language data');
      }
    } catch (e) {
      print("fetchLanguageCode: Error fetching data - $e");
      throw Exception('Failed to fetch language data');
    }
  }


  Future<void> fetchPurchaseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    Map<String, dynamic>? tokenPayload; // Declare tokenPayload as nullable

    if (accessToken != null) {
      tokenPayload = JwtDecoder.decode(accessToken);
      userId = tokenPayload['uid'];
    } else {
      // Handle the case when accessToken is null
      print('Access token is null. Unable to decode token payload.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/purchase_data/${widget
            .id}/$userId'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      print('${MyConstants.baseUrl}/course_api/purchase_data/${widget
          .id}/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Check if the response is a non-empty list
        if (data is List && data.isNotEmpty) {
          // Iterate over the list and find the relevant item
          for (final item in data) {
            if (item is Map<String, dynamic> &&
                item['transaction_status'] == 'Approved') {
              // Found a purchase with 'transaction_status' set to 'Approved'
              setState(() {
                userPurchased = true;
              });
            }
            print(userPurchased);
          }
        }
      }
    }
    catch (e) {
      print('Error fetching purchase data: $e');
    }
  }



              @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: courseDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading course data'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildCourseContent(snapshot.data![0]);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _handleCourseData(Map<String, dynamic> courseData) {
    String? courseMode = courseData['course_mode'];
    if (courseMode == 'recorded') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => curriculum(id: widget.id, title: 'app', children: []),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => curriculum2(id: widget.id, title: 'app', children: []),
        ),
      );
    }
  }


  Future<void> insertPaymentDetails(String userId, String courseId, String transactionId, String amount,String selectedLanguage) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      print("call2");

      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('${MyConstants.baseUrl}/course_api/insert_data'),
          headers: {
            'Authorization': '$accessToken',

          },
          body: ({
            'user_id': userId,
            'course_id': courseId,
            'transaction_id': transactionId,
            'amount': amount,
            'course_lang': selectedLanguage,
          }),

        );

        // print('Response Status Code: ${response.statusCode}');
        // print('Response Body: ${response.body}');

        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);

          if (responseData['message'] == 'Data inserted successfully') {
            print('Payment details inserted successfully');
            // Handle success
          } else {
            throw Exception('Failed to insert payment details: ${responseData['message']}');
          }
        } else {
          throw Exception('Failed to insert payment details. Error code: ${response.statusCode}');
        }
      } else {
        throw Exception('Access token not found');
      }
    } catch (e) {
      print('Error inserting payment details: $e');
      // Handle the error, show an error message, or retry logic
    }
  }


  Widget _buildCourseContent(Map<String, dynamic> courseData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title:

          Container(
            child: Text( courseData['course_name'] ?? 'N/A',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black
              ),),
          ),

          backgroundColor:Color(0xffffc400),

        ),


        body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: screenWidth*1,
                      height: 302.58,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:Center(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child:Image(
                                image: CachedNetworkImageProvider(
                                  '${MyConstants.imageUrl}/${courseData['course_image']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )

                      )
                  ),
                  SizedBox(
                    height: 10,
                  ),


                  Container(
                      width: screenWidth*1,
                      height: 270,
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: courseData['course_name'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 18,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w700,
                                      height: 0.07,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 190,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth*1,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  height: 20,
                                                  child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [

                                                        Icon(Icons.menu_book),
                                                        SizedBox(width: 8,),
                                                        Text.rich(
                                                            TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: courseData['course_lessons'] ?? 'N/A',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xCC222222),
                                                                        fontSize: 14,
                                                                        fontFamily: 'SF Pro',
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        height: 0,
                                                                        decoration: TextDecoration
                                                                            .none
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' lessons',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xCC222222),
                                                                        fontSize: 14,
                                                                        fontFamily: 'SF Pro',
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        height: 0,
                                                                        decoration: TextDecoration
                                                                            .none
                                                                    ),
                                                                  ),
                                                                ]
                                                            )),

                                                        SizedBox(width: screenWidth*0.355,),
                                                        Icon(Icons
                                                            .timer_outlined),
                                                        SizedBox(width: 3,),

                                                        Text(courseData.isNotEmpty
                                                            ? '${courseData['course_duration']} '
                                                            : 'N/A',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight: FontWeight
                                                                  .normal,
                                                              fontSize: 14,
                                                              decoration: TextDecoration
                                                                  .none
                                                          ),)
                                                      ]
                                                  ),

                                                )
                                            ),


                                          ]
                                      ),

                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        // SizedBox(width: 18,),
                                        Icon(Icons.person),
                                        SizedBox(width: 10,),
                                        Text('4 enrolled',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal
                                          ),),
                                        SizedBox(width: screenWidth*0.35,),
                                        Icon(Icons.lightbulb),
                                        SizedBox(width: 3,),
                                        Text('All levels',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal
                                          ),),

                                      ],
                                    ),

                                    SizedBox(height: 10,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          // SizedBox(width: 18,),
                                          Icon(Icons.playlist_add_check_circle),
                                          SizedBox(width: 10,),
                                          Text('Includes certificate',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal
                                            ),),
                                        ]
                                    ),

                                    SizedBox(
                                      height: screenHeight*0.02,
                                    ),
                                    userPurchased
                                        ?  Center(
                                        child:
                                        Container(
                                          width: 150,
                                          height: screenHeight*0.05,
                                          child: ElevatedButton(
                                            onPressed: ()
                                            { _handleCourseData(courseData);
                                            },
                                            child: Text(
                                              "Start now",
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xffffc400)
                                            ),),
                                        )
                                    )
                                        :GestureDetector(
                                        onTap: () async {
                                          // Fetch language data from the API
                                          List<String> languageOptions = await fetchLanguageData();

                                          // Show the language selection form
                                          // String selectedLanguage = await showLanguageSelectionForm(languageOptions) ?? 'defaultLanguage';

// Or if you want to skip the Razorpay payment if the language is not selected:
                                          if(courseMode=='recorded') {
                                            String? selectedLanguage = await showLanguageSelectionForm(
                                                await fetchLanguageData());
                                          }
                                          else{
                                            selectedLanguage='en';
                                          }
                                          if (selectedLanguage != null) {
                                            _openRazorpayPayment();
                                          }

                                        },
                                        child:
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child:
                                          Container(
                                            width: 388,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFF9C311),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Buy',
                                                  style: TextStyle(
                                                    color: Color(0xFF222222),
                                                    fontSize: 16,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),
                            ),

                          ]
                      )
                  ),


                  Container(
                    width: screenWidth*1,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFEBEBEB),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.only(left: 20),
                    child:
                    Container(
                      width: screenWidth*1,
                      height: 44,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course available in:',
                            style: TextStyle(
                                color: Color(0xCC222222),
                                fontSize: 14,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                decoration: TextDecoration.none
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'English, Hindi, and Arabic',
                            style: TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 16,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 0,
                                decoration: TextDecoration.none
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: screenWidth*1,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFEBEBEB),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(padding: EdgeInsets.only(left: 20,right: 20),
                    child:
                    Container(
                      width: screenWidth*1,
                      height: 39,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Price:',
                            style: TextStyle(
                                color: Color(0xA3222222),
                                fontSize: 16,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 0.08,
                                decoration: TextDecoration.none
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                            text: ' INR ',
                                            style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: 18,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          TextSpan(
                                            text: courseData['course_price'] ?? 'N/A',
                                            style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: 18,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),


                                        ]
                                    )
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    height: 10,
                    width: screenWidth*1,
                    color: Colors.grey.shade50,
                  ),

                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text(
                          courseData['course_description'] ?? 'N/A',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 18,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            // Adjust the line height as needed
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.left,
                        ),)

                    ],
                  ),
                  SizedBox(width: 388),

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Html(
                          data: courseData['long_description'] ?? 'N/A',
                          onLinkTap: (url,attributes,element) {
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
                      ],
                    ),
                  ),


                  Center(
                      child:
                      Container(
                        width: 150,
                        height: screenHeight*0.05,
                        child: ElevatedButton(
                          onPressed: ()
                          { _handleCourseData(courseData);
                          },
                          child: Text(
                            "Curriculum",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffffc400)
                          ),),
                      )
                  ),

                  SizedBox(height: 50,)
                ],
              )
          ),
        )
    );
  }

  // ... Your existing code ...

// Function to fetch language data from the API


// ... Your existing code ...


  void _openRazorpayPayment() async {
    print("Opening Razorpay Payment");

    Map<String, dynamic> userInfo = await getUsernameFromToken();

    var options = {
      'key': 'rzp_test_Ekd6vmP8LfPAMm',
      'amount': (int.parse(await fetchCoursePrice()) * 100).toString(),
      'name': 'FXCareers',
      'description': 'Payment for Some Service',
      'prefill': {
        'contact': userInfo['mobile_no'] ?? '',
        'email': userInfo['email'] ?? '',
        'name': userInfo['firstname'] ?? '',
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': '#FABF16',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }



  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("_handlePaymentSuccess: Start");

    try {
      Map<String, dynamic> userInfo = await getUsernameFromToken();
      String userId = userInfo['user_id'] ?? ''; // Fetch user ID
      String courseId = widget.id.toString(); // Get course ID
      String? transactionId = response.paymentId; // Payment ID from Razorpay
      String amount =await fetchCoursePrice(); // Get the amount paid

      print('User ID: $userId');
      print('Course ID: $courseId');
      print('Transaction ID: $transactionId');
      print('Amount: $amount');
      print("Selected language from handlepaymentsuccess: $selectedLanguage");

      if (selectedLanguage != null) {
        //  the language code based on the selected language
        String? selectedLanguageCode = await fetchLanguageCode(
            selectedLanguage ?? '');
        print("Call 1");

        if (selectedLanguageCode != null) {
          await insertPaymentDetails(
              userId, courseId, transactionId!, amount, selectedLanguageCode);
          // print("Payment Successful");
          // print("Payment Id: ${response.paymentId}");
          // Additional logic after successful payment
        } else {
          print('Failed to fetch language code for selected language');
        }
      }else {
        print('Language not selected');
      }
    }catch (e) {
      print('Error handling payment success: $e');
      // Handle the error, show an error message, or retry logic
    }
  }



  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      print("Payment Failed");
      print("Code: ${response.code}");
      print("Message: ${response.message}");
      // Handle failure, e.g., show an error message to the user
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
    // Handle external wallet selection
  }
}

class Topic {
  final int id;
  final String name;
  final String price;
  final String duration;

  Topic({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: int.parse(json['id'].toString()),
      name: json['course_name'] ?? 'N/A',
      price: json['course_price'] ?? 'N/A',
      duration: json['course_duration'] ?? 'N/A',
    );
  }
}
