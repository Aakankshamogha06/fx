// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class MyData extends StatefulWidget {
//   @override
//   _MyDataState createState() => _MyDataState();
// }
//
// class _MyDataState extends State<MyData> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   // TextEditingController lnameController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       Map<String, String> formData = {
//         'name': nameController.text,
//         // 'lastname': lnameController.text,
//         'mobile_no': mobileController.text,
//         'email': emailController.text,
//         // 'password': pController.text,
//         'location' : locationController.text,
//       };
//
//       try {
//         final response = await http.post(
//           Uri.parse('https://fxsignals.ae/admin/api/register'),
//           body: formData,
//         );
//         if (response.statusCode == 200) {
//           print('Form submitted successfully!');
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Form submitted successfully!'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NewPage()),
//           );
//         } else {
//           print('Failed to submit form. Error: ${response.reasonPhrase}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   'Failed to submit form. Error: ${response.reasonPhrase}'),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       } catch (e) {
//         print('Failed to submit form. Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to submit form. Error: $e'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Form Submission'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: <Widget>[
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: locationController,
//                 // decoration: const InputDecoration(labelText: 'location'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: mobileController,
//                 decoration: const InputDecoration(labelText: 'Mobile Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your mobile number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email Address'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email address';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: pController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your location';
//                   }
//                   return null;
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     title: 'Form Submission',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: MyData(),
//   ));
// }





import 'package:flutter/material.dart';
import 'package:new_app/slider1.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:new_app/referral2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';



class wallet extends StatefulWidget {
  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {

  List<Map<String, dynamic>> courseData = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  Future<void> _loadCourseData() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      Map<String, dynamic> tokenPayload = JwtDecoder.decode(accessToken!);
      userId = tokenPayload['uid'];

      List<dynamic> data = await fetchCourseData();

      // Explicitly cast the elements of 'data' to 'Map<String, dynamic>'
      List<Map<String, dynamic>> castedData = data.cast<Map<String, dynamic>>();

      setState(() {
        courseData = castedData;
      });
    } catch (e) {
      print('Error loading course data: $e');
    }
  }


  Future<List<Map<String, dynamic>>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('https://fxcareers.com/api/course_api/wallet_data/$userId'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          return jsonData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        print('Failed to load course data. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
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
    return WillPopScope(
        onWillPop: () async {

         Navigator.push(context, PageTransition(
          type: PageTransitionType.fade,
          child: MyHomePage())
         );
          // Handle the back button press here
          // Return true to allow the app to pop the current route, or false to prevent it
          // You can navigate to a different page or perform any custom logic here
          return true;
        },
child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        leading: BackButton(
          onPressed: (){Navigator.push(context, PageTransition(
              type: PageTransitionType.fade,
              child: MyHomePage())); // Replace '/' with the route name of your homepage
          },
        color: Colors.black,
    ),

    title:

    Container(
      child: Row(
        children: [
          Text("Wallet",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black
            ),),
        ],
      )

    ),

    backgroundColor: Color(0xffffc400),
    ),

       body:SingleChildScrollView(
    child:
    Column(
         children: [
      //      Padding(padding: EdgeInsets.all(15),
      //      child:
      //      Container(
      //        decoration: BoxDecoration(
      //          borderRadius: BorderRadius.circular(20),
      //          border: Border.all(color: Colors.grey, width: 2),
      //        ),
      //        child: Column(
      //          children: [
      //            Row(
      //          crossAxisAlignment: CrossAxisAlignment.start,
      //          children: [
      //            Expanded(
      //              child: Column(
      //                crossAxisAlignment: CrossAxisAlignment.start,
      //                children: [
      //                  Padding(padding:EdgeInsets.all(10),
      //                  child: Text(
      //                    'Invite your friend & earn reward',
      //                    style: TextStyle(
      //                      color: Colors.black,
      //                      fontSize: 25,
      //                      fontWeight: FontWeight.bold,
      //                    ),
      //                  ),),
      //
      // Padding(padding:EdgeInsets.all(10),
      //   child:
      //                  Text(
      //                    'Refer a friend and you will get guaranteed discounts when they make their first purchase on FXCareers app.',
      //                    style: TextStyle(
      //                      color: Colors.black,
      //                      fontSize: 16,
      //                    ),
      //                  ),
      // ),
      //
      //                ],
      //              ),
      //            ),
      //            Center(
      //              child: Container(
      //                height: 200,
      //                width: 150,
      //                decoration: BoxDecoration(
      //                  image: DecorationImage(
      //                    image: AssetImage('assets/images/box-removebg-preview.png'),
      //                    fit: BoxFit.fill,
      //                  ),
      //                ),
      //              ) ,
      //            )
      //
      //          ],
      //        ),
      //        Container(
      //          width: 150,
      //          child: ElevatedButton(
      //            onPressed: () {
      //              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: referral()));
      //            },
      //            child: Text(
      //              "Refer now",
      //              style: TextStyle(
      //                color: Colors.black,
      //              ),
      //            ),
      //            style: ElevatedButton.styleFrom(
      //              primary: Color(0xffffc400),
      //            ),
      //          ),
      //        ),
      //        ])
      //      )
      //        ,),
      //      SizedBox(height: 20), // Add space between sections

           // New column displaying transaction records
           Padding(
             padding: EdgeInsets.all(15),
             child: Column(
               children: [
                 const SizedBox(height: 10),
                 ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: courseData.length + 1, // Add one to account for the header
                   itemBuilder: (context, index) {
                     if (index == 0) {
                       // Build header row with a blank white background
                       return Container(
                         color: Colors.white,
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                         child: const Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Date', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
                             Text('Type', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
                             Text('Amount', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
                           ],
                         ),
                       );
                     } else {
                       final course = courseData[index - 1]; // Adjust index for course data

                       // Alternating row colors for course data
                       final color = index.isOdd ? Colors.yellow.shade50 : Colors.white;

                       return Container(
                         color: color,
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               course['transaction_date'] ?? 'N/A',
                               style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
                             ),
                             Text(
                               course['type'] ?? 'N/A',
                               style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
                             ),
                             Text(
                               course['amount'] != null ? 'INR ${course['amount']} ' : 'N/A',
                               style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
                             ),
                           ],
                         ),
                       );
                     }
                   },
                 ),

               ],
             ),
           ),
         ],
       ),
       )
    )
    );
  }
}

