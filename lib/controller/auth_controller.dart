import 'package:get/get.dart';

class AuthController extends GetxController {
  bool isLoading = false;

  List<String> formErrors = [];


  clearError() {
    formErrors.clear();
    update();
  }

}