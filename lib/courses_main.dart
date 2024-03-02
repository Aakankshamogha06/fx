import 'package:flutter/material.dart';

import 'package:new_app/courses.dart';

class CoursesMain extends StatefulWidget {
  const CoursesMain({super.key});

  @override
  State<CoursesMain> createState() => _CoursesMainState();
}

class _CoursesMainState extends State<CoursesMain> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffffc400),
        leading: BackButton(
          color: Colors.black,
        ),
        title:Text("Programs",
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black
          ),),
      ),
      body: Container(
        child: Column(
          children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'online')),
            );
          },
          child:Center(
             child: Padding(
               padding: EdgeInsets.all( screenHeight*0.02 ),
               child:
          Container(
            height: screenHeight * 0.23,
            decoration: BoxDecoration(
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
                Padding(padding: EdgeInsets.all(10),
                child: Image.asset('assets/images/Online.jpg',
                  fit: BoxFit.fill, // Set fit to cover
                  width: screenWidth*0.5, // Make the image take up the entire width
                  height: screenHeight * 0.16,),),
                Center(
                child: Text("Online courses",
                style:TextStyle(fontWeight: FontWeight.bold)),)
              ],
            ),
          ),
             )
        ),
        ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'offline')),
                );
              },
              child:Center(
                  child: Padding(
                    padding: EdgeInsets.all( screenHeight*0.02 ),
                    child:
                    Container(
                      height: screenHeight * 0.23,
                      decoration: BoxDecoration(
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
                          Padding(padding: EdgeInsets.all(10),
                            child: Image.asset('assets/images/Offline.jpg',fit: BoxFit.fill, // Set fit to cover
                              width: screenWidth*0.5, // Make the image take up the entire width
                              height: screenHeight * 0.16,),),
                          Center(
                            child: Text("Offline courses", style:TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  )
              ),

            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'recorded')),
                );
              },
              child:Center(
                  child: Padding(
                    padding: EdgeInsets.all( screenHeight*0.02 ),
                    child:
                    Container(
                      height: screenHeight * 0.23,
                      decoration: BoxDecoration(
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
                          Padding(padding: EdgeInsets.all(10),
                            child: Image.asset('assets/images/Videos.jpg',fit: BoxFit.fill, // Set fit to cover
                              width: screenWidth*0.5, // Make the image take up the entire width
                              height: screenHeight * 0.16,),),
                          Center(
                            child: Text("Self learning courses",
    style:TextStyle(fontWeight: FontWeight.bold)
    ),)
                        ],
                      ),
                    ),
                  )
              ),
            ),
        ]
        )
      ),
    );
  }
}
