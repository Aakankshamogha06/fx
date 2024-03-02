import 'package:flutter/material.dart';
// import 'package:new_project/market.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:new_app/url.dart';

const List<String> list = <String>['India', 'Dubai'];
const List<String> d = <String>['2023-09-12', '2023-15-12'];
const List<String> t = <String>['17:30', '18:00'];

class BookSlot extends StatefulWidget {
  final int id;
  BookSlot({required this.id,});
  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {

  String? selectedCountry;
  String? selectedState;
  List<String> countries = [];
  List<String> states = [];

  String dropdownValue = list.first;
  String dropdownDateValue = d.first;
  String dropdownTimeValue = t.first;

  List<Map<String, dynamic>> courseData = [];
  Map<String, dynamic> getCourseDataById(int id) {
    return courseData.firstWhere((course) => course['id'] == id, orElse: () => {'defaultKey': 'defaultValue'});
  }

  String userId = '';
  String courseId = '';

  String getCourseName(int id) {
    final course = courseData.firstWhere((course) => course['id'] == id, orElse: () => {'name': 'N/A'});
    return course['name'];
  }

  String getCoursePrice(int id) {
    final coursep = courseData.firstWhere((course) => course['id'] == id, orElse: () => {'price': 'N/A'});
    return coursep['price'];
  }

  String getCourseDuration(int id) {
    final coursed = courseData.firstWhere((course) => course['id'] == id, orElse: () => {'duration': 'N/A'});
    return coursed['duration'];
  }



  @override
  void initState() {
    super.initState();
    _loadCourseData();
    _openRazorpayPayment();
  }

  Future<void> fetchStates(String country) async {
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v2/name/$country'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          final List<dynamic> statesData = jsonData[0]['borders'];
          if (statesData is List) {
            setState(() {
              states = statesData.map<String>((state) => state['name'].toString()).toList();
            });
            print('JSON Data: $jsonData');

          } else {
            throw Exception('Invalid states data format from the API');
          }
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load states');
      }
    } catch (e) {
      print('Error fetching states: $e');
    }
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v2/all'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData is List) {
          setState(() {
            countries = jsonData.map<String>((country) => country['name'].toString()).toList();
          });
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      print('Error fetching countries: $e');
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
      String contact = decodedToken['contact'] ?? '';
      String email = decodedToken['email'] ?? '';
      String userId = decodedToken['uid'] ?? ''; // Assuming 'user_id' is the key for the user ID

      return {
        'contact': contact,
        'email': email,
        'user_id': userId, // Include the user ID in the returned map
      };
    }
    return {}; // Return an empty map if the contact number, email, or user ID cannot be obtained
  }


  Future<void> _loadCourseData() async {
    try {
      List<Topic> topics = await fetchCourseData();
      List<Map<String, dynamic>> convertedData = topics.map((topic) => {
        'id': topic.id,
        'name': topic.name,
        'price': topic.price,
        'duration': topic.duration
        // Add other necessary fields from the Topic class
      }).toList();

      setState(() {
        courseData = convertedData;
        print(courseData);
      });
    } catch (e) {
      // Handle errors here, e.g., show an error message to the user
      print('Error loading course data: $e');
    }
  }


  Future<List<Topic>> fetchCourseData() async {
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

  Future<void> insertPaymentDetails(String userId, String courseId, String transactionId, String amount) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

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




  @override
  Widget build(BuildContext context,) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Container(
          child: Text(
            "Book Slot",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor:  Color(0xffffc400),
      ),
      body:
    Padding(
    padding: EdgeInsets.all(15),
    child: Container(
    width: screenWidth > 600 ? 600 : double.infinity,
    height: screenHeight * 0.38,
    decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
    color: Colors.grey,
    width: 1.0,
    ),
    borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
    children: [
    SizedBox(height: 20),
    Row(
    children: [
    SizedBox(width: 10,),
    Text(
    courseData.isNotEmpty ? 'Course Name: ${getCourseName(widget.id)} ': 'N/A',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: screenWidth > 600 ? 20 : 16,
    ),
    ),




    ],
    ),

    SizedBox(height: 10),
    Row(
    children: [
    SizedBox(width: 10),
    Icon(Icons.price_change),
    SizedBox(width: 5),
    Expanded(child: Text(courseData.isNotEmpty
    ? 'Price: INR ${getCoursePrice(widget.id)} '
        : 'N/A'),),

      Icon(Icons.date_range),
      SizedBox(width: 10),
      Text(courseData.isNotEmpty ? 'Duration: ${getCourseDuration(widget.id)}'  : 'N/A',),


    ],
    ),
    SizedBox(height: screenHeight * 0.02),
      Expanded(child:
      Container(
        child: Row(
          children: [
            SizedBox(width: screenWidth * 0.03),
            Text('Country:'),
            SizedBox(width: screenWidth * 0.03),
          Container(
                width: screenWidth * 0.3, // Adjust the width as needed
                child:
                DropdownButton<String>(
                  value: selectedCountry,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Color(0xffffc400),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCountry = value;
                      selectedState = null; // Reset selected state when country changes
                    });

                    // Fetch states for the selected country
                    fetchStates(selectedCountry!);
                  },
                  items: countries.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
          ),



          ],
        ),
      ),),
      SizedBox(height: screenHeight * 0.01),
   Row(
     children: [
       SizedBox(width: screenWidth * 0.03),
       Text('State:'),
       Container(
          width: screenWidth*0.05,// Adjust the width as needed
         child: DropdownButton<String>(
           value: selectedState,
           icon: const Icon(Icons.arrow_downward),
           elevation: 16,
           style: const TextStyle(color: Colors.black),
           underline: Container(
             height: 2,
             color: Color(0xffffc400),
           ),
           onChanged: (String? value) {
             setState(() {
               selectedState = value;
             });
             // TODO: Fetch cities and districts for the selected state.
           },
           items: states.map<DropdownMenuItem<String>>((String value) {
             return DropdownMenuItem<String>(
               value: value,
               child: Text(value),
             );
           }).toList(),
         ),
       ),
     ],
   ),
   Row(
          children: [
            SizedBox(width: screenWidth*0.03,),
            Text('City:'),
            SizedBox(width: screenWidth*0.08,),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle( color: Colors.black),
              underline: Container(
                height: 2,
                color: Color(0xffffc400),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: screenWidth*0.08,),
            Text('Branch:'),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle( color: Colors.black),
              underline: Container(
                height: 2,
                color: Color(0xffffc400),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

          ],
        ),

      SizedBox(height: screenHeight * 0.01),
      Container(
        child: Row(
          children: [
            SizedBox(width: screenWidth*0.03,),
            Text('Date:'),
            SizedBox(width: screenWidth*0.07,),
            DropdownButton<String>(
              value: dropdownDateValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle( color: Colors.black),
              underline: Container(
                height: 2,
                color: Color(0xffffc400),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownDateValue = value!;
                });
              },
              items: d.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: screenWidth*0.08,),
            Text('Time:'),
            SizedBox(width: screenWidth*0.03,),
            DropdownButton<String>(
              value: dropdownTimeValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle( color: Colors.black),
              underline: Container(
                height: 2,
                color: Color(0xffffc400),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownTimeValue = value!;
                });
              },
              items: t.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

          ],
        ),
      ),
      SizedBox(height: screenHeight*0.02,),

      Container(
        width: screenWidth * 0.5,
        child: ElevatedButton(
          onPressed: ()
          {
            _openRazorpayPayment();
          },
          child: Text(
            "Pay now",
            style: TextStyle(
                color: Colors.black
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffffc400)
          ),),
      )

    ],
    ),
    ),
    )

    );
  }

  void _openRazorpayPayment() async {
    final _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Map<String, dynamic> userInfo = await getUsernameFromToken();

    var options = {
      'key': 'rzp_test_Ekd6vmP8LfPAMm',
      'amount': getCoursePrice(widget.id) + '00', // amount in the smallest currency unit (e.g., paise)
      'name': 'FXCareers', // Replace with your app name
      'description': 'Payment for Some Service',
      'prefill': {
        'contact': userInfo['mobile_no'] ?? '', // Use the fetched contact number
        'email': userInfo['email'] ?? '',
        'name': userInfo['firstname'] ?? ''
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      Map<String, dynamic> userInfo = await getUsernameFromToken();
      String userId = userInfo['user_id'] ?? ''; // Fetch user ID
      String courseId = widget.id.toString(); // Get course ID
      String? transactionId = response.paymentId; // Payment ID from Razorpay
      String amount = getCoursePrice(widget.id); // Get the amount paid

      // print('User ID: $userId');
      // print('Course ID: $courseId');
      // print('Transaction ID: $transactionId');
      // print('Amount: $amount');

      await insertPaymentDetails(userId, courseId, transactionId!, amount);
      // print("Payment Successful");
      // print("Payment Id: ${response.paymentId}");
      // Additional logic after successful payment
    } catch (e) {
      print('Error handling payment success: $e');
      // Handle the error, show an error message, or retry logic
    }
  }



  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed");
    print("Code: ${response.code}");
    print("Message: ${response.message}");
    // Handle failure, e.g., show an error message to the user
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

