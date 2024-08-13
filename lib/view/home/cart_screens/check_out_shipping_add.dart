import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:tuple/tuple.dart';

import '../../../model/model_dummy_selected_add.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/customer.dart';

// ignore: must_be_immutable
class SelectaddressItemWidget extends StatefulWidget {
  SelectaddressItemWidget(this.selectaddressItemModelObj, this.iconPermition,
      {this.isMyAdd = false});

  // Shipping selectaddressItemModelObj;
  Billing selectaddressItemModelObj;
  bool iconPermition = true;
  bool isMyAdd;

  @override
  State<SelectaddressItemWidget> createState() =>
      _SelectaddressItemWidgetState();
}

class _SelectaddressItemWidgetState extends State<SelectaddressItemWidget> {
  HomeScreenController homeController = Get.put(HomeScreenController());
  HomeMainScreenController homemainController =
      Get.put(HomeMainScreenController());
  ProductDataController productDataController =
      Get.find<ProductDataController>();

  getShippingMethods() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    String zoneId = await productDataController.getShippingMethodZoneId(
        homeMainScreenController.wooCommerce1!,
        homeScreenController.selectedShippingAddress!.country,
        city: homeScreenController.selectedShippingAddress!.city,
        state: homeScreenController.selectedShippingAddress!.state,
        pincode: homeScreenController.selectedShippingAddress!.postcode);
    homeScreenController.changeMethod(
        await homeMainScreenController.wooCommerce1!.getAllShippingMethods(
            zoneId,
            homeMainScreenController.wooCommerce1!,
            widget.selectaddressItemModelObj.postcode!));

    homeController.shippingMthLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      builder: (controller) => GestureDetector(
        onTap: () {
          controller.isBillingAdd.value = true;
        },
        child: Container(
          width: double.maxFinite,
          color: regularWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.iconPermition
                            ? getSvgImage("location_icon.svg")
                            : getHorSpace(0.h),
                        widget.iconPermition
                            ? getHorSpace(20.h)
                            : getHorSpace(0.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomFont(
                                  widget.selectaddressItemModelObj.city
                                      .toString(),
                                  18.sp,
                                  regularBlack,
                                  1,
                                  fontWeight: FontWeight.w600),
                              getVerSpace(4.h),
                              getMultilineCustomFont(
                                  "${widget.selectaddressItemModelObj.address1!} ${widget.selectaddressItemModelObj.address2!}, ${widget.selectaddressItemModelObj.city!}, ${widget.selectaddressItemModelObj.state!}, ${widget.selectaddressItemModelObj.country!}, ${widget.selectaddressItemModelObj.postcode!}",
                                  16.sp,
                                  regularBlack,
                                  fontWeight: FontWeight.w400,
                                  txtHeight: 1.5.h),
                              getVerSpace(4.h),
                              getCustomFont(
                                  widget.selectaddressItemModelObj.phone
                                      .toString(),
                                  15.sp,
                                  regularBlack,
                                  1,
                                  fontWeight: FontWeight.w500),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      getCustomFont("Default", 14.sp, buttonColor, 1,
                          fontWeight: FontWeight.w600),
                      getHorSpace(11.h),
                      PopupMenuButton(
                        color: regularWhite,
                        onSelected: (value) {
                          Get.toNamed(Routes.editAddressRoute,
                                  arguments:
                                      Tuple4<bool, Shipping?, Billing?, bool?>(
                                          false,
                                          null,
                                          widget.selectaddressItemModelObj,
                                          null))!
                              .then((value) {
                            // widget.selectaddressItemModelObj =
                            //     homemainController.currentCustomer!.billing!;
                            ModelDummySelectedAdd selectedAdd =
                            ModelDummySelectedAdd(
                                homemainController
                                    .currentCustomer!.billing!.firstName ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.lastName ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.company ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.address1 ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.address2 ??
                                    "",
                                homemainController.currentCustomer!.billing!.city ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.state ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.postcode ??
                                    "",
                                homemainController
                                    .currentCustomer!.billing!.country ??
                                    "");
                            homeScreenController.selectedShippingAddress =
                                selectedAdd;
                            getShippingMethods();
                          });
                        },
                        child: getSvgImage("more_vert_rounded.svg",
                                width: 20.h, height: 20.h)
                            .paddingOnly(right: 0.h),
                        surfaceTintColor: regularWhite,
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                              height: 40.h,
                              value: 'edit',
                              child: Row(
                                children: [
                                  getSvgImage("edit.svg",
                                      height: 20.h, width: 20.h),
                                  8.h.horizontalSpace,
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: Constant.fontsFamily,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ).paddingOnly(top: 10.h, bottom: 20.h, right: 20.h, left: 20.h),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SelectDifferentaddressItemWidget extends StatefulWidget {
  SelectDifferentaddressItemWidget(
      this.selectDifferentaddressItemWidget, this.iconPermition,
      {this.isMyAdd = false});

  Shipping selectDifferentaddressItemWidget;
  bool iconPermition = true;
  bool isMyAdd;

  @override
  State<SelectDifferentaddressItemWidget> createState() =>
      _SelectDifferentaddressItemWidgetState();
}

class _SelectDifferentaddressItemWidgetState
    extends State<SelectDifferentaddressItemWidget> {
  HomeScreenController homeController = Get.put(HomeScreenController());
  HomeMainScreenController homemainController =
      Get.find<HomeMainScreenController>();

  ProductDataController productDataController =
      Get.find<ProductDataController>();

  getShippingMethods() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    String zoneId = await productDataController.getShippingMethodZoneId(
        homeMainScreenController.wooCommerce1!,
        homeScreenController.selectedShippingAddress!.country,
        city: homeScreenController.selectedShippingAddress!.city,
        state: homeScreenController.selectedShippingAddress!.state,
        pincode: homeScreenController.selectedShippingAddress!.postcode);
    homeScreenController.changeMethod(
        await homeMainScreenController.wooCommerce1!.getAllShippingMethods(
            zoneId,
            homeMainScreenController.wooCommerce1!,
            widget.selectDifferentaddressItemWidget.postcode!));

    homeController.shippingMthLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      builder: (controller) => GestureDetector(
        onTap: () {},
        child: Container(
          width: double.maxFinite,
          color: regularWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.iconPermition
                          ? getSvgImage(Constant.locationIcon)
                          : getHorSpace(0.h),
                      widget.iconPermition
                          ? getHorSpace(20.h)
                          : getHorSpace(0.h),
                      Container(
                        width: widget.iconPermition ? 229.h : 288.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                                widget.selectDifferentaddressItemWidget.city
                                    .toString(),
                                18.sp,
                                regularBlack,
                                1,
                                fontWeight: FontWeight.w600),
                            getVerSpace(5.h),
                            getMultilineCustomFont(
                                "${widget.selectDifferentaddressItemWidget.address1!} ${widget.selectDifferentaddressItemWidget.address2!}, ${widget.selectDifferentaddressItemWidget.city!}, ${widget.selectDifferentaddressItemWidget.state!}, ${widget.selectDifferentaddressItemWidget.country!}, ${widget.selectDifferentaddressItemWidget.postcode!}",
                                16.sp,
                                regularBlack,
                                fontWeight: FontWeight.w400,
                                txtHeight: 1.5.h),
                            getVerSpace(5.h),
                            getCustomFont(
                                widget.selectDifferentaddressItemWidget.phone
                                    .toString(),
                                15.sp,
                                regularBlack,
                                1,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    color: regularWhite,
                    onSelected: (value) {
                      Get.toNamed(Routes.editAddressRoute,
                              arguments:
                                  // Tuple4<bool, Shipping, Billing?, bool?>(
                                  Tuple4<bool, Shipping?, Billing?, bool?>(
                                      true,
                                      widget.selectDifferentaddressItemWidget,
                                      null,
                                      null))!
                          .then((value) {
                        // widget.selectDifferentaddressItemWidget =
                        //     homemainController.currentCustomer!.shipping!;
                        ModelDummySelectedAdd selectedAdd =
                        ModelDummySelectedAdd(
                            homemainController
                                .currentCustomer!.shipping!.firstName ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.lastName ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.company ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.address1 ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.address2 ??
                                "",
                            homemainController.currentCustomer!.shipping!.city ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.state ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.postcode ??
                                "",
                            homemainController
                                .currentCustomer!.shipping!.country ??
                                "");
                        homeScreenController.selectedShippingAddress =
                            selectedAdd;
                        getShippingMethods();
                      });
                    },
                    child: getSvgImage("more_vert_rounded.svg",
                            height: 24.h, width: 24.h)
                        .paddingOnly(right: 0.h),
                    surfaceTintColor: regularWhite,
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          height: 40.h,
                          value: 'edit',
                          child: Row(
                            children: [
                              getSvgImage("edit.svg",
                                  height: 20.h, width: 20.h),
                              8.h.horizontalSpace,
                              Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: Constant.fontsFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              getVerSpace(10.h),
            ],
          ).paddingSymmetric(horizontal: 20.h, vertical: 10.h),
        ),
      ),
    );
  }
}
