// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';

import '../../../generated/l10n.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/customer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final imageController = Get.put(ImageController());
  HomeMainScreenController homeController = Get.put(HomeMainScreenController());
  MyProfileScreenController myProfileScreenController =
      Get.put(MyProfileScreenController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = homeController.currentCustomer!.firstName!;
    phoneController.text = homeController.currentCustomer!.billing!.phone!;
    emailController.text = homeController.currentCustomer!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WooCustomer? wooCustomer = homeController.currentCustomer;
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: bgColor,
                body: GetBuilder<MyProfileController>(
                  init: MyProfileController(),
                  builder: (profileScreenController) => Center(
                    child: Column(
                      children: [
                        Container(
                          color: regularWhite,
                          child: getAppBar(
                            S.of(context).editProfile,
                            function: () {
                              Get.back();
                            },
                          ),
                        ),
                        getVerSpace(12.h),
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(30.h),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          getEditProfileOptionFormate(
                                              nameController, false,
                                              iconImage: "profileIcon.png",
                                              userdetail:
                                                  wooCustomer!.username ?? "",
                                              requredImage: true,
                                              hint: S.of(context).name),
                                          getVerSpace(32.h),
                                          getEditProfileOptionFormate(
                                              emailController, false,
                                              iconImage: "mailIcon.png",
                                              userdetail:
                                                  wooCustomer.email ?? "",
                                              requredImage: true,
                                              hint: S.of(context).email,
                                              read: true),
                                          getVerSpace(32.h),
                                          getEditProfileOptionFormate(
                                              phoneController, false,
                                              iconImage: "mobileIcon.png",
                                              userdetail:
                                                  wooCustomer.billing!.phone ??
                                                      "",
                                              requredImage: true,
                                              hint: S.of(context).phoneNumber),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () => getCustomButton(S.of(context).save,
                                          child: myProfileScreenController
                                              .isEditProfileProcess
                                              .value, () async {
                                        myProfileScreenController
                                            .isEditProfileProcess.value = true;
                                        if (homeController
                                            .checkNullOperator()) {
                                          return;
                                        }

                                        await homeController.wooCommerce1!
                                            .updateCustomer(
                                                id: homeController
                                                    .currentCustomer!.id!,
                                                data: {
                                              "first_name": nameController.text
                                                  .toString(),
                                              "email": emailController.text
                                                  .toString(),
                                              "avatar_url":
                                                  "https://en.gravatar.com/avatar/dfdaafd0950fe22715d2bc323e7b3bdf",
                                              "billing": {
                                                "phone": phoneController.text
                                                    .toString()
                                              }
                                            });

                                        homeController.updateCurrentCustomer();

                                        // context.loaderOverlay.hide();
                                        myProfileScreenController
                                            .isEditProfileProcess.value = false;
                                        Get.back();
                                      }).paddingOnly(
                                          bottom: 40.h,
                                          left: 20.h,
                                          right: 20.h),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}
