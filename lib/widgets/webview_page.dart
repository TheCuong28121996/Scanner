import 'dart:io';
import 'package:mobile/routers/screen_arguments.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.arguments}) : super(key: key);
  final ScreenArguments arguments;
  static const routeName = '/WebViewPage';

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        title: const Text('Thông tin'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.arguments.arg1,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFF28022)),
            ),
          )
        ],
      ),
    );
  }
}
