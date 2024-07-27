import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/view/auth/login_page.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static String route = 'splash-page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    final navigator = Navigator.of(context);

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Get.put(HomepageController());
        Get.put(ChatController());
        navigator.pushNamedAndRemoveUntil(HomePage.route, (route) => false);
      } else {
        navigator.pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
    );
  }
}
