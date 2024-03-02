import 'package:flutter/cupertino.dart';
import 'package:new_app/2.dart';

class MyImageWithButtonScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ImageWithButton(
        imagePath: 'assets/images/fx.png', // Replace with your image path
        onPressed: () {
          // Add the action you want to perform when the button is pressed
        },
      ),
    );
  }
}
