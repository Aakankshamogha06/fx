import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:new_app/slider1.dart';

class Live_market_data extends StatefulWidget {
  const Live_market_data({super.key});

  @override
  State<Live_market_data> createState() => _Live_market_dataState();
}

class _Live_market_dataState extends State<Live_market_data> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _controller.future.then((controller) async {
                  Navigator.push(context, PageTransition(
                      type: PageTransitionType.fade,
                      child: MyHomePage()));

                }
                    );
              },
            ),
            title: Text(
                'Live market data'
            ),
            backgroundColor: Color(0xffffc400),
          ),
          body:
          Container(
            height: screenHeight * 0.5,
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
<div class="tradingview-widget-container" style="height:100%;width:100%">
  <div class="tradingview-widget-container__widget" style="height:calc(100% - 32px);width:100%"></div>
  <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
  {
  "autosize": true,
  "symbol": "FX_IDC:INRUSD",
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "light",
  "style": "1",
  "locale": "en",
  "enable_publishing": false,
  "allow_symbol_change": true,
  "support_host": "https://www.tradingview.com"
}
  </script>
</div>
<!-- TradingView Widget END -->         ''',
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
