// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../../model/my_cart_data.dart';
import '../../utils/storage.dart';
import '../../woocommerce/models/customer.dart';
import '../../woocommerce/models/jwt_response.dart';

class LoginEmptyState extends StatefulWidget {
  const LoginEmptyState({Key? key}) : super(key: key);

  @override
  State<LoginEmptyState> createState() => _LoginEmptyStateState();
}

class _LoginEmptyStateState extends State<LoginEmptyState>
    with TickerProviderStateMixin {
  HomeMainScreenController storageController =
      Get.put(HomeMainScreenController());
  LoginEmptyStateController loginController =
      Get.put(LoginEmptyStateController());
  HomeMainScreenController homeMainScreenController =
      Get.find<HomeMainScreenController>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return GetBuilder<LoginEmptyStateController>(
      init: LoginEmptyStateController(),
      builder: (controller) => Directionality(
        textDirection: Constant.getSetDirection(context),
        child: WillPopScope(
          onWillPop: () async {
            if (controller.setLoginIsBuynowval) {
              Get.back();
              controller.setLoginIsBuynow(false);
            } else {
              closeApp();
            }
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: regularWhite,
            body: SafeArea(
              child: Form(
                key: loginForm,
                child: GetBuilder<LoginEmptyStateController>(
                  init: LoginEmptyStateController(),
                  builder: (loginEmptyStateController) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVerSpace(20.h),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            controller.setLoginIsBuynowval
                                ? Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: GestureDetector(
                                        onTap: () {
                                          if (controller.setLoginIsBuynowval) {
                                            Get.back();
                                            controller.setLoginIsBuynow(false);
                                          } else {
                                            closeApp();
                                          }
                                        },
                                        child: getSvgImage(
                                                "arrow_square_left.svg",
                                                height: 24.h,
                                                width: 24.h)
                                            .marginOnly(left: 20.h)),
                                  )
                                : SizedBox(),
                            Column(
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                getAssetImage("logo.png",
                                    height: 124.h, width: 163.h),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: GestureDetector(
                                      onTap: () {
                                        PrefData.setIsSignIn(false);
                                        // homeMainScreenController.onChange(0);
                                        Get.toNamed(Routes.homeMainRoute);
                                      },
                                      child: getCustomFont(S.of(context).skip,
                                          16.sp, regularBlack, 1,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.end))
                                  .marginSymmetric(horizontal: 20.h),
                            ),
                          ],
                        ),
                      ),
                      getVerSpace(32.h),
                      Center(
                          child: getCustomFont(
                        S.of(context).login,
                        28.sp,
                        regularBlack,
                        1,
                        fontWeight: FontWeight.w700,
                      )),
                      getVerSpace(8.h),
                      Center(
                          child: getCustomFont(
                              S.of(context).helloWelcomeBackToYourAccount,
                              16.sp,
                              darkGray,
                              1,
                              fontWeight: FontWeight.w400)),
                      getVerSpace(30.h),
                      Expanded(
                          child: Column(
                        children: [
                          getTextField(S.of(context).usernameOrEmail,
                              controller: emailController,
                              fontWeight: FontWeight.w500,
                              fontsize: 16.sp, validator: (email) {
                            if (email!.isEmpty) {
                              return S
                                  .of(context)
                                  .pleaseEnterValidUsernameOrEmail;
                            }
                            return null;
                          }),
                          getVerSpace(24.h),
                          getTextField(
                              isSuffix: true,
                              suffixFunction: () {
                                loginEmptyStateController.onPasswordPosition();
                              },
                              S.of(context).password,
                              controller: passwordController,
                              fontWeight: FontWeight.w500,
                              fontsize: 16.sp,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return S.of(context).pleaseEnterValidPassword;
                                }
                                return null;
                              },
                              isPass: loginController.passwordPos,
                              textInputAction: TextInputAction.done),
                          getVerSpace(18.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  loginEmptyStateController
                                      .onRememberPosition();
                                },
                                child: Row(
                                  children: [
                                    loginEmptyStateController.remember
                                        ? getSvgImage(Constant.checkBoxFillIcon,
                                            height: 20.h, width: 20.h)
                                        : getSvgImage(Constant.checkBoxIcon,
                                            height: 20.h, width: 20.h),
                                    getHorSpace(8.h),
                                    getCustomFont(S.of(context).rememberMe,
                                        16.sp, regularBlack, 1,
                                        fontWeight: FontWeight.w400)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    // Constant.sendToNext(context, forgotPassScreenRoute);
                                    bool isConnected =
                                        await isInternetConnected();
                                    if (isConnected) {
                                      await launchUrl(
                                        Uri.parse(Constant.forgotUrl),
                                      );
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }
                                  },
                                  child: getCustomFont(
                                      S.of(context).forgotPassword,
                                      16.sp,
                                      regularBlack,
                                      1,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          getVerSpace(40.h),
                          Obx(
                            () => getCustomButton(S.of(context).login,
                                () async {
                              if (loginForm.currentState!.validate()) {
                                bool isConnected = await isInternetConnected();
                                if (isConnected) {
                                  if (homeMainScreenController
                                      .checkNullOperator()) {
                                    return;
                                  }

                                  loginController.loginUser(
                                      context,
                                      homeMainScreenController.wooCommerce1!,
                                      emailController.text.toString(),
                                      passwordController.text.toString());
                                } else {
                                  showCustomToast(
                                      S.of(context).noInternetConnection);
                                }
                              }
                            },
                                buttonheight: 56.h,
                                child: loginController.isDataLoading.value),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 20.h)),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.h),
                        child: getRichtext("${S.of(context).dontHaveAAccount} ",
                                S.of(context).signUp, function: () {
                          Get.toNamed(Routes.signUpRoute);
                        }, firsttextSize: 16.sp)
                            .paddingSymmetric(horizontal: 20.h),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
