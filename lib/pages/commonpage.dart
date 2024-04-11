import 'package:flutter/material.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonPage extends StatefulWidget {
  final String title, url;
  const CommonPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  CommonPageState createState() => CommonPageState();
}

class CommonPageState extends State<CommonPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppbar(
            title: widget.title,
            isSimpleappbar: 1,
            icon: "back.png",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget.url,
                onWebViewCreated: (controller) {
                  _controller = controller;
                  setState(() {
                    _controller.loadUrl(widget.url);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
