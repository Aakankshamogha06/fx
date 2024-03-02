import 'package:flutter/material.dart';
import 'package:new_app/courses.dart';
import 'package:new_app/slider1.dart';

import 'package:new_app/4.dart';

class OfflineOnline extends StatefulWidget {

  @override
  State<OfflineOnline> createState() => _OfflineOnlineState();
}

class _OfflineOnlineState extends State<OfflineOnline> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
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
              MaterialPageRoute(builder: (context) => OfflineOnline()),
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
            icon: Icon(Icons.person,

              size: 30,),
            label: 'Profile',
          ),
        ],
      ),
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

    backgroundColor: Colors.white,

    ),

      body: SingleChildScrollView(
        child: Column(
          children: [
        Center(
        child:  Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),

            child: GestureDetector(
              onTap: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'online')),
                  );
                }
              },
          child:Container(
            height: screenHeight * 0.23,
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
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      height: screenHeight*0.18,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                             child: Image(
                             image: AssetImage(
                                 'assets/images/Online.jpg'),
                          )
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 8, right: screenWidth > 600 ? 110 : 15),
                    //   child:
                    Text(
                      'Online course',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
          )
      )
    ),
    Center(
    child:  Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
    child:Container(
    height: screenHeight * 0.23,
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
    child: GestureDetector(
    onTap: () {
    {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(courseMode: 'offline')),
    );
    }
    },
    child: Expanded(
    child: Column(
    children: [
    Container(
    height: screenHeight*0.18,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: FittedBox(
    fit: BoxFit.contain,
    child: Padding(
    padding: EdgeInsets.all(10),
    child: Image(
      image: AssetImage(
          'assets/images/Offline.jpg'),
    )
    ),
    ),
    ),
    ),
    // Padding(
    //   padding: EdgeInsets.only(top: 8, right: screenWidth > 600 ? 110 : 15),
    //   child:
    Text(
    'Classroom course',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    // ),
    ],
    ),
    ),
    ),
    )
    )
    ),
    Center(
    child:  Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
    child:Container(
    height: screenHeight * 0.23,
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
    child: GestureDetector(
    onTap: () {
   {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(courseMode:'recorded')),
    );
    }
    },
    child: Expanded(
    child: Column(
    children: [
    Container(
    height: screenHeight*0.18,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: FittedBox(
    fit: BoxFit.contain,
    child: Padding(
    padding: EdgeInsets.all(10),
    child:Image(
      image: AssetImage(
          'assets/images/video.jpg'),
    )
    ),
    ),
    ),
    ),
    // Padding(
    //   padding: EdgeInsets.only(top: 8, right: screenWidth > 600 ? 110 : 15),
    //   child:
    Text(
   'Self learing courses',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    // ),
    ],
    ),
    ),
    ),
    )
    )
    )
          ],
        ),
      ),
    );
  }

  }

