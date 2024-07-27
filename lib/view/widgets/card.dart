import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/view/chat_page.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chatapp/model/user_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.user});

  final UserModel user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Get.find<ChatController>().getUserById(widget.user.uid);
          Get.find<ChatController>().getMessages(widget.user.uid);
          Navigator.pushNamed(context, ChatPage.route);
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.user.image),
              ),
              widget.user.isOnline
                  ? const Positioned(
                      right: 0,
                      bottom: -10,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 7,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 5,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          title: Text(
            widget.user.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Last Active : ${timeago.format(widget.user.lastActive)}',
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
