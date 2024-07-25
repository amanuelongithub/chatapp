import 'dart:developer';
import 'dart:typed_data';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/service/firebase_firestore_service.dart';
import 'package:chatapp/service/firebase_storage_service.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:chatapp/view/widgets/custome_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static String route = 'signup-page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;
  String? username;
  String? pwd;
  Uint8List? file;
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Create an account',
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: TextStyle(fontSize: 15.sp)),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: AppConstants.kcPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () async {
                    final pickedImage = await pickImage();
                    setState(() => file = pickedImage!);
                  },
                  child: file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(file!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
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
                          labelText: 'User name',
                          border: OutlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppConstants.kcPrimary,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _.formErrors.add('User name is empty');
                          } else {
                            _.formErrors.remove('User name is empty');
                            setState(() {
                              pwd = value;
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
                SizedBox(
                  height: 30.sp,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                        final isValid = _formKey.currentState!.validate();
                        Get.find<AuthController>().update();

                        log('${!isValid && _.formErrors.isNotEmpty}');
                        if (!isValid && _.formErrors.isNotEmpty) {
                          return;
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

  Future signUp() async {
    Get.find<AuthController>().isLoading = true;
    Get.find<AuthController>().update();

    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!.trim(),
        password: pwd!.trim(),
      );
      final image = await FirebaseStorageService.uploadImage(
          file!, 'image/profile/${user.user!.uid}');

      await FirebaseFirestoreService.createUser(
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: username!,
      );
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Get.find<AuthController>().isLoading = false;
    Get.find<AuthController>().update();
  }
}
