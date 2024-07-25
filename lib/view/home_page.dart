import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/view/widgets/card.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:chatapp/view/widgets/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String route = 'home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(builder: (_) {
      if (_.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            appBar: PreferredSize(
                preferredSize: Size(double.infinity, 80.h),
                child:
                    const CustomAppBar(profileimg: "assets/image/user1.jpg")),
            body: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: ListView.separated(
                  itemCount: _.users!.length,
                  padding:
                      const EdgeInsets.only(left: kHP, right: kHP, top: 20),
                  itemBuilder: (context, index) =>
                      UserCard(user: _.users![index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(),
                  ),
                )));
      }
    });
  }
}
