import 'package:chatapp/view/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final bool hasBack;
  final String? title;
  final String profileimg;
  const CustomAppBar(
      {super.key, this.hasBack = false, this.title, required this.profileimg});

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
      title: Container(
          padding: EdgeInsets.only(top: 10.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            hasBack
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back))
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
            Text("Home",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            CircleAvatar(backgroundImage: AssetImage(profileimg))
          ])),
    );
  }
}
