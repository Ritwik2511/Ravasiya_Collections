// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../controller/controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/color_category.dart';
import '../../utils/constant.dart';
import '../../utils/constantWidget.dart';

class ZoomImageScreen extends StatefulWidget {
  ZoomImageScreen({Key? key}) : super(key: key);

  @override
  State<ZoomImageScreen> createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  ZoomImageScreenController zoomImageScreenController =
      Get.put(ZoomImageScreenController());
  PageController? pcontroller;
  HomeScreenController storageController = Get.find<HomeScreenController>();
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  var argument = Get.arguments;

  @override
  void initState() {
    super.initState();
    pcontroller =
        PageController(initialPage: zoomImageScreenController.currentPage);
  }

  Future<void> share() async {

    Share.share('${storageController.selectedProduct!.name}', subject: '${Constant.webUrl}/product/' +
        storageController.selectedProduct!.name +
        "/");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
            child: GetBuilder(
              init: ZoomImageScreenController(),
              builder: (controller) => Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        PageView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: pcontroller,
                            onPageChanged: (value) {
                              controller.onPageChange(value);
                            },
                            itemBuilder: (context, index) {
                              return Center(
                                child: Zoom(
                                    backgroundColor: regularWhite,
                                    maxZoomHeight: 534.h,
                                    initTotalZoomOut: false,
                                    child: CachedNetworkImage(
                                      height: 261.h,
                                      width: 261.h,
                                      imageUrl: argument
                                          .images[controller.currentPage].src,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        color: buttonColor,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          getAssetImage("no_image_banner.png"),
                                    )),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: argument.images.length),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(end: 20.h),
                            child: getSvgImage("arrow_square_left.svg",
                                height: 24.h, width: 24.h),
                          )),
                      Row(children: [
                        GestureDetector(
                          onTap: () {
                            share();
                          },
                          child: Container(
                            height: 38.h,
                            width: 38.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: regularWhite),
                            child: getSvgImage("share_icon.svg").paddingAll(9.h),
                          ),
                        ),
                        getHorSpace(16.h),
                        GestureDetector(
                          onTap: () {
                            homeMainScreenController.change(2);
                            homeMainScreenController.tabController!.animateTo(
                              2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                            Get.toNamed(Routes.homeMainRoute);
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 38.h,
                                width: 38.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: regularWhite),
                                child: getSvgImage("cart_icon.svg",
                                        color: regularBlack)
                                    .paddingAll(9.h),
                              ),
                              cartControllerNew.cartOtherInfoList.isNotEmpty
                                  ? Container(
                                      margin:
                                          EdgeInsetsDirectional.only(start: 27.h),
                                      height: 20.h,
                                      width: 20.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: buttonColor),
                                      child: Center(
                                          child: getCustomFont(
                                              cartControllerNew
                                                  .cartOtherInfoList.length
                                                  .toString(),
                                              14.sp,
                                              regularWhite,
                                              1,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )
                      ])
                    ],
                  )
                      .paddingOnly(left: 20.h, right: 20.h, top: 20.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            argument.images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 8.h,
                            width: index == zoomImageScreenController.currentPage
                                ? 18.h
                                : 8.h,
                            margin: EdgeInsetsDirectional.symmetric(
                                horizontal: 5.h, vertical: 30.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.h),
                                color: (index ==
                                        zoomImageScreenController.currentPage)
                                    ? buttonColor
                                    : buttonColor.withOpacity(0.3)),
                          );
                        })),
                  ).paddingOnly(bottom: 89.h)
                ],
              ),
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(true);
        },
      ),
    );
  }
}
