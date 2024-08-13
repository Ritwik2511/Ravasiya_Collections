// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ravasiya_collections/model/product_review.dart';
import 'package:ravasiya_collections/utils/constant.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constantWidget.dart';
import 'controller/rating_controller.dart';

class RatingDataScreen extends StatefulWidget {
  RatingDataScreen({Key? key}) : super(key: key);

  @override
  State<RatingDataScreen> createState() => _RatingDataScreenState();
}

class _RatingDataScreenState extends State<RatingDataScreen> {

  HomeScreenController storageController = Get.find<HomeScreenController>();
  RatingController ratingController = Get.put(RatingController());
  var argument = Get.arguments;

  Future<List<ModelReviewProduct>> getReviewList() async {

    if(homeMainScreenController.checkNullOperator()){
      return [];
    }
    var result = await homeMainScreenController.wooCommerce1!
        .getProductReviewByProductId(
            productId: storageController.selectedProduct!.id,
            wooCommerceAPI: homeMainScreenController.api1!);
    return result;
  }

  @override
  void initState() {
    getReviewList();
    Future.delayed(
      Duration.zero,
      () {
        ratingController.setData(argument);



      },
    );
    // });
    super.initState();
  }

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
            body: GetBuilder<HomeMainScreenController>(
              init: HomeMainScreenController(),
              builder: (homeMainScreenController) => Column(children: [
                Container(
                    height: 73.h,
                    width: double.infinity,
                    color: regularWhite,
                    child: getAppBar(S.of(context).review, space: 109.h,
                        function: () {
                      Get.back();
                    })),
                getVerSpace(8.h),
                argument[0]!.isNotEmpty
                    ? Container(
                        color: regularWhite,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              width: 98.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  getRichtext(
                                      argument[1]!.averageRating ?? "", " / 5",
                                      firsttextSize: 28.sp,
                                      firstTextwidth: FontWeight.w700,
                                      secondtextcolor: darkGray,
                                      secondtextSize: 16.sp,
                                      secondTextwidth: FontWeight.w400),
                                  getVerSpace(14.h),
                                  RatingBar(
                                    ignoreGestures: true,
                                    initialRating: double.parse(
                                        storageController
                                            .selectedProduct!.averageRating),
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 18.h,
                                    itemPadding: EdgeInsets.only(right: 1.h),
                                    ratingWidget: RatingWidget(
                                      full: getSvgImage(
                                          "img_star_amber_600.svg",
                                          height: 18.h,
                                          width: 18.h),
                                      half: getSvgImage(
                                          "img_star_amber_600.svg",
                                          height: 18.h,
                                          width: 18.h),
                                      empty: getSvgImage(
                                          "img_vuesaxlinearstar.svg",
                                          height: 18.h,
                                          width: 18.h),
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  getVerSpace(8.h),
                                  getCustomFont(
                                      "${argument[0]!.length} Reviews",
                                      16.sp,
                                      darkGray,
                                      1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                            20.h.horizontalSpace,
                            Container(
                              width: 2.h,
                              color: gray,
                              height: 100.h,
                            ),
                            20.h.horizontalSpace,
                            Expanded(
                              flex: 1,
                              child: GetBuilder(
                                builder: (controller) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: LinearPercentIndicator(
                                                lineHeight: 4.h,
                                                barRadius: Radius.circular(20.h),
                                                progressColor: darkGray,
                                                backgroundColor: gray,
                                                percent: controller.five.toDouble() /
                                                    argument[0]!.length,
                                              )),
                                          getCustomFont(
                                              controller.five.toString(), 16.sp, darkGray, 1,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: LinearPercentIndicator(
                                                lineHeight: 4.h,
                                                barRadius: Radius.circular(20.h),
                                                progressColor: darkGray,
                                                backgroundColor: gray,
                                                percent: controller.four.toDouble() /
                                                    argument[0]!.length,
                                              )),
                                          getCustomFont(
                                              controller.four.toString(), 16.sp, darkGray, 1,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: LinearPercentIndicator(
                                                lineHeight: 4.h,
                                                barRadius: Radius.circular(20.h),
                                                progressColor: darkGray,
                                                backgroundColor: gray,
                                                percent: controller.three.toDouble() /
                                                    argument[0]!.length,
                                              )),
                                          getCustomFont(
                                              controller.three.toString(), 16.sp, darkGray, 1,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: LinearPercentIndicator(
                                                lineHeight: 4.h,
                                                barRadius: Radius.circular(20.h),
                                                progressColor: darkGray,
                                                backgroundColor: gray,
                                                percent: controller.two.toDouble() /
                                                    argument[0]!.length,
                                              )),
                                          getCustomFont(
                                              controller.two.toString(), 16.sp, darkGray, 1,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              getSvgImage(
                                                "star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                              getSvgImage(
                                                "unfill_star.svg",
                                                height: 14.h,
                                                width: 14.h,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: LinearPercentIndicator(
                                                lineHeight: 4.h,
                                                barRadius: Radius.circular(20.h),
                                                progressColor: darkGray,
                                                backgroundColor: gray,
                                                percent: controller.one.toDouble() /
                                                    argument[0]!.length,
                                              )),
                                          getCustomFont(
                                              controller.one.toString(), 16.sp, darkGray, 1,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      )
                                    ],
                                  );
                                },init: RatingController(),
                              ),
                            )
                          ],
                        ).paddingOnly(
                            right: 20.h, top: 20.h, bottom: 20.h, left: 20.h),
                      )
                    : getProgressDialog(),
                Expanded(
                  child: Container(
                    color: regularWhite,
                    child: argument[0]!.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.only(
                                left: 20.h,
                                right: 20.h,
                                top: 20.h,
                                bottom: 20.h),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return getDivider(
                                      color: black20, horPadding: 0, height: 0)
                                  .marginOnly(bottom: 20.h);
                            },
                            itemCount: argument[0]!.length,
                            itemBuilder: (context, index) {
                              ModelReviewProduct model = argument[0]![index];

                              return ProductdetailItemWidget(model);
                            })
                        : Center(
                            child: Lottie.asset(lottieAnimation,
                                height: 130.h, width: 130.h)),
                  ),
                ),
              ]),
            ),
          ))),
    );
  }

  Widget ProductdetailItemWidget(ModelReviewProduct productdetailItemModelObj) {
    DateTime dateTime =
        DateTime.parse(productdetailItemModelObj.dateCreated ?? "");
    String date = DateFormat("dd MMM,yyyy").format(dateTime);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                getAssetImage("img_ellipse152.png", height: 48.h, width: 48.h),
                getHorSpace(14.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getCustomFont(productdetailItemModelObj.reviewer.toString(),
                        16.sp, regularBlack, 1,
                        fontWeight: FontWeight.w400),
                    getVerSpace(1.h),
                    getCustomFont(date, 14.sp, regularBlack, 1,
                        fontWeight: FontWeight.w400),
                  ],
                )
              ],
            ),
            RatingBar(
              ignoreGestures: true,
              initialRating: productdetailItemModelObj.rating!.toDouble(),
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 14.h,
              ratingWidget: RatingWidget(
                full: getSvgImage("img_star_amber_600.svg",
                    height: 15.h, width: 15.h),
                half: getSvgImage("img_star_amber_600.svg",
                    height: 15.h, width: 15.h),
                empty: getSvgImage("img_vuesaxlinearstar.svg",
                    height: 15.h, width: 15.h),
              ),
              onRatingUpdate: (double value) {},
            ),
          ],
        ),
        Html(data: productdetailItemModelObj.review.toString())
      ],
    );
  }
}
