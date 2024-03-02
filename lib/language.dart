import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:new_app/basic1.dart';

class LanguageSelectionPage extends StatefulWidget {
  final List<String> languageOptions;

  LanguageSelectionPage(this.languageOptions);
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;


  @override
  Widget build(BuildContext context) {
    List<String> languageOptions = widget.languageOptions;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor:Color(0xffffc400),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Please select a language for your course:'),
            ...languageOptions.map((String language) {
              return Row(
                children: [
                  Radio<String>(
                    value: language,
                    groupValue: selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                  ),
                  Text(language),
                ],
              );
            }),
            SizedBox(height: 20.0),
            Text("Once selected you cannot change language for your course."),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: screenWidth*0.6,
                child:
            ElevatedButton(
              onPressed: () {
                // Return the selected language to the calling page
                Navigator.pop(context, selectedLanguage);
                // if (selectedLanguage != null) {
                //   insertPaymentDetails(userId, courseId, transactionId, amount, selectedLanguage);
                // }
              },

              child: Text('Select',
              style: TextStyle(color:Colors.black ,),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffffc400)
              ),
            ),
              )
            )
          ],
        ),
      ),
    );
  }
}
