import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatelessWidget {
  final String redirectUrl;

  Payment({required this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(redirectUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
