// Flutter imports:
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});
  static final routeName = "/live_screen";

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  late final WebViewController _controller;

  static const String _iframeHtml = """
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      html, body {
        margin: 0; padding: 0; height: 100%; background: #000; overflow: hidden;
      }
      .wrap {
        position: absolute; inset: 0;
      }
      iframe {
        width: 100%; height: 100%;
        border: 0;
      }
    </style>
  </head>
  <body>
    <div class="wrap">
      <iframe 
        src="https://player.castr.com/live_b86621d0f06c11ef94c26b5e4fa3e5ec"
        allow="autoplay; fullscreen"
        allowfullscreen
        webkitallowfullscreen
        mozallowfullscreen
        oallowfullscreen
        msallowfullscreen
        scrolling="no">
      </iframe>
    </div>
  </body>
</html>
""";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000)) // autoplay enable
      ..loadHtmlString(_iframeHtml);
  }

  @override
  Widget build(BuildContext context) {
    // স্ক্রিন-প্রস্থ অনুযায়ী 16:9 উচ্চতা সেট
    final double playerHeight = MediaQuery.of(context).size.width * 9 / 16;
    return BaseWidgetTupperBotton(
      child2: SingleChildScrollView(
        child: Column(
          children: [
            // Live Stream Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Streams', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16.0),

                  // এখানে WebView বসানো হলো
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: playerHeight < 340 ? 340 : playerHeight, // min-height 340px বজায়
                      width: double.infinity,
                      child: WebViewWidget(controller: _controller),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}