import 'package:chatapp/view/auth/login_page.dart';
import 'package:chatapp/view/auth/signup_page.dart';
import 'package:chatapp/view/chat_page.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/widgets/splash_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    SplashPage.route: (context) => const SplashPage(),
    LoginPage.route: (context) => const LoginPage(),
    SignUpPage.route: (context) => const SignUpPage(),
    HomePage.route: (context) => const HomePage(),
    ChatPage.route: (context) => const ChatPage(),
  };
}
