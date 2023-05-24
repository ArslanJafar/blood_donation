import 'package:blood_donation/Constants/AppAssets.dart';
import 'package:blood_donation/Controllers/AuthController.dart';
import 'package:blood_donation/Controllers/Controllers.dart';
import 'package:blood_donation/Controllers/SearchController.dart';
import 'package:blood_donation/Views/DashBoardView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginView.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  openAuthView() async
  {
   AuthController auth = Get.find();
   await auth.checkUserExistOrNot();
  }
  void startTimer() async
  {
    await Future.delayed(const Duration(seconds: 3), openAuthView );
  }
  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);
    Get.put(DashBoardController(), permanent: true);
    Get.put(BloodController(), permanent: true);
    Get.put(BloodSearchController(),permanent: true);
    BloodController bloodController = Get.find();
    bloodController.getAllRequests();
    return Scaffold(

      body: Center(
        child:SvgPicture.asset(AppAssets.appLogo,height: 130.h,)
      )

    );
  }
}
