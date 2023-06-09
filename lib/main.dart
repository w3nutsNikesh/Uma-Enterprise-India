// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:umaenterpriseindia/my_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:umaenterpriseindia/version_code_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyHomePageModel()),
      ],
      child: MaterialApp(
        title: 'Uma Enterprise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? deepLink;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      getVersion();

    });
    super.initState();
  }

  Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink;
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    try {
      if (data?.link != null) {
        deepLink = data?.link.toString();
      }
    } catch (e) {
      print('No deepLink found');
    }
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    initDynamicLink(context);
    var response = await http.get(
      Uri.parse("https://api.umaenterpriseindia.in/api/app-versions"),
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      var data = VersionCodeResponse.fromJson(jsonData);

      if (Platform.isAndroid) {
        String android;
        android = packageInfo.version;
        if (data.data!.first.android != android) {
          final url = "https://play.google.com/store/apps/details?id=${packageInfo.packageName}";
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(deepLink ?? ""),
            ),
          );
        }
      } else if (Platform.isIOS) {
        String ios;
        ios = packageInfo.version;
        if (data.data!.first.ios == ios) {
          String url = data.data?.first.appstoreUrl ?? "";
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          }
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(deepLink ?? ""),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/logo.png",
                scale: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
