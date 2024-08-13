// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/woocommerce/models/product_review.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../generated/l10n.dart';
import '../../../model/product_review.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/model_order.dart';
import '../../../woocommerce/models/product_variation.dart';
import '../../../woocommerce/models/products.dart';
import '../../../woocommerce/models/woo_get_created_order.dart';

class TrackOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackOrder();
  }
}

class _TrackOrder extends State<TrackOrder>
    with SingleTickerProviderStateMixin {
  backClick(BuildContext context) {
    backToPrev(context);
  }

  var argument = Get.arguments;
  WooGetCreatedOrder? orderModel;
  HomeMainScreenController productDataController =
      Get.find<HomeMainScreenController>();
  ProductDataController controller = Get.find<ProductDataController>();
  List<ModelOrderNote> orderNoteList = [];

  // HomeMainScreenController homeController =
  //     Get.find<HomeMainScreenController>();
  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  List<ModelReviewProduct> productReviewList = [];
  List<double> reviewList = [];
  RxBool shippingMthLoaded = false.obs;
  String? date;
  String? time;
  TextEditingController cancelController = TextEditingController();
  late AnimationController animationController;
  int dialogSecond = 300;

  Future<void> fetchData() async {
    if (orderModel == null) {
      orderModel = argument;
      DateTime dateTime = DateTime.parse(orderModel!.dateCreated ?? "");
      date = DateFormat("dd-MMM-yyyy").format(dateTime);
      time = DateFormat("hh:mm a").format(dateTime);
    }

    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    final response = await homeMainScreenController.api1!
        .getWithout("orders/${argument!.id}");

    orderModel = WooGetCreatedOrder.fromJson(response);
    DateTime dateTime = DateTime.parse(orderModel!.dateCreated ?? "");
    date = DateFormat("dd-MMM-yyyy").format(dateTime);
    time = DateFormat("hh:mm a").format(dateTime);
  }

  setFetchData() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    final response = await homeMainScreenController.api1!
        .getWithout("orders/${argument!.id}");
    setState(() {
      if (orderModel == null) {
        orderModel = argument;
      } else {
        orderModel = WooGetCreatedOrder.fromJson(response);
      }
    });
  }

  Future<List<ModelReviewProduct>> getReviewList() async {
    if (productDataController.checkNullOperator()) {
      return [];
    }

    var result = await productDataController.wooCommerce1!
        .getProductReviewByProductId(
            productId: 1, wooCommerceAPI: homeMainScreenController.api1!);
    return result;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<WooProductReview?> getReviewListUpdate(productReview) async {
    if (productDataController.checkNullOperator()) {
      return null;
    }

    var result = await productDataController.wooCommerce1!
        .updateProductReview(productReview: productReview);
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = Duration(milliseconds: dialogSecond);
    animationController.reverseDuration = Duration(milliseconds: dialogSecond);
    getReviewList().then((value) {
      productReviewList = value
          .where((element) =>
              element.reviewerEmail ==
              productDataController.currentCustomer!.email)
          .toList();
      productReviewList.forEach((element) {});
    });

    getShippingMethods();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);

    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: regularWhite,
            body: SafeArea(
              child: Container(
                  color: bgColor,
                  child: Column(
                    children: [
                      Container(
                        color: regularWhite,
                        child:
                            getAppBar(S.of(context).orderDetail, function: () {
                          // backClick(context);
                          backClick(context);
                        }, space: 105.h),
                      ),
                      Expanded(
                        flex: 1,
                        child: SmartRefresher(
                          onRefresh: () {
                            setFetchData();
                            getReviewList().then((value) {
                              productReviewList = value
                                  .where((element) =>
                                      element.reviewerEmail ==
                                      productDataController
                                          .currentCustomer!.email)
                                  .toList();
                              productReviewList.forEach((element) {});
                            });

                            getShippingMethods();
                            _refreshController.refreshCompleted();
                          },
                          controller: _refreshController,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              getVerSpace(12.h),
                              Container(
                                color: regularWhite,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomFont(
                                            "${S.of(context).orderId} ${orderModel!.id}",
                                            16.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w600),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(37.h),
                                              color:
                                                  Constant.getOrderStatusColor(
                                                          orderModel!.status ??
                                                              "",
                                                          context)
                                                      .withOpacity(0.14)),
                                          child: getCustomFont(
                                                  orderModel!.status![0]
                                                          .toUpperCase() +
                                                      orderModel!.status!
                                                          .substring(1),
                                                  16.sp,
                                                  Constant.getOrderStatusColor(
                                                      orderModel!.status ?? "",
                                                      context),
                                                  1,
                                                  fontWeight: FontWeight.w600)
                                              .paddingSymmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.h),
                                        ),
                                      ],
                                    ),
                                    getVerSpace(8.h),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10.h,
                                          width: 10.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: buttonColor),
                                        ),
                                        getHorSpace(8.h),
                                        getCustomFont(
                                            "${S.of(context).orderAt} ${time} | ${date}",
                                            16.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w400)
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(
                                    horizontal: 20.h, vertical: 10.h),
                              ),
                              getVerSpace(16.h),
                              ListView.separated(
                                separatorBuilder: (context, index) {
                                  return getVerSpace(8.h);
                                },
                                itemBuilder: (context, index) {
                                  LineItem lineItem =
                                      orderModel!.lineItems![index];

                                  if (productDataController
                                      .checkNullOperator()) {
                                    return Container();
                                  }
                                  return FutureBuilder<WooProduct>(
                                    future: productDataController.wooCommerce1!
                                        .getYouProduct(
                                            id: lineItem.productId!,
                                            wooCommerceAPI:
                                                homeMainScreenController.api1!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        WooProduct product = snapshot.data!;

                                        for (var element in productReviewList) {
                                          if (product.id == element.productId) {
                                            reviewList.add(double.parse(
                                                element.rating.toString()));
                                          }
                                        }
                                        if (productDataController
                                            .checkNullOperator()) {
                                          return Container();
                                        }

                                        return FutureBuilder<
                                            WooProductVariation>(
                                          future: productDataController
                                              .wooCommerce1!
                                              .getProductVariationById(
                                                  productId:
                                                      lineItem.productId!,
                                                  variationId:
                                                      lineItem.variationId!,
                                                  wooCommerceAPI:
                                                      homeMainScreenController
                                                          .api1!),
                                          builder: (context, snapshot) {
                                            WooProductVariation? variation;
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              variation = snapshot.data!;
                                            }
                                            return GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.h,
                                                    vertical: 20.h),
                                                width: double.infinity,
                                                color: regularWhite,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            height: 88.h,
                                                            width: 88.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.h),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(16
                                                                            .h),
                                                                border: Border.all(
                                                                    color:
                                                                        black20),
                                                                color:
                                                                    regularWhite),
                                                            child:
                                                                Image.network(
                                                              product.images[0]
                                                                  .src,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                            )),
                                                        getHorSpace(23.h),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              getCustomFont(
                                                                  product.name,
                                                                  16.sp,
                                                                  regularBlack,
                                                                  1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              getVerSpace(4.h),
                                                              getCustomFont(
                                                                  "${getCurrency(context)}${lineItem.subtotal ?? ""}",
                                                                  14.sp,
                                                                  regularBlack,
                                                                  1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              getVerSpace(18.h),
                                                              Container(
                                                                height: 21.h,
                                                                child: Center(
                                                                  child: Row(
                                                                    children: [
                                                                      variation !=
                                                                              null
                                                                          ? Container(
                                                                              margin: EdgeInsetsDirectional.only(bottom: 0.h),
                                                                              height: 22.h,
                                                                              child: ListView.builder(
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemCount: variation.attributes!.length,
                                                                                itemBuilder: (context, index) {
                                                                                  return Container(
                                                                                    padding: EdgeInsetsDirectional.only(start: (index == 0) ? 0.h : 10.h, end: (index == variation!.attributes!.length - 1) ? 0.h : 10.h),
                                                                                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: (index == variation.attributes!.length - 1) ? Colors.transparent : Colors.grey.shade300))),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        getCustomFont("${variation.attributes![index].name!}:  ", 14.sp, darkGray, 1, fontWeight: FontWeight.w500),
                                                                                        getCustomFont("${variation.attributes![index].option!}", 14.sp, regularBlack, 1, fontWeight: FontWeight.w400),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            )
                                                                          : 0
                                                                              .h
                                                                              .verticalSpace,
                                                                      variation !=
                                                                              null
                                                                          ? getHorSpace(
                                                                              15.h)
                                                                          : SizedBox(),
                                                                      getCustomFont(
                                                                          "${S.of(context).qty} ${lineItem.quantity}",
                                                                          14.sp,
                                                                          darkGray,
                                                                          1,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    orderModel!.status ==
                                                            'completed'
                                                        // 'completed'
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  RatingBar
                                                                      .builder(
                                                                    initialRating: productReviewList
                                                                            .where((element) =>
                                                                                element.productId ==
                                                                                product
                                                                                    .id)
                                                                            .isEmpty
                                                                        ? 0
                                                                        : productReviewList[productReviewList.indexWhere((element) =>
                                                                                element.productId ==
                                                                                product.id)]
                                                                            .rating!
                                                                            .toDouble(),
                                                                    minRating:
                                                                        0,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        false,
                                                                    itemCount:
                                                                        5,
                                                                    ignoreGestures: productReviewList
                                                                            .where((element) =>
                                                                                element.productId ==
                                                                                product.id)
                                                                            .isEmpty
                                                                        ? false
                                                                        : true,
                                                                    itemSize:
                                                                        20.h,
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    unratedColor:
                                                                        '#DCDCDC'
                                                                            .toColor(),
                                                                    onRatingUpdate:
                                                                        (rating) {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .reviewOrderRoute,
                                                                          arguments: [
                                                                            product,
                                                                            rating,
                                                                            orderModel
                                                                          ]);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ).paddingOnly(
                                                            top: 24.h)
                                                        : Container()
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return 0.horizontalSpace;
                                      }
                                    },
                                  );
                                },
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderModel!.lineItems!.length,
                              ),
                              getVerSpace(16.h),
                              orderModel!.billing == null
                                  ? SizedBox()
                                  : Container(
                                      width: double.infinity,
                                      color: regularWhite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getCustomFont(
                                              S.of(context).billingAddress,
                                              20.h,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w700),
                                          getVerSpace(16.h),
                                          getCustomFont(
                                              orderModel!.shipping!.city!,
                                              16.sp,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w600),
                                          getVerSpace(5.h),
                                          getMultilineCustomFont(
                                              "${orderModel!.billing!.address1!} ${orderModel!.billing!.address2!}, ${orderModel!.billing!.city!}, ${orderModel!.billing!.state!}, ${orderModel!.billing!.country!}, ${orderModel!.billing!.postcode!}",
                                              14.sp,
                                              regularBlack,
                                              fontWeight: FontWeight.w400),
                                          getVerSpace(16.h),
                                          getCustomFont(
                                              "${S.of(context).paymentMode} ${orderModel!.paymentMethod == "cod" ? "Cash on delivery" : orderModel!.paymentMethod}",
                                              16.sp,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w600),
                                        ],
                                      ).paddingAll(20.h)),
                              getVerSpace(16.h),
                              orderModel!.shipping!.address1!.isEmpty
                                  ? SizedBox()
                                  : Container(
                                      width: double.infinity,
                                      color: regularWhite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getCustomFont(
                                              S.of(context).shippingAddress,
                                              20.h,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w700),
                                          getVerSpace(16.h),
                                          getCustomFont(
                                              orderModel!.shipping!.city!,
                                              16.sp,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w600),
                                          getVerSpace(5.h),
                                          getMultilineCustomFont(
                                              "${orderModel!.shipping!.address1!} ${orderModel!.shipping!.address2!}, ${orderModel!.shipping!.city!}, ${orderModel!.shipping!.state!}, ${orderModel!.shipping!.country!}, ${orderModel!.shipping!.postcode!}",
                                              14.sp,
                                              regularBlack,
                                              fontWeight: FontWeight.w400),
                                        ],
                                      ).paddingAll(20.h)),
                              if (orderModel!.status == 'completed' ||
                                  orderModel!.status == 'cancelled' ||
                                  orderModel!.status == 'processing')
                                SizedBox()
                              else
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        transitionAnimationController:
                                            animationController,
                                        isScrollControlled: true,
                                        backgroundColor: regularWhite,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16.h))),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: regularWhite,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              16.h))),
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  10.h.verticalSpace,
                                                  Container(
                                                    height: 4.h,
                                                    width: 48.h,
                                                    decoration: BoxDecoration(
                                                        color: '#1A12121D'
                                                            .toColor(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.h)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                                start: 20.h,
                                                                top: 20.h,
                                                                end: 20.h),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        getCustomFont(
                                                            S
                                                                .of(context)
                                                                .cancelingOrder,
                                                            20.sp,
                                                            regularBlack,
                                                            1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            child: getSvgImage(
                                                                "close.svg",
                                                                width: 24.h,
                                                                height: 24.h))
                                                      ],
                                                    ),
                                                  ),
                                                  35.h.verticalSpace,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.h),
                                                    child: TextFormField(
                                                      cursorColor: buttonColor,
                                                      controller:
                                                          cancelController,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      12.h))),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      12.h),
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      regularBlack,
                                                                  width: 1.h)),
                                                          contentPadding:
                                                              EdgeInsetsDirectional.only(
                                                                  start: 16.h,
                                                                  top: 16.h),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(12.h),
                                                                  borderSide: BorderSide(color: Color(0XFFDFDFDF), width: 1.h)),
                                                          hintText: S.of(context).enterReasonForCancelOrderOptional,
                                                          hintStyle: TextStyle(color: Color(0XFF6E758A), fontSize: 16.sp, fontFamily: Constant.fontsFamily)),
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  35.h.verticalSpace,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.h),
                                                    child: getCustomButton(
                                                        S
                                                            .of(context)
                                                            .cancelOrder,
                                                        () async {
                                                      String status =
                                                          'cancelled';
                                                      context.loaderOverlay.show(

                                                              showOverlay:  getProgressDialog());

                                                      if (productDataController
                                                          .checkNullOperator()) {
                                                        return;
                                                      }

                                                      await productDataController
                                                          .wooCommerce1!
                                                          .updateOrderStatus(
                                                              id: argument!.id!,
                                                              status: status,
                                                              reason:
                                                                  cancelController
                                                                      .text);
                                                      clearMyOrderCacheCache();
                                                      context.loaderOverlay
                                                          .hide();

                                                      Get.toNamed(
                                                          Routes.myOrderRoute);
                                                    },
                                                        buttonwidth:
                                                            double.infinity,
                                                        buttonheight: 56.h),
                                                  ),
                                                  35.h.verticalSpace,
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    color: regularWhite,
                                    child: Center(
                                      child: getCustomFont(
                                              S.of(context).cancelOrder,
                                              16.sp,
                                              Color(0XFFFF3E3E),
                                              1,
                                              fontWeight: FontWeight.w700)
                                          .paddingAll(20.h),
                                    ),
                                  ),
                                ),
                              orderModel!.status == 'cancelled' ||
                                      orderModel!.status == 'completed'
                                  ? getVerSpace(0.h)
                                  : getVerSpace(16.h),
                              Container(
                                color: regularWhite,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont(S.of(context).paymentSummary,
                                        20.sp, regularBlack, 1,
                                        fontWeight: FontWeight.w700),
                                    Padding(
                                        padding: EdgeInsets.only(top: 16.h),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              getCustomFont(
                                                  S.of(context).subTotal,
                                                  16.sp,
                                                  regularBlack,
                                                  1,
                                                  fontWeight: FontWeight.w400),
                                              getCustomFont(
                                                  formatStringCurrency(
                                                      total: getSubTotal(
                                                          argument!.lineItems!),
                                                      context: context),
                                                  16.sp,
                                                  regularBlack,
                                                  1,
                                                  fontWeight: FontWeight.w400),
                                            ])),
                                    getVerSpace(12.h),
                                    getDivider(
                                        color: black20,
                                        horPadding: 0.h,
                                        height: 0),
                                    GetBuilder<CartControllerNew>(
                                      init: CartControllerNew(),
                                      builder: (controller) => Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                getCustomFont(
                                                    S.of(context).discount,
                                                    16.sp,
                                                    regularBlack,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                getCustomFont(
                                                    "-${formatStringCurrency(total: orderModel!.discountTotal.toString(), context: context)}",
                                                    16.sp,
                                                    Color(0XFF089A16),
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ])),
                                    ),
                                    getVerSpace(8.h),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          getCustomFont(S.of(context).tax,
                                              16.sp, regularBlack, 1,
                                              fontWeight: FontWeight.w400),
                                          GetBuilder<HomeScreenController>(
                                            init: HomeScreenController(),
                                            builder: (homeScreen) =>
                                                getCustomFont(
                                                    formatStringCurrency(
                                                        total:
                                                            argument!.totalTax,
                                                        context: context),
                                                    16.sp,
                                                    regularBlack,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          )
                                        ]),
                                    getVerSpace(12.h),
                                    Container(
                                        decoration: BoxDecoration(),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GetBuilder<HomeScreenController>(
                                                init: HomeScreenController(),
                                                builder: (controller) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    getCustomFont(
                                                        S.of(context).shipping,
                                                        16.sp,
                                                        regularBlack,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    getCustomFont(
                                                        "+${formatStringCurrency(total: orderModel!.shippingTotal, context: context)}",
                                                        16.sp,
                                                        regularBlack,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w400)
                                                  ],
                                                ),
                                              ),
                                            ])),
                                    getVerSpace(12.h),
                                    getDivider(
                                        color: black20,
                                        horPadding: 0.h,
                                        height: 0),
                                    GetBuilder<CartControllerNew>(
                                      init: CartControllerNew(),
                                      builder: (controller) => Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                getCustomFont(
                                                    S
                                                        .of(context)
                                                        .totalPaymentAmount,
                                                    16.sp,
                                                    regularBlack,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                GetBuilder<
                                                    HomeScreenController>(
                                                  init: HomeScreenController(),
                                                  builder: (homeScreen) =>
                                                      getCustomFont(
                                                          formatStringCurrency(
                                                              total: argument!
                                                                  .total
                                                                  .toString(),
                                                              context: context),
                                                          16.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ])),
                                    ),
                                  ],
                                ).paddingSymmetric(
                                    vertical: 20.h, horizontal: 20.h),
                              ),
                              getVerSpace(16.h),
                              getVerSpace(20.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          onWillPop: () async {
            backClick(context);
            return false;
          }),
    );
  }

  String getSubTotal(List<LineItem> lineItem) {
    return productDataController.cartTotalPriceF(lineItem).toString();
  }

  getShippingMethods() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }

    String zoneId = await controller.getShippingMethodZoneId(
        homeMainScreenController.wooCommerce1!, orderModel!.shipping!.country!,
        state: orderModel!.shipping!.state!,
        city: orderModel!.shipping!.city!,
        pincode: orderModel!.shipping!.postcode!);

    homeScreenController.changeMethod(
        await homeMainScreenController.wooCommerce1!.getAllShippingMethods(
            zoneId,
            homeMainScreenController.wooCommerce1!,
            orderModel!.shipping!.postcode!));

    shippingMthLoaded.value = true;
  }

  Row buildSubtotalRow(BuildContext context, String title, String total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCustomFont(
          title,
          14.sp,
          regularBlack,
          1,
          fontWeight: FontWeight.w400,
        ),
        getCustomFont(
          total,
          14,
          regularBlack,
          1,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Row buildTotalRow(BuildContext context, String title, String total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCustomFont(
          title,
          17,
          regularBlack,
          1,
          fontWeight: FontWeight.w600,
        ),
        getCustomFont(
          total,
          17,
          regularBlack,
          1,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
