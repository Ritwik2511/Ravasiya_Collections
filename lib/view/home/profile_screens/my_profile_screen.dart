// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../generated/l10n.dart';
import '../../../woocommerce/models/customer.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    WooCustomer? wooCustomer = homeMainScreenController.currentCustomer;
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Directionality(
          textDirection: Constant.getSetDirection(context),
          child: Scaffold(
              backgroundColor: regularWhite,
              body: SafeArea(
                  child: Container(
                color: bgColor,
                child: GetBuilder<MyProfileController>(
                  init: MyProfileController(),
                  builder: (profileScreenController) => Column(
                    children: [
                      Container(
                        color: regularWhite,
                        child: getAppBar(S.of(context).myProfile, function: () {
                          Get.back();
                        },
                            actionIcon: true,
                            widget: GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.editProfileRoute)!
                                      .then((value) => setState(() {}));
                                },
                                child: getSvgImage("editIcon.svg",
                                    height: 20.h, width: 20.h))),
                      ),
                      getVerSpace(8.h),
                      Expanded(
                        child: Container(
                          color: regularWhite,
                          width: double.infinity,
                          child: Column(
                            children: [
                              getVerSpace(24.h),
                              getMyprofileDetailFormate(
                                  "myprofileIcon.svg",
                                  S.of(context).name,
                                  wooCustomer!.firstName ?? ""),
                              getVerSpace(20.h),
                              getDivider(height: 0),
                              getVerSpace(20.h),
                              getMyprofileDetailFormate("mailIcon.svg",
                                  S.of(context).email, wooCustomer.email ?? ""),
                              getVerSpace(20.h),
                              getDivider(height: 0),
                              getVerSpace(20.h),
                              getMyprofileDetailFormate(
                                  "mobileIcon.svg",
                                  S.of(context).phoneNumber,
                                  wooCustomer.billing!.phone ?? ""),
                              getVerSpace(30.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
        ),
      ),
    );
  }
}
