import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_ios/url_launcher_ios.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:page_transition/page_transition.dart';

import 'package:new_app/url.dart';
import 'package:new_app/video.dart';


class curriculum extends StatefulWidget {

  final int id;
  final String title;
  final List<Widget> children;

  curriculum({required this.id,required this.title,required this.children});


  @override
  _curriculumState createState() => _curriculumState();
}


class _curriculumState extends State<curriculum> {
  List<Item> _data = [];
  bool _isLoading = true;
  String selectedTopic = '';
  List<Topic> _topics = [];
  String userId = '';
  bool userPurchased = false;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  List<Map<String, dynamic>> courseData = [];
  String courseMode='';
  String courseLanguage = '';

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network('https://play.dyntube.io/iframe/2mxCS2SXTkKKL6RQT9Umvg');

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9, // You can adjust this to your video's aspect ratio
      autoPlay: false, // Set to true if you want the video to auto-play
      looping: false, // Set to true if you want the video to loop
      // Add other customization options as needed
    );

    fetchCourseData();
    fetchPurchaseData();
    fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
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
          setState(() {
            courseData = jsonData.cast<Map<String, dynamic>>();

          });
          return courseData;

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

  Future<void> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/topic_data/${widget.id}'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData != null) {
          loadTopics(jsonData);
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching course data: $e');
    }
  }

  Future<void> loadTopics(List<dynamic> jsonData) async {
    for (var topicData in jsonData) {
      final Topic topic = Topic.fromJson(topicData);
      try {
        final List<Subtopic> subtopics = await fetchSubtopicsForTopic(topic.id,);
        topic.subtopics = subtopics;
      } catch (e) {
        print('Error loading subtopics for topic ${topic.id}: $e');
      }
      setState(() {
        _topics.add(topic);
        if (_topics.length == jsonData.length) {
          _isLoading = false;
        }
      });
    }
  }

  Future<List<Subtopic>> fetchSubtopicsForTopic(int topicId) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/langwisevideo_data/$topicId/$courseLanguage'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data != null && data.isNotEmpty && data[0] is Map<String, dynamic>) {
          final List<Subtopic> subtopics = data.map<Subtopic>((subtopicData) => Subtopic.fromJson(subtopicData)).toList();
          return subtopics;
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load subtopics for the topic: $topicId');
      }
    } catch (e) {
      print('Error fetching subtopics for the topic $topicId: $e');
      throw e;
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
        Uri.parse('${MyConstants.baseUrl}/course_api/purchase_data/${widget.id}/$userId'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      print('${MyConstants.baseUrl}/course_api/purchase_data/${widget.id}/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Check if the response is a non-empty list
        if (data is List && data.isNotEmpty) {
          // Iterate over the list and find the relevant item
          for (final item in data) {
            if (item is Map<String, dynamic> && item['transaction_status'] == 'Approved') {
              // Found a purchase with 'transaction_status' set to 'Approved'
              setState(() {
                userPurchased = true;
              });

              // Extract course_mode if it exists
              if (item.containsKey('course_mode')) {
                String courseMode = item['course_mode'];

                // Now, you can use 'courseMode' in your conditions
                print('course_mode: $courseMode');
              }

              if (item.containsKey('course_lang')) {
                courseLanguage = item['course_lang']; // Store the fetched language
                print('course_language: $courseLanguage');
              }
              break;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching purchase data: $e');
    }
  }

  int _expandedPanelIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
            ),
            title:

            Container(
              child: Text('Curriculum',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black
                ),),
            ),

            backgroundColor: Color(0xffffc400),

          ),


          body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  // height: 700,
                  width: screenWidth*1 ,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the rectangle
                    border: Border.all(
                      color: Colors.transparent, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                          10.0), // Border radius to create rounded corners
                    ),
                  ),
                  child:
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      final topic = _topics[index];
                      return CustomExpansionTile(
                        title: Text(topic.name, style: TextStyle(color: Colors.black, fontSize: 18)),
                        children: topic.subtopics.map<Widget>((subtopic) {
                          final tile = userPurchased
                              ? PurchasedUserTile(subtopic)
                              : NonPurchasedUserTile(subtopic);
                          print('Adding tile: $tile');
                          return tile;
                        }).toList(),
                      );
                    },
                  )

              )

          )

      );
  }

  List<Item> generateItems(List<Map<String, dynamic>> topics) {
    return topics.map<Item>((topic) {
      return Item(
        headerValue: topic['name'],
        expandedValue:topic['name'],
      );
    }).toList();
  }
}



class Item {
  Item({
    this.headerValue = '',
    this.expandedValue = '', // Provide a default non-null value here
  });

  final String headerValue;
  final String expandedValue;
}



List<Item> generateItems(List<dynamic> topics) {
  return topics.map<Item>((topic) {
    return Item(
      headerValue: topic['name'] ?? 'Default Header Value',
      expandedValue: topic['name'] ?? 'Default Expanded Value',
    );
  }).toList();
}

class Topic {
  final int id;
  final String name;
  List<Subtopic> subtopics;
  bool isExpanded;

  Topic({
    this.id = 0,
    this.name = '', // Provide a default non-null value here
    this.subtopics = const [],
    this.isExpanded = false,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: int.parse(json['id'].toString()), // Parse id as an integer
      name: json['topic_name'],
    );
  }
}

class Subtopic {
  final String name;
  final String vid;

  Subtopic({
    this.name = '',
    this.vid = '', // Provide a default non-null value here
  });

  factory Subtopic.fromJson(Map<String, dynamic> json) {
    return Subtopic(
      name: json['sub_topic_name'],
      vid: json['video_link'],
    );
  }
}


class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  CustomExpansionTile({
    this.title = const Text('Title'),
    this.children = const [], // Provide a default non-null value here
    this.initiallyExpanded = false,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState(initiallyExpanded);
}



class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded;

  _CustomExpansionTileState(this.isExpanded);


  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: toggleExpansion, // Toggle the expansion state
            child: Padding(
              padding: EdgeInsets.all(10),
              child:Container(

                color: Color(0xffffc400),
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(child: widget.title),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            )
        ),
        if (isExpanded)
          Column(
            children: widget.children
                .asMap()
                .entries
                .map<Widget>((entry) {
              final child = entry.value;
              final childIndex = entry.key;
              final childBackgroundColor = childIndex % 2 == 0 ? Colors.yellow.shade50 : Colors.white;
              return Container(
                color: childBackgroundColor,
                child: child,
              );
            })
                .toList(),
          ),
      ],
    );
  }
}

class PurchasedUserTile extends StatelessWidget {
  final Subtopic subtopic;

  PurchasedUserTile(this.subtopic);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.library_books, color: Colors.black),
      title: Row(
        children: [
          Expanded(
            child: Text(subtopic.name, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          GestureDetector(
            onTap: () {
              if (subtopic.vid != null) {
                // Open a new screen or dialog with the video content
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoApp(videoUrl: subtopic.vid),
                  ),
                );
              } // Handle video playback for purchased user
            },
            child: Icon(Icons.video_library_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class NonPurchasedUserTile extends StatelessWidget {
  final Subtopic subtopic;

  NonPurchasedUserTile(this.subtopic);

  @override
  Widget build(BuildContext context) {
    print('Building NonPurchasedUserTile for: ${subtopic.name}');

    return ListTile(
      leading: Icon(Icons.library_books, color: Colors.black),
      title: Row(
        children: [
          Expanded(
            child: Text(subtopic.name, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Icon(Icons.lock, color: Colors.black),
        ],
      ),
    );
  }
}





