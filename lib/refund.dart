import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Refund extends StatefulWidget {
  final String url;

  Refund({required this.url});

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  bool _isLoadingPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xffffc400),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              setState(() {
                _isLoadingPage = true;
              });
            },
            onPageFinished: (url) {
              setState(() {
                _isLoadingPage = false;
              });
            },
          ),
          if (_isLoadingPage)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
