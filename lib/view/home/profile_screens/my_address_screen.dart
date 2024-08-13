// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes.dart';
import '../../../woocommerce/models/customer.dart';
import '../cart_screens/check_out_shipping_add.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({Key? key}) : super(key: key);

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  backClick(BuildContext context) {
    backToPrev(context);
  }

  HomeMainScreenController homeController = Get.put(HomeMainScreenController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    Get.put(ShippingAddressController());
    super.initState();
  }

  List list = [0];

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
            backgroundColor: regularWhite,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
                child: Container(
              color: bgColor,
              child: GetBuilder<HomeMainScreenController>(
                init: HomeMainScreenController(),
                builder: (controller) {
                  Shipping? shippingAddress =
                      (homeController.currentCustomer != null)
                          ? homeController.currentCustomer!.shipping
                          : null;
                  Billing? wooCustomer =
                      (homeController.currentCustomer != null)
                          ? homeController.currentCustomer!.billing
                          : null;

                  return Column(
                    children: [
                      Container(
                        color: regularWhite,
                        child: getAppBar(S.of(context).myAddress, function: () {
                          Get.back();
                        }, space: 131.h),
                      ),
                      getVerSpace(8.h),
                      (homeController.currentCustomer != null &&
                              wooCustomer!.city!.isNotEmpty)
                          ? Expanded(
                              child: ListView(
                                primary: true,
                                shrinkWrap: false,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (wooCustomer.city!.isNotEmpty)
                                          ? Container(
                                              width: double.infinity,
                                              color: regularWhite,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getVerSpace(10.h),
                                                  getCustomFont(
                                                          S
                                                              .of(context)
                                                              .billingAddress,
                                                          20.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w700)
                                                      .paddingSymmetric(
                                                          horizontal: 20.h),
                                                  getVerSpace(0.h),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h),
                                                    child:
                                                        SelectaddressItemWidget(
                                                            wooCustomer, true,
                                                            isMyAdd: true),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                      getVerSpace(20.h),
                                      (shippingAddress != null &&
                                              shippingAddress.city!.isNotEmpty)
                                          ? Container(
                                              width: double.infinity,
                                              color: regularWhite,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getVerSpace(10.h),
                                                  getCustomFont(
                                                          S
                                                              .of(context)
                                                              .shippingAddress,
                                                          20.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w700)
                                                      .paddingSymmetric(
                                                          horizontal: 20.h),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0.h),
                                                      child:
                                                          SelectDifferentaddressItemWidget(
                                                        shippingAddress,
                                                        true,
                                                        isMyAdd: true,
                                                      ).paddingSymmetric(
                                                              vertical: 0.h)),
                                                ],
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: getEmptyWidget(
                                  context,
                                  Constant.noAddressLogo,
                                  S.of(context).noAddressYet,
                                  S
                                      .of(context)
                                      .addYourAddressForFasterCheckOutProductDeals,
                                  S.of(context).add, () {
                                homeController.currentCustomer != null
                                    ? Get.toNamed(Routes.addBillingAddressRoute,
                                            arguments: false)!
                                        .then((value) => setState(() {}))
                                    : showCustomToast(
                                        S.of(context).pleaseLogin);
                              }),
                            )
                    ],
                  );
                },
              ),
            ) /**/)),
      ),
    );
  }
}
