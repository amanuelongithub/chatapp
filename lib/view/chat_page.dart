import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/view/widgets/chat_messages.dart';
import 'package:chatapp/view/widgets/chat_text_field.dart';
import 'package:chatapp/view/widgets/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static String route = 'chat-page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
      if (_.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 80.h),
              child: const CustomAppBar(ishome: false)),
          body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: ChatMessages(),
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            padding: EdgeInsets.only(left: 20.w, right: 10),
            decoration: const BoxDecoration(color: Colors.white),
            child: const ChatTextField(),
          ),
        );
      }
    });
  }
}
