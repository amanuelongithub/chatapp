import 'dart:io';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/service/firebase_firestore_service.dart';
import 'package:chatapp/view/auth/signup_page.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:chatapp/view/widgets/custome_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = 'login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? pwd;
  Map<String, String>? user;
  bool isSaved = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      if (_.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(top: 80),
            child: ListView(
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    'Welcome to Chat app',
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: TextStyle(fontSize: 15.sp)),
                    GestureDetector(
                      onTap: () {
                        _.clearError();
                        Navigator.popAndPushNamed(context, SignUpPage.route);
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: AppConstants.kcPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          border: OutlineInputBorder(),
                        ),
                        cursorColor: AppConstants.kcPrimary,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _.formErrors.add('Email address require');
                          } else if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            _.formErrors.add('Email address not valid');
                          } else {
                            _.formErrors.remove('Email address require');
                            _.formErrors.remove('Email address not valid');
                            setState(() {
                              email = value;
                            });
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppConstants.kcPrimary,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _.formErrors.add('Password is empty');
                          } else {
                            _.formErrors.remove('Password is empty');
                            setState(() {
                              pwd = value;
                            });
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Recovery Password',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _.formErrors.isNotEmpty
                        ? errorMessage(_.formErrors.last)
                        : Container(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: CustomeButton(
                      title: "Continue",
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate() &&
                            _.formErrors.isEmpty) {
                          signIn();
                        } else {
                          Get.find<AuthController>().update();
                        }
                      },
                    )),
              ],
            ),
          ),
        );
      }
    });
  }

  Future signIn() async {
    Get.find<AuthController>().isLoading = true;
    Get.find<AuthController>().update();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: pwd!,
      );

      await FirebaseFirestoreService.updateUserData(
        {'isOnline': true, 'lastActive': DateTime.now()},
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomePage.route);
      }
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on SocketException {
      const snackBar = SnackBar(content: Text("Please Check your internet"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Get.find<AuthController>().isLoading = false;
    Get.find<AuthController>().update();
  }
}
