import 'package:chatapp/view/home_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    HomePage.route: (context) => const HomePage(),
  };
}
