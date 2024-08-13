// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/constantWidget.dart';

class OrderConfirmScreen extends StatefulWidget {
  OrderConfirmScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  OrderConfirmScreenController orderConfirmScreenController =
      Get.put(OrderConfirmScreenController());
  HomeMainScreenController putHome = Get.put(HomeMainScreenController());

  HomeScreenController putstorageController = Get.put(HomeScreenController());

  var argument = Get.arguments;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          putstorageController.cleareShipping();
          putstorageController.clearShippingMethod();
          putstorageController.changeShippingIndex(-1);
          putstorageController.changeShippingTax(0.0);
          putHome.change(0);
          putHome.tabController!.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          Get.toNamed(Routes.homeMainRoute);
          return false;
        },
        child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSuccessAnimation(),
                getVerSpace(32.h),
                getCustomFont(argument[0], 22, regularBlack, 1,
                    textAlign: TextAlign.center, fontWeight: FontWeight.w700),
                12.h.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCustomFont(S.of(context).status, 18.sp, regularBlack, 1,fontWeight: FontWeight.w500,),
                    getHorSpace(5.h),
                    getCustomFont("${ orderConfirmScreenController.orderStatus!.toUpperCase()}", 18.sp, Constant.getOrderStatusColor(
                        orderConfirmScreenController.orderStatus ?? "",
                        context), 1,fontWeight: FontWeight.w500,),
                  ],
                ),


                12.h.verticalSpace,
                getCustomFont(
                    "${S.of(context).orderId} ${orderConfirmScreenController.orderId!}",
                    18.sp,
                    regularBlack,
                    1,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600),
                24.h.verticalSpace,
                getMultilineCustomFont(argument[1], 16, regularBlack,
                    textAlign: TextAlign.center, fontWeight: FontWeight.w400),
                40.h.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getCustomButton(S.of(context).viewMyOrder, () {
                      // clearMyOrderCacheCache();
                      orderConfirmScreenController
                          .setNavigateToOrderConfirm(true);
                      putstorageController.cleareShipping();
                      putstorageController.clearShippingMethod();
                      putstorageController.changeShippingIndex(-1);
                      putstorageController.changeShippingTax(0.0);
                      Get.toNamed(Routes.myOrderRoute);
                    }).paddingSymmetric(horizontal: 0.h)
                  ],
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
