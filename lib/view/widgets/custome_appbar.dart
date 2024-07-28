import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/service/firebase_firestore_service.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomAppBar extends StatefulWidget {
  final bool ishome;
  const CustomAppBar({super.key, required this.ishome});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? image;

  @override
  void initState() {
    super.initState();
    getProfileImg();
  }

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
      leading: widget.ishome
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
      title: widget.ishome
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Home",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: image!,
                              height: 50.r,
                              width: 50.r,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 15),
                    GestureDetector(
                        onTap: () async {
                          await FirebaseFirestoreService.updateUserData({
                            'lastActive': DateTime.now(),
                            'isOnline': false,
                          });
                          sigout();
                        },
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                        )),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            )
          : Row(
              children: [
                CircleAvatar(
                    radius: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: Get.find<ChatController>().user!.image,
                        height: 57.r,
                        width: 57.r,
                        fit: BoxFit.cover,
                      ),
                    )),
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
                          : timeago
                              .format(
                                  Get.find<ChatController>().user!.lastActive)
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
    );
  }

  Future<void> getProfileImg() async {
    setState(() {
      image = Get.find<HomepageController>()
          .users!
          .firstWhere((e) => e.uid == FirebaseAuth.instance.currentUser?.uid)
          .image;
    });
  }

  void sigout() {
    FirebaseAuth.instance.signOut();
  }
}
