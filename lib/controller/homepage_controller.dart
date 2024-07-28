import 'dart:io';
import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageController extends GetxController {
  bool isLoading = false;

  List<UserModel>? users;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading = true;
      update();
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastActive', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        this.users =
            users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
        isLoading = false;
        update();
      });
    } catch (e) {
      if (e is SocketException) {
        const snackBar = SnackBar(content: Text("Please Check your internet"));
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      }
    }
  }
}
