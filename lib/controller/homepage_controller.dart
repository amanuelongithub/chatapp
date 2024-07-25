import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomepageController extends GetxController {
  bool isLoading = false;

  List<UserModel>? users;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  fetchData() async {
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
  }
}
