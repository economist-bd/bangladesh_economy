import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: bangladesheconomyWebView(),
  ));
}

class bangladesheconomyWebView extends StatefulWidget {
  const bangladesheconomyWebView({super.key});

  @override
  State<bangladesheconomyWebView> createState() => _bangladesheconomyWebViewState();
}

class _bangladesheconomyWebViewState extends State<bangladesheconomyWebView> {
  late final WebViewController _controller;
  bool _isLoading = true; // লোডিং দেখানোর জন্য ভেরিয়েবল

  @override
  void initState() {
    super.initState();
    
    // ওয়েব ভিউ কন্ট্রোলার সেটআপ
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      // ====================================================
      // নিচে আপনার ওয়েবসাইটের লিংকটি বসান
      // ====================================================
      ..loadRequest(Uri.parse('https://bangladesh-economy.netlify.app')); 
  }

  @override
  Widget build(BuildContext context) {
    // অ্যান্ড্রয়েডের ব্যাক বাটন যাতে কাজ করে (অ্যাপ বন্ধ না হয়ে আগের পেজে যায়)
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        // অ্যাপ বার বা টাইটেল বার (চাইলে মুছে দিতে পারেন)
        appBar: AppBar(
          title: const Text("bangladesheconomy"),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            
            // লোডিং ইন্ডিকেটর (পেজ লোড হওয়ার সময় ঘুরবে)
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              ),
          ],
        ),
      ),
    );
  }
}