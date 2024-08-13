// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/view/home/cart_screens/my_cart_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/home_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated/l10n.dart';
import '../../model/model_dummy_selected_add.dart';
import '../../woocommerce/models/customer.dart';
import '../../woocommerce/models/model_shipping_method.dart';
import '../../woocommerce/models/product_category.dart';
import '../../woocommerce/models/products.dart';
import 'home_screens/plant_type_screen.dart';
import 'profile_screens/profile_screen.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen>
    with SingleTickerProviderStateMixin {
  closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemNavigator.pop();
    });
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  HomeMainScreenController homeMainScreenControllerPut =
      Get.put(HomeMainScreenController());

  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  HomeScreenController findhomeScreenController =
      Get.find<HomeScreenController>();

  List<WooProductCategory> categoryList = [];
  ProductDataController productDataController =
      Get.put(ProductDataController());
  ProductDataController productController = Get.put(ProductDataController());
  HomeMainScreenController homeController =
      Get.find<HomeMainScreenController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // productDataController
    //     .getCountrieList(homeMainScreenController.wooCommerce1!);

    // Future.delayed(Duration(seconds: 3), () {
    //   ModelDummySelectedAdd selectedAdd;
    //
    //   if (cartControllerNew.differentAddress &&
    //       homeController.currentCustomer != null) {
    //     Shipping billing = homeController.currentCustomer!.shipping!;
    //     selectedAdd = ModelDummySelectedAdd(
    //         billing.firstName ?? "",
    //         billing.lastName ?? "",
    //         billing.company ?? "",
    //         billing.address1 ?? "",
    //         billing.address2 ?? "",
    //         billing.city ?? "",
    //         billing.state ?? "",
    //         billing.postcode ?? "",
    //         billing.country ?? "");
    //     homeScreenController.selectedShippingAddress = selectedAdd;
    //   } else if (homeController.currentCustomer != null) {
    //     Billing billing = homeController.currentCustomer!.billing!;
    //
    //     selectedAdd = ModelDummySelectedAdd(
    //         billing.firstName ?? "",
    //         billing.lastName ?? "",
    //         billing.company ?? "",
    //         billing.address1 ?? "",
    //         billing.address2 ?? "",
    //         billing.city ?? "",
    //         billing.state ?? "",
    //         billing.postcode ?? "",
    //         billing.country ?? "");
    //     homeScreenController.selectedShippingAddress = selectedAdd;
    //   }
    //
    //   // if (homeScreenController.selectedShippingAddress == null) {
    //   // } else {
    //   //   getShippingMethods();
    //   // }
    // });

    getCategoryData();
    getBestSellingList();
    getFeaturedProduct();

    getBlogData();
    getAllTax();

    homeMainScreenControllerPut.setTabController(widgetList);

    if (homeMainScreenController.checkNullOperator()) {
      return;
    }

    productDataController.getAllCouponList(homeMainScreenController.api1!);

    productDataController
        .getAllPaymentMethodList(homeMainScreenController.api1!);
    // Future.delayed(Duration(seconds: 2),() {

    // },);
  }

  dispose() {
    homeMainScreenControllerPut.tabController!.dispose();
    super.dispose();
  }

  Future<List<ModelShippingMethod>> getShippingMethods() async {
    // if (homeMainScreenController.checkNullOperator()) {
    //   return;
    // }

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
            homeScreenController.selectedShippingAddress!.postcode));

    findhomeScreenController.shippingMthLoaded.value = true;
    return homeScreenController.shippingMethods;
  }

  getBlogData() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController.getAllPostsList(homeMainScreenController.api1!);
  }

  getFeaturedProduct() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController.getNewArrivalProductList(homeMainScreenController.api1!);
  }

  Future<List<WooProduct>> getBestSellingList() async {
    // if (homeMainScreenController.checkNullOperator()) {
    //   return;
    // }
    final response =
        await homeMainScreenController.api1!.getWithout("products");
    List parseRes = response;
    List<WooProduct> postList =
        parseRes.map((e) => WooProduct.fromJson(e)).toList();
    for (WooProduct data in postList) {
      // if (data.status.toString() == "Status.PUBLISH") {
      homeScreenController.setTrendingPlant(data);

      // }
    }
    return postList;
  }

  getCategoryData() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    Future.delayed(
      Duration.zero,
      () {
        productController
            .getAllProductCategoryList(homeMainScreenController.api1!);
      },
    );
  }

  getAllTax() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController.getAllTaxList(homeMainScreenController.api1!);
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    setStatusBar();
    return GetBuilder<HomeMainScreenController>(
      init: HomeMainScreenController(),
      builder: (homeMainScreenController) => WillPopScope(
          onWillPop: () async {
            if (homeMainScreenController.position != 0) {
              homeMainScreenControllerPut.change(0);
              homeMainScreenController.tabController!.animateTo(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return Directionality(
                    textDirection:
                        Constant.getSetDirection(context) == TextDirection.ltr
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                    child: AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.only(left: 20.h, right: 20.h),
                      content: Container(
                        width: 374.h,
                        child: Padding(
                          padding: EdgeInsets.all(30.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: double.infinity,
                                child: getMultilineCustomFont(
                                    S.of(context).areYouWantToSureExitApp,
                                    18.sp,
                                    regularBlack,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 25.h, bottom: 13.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: getCustomButton(S.of(context).no,
                                            () {
                                      Get.back();
                                    }, buttonheight: 56.h)),
                                    SizedBox(width: 20.h),
                                    Expanded(
                                        child: getCustomButton(
                                            S.of(context).yes, () {
                                      Get.back();
                                      closeApp();
                                    },
                                            color: buttonColor,
                                            decoration: ButtonStyle(
                                                surfaceTintColor:
                                                    MaterialStatePropertyAll(
                                                        regularWhite),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        regularWhite),
                                                maximumSize:
                                                    MaterialStatePropertyAll(
                                                  Size(double.infinity, 56.h),
                                                ),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.h),
                                                        side: BorderSide(
                                                            color:
                                                                buttonColor)))),
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

            return false;
          },
          child: Directionality(
            textDirection:
                Constant.getSetDirection(context) == TextDirection.ltr
                    ? TextDirection.ltr
                    : TextDirection.rtl,
            child: GetBuilder<CartControllerNew>(
              init: CartControllerNew(),
              builder: (cartController) => Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: SmartRefresher(
                    controller: refreshController,
                    onRefresh: () => Future.sync(
                      () {
                        setState(() {
                          getCategoryData();
                          getBestSellingList();
                          getFeaturedProduct();
                          getBlogData();
                          getAllTax();
                          homeMainScreenControllerPut
                              .setTabController(widgetList);

                          if (homeMainScreenController.checkNullOperator()) {
                            return;
                          }

                          productDataController
                              .getAllCouponList(homeMainScreenController.api1!);

                          productDataController.getAllPaymentMethodList(
                              homeMainScreenController.api1!);
                        });

                        refreshController.refreshCompleted();
                      },
                    ),
                    child: TabBarView(
                      controller: homeMainScreenController.tabController,
                      children: widgetList,
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    elevation: 0,
                    backgroundColor: regularWhite,
                    currentIndex: homeMainScreenController.position.value,
                    onTap: (index) {
                      homeScreenController.clearTrending();
                      cartControllerNew.creatUpsellListClear();
                      homeMainScreenControllerPut.change(index);
                      homeMainScreenController.tabController!.animateTo(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          activeIcon: Column(
                            children: [
                              Container(
                                  height: 38.h,
                                  width: 38.h,
                                  decoration: BoxDecoration(
                                      color: lightGreen,
                                      shape: BoxShape.circle),
                                  child: getSvgImage(Constant.homefillIcon,
                                          height: 20.h,
                                          width: 20.h,
                                          color: buttonColor)
                                      .paddingAll(9.h)),
                              getVerSpace(3.h),
                              getCustomFont(
                                  S.of(context).home, 14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ).paddingSymmetric(vertical: 12.h),
                          icon: Column(
                            children: [
                              getSvgImage(Constant.homeIcon,
                                  height: 20.h, width: 20.h),
                              getVerSpace(3.h),
                              getCustomFont("", 14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                          activeIcon: Column(
                            children: [
                              Container(
                                  height: 38.h,
                                  width: 38.h,
                                  decoration: BoxDecoration(
                                      color: lightGreen,
                                      shape: BoxShape.circle),
                                  child: getSvgImage(Constant.categoryFillIcon,
                                          height: 20.h,
                                          width: 20.h,
                                          color: buttonColor)
                                      .paddingAll(9.h)),
                              getVerSpace(3.h),
                              getCustomFont(S.of(context).categories, 14.sp,
                                  regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ).paddingSymmetric(vertical: 12.h),
                          icon: Column(
                            children: [
                              getSvgImage(Constant.categoryIcon,
                                  height: 20.h, width: 20.h),
                              getVerSpace(3.h),
                              getCustomFont("", 14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                          activeIcon: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      height: 38.h,
                                      width: 38.h,
                                      decoration: BoxDecoration(
                                          color: lightGreen,
                                          shape: BoxShape.circle),
                                      child: getSvgImage(Constant.cartFillIcon,
                                              height: 20.h,
                                              width: 20.h,
                                              color: buttonColor)
                                          .paddingAll(9.h)),
                                  cartController.cartOtherInfoList.isNotEmpty
                                      ? Container(
                                          height: 20.h,
                                          width: 20.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: buttonColor),
                                          child: Center(
                                              child: getCustomFont(
                                                  cartController
                                                      .cartOtherInfoList.length
                                                      .toString(),
                                                  14.sp,
                                                  regularWhite,
                                                  1,
                                                  fontWeight: FontWeight.w400)),
                                        ).paddingOnly(left: 25.h)
                                      : SizedBox()
                                ],
                              ),
                              getVerSpace(3.h),
                              getCustomFont(
                                  S.of(context).cart, 14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ).paddingSymmetric(vertical: 12.h),
                          icon: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 38.h,
                                    width: 38.h,
                                    alignment: Alignment.center,
                                    child: getSvgImage(Constant.cartBgIcon,
                                        height: 20.h, width: 20.h),
                                  ),
                                  cartController.cartOtherInfoList.isNotEmpty
                                      ? Container(
                                          height: 20.h,
                                          width: 20.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: buttonColor),
                                          child: Center(
                                              child: getCustomFont(
                                                  cartController
                                                      .cartOtherInfoList.length
                                                      .toString(),
                                                  14.sp,
                                                  regularWhite,
                                                  1,
                                                  fontWeight: FontWeight.w400)),
                                        ).paddingOnly(left: 25.h)
                                      : SizedBox()
                                ],
                              ),
                              getVerSpace(3.h),
                              getCustomFont("", 14.sp, regularBlack, 1,
                                  fontWeight: FontWeight.w600)
                            ],
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                        activeIcon: Column(
                          children: [
                            Container(
                                height: 38.h,
                                width: 38.h,
                                decoration: BoxDecoration(
                                    color: lightGreen, shape: BoxShape.circle),
                                child: getSvgImage(Constant.profileFillIcon,
                                        height: 20.h,
                                        width: 20.h,
                                        color: buttonColor)
                                    .paddingAll(9.h)),
                            getVerSpace(3.h),
                            getCustomFont(
                                S.of(context).profile, 14.sp, regularBlack, 1,
                                fontWeight: FontWeight.w600)
                          ],
                        ).paddingSymmetric(vertical: 12.h),
                        icon: Column(
                          children: [
                            getSvgImage(Constant.profileIcon,
                                height: 20.h, width: 20.h),
                            getVerSpace(3.h),
                            getCustomFont("", 14.sp, regularBlack, 1,
                                fontWeight: FontWeight.w600)
                          ],
                        ),
                        label: '',
                      ),
                    ]),
              ),
            ),
          )),
    );
  }

  List<Widget> widgetList = [
    HomeScreen(),
    CategoriesScreen(),
    MyCartScreen(),
    ProfileScreen(),
  ];
}
