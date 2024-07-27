import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final bool ishome;
  const CustomAppBar({super.key, required this.ishome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 104.h - MediaQuery.of(context).viewPadding.top,
      backgroundColor: AppConstants.kcSecondary,
      centerTitle: false,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.5,
      shadowColor: AppConstants.kcPrimary,
      surfaceTintColor: AppConstants.kcBkg,
      leading: ishome
          ? IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
          : const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: BackButton(
                color: Colors.white,
              ),
            ),
      title: ishome
          ? Text("Home",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))
          : Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(Get.find<ChatController>().user!.image),
                  radius: 20,
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Get.find<ChatController>().user!.name,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text(
                      Get.find<ChatController>().user!.isOnline
                          ? 'Online'
                          : Get.find<ChatController>()
                              .user!
                              .lastActive
                              .day
                              .toString(),
                      style: TextStyle(
                        color: Get.find<ChatController>().user!.isOnline
                            ? Colors.green
                            : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      actions: ishome
          ? [
              CircleAvatar(backgroundImage: NetworkImage(getProfileImg()!)),
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  )),
              const SizedBox(width: 15),
            ]
          : null,
    );
  }

  getProfileImg() {
    return Get.find<HomepageController>()
        .users!
        .firstWhere((e) => e.uid == FirebaseAuth.instance.currentUser?.uid)
        .image;
  }
}
