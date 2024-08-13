// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/woocommerce/models/delete_customer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../datafile/model_data.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../model/language_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/pref_data.dart';
import '../../../utils/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyProfileController profileScreenController = Get.put(MyProfileController());
  HomeMainScreenController homeController = Get.put(HomeMainScreenController());
  OrderConfirmScreenController orderConfirmScreenController =
      Get.put(OrderConfirmScreenController());
  LoginEmptyStateController loginController =
      Get.put(LoginEmptyStateController());
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  List<LanguageData> langList = Data.getLanguage();
  SelectLanguagesScreenController selectLanguagesScreenController1 =
      Get.put(SelectLanguagesScreenController());

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor: bgColor,
                body: GetBuilder<MyProfileController>(
                  init: MyProfileController(),
                  builder: (controller) => Column(
                    children: [
                      Container(
                          color: regularWhite,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              getCustomFont(S.of(context).profile, 22.sp,
                                      regularBlack, 1,
                                      fontWeight: FontWeight.w700)
                                  .paddingSymmetric(vertical: 20.h),
                              homeMainScreenController.currentCustomer == null
                                  ? SizedBox()
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Directionality(
                                                textDirection:
                                                    Constant.getSetDirection(
                                                                context) ==
                                                            TextDirection.ltr
                                                        ? TextDirection.ltr
                                                        : TextDirection.rtl,
                                                child: AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0.h,
                                                          right: 0.h),
                                                  insetPadding: EdgeInsets.only(
                                                      left: 20.h, right: 20.h),
                                                  content: Container(
                                                    width: 374.h,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(30.h),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          getMultilineCustomFont(
                                                              S
                                                                  .of(context)
                                                                  .areYouSureYouWantToLogout,
                                                              18.sp,
                                                              regularBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 25.h,
                                                                    bottom:
                                                                        13.h),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: getCustomButton(
                                                                        S
                                                                            .of(
                                                                                context)
                                                                            .no,
                                                                        () {
                                                                  Get.back();
                                                                },
                                                                        color:
                                                                            buttonColor,
                                                                        decoration: ButtonStyle(
                                                                            elevation: MaterialStatePropertyAll(0.0),
                                                                            surfaceTintColor: MaterialStatePropertyAll(regularWhite),
                                                                            backgroundColor: MaterialStatePropertyAll(regularWhite),
                                                                            maximumSize: MaterialStatePropertyAll(
                                                                              Size(double.infinity, 56.h),
                                                                            ),
                                                                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h), side: BorderSide(color: buttonColor)))),
                                                                        buttonheight: 50.h)),
                                                                SizedBox(
                                                                    width:
                                                                        20.h),
                                                                Expanded(
                                                                    child: getCustomButton(
                                                                        S
                                                                            .of(
                                                                                context)
                                                                            .delete,
                                                                        () {
                                                                  context
                                                                      .loaderOverlay
                                                                      .show(
                                                                          showOverlay:
                                                                              getProgressDialog());

                                                                  if (homeMainScreenController
                                                                      .checkNullOperator()) {
                                                                    return;
                                                                  }

                                                                  homeMainScreenController
                                                                      .api1!
                                                                      .delete(
                                                                          "customers/${homeMainScreenController.currentCustomer!.id}?force=true")
                                                                      .then(
                                                                          (value) {
                                                                    WooDeleteCustomer
                                                                        postList =
                                                                        wooDeleteCustomerFromJson(
                                                                            value);

                                                                    if (postList
                                                                            .id ==
                                                                        homeMainScreenController
                                                                            .currentCustomer!
                                                                            .id) {
                                                                      setLoggedIn(
                                                                          false);
                                                                      homeController
                                                                              .currentCustomer =
                                                                          null;

                                                                      homeController
                                                                          .change(
                                                                              3);
                                                                      homeController
                                                                          .tabController!
                                                                          .animateTo(
                                                                        3,
                                                                        duration:
                                                                            Duration(milliseconds: 300),
                                                                        curve: Curves
                                                                            .ease,
                                                                      );
                                                                      cartControllerNew
                                                                          .clearCart();

                                                                      clearKey(
                                                                          keyCurrentUser);
                                                                      loginController
                                                                          .setLoginIsBuynow(
                                                                              true);
                                                                      Get.lazyPut(
                                                                          () =>
                                                                              LoginEmptyStateController());
                                                                      homeMainScreenController
                                                                          .changeIsLogin(
                                                                              false);
                                                                      context
                                                                          .loaderOverlay
                                                                          .hide();
                                                                      Get.offNamed(
                                                                          Routes
                                                                              .loginRoute);
                                                                    }
                                                                  });
                                                                }, buttonheight: 56.h)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: getAssetImage(
                                                "delete_account.png",
                                                height: 24.h,
                                                width: 24.h,
                                                color: regularBlack)
                                            .paddingOnly(right: 20.h),
                                      ),
                                    )
                            ],
                          )),
                      getVerSpace(12.h),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              color: regularWhite,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getVerSpace(24.h),
                                  getCustomFont(S.of(context).account, 20.sp,
                                      regularBlack, 1,
                                      fontWeight: FontWeight.w700),
                                  getVerSpace(24.h),
                                  getProfileOption("profile_icon.svg",
                                      S.of(context).myProfile, () async {
                                    bool isConnected =
                                        await isInternetConnected();

                                    if (isConnected) {
                                      if (homeMainScreenController
                                              .currentCustomer !=
                                          null) {
                                        Get.toNamed(Routes.myProfileRoute)!
                                            .then(
                                          (value) {},
                                        );
                                      } else {
                                        showCustomToast(
                                            S.of(context).pleaseLogin);
                                      }
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }
                                  }),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "unselected_address_icon_lt.svg",
                                      S.of(context).myAddress, () async {
                                    bool isConnected =
                                        await isInternetConnected();

                                    if (isConnected) {
                                      if (homeMainScreenController
                                              .currentCustomer !=
                                          null) {
                                        Get.toNamed(Routes.myAddressRoute);
                                      } else {
                                        showCustomToast(
                                            S.of(context).pleaseLogin);
                                      }
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }
                                  }),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption("my_order_icon.svg",
                                      S.of(context).myOrder, () async {
                                    bool isConnected =
                                        await isInternetConnected();

                                    if (isConnected) {
                                      orderConfirmScreenController
                                          .setNavigateToOrderConfirm(false);

                                      if (homeMainScreenController
                                              .currentCustomer !=
                                          null) {
                                        Get.toNamed(Routes.myOrderRoute);
                                      } else {
                                        showCustomToast(
                                            S.of(context).pleaseLogin);
                                      }
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }
                                  }),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "heart.svg", S.of(context).wishlist,
                                      () async {
                                    bool isConnected =
                                        await isInternetConnected();

                                    if (isConnected) {
                                      orderConfirmScreenController
                                          .setNavigateToOrderConfirm(false);
                                      Get.toNamed(Routes.favouriteRoute);
                                    } else {
                                      showCustomToast(
                                          S.of(context).noInternetConnection);
                                    }
                                  }),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "language.svg", S.of(context).language,
                                      () {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          backgroundColor: regularWhite,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.h)),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.h),
                                                color: regularWhite),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                getVerSpace(10.h),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    getCustomFont("Language",
                                                        20.sp, regularBlack, 1,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerEnd,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .only(
                                                                        end: 20
                                                                            .h),
                                                            child:
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child: getSvgImage(
                                                                        "close.svg",
                                                                        height: 24
                                                                            .h,
                                                                        width: 24
                                                                            .h))))
                                                  ],
                                                ),
                                                getVerSpace(10.h),
                                                ListView.builder(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount: langList.length,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    LanguageData lan =
                                                        langList[index];
                                                    return GetBuilder<
                                                        SelectLanguagesScreenController>(
                                                      init:
                                                          SelectLanguagesScreenController(),
                                                      builder:
                                                          (selectLanguagesScreenController) =>
                                                              InkWell(
                                                        onTap: () {
                                                          selectLanguagesScreenController1
                                                              .setLanguge(
                                                                  lan.id,
                                                                  lan.languageCode,
                                                                  lan.language);
                                                          PrefData
                                                              .setLanguageSelection(
                                                                  false);

                                                          Get.toNamed(
                                                              Routes
                                                                  .splashRoute,
                                                              arguments: true);
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              getCustomFont(
                                                                  "${lan.language} (${lan.languageCode})"
                                                                          .capitalizeFirst ??
                                                                      '',
                                                                  20.sp,
                                                                  regularBlack,
                                                                  1),
                                                              getSvgImage(lnCode.value ==
                                                                      lan
                                                                          .languageCode
                                                                  ? Constant
                                                                      .radioFillIcon
                                                                  : Constant
                                                                      .radioButtonIcon)
                                                            ],
                                                          ).paddingSymmetric(
                                                              horizontal: 20.h,
                                                              vertical: 10.h),
                                                        ),
                                                      ).paddingSymmetric(
                                                                  horizontal:
                                                                      20.h),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(20.h),
                                  getCustomFont(S.of(context).information,
                                      20.sp, regularBlack, 1,
                                      fontWeight: FontWeight.w700),
                                  getVerSpace(24.h),
                                  getProfileOption("privacy_policy_icon.svg",
                                      S.of(context).privacyPolicy, () {
                                    launchUrl(
                                        Uri.parse(Constant.privacyPolicyUrl),
                                        mode: LaunchMode.externalApplication);
                                    // Get.to(PrivacyPolicy());
                                  }, height: 24.h, width: 24.h),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "mail.svg", S.of(context).contactUs, () {
                                    launchUrl(Uri.parse(Constant.contactUsUrl),
                                        mode: LaunchMode.externalApplication);
                                  }, height: 24.h, width: 24.h),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "rating.svg", S.of(context).rateUs, () {
                                    rateUs_dialogue();
                                  }, height: 24.h, width: 24.h),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption("about_us.svg", "About us",
                                      () {
                                    launchUrl(
                                        Uri.parse(Constant.aboutUsPolicyUrl),
                                        mode: LaunchMode.externalApplication);
                                  }, height: 24.h, width: 24.h),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.feedBackRoute);
                                    },
                                    child: Container(
                                      height: 45.h,
                                      width: double.infinity,
                                      color: Color(0XFFFFFFFF),
                                      alignment: Alignment.topCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              getAssetImage("Feedback.png",
                                                  height: 24.h, width: 24.h),
                                              getHorSpace(20.w),
                                              getCustomFont(
                                                  S.of(context).feedback,
                                                  16.sp,
                                                  Color(0XFF000000),
                                                  1,
                                                  fontWeight: FontWeight.w500)
                                            ],
                                          ),
                                          getSvgImage("arrow_right.svg",
                                              height: 20.h, width: 20.w)
                                        ],
                                      ),
                                    ),
                                  ),
                                  getDivider(
                                      horPadding: 0.h,
                                      color: lightColor,
                                      height: 0),
                                  getVerSpace(18.h),
                                  getProfileOption(
                                      "logout.svg",
                                      homeMainScreenController
                                                  .currentCustomer ==
                                              null
                                          ? S.of(context).login
                                          : S.of(context).logout, () {
                                    if (homeMainScreenController
                                            .currentCustomer ==
                                        null) {
                                      loginController.setLoginIsBuynow(true);
                                      homeMainScreenController
                                          .changeIsLogin(false);
                                      Get.toNamed(Routes.loginRoute);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Directionality(
                                            textDirection:
                                                Constant.getSetDirection(
                                                            context) ==
                                                        TextDirection.ltr
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            child: AlertDialog(
                                              contentPadding: EdgeInsets.only(
                                                  left: 0.h, right: 0.h),
                                              insetPadding: EdgeInsets.only(
                                                  left: 20.h, right: 20.h),
                                              content: Container(
                                                width: 374.h,
                                                child: Padding(
                                                  padding: EdgeInsets.all(30.h),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      getMultilineCustomFont(
                                                          S
                                                              .of(context)
                                                              .areYouSureYouWantLogout,
                                                          18.sp,
                                                          regularBlack,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          textAlign:
                                                              TextAlign.center),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 25.h,
                                                                bottom: 13.h),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: getCustomButton(
                                                                    S
                                                                        .of(
                                                                            context)
                                                                        .yes,
                                                                    () {
                                                              setLoggedIn(
                                                                  false);
                                                              homeController
                                                                      .currentCustomer =
                                                                  null;

                                                              homeController
                                                                  .change(3);
                                                              homeController
                                                                  .tabController!
                                                                  .animateTo(
                                                                3,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        300),
                                                                curve:
                                                                    Curves.ease,
                                                              );
                                                              cartControllerNew
                                                                  .clearCart();
                                                              setState(() {
                                                                homeController =
                                                                    Get.find<
                                                                        HomeMainScreenController>();
                                                                homeMainScreenController
                                                                        .currentCustomer =
                                                                    homeController
                                                                        .currentCustomer;
                                                              });
                                                              clearKey(
                                                                  keyCurrentUser);
                                                              loginController
                                                                  .setLoginIsBuynow(
                                                                      true);
                                                              Get.lazyPut(() =>
                                                                  LoginEmptyStateController());
                                                              homeMainScreenController
                                                                  .changeIsLogin(
                                                                      false);
                                                              Get.offNamed(Routes
                                                                  .loginRoute);
                                                            },
                                                                    buttonheight:
                                                                        56.h)),
                                                            SizedBox(
                                                                width: 20.h),
                                                            Expanded(
                                                                child: getCustomButton(
                                                                    S
                                                                        .of(
                                                                            context)
                                                                        .no,
                                                                    () {
                                                              Get.back();
                                                            },
                                                                    color:
                                                                        buttonColor,
                                                                    decoration: ButtonStyle(
                                                                        elevation: MaterialStatePropertyAll(0.0),
                                                                        surfaceTintColor: MaterialStatePropertyAll(regularWhite),
                                                                        backgroundColor: MaterialStatePropertyAll(regularWhite),
                                                                        maximumSize: MaterialStatePropertyAll(
                                                                          Size(
                                                                              double.infinity,
                                                                              56.h),
                                                                        ),
                                                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h), side: BorderSide(color: buttonColor)))),
                                                                    buttonheight: 50.h)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }, height: 24.h, width: 24.h),
                                  // getVerSpace(20.h),
                                ],
                              ).paddingSymmetric(horizontal: 20.h),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Future rateUs_dialogue() {
    return Get.defaultDialog(
        backgroundColor: regularWhite,
        title: '',
        content: Column(
          children: [
            getAssetImage(Constant.rateUsPng, height: 172.h, width: 269.h),
            getVerSpace(30.h),
            getCustomFont(S.of(context).giveYourOpinion, 22.sp, regularBlack, 1,
                fontWeight: FontWeight.w700),
            getVerSpace(12.h),
            getMultilineCustomFont(
                    S.of(context).makeBetterMathGoalForYouAndWouldLoveTo,
                    16.sp,
                    regularBlack,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center)
                .paddingSymmetric(horizontal: 20.h),
            getVerSpace(30.h),
            RatingBar(
              initialRating: profileScreenController.review,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.h,
              glow: false,
              ratingWidget: RatingWidget(
                full: getSvgImage("fidbackfillicon.svg"),
                half: getSvgImage("fidbackemptyicon.svg"),
                empty: getSvgImage("fidbackemptyicon.svg"),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 8.h),
              onRatingUpdate: (rating) {
                profileScreenController.setReview(rating);
              },
            ),
            getVerSpace(30.h),
            Row(
              children: [
                Expanded(
                    child: getCustomButton(
                  S.of(context).cancel,
                  () {
                    Get.back();
                  },
                  color: buttonColor,
                  decoration: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0.0),
                      overlayColor: MaterialStatePropertyAll(lightGreen),
                      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.white,
                      ),
                      maximumSize: MaterialStatePropertyAll(
                        Size(double.infinity, 56.h),
                      ),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.h),
                          side: BorderSide(color: buttonColor)))),
                )),
                getHorSpace(20.h),
                Expanded(
                    child: getCustomButton(
                  S.of(context).submit,
                  () {
                    Get.back();
                    if (profileScreenController.review < 3.0) {
                      Get.toNamed(Routes.writeReviewForLowStarRoute);
                    } else {
                      LaunchReview.launch(
                          androidAppId: "com.ravasiya.collection",
                          iOSAppId: "585027354");
                    }
                  },
                )),
              ],
            ).paddingSymmetric(horizontal: 20.h)
          ],
        ));
  }
}
