// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:ravasiya_collections/woocommerce/models/retrieve_coupon.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/order_create_model.dart';

class CoupanScreen extends StatefulWidget {
  const CoupanScreen({Key? key}) : super(key: key);

  @override
  State<CoupanScreen> createState() => _CoupanScreenState();
}

class _CoupanScreenState extends State<CoupanScreen> {
  TextEditingController couponCode = TextEditingController();
  ProductDataController productDataController =
      Get.put(ProductDataController());
  HomeMainScreenController homeMainScreenController =
      Get.find<HomeMainScreenController>();
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  CouponsController couponsController = Get.put(CouponsController());

  final formkey = GlobalKey<FormState>();

  getAllCartList() {
    PrefData.getCartList().then((value) {
      cartControllerNew.getCartList(value);
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCartList();
  }

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
          backgroundColor: regularWhite,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              color: bgColor,
              child: GetBuilder<CoupanScreenController>(
                init: CoupanScreenController(),
                builder: (coupanScreenController) => Column(
                  children: [
                    Container(
                      color: regularWhite,
                      child: getAppBar(S.of(context).coupons, space: 117.h,
                          function: () {
                        Get.back();
                      }),
                    ),
                    getVerSpace(8.h),
                    Expanded(
                      child: GetBuilder<CartControllerNew>(
                          init: CartControllerNew(),
                          builder: (controller) {
                            couponCode.text = controller.inputCoupon.value;
                            return Container(
                              color: regularWhite,
                              width: double.infinity,
                              child: productDataController
                                      .modelCouponCode.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          getVerSpace(20.h),
                                          getCustomFont(
                                                  S.of(context).haveACouponCode,
                                                  16.sp,
                                                  regularBlack,
                                                  1,
                                                  fontWeight: FontWeight.w400)
                                              .paddingSymmetric(
                                                  horizontal: 20.h),
                                          getVerSpace(8.h),
                                          Form(
                                            key: formkey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: couponCode,
                                                    validator: (value) {
                                                      String? error = "";
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        error = S
                                                            .of(context)
                                                            .pleaseEnterCouponCode;
                                                      } else {
                                                        for (int i = 0;
                                                            i <
                                                                productDataController
                                                                    .modelCouponCode
                                                                    .length;
                                                            i++) {
                                                          if (!productDataController
                                                              .modelCouponCode[
                                                                  i]!
                                                              .code
                                                              .contains(value
                                                                  .toString())) {
                                                            error = S
                                                                .of(context)
                                                                .pleaseEnterValidCouponCode;
                                                          } else {
                                                            error = null;
                                                            break;
                                                          }
                                                        }
                                                      }

                                                      return error;
                                                    },
                                                    decoration: InputDecoration(
                                                        errorStyle: TextStyle(
                                                            color: redColor,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: Constant
                                                                .fontsFamily),
                                                        hintText: S
                                                            .of(context)
                                                            .enterHere,
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.h),
                                                          borderSide:
                                                              BorderSide(
                                                            color: redColor,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.h),
                                                          borderSide:
                                                              BorderSide(
                                                            color: redColor,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        disabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    16.h),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    tabbarBackground)),
                                                        hintStyle: TextStyle(
                                                            fontFamily: Constant
                                                                .fontsFamily,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: darkGray),
                                                        contentPadding:
                                                            EdgeInsetsDirectional.only(
                                                                start: 16.h),
                                                        filled: true,
                                                        prefixIcon: SizedBox(
                                                            height: 56.h,
                                                            width: 16.h),
                                                        prefixIconConstraints:
                                                            BoxConstraints(
                                                                minWidth: 16.h,
                                                                minHeight: 56.h,
                                                                maxHeight: 56.h,
                                                                maxWidth: 16.h),
                                                        fillColor:
                                                            tabbarBackground,
                                                        border: InputBorder.none,
                                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.h), borderSide: BorderSide(color: tabbarBackground)),
                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.h), borderSide: BorderSide(color: tabbarBackground))),
                                                  ),
                                                ),
                                                getHorSpace(8.h),
                                                Obx(
                                                  () => getCustomButton(
                                                    S.of(context).apply,
                                                    child: couponsController
                                                        .isApplyCouponProcess
                                                        .value,
                                                    () async {
                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        // context.loaderOverlay
                                                        //     .show();
                                                        couponsController
                                                            .isApplyCouponProcess
                                                            .value = true;
                                                        CouponLines coupon =
                                                            CouponLines(
                                                                code: controller
                                                                    .inputCoupon
                                                                    .value);
                                                        controller
                                                            .changeInputCoupon(
                                                                couponCode
                                                                    .text);
                                                        controller
                                                            .addCoupon(coupon);

                                                        if (homeMainScreenController
                                                            .checkNullOperator()) {
                                                          return;
                                                        }
                                                        var promoPrice =
                                                            await homeMainScreenController
                                                                .wooCommerce1!
                                                                .retrieveCoupon(
                                                                    controller
                                                                        .inputCoupon
                                                                        .value,
                                                                    controller
                                                                        .cartOtherInfoList);
                                                        showCustomToast(
                                                            "Apply ${cartControllerNew.inputCoupon} Coupon Successfully");
                                                        if (promoPrice > 0.0) {
                                                          controller
                                                              .updatePrice(
                                                                  promoPrice);
                                                          controller
                                                              .changeCoupon(
                                                                  true);
                                                          // onTapArrowleft10();
                                                          // context.loaderOverlay
                                                          //     .hide();
                                                          couponsController
                                                              .isApplyCouponProcess
                                                              .value = false;
                                                        } else {
                                                          // context.loaderOverlay
                                                          //     .hide();
                                                          couponsController
                                                              .isApplyCouponProcess
                                                              .value = false;
                                                        }
                                                        Get.back();
                                                      }
                                                    },
                                                    buttonheight: 56.h,
                                                    decoration: ButtonStyle(
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                0),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                buttonColor),
                                                        maximumSize:
                                                            MaterialStatePropertyAll(
                                                          Size(107.h, 56.h),
                                                        ),
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.h)))),
                                                  ),
                                                )
                                              ],
                                            ).paddingSymmetric(
                                                horizontal: 20.h),
                                          ),
                                          getVerSpace(40.h),
                                          getCustomFont(S.of(context).promocode,
                                                  15.sp, darkGray, 1,
                                                  fontWeight: FontWeight.w500)
                                              .paddingSymmetric(
                                                  horizontal: 20.h),
                                          getVerSpace(8.h),
                                          ObxValue<RxBool>((p0) {
                                            if (!p0.value &&
                                                productDataController
                                                    .modelCouponCode
                                                    .isNotEmpty) {
                                              return Expanded(
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                          height: 16.h);
                                                    },
                                                    itemCount:
                                                        productDataController
                                                            .modelCouponCode
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final coupon =
                                                          productDataController
                                                                  .modelCouponCode[
                                                              index];
                                                      return CouponItemWidget(
                                                          coupon);
                                                    }),
                                              );
                                            } else {
                                              return Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      getSvgImage(
                                                          "coupon_icon.svg",
                                                          height: 93.h,
                                                          width: 129.h),
                                                      getVerSpace(32.h),
                                                      getCustomFont(
                                                          S
                                                              .of(context)
                                                              .noCouponAvailable,
                                                          28.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      getVerSpace(8.h),
                                                      Container(
                                                          width: 284.h,
                                                          child: getMultilineCustomFont(
                                                              S
                                                                  .of(context)
                                                                  .butDontWorryYouStillGetToEnjoyTheBest,
                                                              16.sp,
                                                              regularBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center))
                                                    ],
                                                  ));
                                            }
                                          },
                                              productDataController
                                                  .isCouponLoading),
                                        ])
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getSvgImage(Constant.emptyCoupanIcon,
                                            height: 93.h, width: 129.h),
                                        getVerSpace(32.h),
                                        getCustomFont(
                                            S.of(context).noCouponAvailable,
                                            28.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w700),
                                        getVerSpace(8.h),
                                        Container(
                                            width: 284.h,
                                            child: getMultilineCustomFont(
                                                S
                                                    .of(context)
                                                    .butDontWorryYouStillGetToEnjoyTheBest,
                                                16.sp,
                                                regularBlack,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.center))
                                      ],
                                    ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CouponItemWidget(RetrieveCoupon? coupon) {
    return GetBuilder<CartControllerNew>(
      init: CartControllerNew(),
      builder: (controller) => GestureDetector(
        onTap: () {
          controller.changeInputCoupon(coupon.code);

          controller.couponCodeController.text = coupon.code.toString();
        },
        child: Container(
          decoration: BoxDecoration(
              border: controller.inputCoupon.value == coupon!.code
                  ? Border.all(color: buttonColor, width: 1.h)
                  : null,
              borderRadius: BorderRadius.circular(12.h),
              color: bgColor),
          child: Row(
            children: [
              getCustomFont(coupon.code, 15.sp, regularBlack, 1,
                  fontWeight: FontWeight.w500),
              getHorSpace(7.h),
              Tooltip(
                  message: coupon.description,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: Duration(seconds: 4),
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getSvgImage("question_mark_rounded.svg"))
            ],
          ).paddingSymmetric(horizontal: 20.h, vertical: 23.h),
        ).paddingSymmetric(horizontal: 20.h),
      ),
    );
  }
}
