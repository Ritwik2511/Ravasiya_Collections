// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/model/my_cart_data.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';

import '../../../generated/l10n.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/model_shipping_method.dart';
import '../../../woocommerce/models/model_tax.dart';
import '../../../woocommerce/models/order_create_model.dart';
import '../../../woocommerce/models/products.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  RxList<String> favProductList = <String>[].obs;

  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  ProductDataController productController = Get.put(ProductDataController());

  StorageController storageControllersecond = Get.put(StorageController());
  ProductDataController productDataController =
      Get.put(ProductDataController());
  TextEditingController couponCodeController = TextEditingController();
  Rx<ModelShippingMethod?> selectedShippingMethod = (null).obs;
  Rx<ModelTax?> taxModel = (null).obs;

  RxInt cartIndex = 0.obs;
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());

  LoginEmptyStateController loginController =
      Get.put(LoginEmptyStateController());

  final formkey = GlobalKey<FormState>();

  RxDouble tax = 0.0.obs;
  List<ModelTax> taxList = [];

  var one = Get.arguments ?? false;

  getOnlineCart() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    var result = await homeMainScreenController.wooCommerce1!.getMyCartItems();
    result.forEach((element) {
      if (element.variation!.isEmpty) {
        homeMainScreenController.wooCommerce1!
            .getProductDetail(id: element.id)
            .then((value) {
          cartControllerNew.addItemInfo(CartOtherInfo(
              variationId: 0,
              productId: element.id,
              type: "type",
              productName: element.name,
              productImage: element.images![0].src,
              productPrice: parseWcPrice(
                  (double.parse(element.prices!.regularPrice.toString()) / 100)
                      .round()
                      .toString()),
              variationList: [],
              quantity: element.quantity,
              stockStatus: value.stockStatus,
              taxClass: value.taxClass));
        });
      }
    });
    PrefData.setFirstLoad(true);
  }

  getTaxRates(List<CartOtherInfo> cartOtherInfoList) {
    tax.value = 0.0;
    cartOtherInfoList.forEach((element) async {
      taxList = productDataController.taxList;
      if (taxList.isNotEmpty) {
        for (int i = 0; i < taxList.length; i++) {
          if (element.taxClass == TaxClass.EMPTY) {
            if (taxList[i].modelTaxClass == null) {
              tax.value = tax.value +
                  (element.productPrice! *
                          double.parse(taxList[i].rate.toString()) /
                          100) *
                      element.quantity!;
            }
          }
          if (element.taxClass == taxList[i].modelTaxClass) {
            tax.value = tax.value +
                (element.productPrice! *
                        double.parse(taxList[i].rate.toString()) /
                        100) *
                    element.quantity!;
          }
        }
      }
    });
  }

  getFavourit() {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  getAllCartList() {
    PrefData.getCartList().then((value) {
      cartControllerNew.getCartList(value);
    });
  }

  getupsell() async {
    cartControllerNew.upsellProduct = [];
    final result = await PrefData.getCartList();

    if (homeMainScreenController.checkNullOperator()) {
      return;
    }

    for (var i = 0; i < result.length; i++) {
      var result = await homeMainScreenController.wooCommerce1!.getYouProduct(
          wooCommerceAPI: homeMainScreenController.api1!,
          id: cartControllerNew.cartOtherInfoList[i].productId!);

      result.upsellIds.forEach((element) async {
        var upsell = await homeMainScreenController.wooCommerce1!.getYouProduct(
            wooCommerceAPI: homeMainScreenController.api1!, id: element);

        cartControllerNew.setUpsellData(upsell);

        final ids = cartControllerNew.upsellProduct.map((e) => e.id).toSet();
        cartControllerNew.upsellProduct.retainWhere((x) => ids.remove(x.id));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    cartControllerNew.getCartItem();

    // if (homeMainScreenController.currentCustomer != null) {
    //   if (!PrefData.getFirstLoad()) {
    //     getOnlineCart();
    //   }
    // }

    if (homeMainScreenController.currentCustomer != null) {
      getAllCartList();
    } else {
      getAllCartList();
    }

    Future.delayed(Duration(milliseconds: 200), () async {
      if (homeMainScreenController.checkNullOperator()) {
        return;
      }

      if (cartControllerNew.isCouponApply.value) {
        var promoPrice = await homeMainScreenController.wooCommerce1!
            .retrieveCoupon(cartControllerNew.inputCoupon.value,
                cartControllerNew.cartOtherInfoList);
        if (promoPrice > 0.0) {
          cartControllerNew.updatePrice(promoPrice);
          cartControllerNew.changeCoupon(true);
        }
      } else {
        cartControllerNew.updatePrice(0.00);
      }
    });
    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });
    getFavourit();
    cartControllerNew.createLineItems();

    Future.delayed(Duration.zero, () {
      getupsell();
    });

    if (PrefData.getCouponCode().isEmpty) {
      return;
    }

    couponCodeController.text = PrefData.getCouponCode();

    Future.delayed(
      Duration.zero,
      () => applyCoupon(cartControllerNew, isFirst: true),
    );

    super.initState();
  }

  applyCoupon(var controller, {bool isFirst = false}) async {
    if (couponCodeController.text.isEmpty) {
      return;
    }
    bool validate = true;
    if (!isFirst) {
      validate = formkey.currentState!.validate();
    }
    if (validate) {
      if (couponCodeController.text.isNotEmpty) {
        cartControllerNew.changeInputCoupon(couponCodeController.text);
        controller.couponCodeController.text =
            couponCodeController.text.toString();
        // context.loaderOverlay.show(widget: getProgressDialog());
        productDataController.isApplyCouponProcess.value = true;
        CouponLines coupon = CouponLines(code: controller.inputCoupon.value);
        controller.addCoupon(coupon);
        if (homeMainScreenController.checkNullOperator()) {
          return;
        }

        var promoPrice = await homeMainScreenController.wooCommerce1!
            .retrieveCoupon(
                controller.inputCoupon.value, controller.cartOtherInfoList);
        showCustomToast(
            "Apply ${cartControllerNew.inputCoupon} Coupon Successfully");
        if (promoPrice > 0.0) {
          controller.updatePrice(promoPrice);
          controller.changeCoupon(true);
          productDataController.isApplyCouponProcess.value = false;
          // context.loaderOverlay.hide();
        } else {
          // context.loaderOverlay.hide();
          productDataController.isApplyCouponProcess.value = false;
        }
      }
    }
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  @override
  Widget build(BuildContext context) {
    if (!homeMainScreenController.checkNullOperator()) {
      productDataController.getAllPostsList(homeMainScreenController.api1!);
      if (productController.newArriveProductList.isEmpty) {
        productController
            .getNewArrivalProductList(homeMainScreenController.api1!);
      }
    }

    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          if (one) {
            Get.back();
          } else {
            // Get.back();
            Get.back();
          }

          return Future.value(true);
        },
        child: Scaffold(
            backgroundColor: regularWhite,
            body: SafeArea(
                child: Container(
              color: bgColor,
              child: GetBuilder<ToyDetailScreenController>(
                init: ToyDetailScreenController(),
                builder: (toyDetailScreenController) =>
                    GetBuilder<CartControllerNew>(
                  init: CartControllerNew(),
                  builder: (controller) => FutureBuilder<List<CartOtherInfo>>(
                    future: PrefData.getCartList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Stack(
                            children: [
                              Container(
                                color: regularWhite,
                                child: getAppBar(
                                  S.of(context).cart,
                                  function: () {
                                    if (one) {
                                      Get.back();
                                    } else {
                                      Get.back();
                                      Get.back();
                                    }
                                  },
                                ),
                              ),
                              Center(
                                child: getEmptyWidget(
                                    context,
                                    Constant.cartEmptyLogo,
                                    S.of(context).yourCartIsCurrentlyEmpty,
                                    S
                                        .of(context)
                                        .mustAddItemsOnTheCartBeforeYouProceedTo,
                                    S.of(context).addProduct, () {
                                  homeMainScreenController.change(0);
                                  homeMainScreenController.tabController!
                                      .animateTo(
                                    0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                  Get.toNamed(Routes.homeMainRoute);
                                }).paddingSymmetric(horizontal: 20.h),
                              ),
                            ],
                          );
                        } else {
                          getTaxRates(controller.cartOtherInfoList);
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    color: regularWhite,
                                    child: getAppBar(
                                      S.of(context).cart,
                                      function: () {
                                        Get.back();
                                        // Get.back();
                                      },
                                    ),
                                  ),
                                  getVerSpace(12.h),
                                  Expanded(
                                    flex: 1,
                                    child: ListView(
                                      children: [
                                        Container(
                                          color: regularWhite,
                                          width: double.infinity,
                                          child: Stack(
                                            alignment: Alignment(0,-0.35),
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      getSvgImage(Constant.myCartProcessIconFill)
                                                          .paddingSymmetric(
                                                          horizontal: 20.h,
                                                          vertical: 14.h),
                                                      getVerSpace(5.h),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          getCustomFont(
                                                            S.of(context).myCart,
                                                            14.sp,
                                                            regularBlack,
                                                            1,
                                                            fontWeight:
                                                            FontWeight.w400,),

                                                        ],
                                                      ),
                                                      getVerSpace(14.h),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      getSvgImage(Constant.paymentProcessIconUnFill)
                                                          .paddingSymmetric(
                                                          horizontal: 20.h,
                                                          vertical: 14.h),
                                                      getVerSpace(5.h),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          getCustomFont(
                                                            S.of(context).payment,
                                                            14.sp,
                                                            Color(0xFF696969),
                                                            1,
                                                            fontWeight:
                                                            FontWeight.w400,),

                                                        ],
                                                      ),
                                                      getVerSpace(14.h),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              getSvgImage(Constant.line),
                                            ],
                                          ),
                                        ),
                                        getVerSpace(16.h),
                                        ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) {
                                              return 8.h.verticalSpace;
                                            },
                                            itemCount: controller
                                                .cartOtherInfoList.length,
                                            itemBuilder: (context, index) {
                                              CartOtherInfo cartInfo =
                                                  controller
                                                      .cartOtherInfoList[index];

                                              return getCartDetailFormateNew(
                                                  cartInfo.productImage!,
                                                  cartInfo.productName!,
                                                  cartInfo.productPrice!
                                                      .toString(),
                                                  cartInfo.quantity!, () async {
                                                if (cartInfo.quantity! > 1) {
                                                  controller
                                                      .decreaseQuantity(index);
                                                }
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                    getAllCartList();
                                                  },
                                                );
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () async {
                                                  if (controller
                                                      .isCouponApply.value) {
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
                                                    if (promoPrice > 0.0) {
                                                      controller.updatePrice(
                                                          promoPrice);
                                                      controller
                                                          .changeCoupon(true);
                                                    }
                                                  }
                                                });
                                              }, () {
                                                controller
                                                    .increaseQuantity(index);
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                    getAllCartList();
                                                  },
                                                );
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () async {
                                                  if (controller
                                                      .isCouponApply.value) {
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
                                                    if (promoPrice > 0.0) {
                                                      controller.updatePrice(
                                                          promoPrice);
                                                      controller
                                                          .changeCoupon(true);
                                                    }
                                                  }
                                                });
                                              }, () {
                                                cartControllerNew
                                                    .removeItemInfo(
                                                        controller
                                                            .cartOtherInfoList[
                                                                index]
                                                            .productName
                                                            .toString(),
                                                        controller
                                                            .cartOtherInfoList[
                                                                index]
                                                            .variationId!);
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                    getAllCartList();
                                                  },
                                                );
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () async {
                                                  if (controller
                                                      .isCouponApply.value) {
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
                                                    if (promoPrice > 0.0) {
                                                      controller.updatePrice(
                                                          promoPrice);
                                                      controller
                                                          .changeCoupon(true);
                                                    }
                                                  }
                                                });
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                    if (controller
                                                        .cartOtherInfoList
                                                        .isEmpty) {
                                                      controller
                                                          .changeInputCoupon(
                                                              "");
                                                    }
                                                  },
                                                );
                                                controller.coupon.clear();
                                                Future.delayed(
                                                  Duration.zero,
                                                  () {
                                                    getupsell();
                                                  },
                                                );
                                                Get.back();
                                              }, context,
                                                  widget:
                                                      cartInfo.variationList !=
                                                                  null &&
                                                              cartInfo
                                                                  .variationList!
                                                                  .isNotEmpty
                                                          ? ListView.builder(
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount: cartInfo
                                                                  .variationList!
                                                                  .length,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                          end: 12
                                                                              .h),
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return getCustomFont(
                                                                    "${cartInfo.variationList![index]!.name!}: ${cartInfo.variationList![index]!.option!}",
                                                                    14.sp,
                                                                    Color(
                                                                        0XFF808080),
                                                                    1,
                                                                    txtHeight:
                                                                        1.5.h,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500);
                                                              },
                                                            )
                                                          : SizedBox());
                                            }),
                                        controller.upsellProduct.isEmpty
                                            ? getVerSpace(0.h)
                                            : getVerSpace(16.h),
                                        controller.upsellProduct.isEmpty
                                            ? SizedBox()
                                            : Container(
                                                width: double.infinity,
                                                color: regularWhite,
                                                child: Column(
                                                  children: [
                                                    getVerSpace(20.h),
                                                    ObxValue<RxBool>((p0) {
                                                      if (!p0.value &&
                                                          productController
                                                              .newArriveProductList
                                                              .isNotEmpty) {
                                                        List<WooProduct>
                                                            bestSellingList =
                                                            controller
                                                                .upsellProduct;

                                                        return Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                getCustomFont(
                                                                    S
                                                                        .of(
                                                                            context)
                                                                        .theresMoreProductToTry,
                                                                    20.sp,
                                                                    regularBlack,
                                                                    1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    txtHeight:
                                                                        1.5.h),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      Get.toNamed(Routes
                                                                              .upsellProductRoute)!
                                                                          .then(
                                                                              (value) {
                                                                        getFavDataList();
                                                                      });
                                                                      // Get.to(
                                                                      //     UpsellProductListScreen());
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          29.h,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              gray,
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.h)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: getCustomFont(
                                                                              S.of(context).viewAll,
                                                                              14.sp,
                                                                              darkGray,
                                                                              1,
                                                                              fontWeight: FontWeight.w400,
                                                                              txtHeight: 1.5.h,
                                                                              textAlign: TextAlign.center)
                                                                          .paddingSymmetric(horizontal: 10.h),
                                                                    ))
                                                              ],
                                                            ).paddingSymmetric(
                                                                horizontal:
                                                                    20.h),
                                                            getVerSpace(20.h),
                                                            controller
                                                                    .upsellProduct
                                                                    .isEmpty
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                    color:
                                                                        buttonColor,
                                                                  ))
                                                                : Container(
                                                                    height:
                                                                        280.h,
                                                                    child: ListView
                                                                        .builder(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.h),
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      itemCount: bestSellingList.length <
                                                                              3
                                                                          ? bestSellingList
                                                                              .length
                                                                          : 3,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        WooProduct
                                                                            model =
                                                                            bestSellingList[index];
                                                                        return productDataFormateInListView(context,
                                                                                () {
                                                                          homeScreenController
                                                                              .setSelectedWooProduct(model);
                                                                          homeScreenController
                                                                              .clearProductVariation();

                                                                          sendToPlanDetail(
                                                                            id: "${model.id}",
                                                                              tag: "There’s more product to try!${index}${model.images[0].src}",
                                                                              function: () {
                                                                                getFavDataList();
                                                                              });
                                                                        },
                                                                                model,
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    checkInFavouriteList(model);
                                                                                    List<String> strList = favProductList.map((i) => i.toString()).toList();
                                                                                    PrefData().setFavouriteList(strList);
                                                                                    getFavourit();
                                                                                  },
                                                                                  child: Obx(
                                                                                    () {
                                                                                      return getSvgImage(favProductList.contains(model.id.toString()) ? "likefillIconnew.svg" : "likeIconnew.svg", height: 22.h, width: 22.h).marginOnly(top: 10.h, right: 14.h, left: 15.h);
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                index,
                                                                                'There’s more product to try!',
                                                                                homeMainScreenController)
                                                                            .paddingSymmetric(horizontal: 10.h);
                                                                      },
                                                                    ),
                                                                  ),
                                                          ],
                                                        );
                                                      } else {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: buttonColor,
                                                        ));
                                                      }
                                                    },
                                                        productController
                                                            .isNewArrivalDataLoading),
                                                    getVerSpace(20.h),
                                                  ],
                                                ),
                                              ),
                                        getVerSpace(16.h),
                                        Form(
                                          key: formkey,
                                          child: Container(
                                            color: regularWhite,
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
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
                                                          cursorColor:
                                                              buttonColor,
                                                          controller:
                                                              couponCodeController,
                                                          decoration:
                                                              InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      color:
                                                                          redColor,
                                                                      fontSize: 16
                                                                          .sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          Constant
                                                                              .fontsFamily),
                                                                  filled: true,
                                                                  fillColor:
                                                                      lightGray,
                                                                  contentPadding:
                                                                      EdgeInsetsDirectional
                                                                          .only(
                                                                              start: 16
                                                                                  .h),
                                                                  hintText: S
                                                                      .of(
                                                                          context)
                                                                      .enterCouponCode,
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    color:
                                                                        black40,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.h),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          lightGray,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.h),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          redColor,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.h),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          redColor,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.h),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          lightGray,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.h),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          buttonColor,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  suffixIconConstraints: BoxConstraints(
                                                                      maxHeight:
                                                                          52.h,
                                                                      minHeight:
                                                                          52.h,
                                                                      maxWidth:
                                                                          75.h),
                                                                  suffixIcon:
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            applyCoupon(controller);
                                                                          },
                                                                          child:
                                                                              Obx(
                                                                            () =>
                                                                                Container(
                                                                              margin: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h, end: 15.h),
                                                                              width: 60.h,
                                                                              decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(7.h)),
                                                                              alignment: Alignment.center,
                                                                              child: productDataController.isApplyCouponProcess.value
                                                                                  ? SizedBox(
                                                                                height: 15.h,
                                                                                width: 15.h,
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 2.h,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              )
                                                                                  : getCustomFont(S.of(context).apply, 16.sp, regularWhite, 1, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          )))),
                                                    ),
                                                    getCustomButton(
                                                      S.of(context).viewAll,
                                                      () async {
                                                        Get.toNamed(Routes
                                                                .couponRoute)!
                                                            .then((value) {
                                                          formkey.currentState!
                                                              .reset();
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  new FocusNode());
                                                        });
                                                      },
                                                      buttonheight: 56.h,
                                                      fontSize: 16.sp,
                                                      color: regularBlack,
                                                      weight: FontWeight.w400,
                                                      decoration: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  regularWhite),
                                                          maximumSize:
                                                              MaterialStatePropertyAll(
                                                            Size(107.h, 56.h),
                                                          ),
                                                          elevation:
                                                              MaterialStatePropertyAll(
                                                                  0),
                                                          shape: MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0)))),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ).paddingSymmetric(
                                                vertical: 16.h,
                                                horizontal: 20.h),
                                            padding: EdgeInsetsDirectional.only(
                                                bottom: 12.h),
                                          ),
                                        ),
                                        getVerSpace(16.h),
                                        Container(
                                          color: regularWhite,
                                          child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                getCustomFont(
                                                        S
                                                            .of(context)
                                                            .paymentSummary,
                                                        20.sp,
                                                        regularBlack,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w700)
                                                    .paddingSymmetric(
                                                        horizontal: 20.h),
                                                getVerSpace(20.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getCustomFont(
                                                          S
                                                              .of(context)
                                                              .subTotal,
                                                          16.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      getSubTotal(controller
                                                                  .cartOtherInfoList) ==
                                                              "0.0"
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                              color:
                                                                  buttonColor,
                                                            ))
                                                          : getCustomFont(
                                                              formatStringCurrency(
                                                                  total: getSubTotal(
                                                                      controller
                                                                          .cartOtherInfoList),
                                                                  context:
                                                                      context),
                                                              16.sp,
                                                              regularBlack,
                                                              1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ],
                                                  ),
                                                ),
                                                12.h.verticalSpace,
                                                getDivider(
                                                    color: dividerColor,
                                                    height: 0),
                                                12.h.verticalSpace,
                                                Row(
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
                                                            FontWeight.w500),
                                                    getSubTotal(controller
                                                                .cartOtherInfoList) ==
                                                            "0.0"
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                            color: buttonColor,
                                                          ))
                                                        : Row(
                                                            children: [
                                                              cartControllerNew
                                                                      .isCouponApply
                                                                      .value
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        // context
                                                                        //     .loaderOverlay
                                                                        //     .show(widget: getProgressDialog());
                                                                            controller.isRemoveCouponProcess.value = true;
                                                                        CouponLines
                                                                            coupon =
                                                                            CouponLines(code: controller.inputCoupon.value);
                                                                        controller
                                                                            .removeCoupon(coupon);
                                                                        if (homeMainScreenController
                                                                            .checkNullOperator()) {
                                                                          return;
                                                                        }
                                                                        var promoPrice = await homeMainScreenController.wooCommerce1!.retrieveCoupon(
                                                                            controller.inputCoupon.value,
                                                                            controller.cartOtherInfoList);
                                                                        showCustomToast(
                                                                            "Remove ${cartControllerNew.inputCoupon} Coupon Successfully");
                                                                        if (promoPrice >
                                                                            0.0) {
                                                                          controller
                                                                              .updatePrice(promoPrice);
                                                                          controller
                                                                              .changeCoupon(false);
                                                                          controller
                                                                              .changeInputCoupon("");

                                                                          // context
                                                                          //     .loaderOverlay
                                                                          //     .hide();
                                                                          controller.isRemoveCouponProcess.value = false;
                                                                          Future.delayed(
                                                                              Duration(milliseconds: 200),
                                                                              () async {
                                                                            if (cartControllerNew.isCouponApply.value) {
                                                                              if (homeMainScreenController.checkNullOperator()) {
                                                                                return;
                                                                              }
                                                                              var promoPrice = await homeMainScreenController.wooCommerce1!.retrieveCoupon(cartControllerNew.inputCoupon.value, controller.cartOtherInfoList);
                                                                              if (promoPrice > 0.0) {
                                                                                cartControllerNew.updatePrice(promoPrice);
                                                                                cartControllerNew.changeCoupon(true);
                                                                              }
                                                                            } else {
                                                                              cartControllerNew.updatePrice(0.00);
                                                                            }
                                                                          });
                                                                        } else {
                                                                          // context
                                                                          //     .loaderOverlay
                                                                          //     .hide();
                                                                          controller.isRemoveCouponProcess.value = false;
                                                                        }
                                                                      },
                                                                      child: controller.isRemoveCouponProcess.value? SizedBox(
                                                                        height: 15.h,
                                                                        width: 15.h,
                                                                        child: CircularProgressIndicator(
                                                                          strokeWidth: 2.h,
                                                                          color: buttonColor,
                                                                        ),
                                                                      ) : getCustomFont(
                                                                          S.of(context).removeCoupon,
                                                                          16.sp,
                                                                          black40,
                                                                          1))
                                                                  : SizedBox(),
                                                              getHorSpace(10.h),
                                                              getCustomFont(
                                                                  formatStringCurrency(
                                                                      total: controller
                                                                          .promoPrice
                                                                          .toString(),
                                                                      context:
                                                                          context),
                                                                  16.sp,
                                                                  Color(
                                                                      0XFF000000),
                                                                  1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ],
                                                          ),
                                                  ],
                                                ).paddingSymmetric(
                                                    horizontal: 20.h),
                                                getVerSpace(8.h),
                                                Obx(
                                                  () => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getCustomFont(
                                                          "Tax ${(taxModel.value != null) ? taxModel.value!.rate!.replaceRange(1, 6, "") : ""}%",
                                                          16.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      getCustomFont(
                                                          formatStringCurrency(
                                                              total: (tax.value !=
                                                                      0.0)
                                                                  ? tax.value
                                                                      .toString()
                                                                  : "0",
                                                              context: context),
                                                          16.sp,
                                                          Color(0XFF000000),
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ],
                                                  ).paddingSymmetric(
                                                      horizontal: 20.h),
                                                ),
                                                getVerSpace(12.h),
                                                getDivider(
                                                    color: dividerColor,
                                                    height: 0),
                                                getVerSpace(16.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getCustomFont(
                                                          S
                                                              .of(context)
                                                              .totalPaymentAmount,
                                                          18.sp,
                                                          Color(0XFF000000),
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      getSubTotal(controller
                                                                  .cartOtherInfoList) ==
                                                              "0.0"
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                              color:
                                                                  buttonColor,
                                                            ))
                                                          : getCustomFont(
                                                              formatStringCurrency(
                                                                  total: getTotalString(
                                                                      controller
                                                                          .isCouponApply,
                                                                      controller
                                                                          .cartOtherInfoList),
                                                                  context:
                                                                      context),
                                                              18.sp,
                                                              Color(0XFF000000),
                                                              1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ],
                                                  ),
                                                ),
                                              ])
                                              .paddingSymmetric(vertical: 20.h),
                                        ),
                                        getVerSpace(16.h),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: regularWhite,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getCustomFont(
                                                S.of(context).grandTotal,
                                                12.sp,
                                                darkGray,
                                                1,
                                                fontWeight: FontWeight.w400),
                                            getVerSpace(2.h),
                                            getCustomFont(
                                                formatStringCurrency(
                                                    total: getTotalString(
                                                        controller
                                                            .isCouponApply,
                                                        controller
                                                            .cartOtherInfoList),
                                                    context: context),
                                                18.sp,
                                                regularBlack,
                                                1,
                                                fontWeight: FontWeight.w600),
                                          ],
                                        ),
                                        // getHorSpace(65.h),
                                        getCustomButton(
                                            S.of(context).proceedToPayment,
                                            () async {
                                          bool isConnected =
                                              await isInternetConnected();

                                          if (isConnected) {
                                            checkProductInStock();
                                            if (cartControllerNew
                                                .inStock.value) {
                                              if (homeMainScreenController
                                                      .currentCustomer !=
                                                  null) {
                                                // List<CartOtherInfo>
                                                //     cartOtherInfoList = [];
                                                PrefData.getCartList()
                                                    .then((value) {
                                                  // cartOtherInfoList = value;
                                                  cartControllerNew
                                                      .getCartList(value);
                                                  Get.toNamed(
                                                      Routes
                                                          .cartBeforePaymentRoute,
                                                      arguments: controller
                                                          .cartOtherInfoList);
                                                });
                                              } else {
                                                loginController
                                                    .setLoginIsBuynow(true);
                                                homeMainScreenController
                                                    .changeIsLogin(true);
                                                Get.toNamed(Routes.loginRoute);
                                              }
                                            } else {
                                              showCustomToast(S
                                                  .of(context)
                                                  .productIsOutOfStock);
                                            }
                                          } else {
                                            showCustomToast(S
                                                .of(context)
                                                .noInternetConnection);
                                          }
                                        }, buttonheight: 56.h)
                                      ],
                                    ).paddingSymmetric(
                                        horizontal: 20.h, vertical: 20.h),
                                  ),
                                  getVerSpace(20.h),
                                ],
                              ),
                            ],
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: buttonColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ))),
      ),
    );
  }

  String getSubTotal(List<CartOtherInfo> cartOtherInfoList) {
    return cartControllerNew.cartTotalPriceF(1, cartOtherInfoList).toString();
  }

  String getTotalString(
      RxBool isCouponApply, List<CartOtherInfo> cartOtherInfoList) {
    double totalVals = (isCouponApply.value)
        ? (cartControllerNew.cartTotalPriceF(1, cartOtherInfoList) -
            cartControllerNew.promoPrice +
            ((tax.value != 0.0) ? tax.value : 0.0))
        : cartControllerNew.cartTotalPriceF(1, cartOtherInfoList) +
            ((tax.value != 0.0) ? tax.value : 0.0);

    if (selectedShippingMethod.value != null) {
      totalVals = totalVals +
          double.parse(
              selectedShippingMethod.value!.settings!.cost!.value ?? "0");
    }
    return totalVals.toString();
  }

  checkProductInStock() {
    cartControllerNew.inStock.value = true;
    for (var i = 0; i < cartControllerNew.cartOtherInfoList.length; i++) {
      if (cartControllerNew.cartOtherInfoList[i].stockStatus == 'outofstock') {
        cartControllerNew.inStock.value = false;
        break;
      }
    }
  }

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }
}
