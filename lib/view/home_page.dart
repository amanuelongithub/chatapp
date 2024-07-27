import 'package:chatapp/controller/homepage_controller.dart';
import 'package:chatapp/service/firebase_firestore_service.dart';
import 'package:chatapp/view/widgets/card.dart';
import 'package:chatapp/view/widgets/constant.dart';
import 'package:chatapp/view/widgets/custome_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String route = 'home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed: // when user get back to app
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;

      case AppLifecycleState.inactive: // run app in background
      case AppLifecycleState.paused: // ex: switch to another app
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
      case AppLifecycleState.detached: // terminat the app
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
                child: const CustomAppBar(
                  ishome: true,
                )),
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
                  itemBuilder: (context, index) => _.users![index].uid !=
                          FirebaseAuth.instance.currentUser?.uid
                      ? UserCard(user: _.users![index])
                      : const SizedBox(),
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _.users![index].uid !=
                            FirebaseAuth.instance.currentUser?.uid
                        ? const Divider()
                        : const SizedBox(),
                  ),
                )));
      }
    });
  }
}
