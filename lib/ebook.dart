import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:new_app/url.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Ebook extends StatefulWidget {
  @override
  State<Ebook> createState() => _EbookState();
}

class _EbookState extends State<Ebook> {
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
        Uri.parse('${MyConstants.baseUrl}/course_api/ebook_data'),
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
    setState(() {
      _isLoading = true; // Show loader before fetching data
    });
    try {
      List<Map<String, dynamic>> data = await fetchCourseData();
      setState(() {
        courseData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading course data: $e');
      // Handle errors here, e.g., show an error message to the user
      setState(() {
        _isLoading = false;
      });
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Container(
          child: Row(
            children: [
              Text(
                "E-Book",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xffffc400),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader if loading
          : ListView.builder(
        shrinkWrap: true,
        itemCount: courseData.length,
        itemBuilder: (context, index) {
          final course = courseData[index];
          return GestureDetector(
            onTap: () {
              if (course != null && course.containsKey('source')) {
                String pdfUrl = '${MyConstants.imageUrl}/${course['source']}';
                _viewPdf(pdfUrl);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Center(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator()) // Show loader if loading
                              : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              '${MyConstants.imageUrl}/${course['ebook_image']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      courseData.isNotEmpty
                          ? courseData[index]['ebook_name']
                          : 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth * 0.8,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (course != null && course.containsKey('source')) {
                            String pdfUrl = '${MyConstants.imageUrl}/${course['source']}';
                            _viewPdf(pdfUrl);
                          }
                        },
                        child: Text(
                          "View E-Book",
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Color(0xffffc400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
