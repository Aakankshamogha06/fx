// import 'package:flutter/material.dart';
// import 'package:new_app/slider1.dart';
// import 'package:page_transition/page_transition.dart';
// // import 'package:new_app/referral2.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
//
//
//
// class wallet extends StatefulWidget {
//   @override
//   State<wallet> createState() => _walletState();
// }
//
// class _walletState extends State<wallet> {
//
//   List<Map<String, dynamic>> courseData = [];
//   String userId = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCourseData();
//   }
//
//   Future<void> _loadCourseData() async {
//     try {
//       final storage = FlutterSecureStorage();
//       String? accessToken = await storage.read(key: 'access_token');
//
//       Map<String, dynamic> tokenPayload = JwtDecoder.decode(accessToken!);
//       userId = tokenPayload['uid'];
//
//       List<dynamic> data = await fetchCourseData();
//
//       // Explicitly cast the elements of 'data' to 'Map<String, dynamic>'
//       List<Map<String, dynamic>> castedData = data.cast<Map<String, dynamic>>();
//
//       setState(() {
//         courseData = castedData;
//       });
//     } catch (e) {
//       print('Error loading course data: $e');
//     }
//   }
//
//
//   Future<List<Map<String, dynamic>>> fetchCourseData() async {
//     final storage = FlutterSecureStorage();
//     String? accessToken = await storage.read(key: 'access_token');
//     try {
//       final response = await http.get(
//         Uri.parse('https://fxcareers.com/api/course_api/wallet_data/$userId'),
//         headers: {
//           'Authorization': '$accessToken',
//         },
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         print(jsonData);
//         if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
//           return jsonData.cast<Map<String, dynamic>>();
//         } else {
//           throw Exception('Invalid data format from the API');
//         }
//       } else {
//         print('Failed to load course data. Status Code: ${response.statusCode}');
//         print('Response Body: ${response.body}');
//         throw Exception('Failed to load course data');
//       }
//     } catch (e) {
//       print('Error fetching course data: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return WillPopScope(
//         onWillPop: () async {
//
//          Navigator.push(context, PageTransition(
//           type: PageTransitionType.fade,
//           child: MyHomePage())
//          );
//           // Handle the back button press here
//           // Return true to allow the app to pop the current route, or false to prevent it
//           // You can navigate to a different page or perform any custom logic here
//           return true;
//         },
// child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//         leading: BackButton(
//           onPressed: (){Navigator.push(context, PageTransition(
//               type: PageTransitionType.fade,
//               child: MyHomePage())); // Replace '/' with the route name of your homepage
//           },
//         color: Colors.black,
//     ),
//
//     title:
//
//     Container(
//       child: Row(
//         children: [
//           Text("Wallet",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//                 color: Colors.black
//             ),),
//         ],
//       )
//
//     ),
//
//     backgroundColor: Color(0xffffc400),
//     ),
//
//        body:SingleChildScrollView(
//     child:
//     Column(
//          children: [
//       //      Padding(padding: EdgeInsets.all(15),
//       //      child:
//       //      Container(
//       //        decoration: BoxDecoration(
//       //          borderRadius: BorderRadius.circular(20),
//       //          border: Border.all(color: Colors.grey, width: 2),
//       //        ),
//       //        child: Column(
//       //          children: [
//       //            Row(
//       //          crossAxisAlignment: CrossAxisAlignment.start,
//       //          children: [
//       //            Expanded(
//       //              child: Column(
//       //                crossAxisAlignment: CrossAxisAlignment.start,
//       //                children: [
//       //                  Padding(padding:EdgeInsets.all(10),
//       //                  child: Text(
//       //                    'Invite your friend & earn reward',
//       //                    style: TextStyle(
//       //                      color: Colors.black,
//       //                      fontSize: 25,
//       //                      fontWeight: FontWeight.bold,
//       //                    ),
//       //                  ),),
//       //
//       // Padding(padding:EdgeInsets.all(10),
//       //   child:
//       //                  Text(
//       //                    'Refer a friend and you will get guaranteed discounts when they make their first purchase on FXCareers app.',
//       //                    style: TextStyle(
//       //                      color: Colors.black,
//       //                      fontSize: 16,
//       //                    ),
//       //                  ),
//       // ),
//       //
//       //                ],
//       //              ),
//       //            ),
//       //            Center(
//       //              child: Container(
//       //                height: 200,
//       //                width: 150,
//       //                decoration: BoxDecoration(
//       //                  image: DecorationImage(
//       //                    image: AssetImage('assets/images/box-removebg-preview.png'),
//       //                    fit: BoxFit.fill,
//       //                  ),
//       //                ),
//       //              ) ,
//       //            )
//       //
//       //          ],
//       //        ),
//       //        Container(
//       //          width: 150,
//       //          child: ElevatedButton(
//       //            onPressed: () {
//       //              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: referral()));
//       //            },
//       //            child: Text(
//       //              "Refer now",
//       //              style: TextStyle(
//       //                color: Colors.black,
//       //              ),
//       //            ),
//       //            style: ElevatedButton.styleFrom(
//       //              primary: Color(0xffffc400),
//       //            ),
//       //          ),
//       //        ),
//       //        ])
//       //      )
//       //        ,),
//       //      SizedBox(height: 20), // Add space between sections
//
//            // New column displaying transaction records
//            Padding(
//              padding: EdgeInsets.all(15),
//              child: Column(
//                children: [
//                  const SizedBox(height: 10),
//                  ListView.builder(
//                    shrinkWrap: true,
//                    physics: const NeverScrollableScrollPhysics(),
//                    itemCount: courseData.length + 1, // Add one to account for the header
//                    itemBuilder: (context, index) {
//                      if (index == 0) {
//                        // Build header row with a blank white background
//                        return Container(
//                          color: Colors.white,
//                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                          child: const Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                              Text('Date', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
//                              Text('Type', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
//                              Text('Amount', style: TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.bold)),
//                            ],
//                          ),
//                        );
//                      } else {
//                        final course = courseData[index - 1]; // Adjust index for course data
//
//                        // Alternating row colors for course data
//                        final color = index.isOdd ? Colors.yellow.shade50 : Colors.white;
//
//                        return Container(
//                          color: color,
//                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                              Text(
//                                course['transaction_date'] ?? 'N/A',
//                                style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
//                              ),
//                              Text(
//                                course['type'] ?? 'N/A',
//                                style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
//                              ),
//                              Text(
//                                course['amount'] != null ? 'INR ${course['amount']} ' : 'N/A',
//                                style: const TextStyle(color: Color(0xFF222222),fontWeight: FontWeight.w500),
//                              ),
//                            ],
//                          ),
//                        );
//                      }
//                    },
//                  ),
//
//                ],
//              ),
//            ),
//          ],
//        ),
//        )
//     )
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// //
// // class WalletScreen extends StatefulWidget {
// //   @override
// //   _WalletScreenState createState() => _WalletScreenState();
// // }
// //
// // class _WalletScreenState extends State<WalletScreen> {
// //   late Razorpay _razorpay;
// //   double _balance = 0.0; // Initial balance
// //   TextEditingController _amountController = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //   }
// //
// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _razorpay.clear();
// //   }
// //
// //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text("Payment Successful"),
// //       ),
// //     );
// //     // You can update the wallet balance or navigate to a different screen
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text("Payment Failed: ${response.message}"),
// //       ),
// //     );
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text("External Wallet: ${response.walletName}"),
// //       ),
// //     );
// //   }
// //
// //   void _addFunds(double amount) {
// //     setState(() {
// //       _balance += amount;
// //     });
// //   }
// //
// //   void _makePayment(double amount) {
// //     var options = {
// //       'key': 'rzp_live_VPG6tFrUDuxH6v',
// //       'amount': amount * 100, // amount in the smallest currency unit (e.g., cents)
// //       'name': 'Your App Name',
// //       'description': 'Payment for Wallet Top-up',
// //       'prefill': {'contact': '', 'email': ''},
// //       'external': {
// //         'wallets': ['paytm']
// //       }
// //     };
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint('Error: $e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Wallet'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(
// //               'Balance: \₹$_balance',
// //               style: TextStyle(fontSize: 24),
// //             ),
// //             SizedBox(height: 20),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
// //               child: TextField(
// //                 controller: _amountController,
// //                 keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                 decoration: InputDecoration(
// //                   labelText: 'Enter Amount',
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 double amount = double.tryParse(_amountController.text) ?? 0.0;
// //                 if (amount > 0) {
// //                   _addFunds(amount);
// //                   _amountController.clear();
// //                 }
// //               },
// //               child: Text('Add Funds'),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 double amount = double.tryParse(_amountController.text) ?? 0.0;
// //                 if (amount > 0) {
// //                   _makePayment(amount);
// //                   _amountController.clear();
// //                 }
// //               },
// //               child: const Text('Make Payment'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // void main() {
// //   runApp(MaterialApp(
// //     home: WalletScreen(),
// //   ));
// // }
//
//
//
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     // return Scaffold(
// //     //   appBar: AppBar(
// //     //     // backgroundColor: Color(0xffffc400),
// //     //     title: Text('Wallet'),
// //     //     backgroundColor: Colors.red,
// //     //   ),
// //     // );
// //     return MaterialApp(
// //       title: 'Wallet App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: WalletPage(),
// //     );
// //   }
// // }
// //
// // class WalletPage extends StatefulWidget {
// //   @override
// //   _WalletPageState createState() => _WalletPageState();
// // }
// //
// // class _WalletPageState extends State<WalletPage> {
// //   TextEditingController _amountController = TextEditingController();
// //   late Razorpay _razorpay;
// //   double _walletBalance = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //     // Initialize wallet balance here, fetch from database or API
// //     _fetchWalletBalance();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     _amountController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _fetchWalletBalance() {
// //     // Example: Fetch wallet balance from database or API
// //     // Here, it's initialized with a hardcoded value for demonstration
// //     setState(() {
// //       _walletBalance = 0.0;
// //     });
// //   }
// //
// //   void _openCheckout() {
// //     var options = {
// //       'key': 'rzp_live_VPG6tFrUDuxH6v',
// //       'amount': int.parse(_amountController.text) *
// //           100, // Convert to smallest currency unit
// //       'name': 'Wallet Recharge',
// //       'description': 'Wallet Recharge',
// //       // 'prefill': {'contact': '', 'email': ''},
// //       // 'external': {
// //       //   'wallets': ['paytm']
// //       // }
// //     };
// //
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint('Error: $e');
// //     }
// //   }
// //
// //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //     debugPrint('Payment Success: ${response.paymentId}');
// //     // You can handle successful payment here
// //     // For demo, updating wallet balance with added amount
// //     setState(() {
// //       _walletBalance += double.parse(_amountController.text);
// //     });
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     debugPrint('Payment Error: ${response.code} - ${response.message}');
// //     // You can handle payment error here
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     debugPrint('External Wallet: ${response.walletName}');
// //     // Handle external wallet payment here
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Wallet'),
// //         backgroundColor: Color(0xffffc400),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Text(
// //               'Current Balance: $_walletBalance',
// //               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 16.0),
// //             TextField(
// //               controller: _amountController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(
// //                 labelText: 'Enter Amount',
// //               ),
// //             ),
// //             SizedBox(height: 16.0),
// //             ElevatedButton(
// //               onPressed: _openCheckout,
// //               child: Text('Add to Wallet'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay;
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Initialize wallet balance from shared preferences
    _fetchWalletBalance();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  void _fetchWalletBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _walletBalance = prefs.getDouble('wallet_balance') ?? 0.0;
    });
  }

  void _saveWalletBalance(double balance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('wallet_balance', balance);
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_live_VPG6tFrUDuxH6v',
      'amount': int.parse(_amountController.text) *
          100, // Convert to smallest currency unit
      'name': 'Wallet Recharge',
      'description': 'Wallet Recharge',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    double amount = double.parse(_amountController.text);
    // Update wallet balance and save to shared preferences
    setState(() {
      _walletBalance += amount;
    });
    _saveWalletBalance(_walletBalance);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    // You can handle payment error here
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    // Handle external wallet payment here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        title: const Text('Wallet'),
        backgroundColor: Color(0xffffc400),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Balance: $_walletBalance',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _openCheckout,
              child: Text('Add to Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
