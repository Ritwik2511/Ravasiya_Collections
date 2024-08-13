// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../generated/l10n.dart';
import '../../woocommerce/models/customer.dart';

class SignUpEmptyState extends StatefulWidget {
  const SignUpEmptyState({Key? key}) : super(key: key);

  @override
  State<SignUpEmptyState> createState() => _SignUpEmptyStateState();
}

class _SignUpEmptyStateState extends State<SignUpEmptyState> {
  String? setpassword = '';
  String? setConfirmPassword = '';
  RegisterController controller = Get.put(RegisterController());
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());

  final _registrationformKey = GlobalKey<FormState>();
  RxString countryCode = "IN".obs;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: regularWhite,
          body: SafeArea(
            child: Form(
              key: _registrationformKey,
              child: GetBuilder<SignUpEmptyStateController>(
                init: SignUpEmptyStateController(),
                builder: (signUpEmptyStateController) => Column(
                  children: [
                    getVerSpace(20.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 20.h),
                            child: getSvgImage("arrow_square_left.svg",
                                height: 24.h, width: 24.h),
                          )),
                    ),
                    Expanded(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      children: [
                        Center(
                            child: getCustomFont(S.of(context).signUp, 28.sp,
                                Color(0XFF000000), 1,
                                fontWeight: FontWeight.w700)),
                        getVerSpace(8.h),
                        Center(
                            child: getCustomFont(
                                S.of(context).letsCreateYourAccount,
                                16.sp,
                                darkGray,
                                1,
                                fontWeight: FontWeight.w400)),
                        getVerSpace(38.h),
                        getTextField(S.of(context).userName,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w500, validator: (name) {
                          if (name!.isEmpty) {
                            return S.of(context).pleaseEnterValidUsername;
                          }
                          return null;
                        }, controller: controller.groupSixtySixController),
                        getVerSpace(24.h),
                        getTextField(S.of(context).emailAddress,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w500, validator: (email) {
                          if (email == null ||
                              (!isValidEmail(email, isRequired: true))) {
                            return S.of(context).pleaseEnterValidEmail;
                          }
                          return null;
                        }, controller: controller.groupSixtyEightController),
                        getVerSpace(24.h),
                        getTextField(S.of(context).password,
                            validator: (password) {
                              setpassword = '';
                              setpassword = password;
                              if (password!.isEmpty) {
                                return S.of(context).pleaseEnterValidPassword;
                              }
                              return null;
                            },
                            controller: controller.groupSixtyNineController,
                            isPass: signUpEmptyStateController.isPass,
                            isSuffix: true,
                            suffixFunction: () {
                              signUpEmptyStateController.onIsPassPosition();
                            }),
                        getVerSpace(24.h),
                        getTextField(S.of(context).confirmPassword,
                            isSuffix: true, suffixFunction: () {
                          signUpEmptyStateController.onPasswordPosition();
                        }, validator: (confirmPassword) {
                          setConfirmPassword = '';
                          setConfirmPassword = confirmPassword;
                          if (confirmPassword!.isEmpty) {
                            return S.of(context).enterTheConfirmPassword;
                          }
                          if (setpassword != setConfirmPassword) {
                            return S
                                .of(context)
                                .pleaseEnterValidConfirmPassword;
                          }
                          return null;
                        },
                            controller: controller.groupSeventyController,
                            isPass: signUpEmptyStateController.passwordPos),
                        getVerSpace(18.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                signUpEmptyStateController.onRememberPosition();
                              },
                              child: Row(
                                children: [
                                  signUpEmptyStateController.remember
                                      ? getSvgImage(Constant.checkBoxFillIcon,
                                          height: 20.h, width: 20.h)
                                      : getSvgImage(Constant.checkBoxIcon,
                                          height: 20.h, width: 20.h),
                                  getHorSpace(8.h),
                                  getRichtext(S.of(context).iAccepted,
                                      ' ${S.of(context).termsPrivacyPolicy}',
                                      function: () async {
                                    bool isConnected =
                                        await isInternetConnected();
                                    if (isConnected) {
                                      launchURL(Constant.termsAndConditionUrl);
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }

                                    // Get.toNamed(Routes.termConditionRoute);
                                  },
                                      firsttextSize: 16.sp,
                                      secondtextSize: 16.sp,
                                      firstTextwidth: FontWeight.w400,
                                      secondTextwidth: FontWeight.w400,
                                      firsttextcolor: regularBlack,
                                      secondtextcolor: buttonColor)
                                ],
                              ),
                            ),
                          ],
                        ),
                        getVerSpace(40.h),
                        Obx(
                          () => getCustomButton(S.of(context).signUp,
                              child: controller.isDataLoading.value, () async {
                            if (_registrationformKey.currentState!.validate()) {
                              if (signUpEmptyStateController.remember) {
                                bool isConnected = await isInternetConnected();
                                if (isConnected) {
                                  if (homeMainScreenController
                                      .checkNullOperator()) {
                                    return;
                                  }
                                  controller.registerUser(
                                      context,
                                      homeMainScreenController.wooCommerce1!,
                                      WooCustomer(
                                          firstName: controller
                                              .groupSixtySixController.text
                                              .toString(),
                                          username: controller
                                              .groupSixtySixController.text
                                              .toString(),
                                          email: controller
                                              .groupSixtyEightController.text
                                              .toString(),
                                          password: controller
                                              .groupSixtyNineController.text
                                              .toString(),
                                          billing: Billing(
                                              country:
                                                  countryCode.value.toString(),
                                              phone: "",
                                              email: controller
                                                  .groupSixtyEightController
                                                  .text
                                                  .toString())),
                                      controller.groupSixtyEightController.text
                                          .toString(),
                                      controller.groupSixtyNineController.text
                                          .toString(),
                                      currentCustomer: homeMainScreenController
                                          .currentCustomer);
                                } else {
                                  showCustomToast(
                                      S.of(context).noInternetConnection);
                                }
                              } else {
                                showCustomToast(S
                                    .of(context)
                                    .pleaseAcceptTermsPrivacyPolicy);
                              }
                            }
                          }),
                        )
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: getRichtext(
                          "${S.of(context).alreadyHaveAAccount} ",
                          S.of(context).signIn, function: () {
                        Get.back();
                      }, firsttextSize: 16.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
