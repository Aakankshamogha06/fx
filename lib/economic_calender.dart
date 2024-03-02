import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/slider1.dart';

class Economic_calender extends StatefulWidget {
  const Economic_calender({super.key});

  @override
  State<Economic_calender> createState() => _Economic_calenderState();
}

class _Economic_calenderState extends State<Economic_calender> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.future.then((controller) async {
          if (await controller.canGoBack()) {
            await controller.goBack();
            return false;
          } else {
            return true;
          }
        })) {
          // If the WebView can't go back, allow the default back behavior
          return true;
        }
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _controller.future.then((controller) async {
                  Navigator.push(context, PageTransition(
                      type: PageTransitionType.fade,
                      child: MyHomePage()));
                });
              },
            ),
            title: Text(
                'Economic calendar'
            ),
            backgroundColor: Color(0xffffc400),
          ),
          body:
          Container(
            // height: screenHeight * 0.5,
            child: WebView(
              initialUrl: 'about:blank',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _controller.complete(controller);
                // Load TradingView widget when WebView is created
                controller.loadUrl(
                  Uri.dataFromString(
                    '''
<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
<div class="tradingview-widget-container__widget"></div>
<div class="tradingview-widget-copyright"><a href="https://in.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
<script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-events.js" async>
  {
  "width": "100%",
  "height": "100%",
  "colorTheme": "light",
  "isTransparent": false,
  "locale": "in",
  "importanceFilter": "-1,0,1",
  "countryFilter": "in"
}
</script>
</div>
<!-- TradingView Widget END -->
      ''',
                    mimeType: 'text/html',
                  ).toString(),
                );
              },
              onWebResourceError: (WebResourceError error) {
                print("Web Resource Error: $error");
              },
            ),
          )
      ),)
    ;
  }
}
