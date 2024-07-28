import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AppConstants {
  static Color kcPrimary = Colors.purple;
  static Color kcSecondary = Colors.black;
  static Color kcBkg = Colors.grey; 
}

const double kRadius = 10;
const double kHP = 20;


Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 2),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ));
}


Future<Uint8List?> pickImage() async {
  try {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file.readAsBytes();
    }
  } on PlatformException catch (e) {
    debugPrint('Failed to pick image: $e');
  }
  return null;
}

Future<String> uploadImage(Uint8List file, String storagePath) async =>
    await FirebaseStorage.instance
        .ref()
        .child(storagePath)
        .putData(file)
        .then((task) => task.ref.getDownloadURL());
