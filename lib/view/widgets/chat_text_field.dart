import 'dart:typed_data';
import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../service/firebase_firestore_service.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();

  Uint8List? file;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final inputBorder = OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color.fromARGB(196, 80, 80, 80), width: 1),
      borderRadius: BorderRadius.circular(kRadius));

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Message...",
                hintStyle: TextStyle(fontSize: 14.sp),
                filled: true,
                fillColor: Colors.white,
                border: inputBorder,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppConstants.kcSecondary.withOpacity(0.8),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(kRadius.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
              ),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: AppConstants.kcPrimary,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendText(context),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: AppConstants.kcPrimary,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _sendImage,
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: Get.find<ChatController>().user!.uid,
        content: controller.text,
      );

      controller.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    final pickedImage = await pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: Get.find<ChatController>().user!.uid,
        file: file!,
      );
    }
  }
}
