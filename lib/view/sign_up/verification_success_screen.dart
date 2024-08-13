// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';

import '../../routes/app_routes.dart';

class VerificationSuccessScreen extends StatefulWidget {
  const VerificationSuccessScreen({Key? key}) : super(key: key);

  @override
  State<VerificationSuccessScreen> createState() =>
      _VerificationSuccessScreenState();
}

class _VerificationSuccessScreenState extends State<VerificationSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Color(0XFFE5E5E5),
          body: SafeArea(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getAssetImage("verificationSuccess.png",
                    height: 140.h, width: 140.w),
                getVerSpace(30.h),
                getCustomFont("Account Created", 28, Color(0XFF000000), 2,
                    fontWeight: FontWeight.w700),
                getVerSpace(8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.h),
                  child: getCustomFont(
                      "Your account has been sucessfully created!",
                      16,
                      Color(0XFF000000),
                      2,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center),
                ),
                getVerSpace(40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 75.w),
                  child: getCustomButton("Ok", () {
                    PrefData.setIsSignIn(false);
                    Get.toNamed(Routes.homeMainRoute);
                  }),
                ),
              ],
            ),
          )),
        ));
  }
}
