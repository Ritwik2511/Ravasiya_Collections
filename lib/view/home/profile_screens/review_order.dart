// ignore_for_file: deprecated_member_use, unused_import

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../generated/l10n.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class ReviewOrder extends StatefulWidget {
  ReviewOrder({Key? key}) : super(key: key);

  @override
  State<ReviewOrder> createState() => _ReviewOrderState();
}

class _ReviewOrderState extends State<ReviewOrder> {
  backClick(BuildContext context) {
    backToPrev(context);
  }

  var argument = Get.arguments;

  HomeMainScreenController productDataController =
      Get.find<HomeMainScreenController>();
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          backClick(context);
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: regularWhite,
                        child: getAppBar(S.of(context).review, function: () {
                          // backClick(context);
                          backClick(context);
                        }, space: 105.h),
                      ),
                      getVerSpace(12.h),
                      Container(
                        width: double.infinity,
                        color: regularWhite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 70.h,
                                width: 70.h,
                                padding: EdgeInsets.all(12.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.h),
                                    border: Border.all(color: black20)),
                                child: Image.network(
                                  argument[0]!.images[0].src ?? "",
                                  height: double.infinity,
                                  width: double.infinity,
                                )),
                            getHorSpace(24.h),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(argument[0]!.name ?? "", 16.sp,
                                      regularBlack, 2,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.visible),
                                  getVerSpace(10.h),
                                  RatingBar.builder(
                                    initialRating: argument[1]!,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20.h,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20.h,
                                    ),
                                    unratedColor: '#E0E0E0'.toColor(),
                                    onRatingUpdate: (rating) {
                                      argument[1] = rating;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).paddingAll(20.h),
                      ),
                      getVerSpace(16.h),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: regularWhite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getVerSpace(24.h),
                              getCustomFont(S.of(context).addPhotoOrVideo,
                                  14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600),
                              getVerSpace(8.h),
                              Container(
                                width: 177.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.h),
                                    border: Border.all(color: black20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getSvgImage("camera_icon_green.svg",
                                        height: 20.h, width: 20.h),
                                    getHorSpace(8.h),
                                    getCustomFont(
                                        "Add Photo", 14.sp, buttonColor, 1,
                                        fontWeight: FontWeight.w400)
                                  ],
                                ).paddingSymmetric(vertical: 13.h),
                              ),
                              getVerSpace(18.h),
                              ExpandableText(
                                S
                                    .of(context)
                                    .uploadPhotosvideosRelatedToTheProductLikeUnboxingInstallationProduct,
                                expandText: S.of(context).showMore,
                                collapseText: S.of(context).showLess,
                                maxLines: 2,
                                linkColor: Colors.blue,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: darkGray,
                                    fontFamily: Constant.fontsFamily),
                              ),
                              getVerSpace(32.h),
                              getCustomFont(S.of(context).writeAReview, 14.sp,
                                  regularBlack, 1,
                                  fontWeight: FontWeight.w600),
                              getVerSpace(6.h),
                              TextFormField(
                                maxLines: 4,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black20, width: 1),
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black20, width: 1),
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black20, width: 1),
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black20, width: 1),
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    hintText: S.of(context).typeHere,
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: "#A3A3A3".toColor(),
                                        fontFamily: Constant.fontsFamily)),
                                controller: reviewController,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: regularBlack,
                                    fontFamily: Constant.fontsFamily),
                              ),
                              getVerSpace(20.h),
                            ],
                          ).paddingSymmetric(horizontal: 20.h),
                        ),
                      ),
                    ],
                  ),
                ),
                getCustomButton(S.of(context).submit, () async {
                  if (reviewController.text.isEmpty) {
                    return showCustomToast(S.of(context).pleaseEnterReview);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Directionality(
                          textDirection: Constant.getSetDirection(context) ==
                                  TextDirection.ltr
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          child: AlertDialog(
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: 20.h),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.h),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                getSvgImage(Constant.thankyouIcon,
                                    height: 127.h, width: 127.h),
                                getVerSpace(32.h),
                                getCustomFont(S.of(context).thankYou, 28.sp,
                                    regularBlack, 2,
                                    fontWeight: FontWeight.w700),
                                getVerSpace(8.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 41.h),
                                  child: getCustomFont(
                                      S
                                          .of(context)
                                          .thanksForSpendingYourValuableTime,
                                      16.sp,
                                      regularBlack,
                                      2,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center),
                                ),
                                getVerSpace(30.h),
                                getCustomButton(S.of(context).ok, () {
                                  if (productDataController
                                      .checkNullOperator()) {
                                    return;
                                  }

                                  productDataController.wooCommerce1!
                                      .createProductReview(
                                          productId: argument[0]!.id.toInt(),
                                          reviewer:
                                              "${productDataController.currentCustomer!.firstName} ${productDataController.currentCustomer!.lastName}",
                                          reviewerEmail: productDataController
                                              .currentCustomer!.email
                                              .toString(),
                                          review: reviewController.text,
                                          rating: argument[1]!.toInt())
                                      .then((value) {
                                    // Get.toNamed(Routes.trackOrderRoute,
                                    //     arguments: argument[2]);
                                    Get.back();
                                    Get.back();
                                  });
                                }, buttonwidth: 147.h, buttonheight: 46.h),
                              ],
                            ).paddingSymmetric(vertical: 42.h),
                          ),
                        );
                      },
                    );
                  }
                }).paddingOnly(bottom: 30.h, left: 20.h, right: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
