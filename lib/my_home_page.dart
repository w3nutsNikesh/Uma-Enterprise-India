// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyHomePageModel>(context, listen: false).init(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomePageModel>(builder: (context, hp, _) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (await hp._controller!.canGoBack()) {
              await hp._controller!.goBack();
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            body: hp._controller != null
                ? WebViewWidget(
                    controller: hp._controller!,
                  )
                : Container(),
          ),
        ),
      );
    });
  }
}

class MyHomePageModel extends ChangeNotifier {
  WebViewController? _controller;

  init(BuildContext context) {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageFinished: (String url) {},
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..addJavaScriptChannel(
        "Toaster",
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(
        Uri.parse("https://umaenterpriseindia.in/"),
      )
      ..enableZoom(false);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(true);
    }

    _controller = controller;
    notifyListeners();
  }
}
