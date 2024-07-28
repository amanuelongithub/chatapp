import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:chatapp/view/widgets/empty_widget.dart';
import 'package:chatapp/view/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ChatController>(
        builder: (_) => _.messages.isEmpty
            ? const EmptyWidget(icon: Icons.waving_hand, text: 'Say Hello!')
            : ListView.builder(
                controller: _.scrollController,
                itemCount: _.messages.length,
                itemBuilder: (context, index) {
                  final isTextMessage =
                      _.messages[index].messageType == MessageType.text;
                  final isMe = _.user!.uid != _.messages[index].senderId;

                  return isTextMessage
                      ? MessageBubble(
                          isMe: isMe,
                          message: _.messages[index],
                          isImage: false,
                        )
                      : MessageBubble(
                          isMe: isMe,
                          message: _.messages[index],
                          isImage: true,
                        );
                },
              ),
      );
}
