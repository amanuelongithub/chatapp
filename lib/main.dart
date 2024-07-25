import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/route.dart';
import 'package:chatapp/view/auth/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(HomepageController());
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat app',
            initialRoute: SignUpPage.route,
            routes: getRoutes(),
          );
        });
  }
}
