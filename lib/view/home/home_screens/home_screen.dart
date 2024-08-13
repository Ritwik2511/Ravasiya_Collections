import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/firebas_init.dart';
import 'package:ravasiya_collections/utils/notification_init.dart';
import 'package:ravasiya_collections/woocommerce/woocommerce.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';
import '../../../model/slider_data.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/pref_data.dart';
import '../../../woocommerce/models/posts.dart';
import '../../../woocommerce/models/retrieve_coupon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  CategoriesScreenController categoriesScreenController =
      Get.put(CategoriesScreenController());
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());

  ProductDataController productController = Get.put(ProductDataController());

  late TabController _tabController;
  TextEditingController search = TextEditingController();

  RxList<String> favProductList = <String>[].obs;
  StorageController storeController = Get.put(StorageController());

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final random = new Random();

  @override
  void initState() {
    notificationDialogue();
    _requestPermissions();
    _tabController = TabController(length: 4, vsync: this);

    homeMainScreenController.setProduct();
    Future.delayed(Duration.zero, () async {
      getFavDataList();

      cartControllerNew.getCartItem();
    });
    getFavourit();
    super.initState();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {}
  }

  notificationDialogue() async {
    if (!kIsWeb) {
      await NotificationInit.init();
      await FirebaseInit.init();
    }
  }

  getFavourit() {
    if (homeMainScreenController.checkNullOperator()) {
      return [];
    }
    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  List<SliderData> getSlider = Constant.getSlider();

  List<Color> getColor = Constant.getCouponColor();

  CartControllerNew cartControllerNew = Get.put(CartControllerNew());

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (homeScreenController) => column());
  }

  Widget column() {
    return Column(
      children: [
        Container(
            color: regularWhite,
            child: Column(
              children: [
                getVerSpace(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(S.of(context).findYourFavouriteProducts,
                        20.sp, regularBlack, 1,
                        fontWeight: FontWeight.w700),
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
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: darkGray.withOpacity(0.08)),
                            child: getSvgImage("cart_icon.svg",
                                    color: regularBlack)
                                .paddingAll(9.h),
                          ),
                          cartControllerNew.cartOtherInfoList.isNotEmpty
                              ? Container(
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
                                ).paddingOnly(left: 27.h)
                              : SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
                getVerSpace(15.h),
                GetBuilder<SearchScreenController>(
                  init: SearchScreenController(),
                  builder: (controller) => GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.searchScreenRoute);
                    },
                    child: getSearchField(S.of(context).search, search,
                        fontweight: FontWeight.w500,
                        prefixiconimage: "searchIcon.png",
                        suffixfunction: () {},
                        readOnly: true,
                        enable: false),

                  ),
                ),
                getVerSpace(10.h)
              ],
            ).paddingSymmetric(horizontal: 20.h)),
        Expanded(
          child: Container(
            color: bgColor,
            child: ListView(
              primary: true,
              shrinkWrap: false,
              children: [
                GetBuilder<HomeScreenController>(
                  init: HomeScreenController(),
                  builder: (storageController) =>
                      GetBuilder<ProductDataController>(
                    init: ProductDataController(),
                    builder: (controller) => Column(
                      children: [
                        Container(
                          color: regularWhite,
                          child: Column(
                            children: [
                              animation_function(
                                1,
                                CarouselSlider.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index, realIndex) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          categoriesScreenController
                                              .setNavigationIsHome(true);
                                          Get.toNamed(
                                              Routes.categoryScreenRoute);
                                        },
                                        child: Container(
                                          // width: 308.h,
                                          height: 110.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.h),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    Constant.assetImagePath +
                                                        getSlider[index]
                                                            .image
                                                            .toString()),
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 140.h,
                                    autoPlay: true,
                                    scrollDirection: Axis.horizontal,
                                    initialPage: 0,
                                    onPageChanged: (index, reason) {
                                      homeScreenController.onPageChange(index);
                                    },
                                  ),
                                ).paddingOnly(top: 10.h, bottom: 10.h),
                              ),
                              indicator(storageController),
                              getVerSpace(20.h)
                            ],
                          ),
                        ),
                        getVerSpace(16.h),
                        controller.isCategoryLoad
                            ? SizedBox()
                            : Container(
                                width: double.infinity,
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomFont(
                                            S.of(context).shopCategories,
                                            20.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w700,
                                            txtHeight: 1.5.h),
                                        GestureDetector(
                                            onTap: () {
                                              categoriesScreenController
                                                  .setNavigationIsHome(true);
                                              Get.toNamed(
                                                  Routes.categoryScreenRoute);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 10.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.h),
                                                  color: gray),
                                              child: getCustomFont(
                                                  S.of(context).viewAll,
                                                  14.sp,
                                                  darkGray,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                  txtHeight: 1.5.h),
                                            ))
                                      ],
                                    ).marginSymmetric(horizontal: 20.h),
                                    getVerSpace(20.h),
                                    controller.categoryList.isEmpty
                                        ? Container(
                                            height: 130.h,
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                width: 19.h,
                                              ),
                                              itemCount: 6,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.h),
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 79.h,
                                                          height: 79.h,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.h),
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        getVerSpace(6.h),
                                                        Container(
                                                          width: 70.h,
                                                          height: 20.h,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ));
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 130.h,
                                            child: ListView.builder(
                                              // separatorBuilder:
                                              //     (context, index) => SizedBox(
                                              //   width: 19.h,
                                              // ),
                                              itemCount: controller
                                                  .categoryList.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 11.h),
                                              itemBuilder: (context, index) {
                                                WooProductCategory item =
                                                    controller
                                                        .categoryList[index];
                                                return
                                                    // item.image == null
                                                    //   ? SizedBox()
                                                    //   :
                                                    // item.image!.src!.isEmpty
                                                    //         ? SizedBox()
                                                    //         :
                                                    Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 9.h),
                                                  child: GestureDetector(
                                                          onTap: () {
                                                            homeMainScreenController
                                                                .setProduct();

                                                            homeMainScreenController
                                                                .setCategory(item
                                                                    .id!
                                                                    .toInt());
                                                            homeMainScreenController
                                                                .setMainCategoryName(
                                                                    item.name);
                                                            homeMainScreenController
                                                                .setCategoryDisplay(
                                                                    item.display!);

                                                            Get.toNamed(Routes
                                                                    .mainCategoryScreenRoute)!
                                                                .then((value) {
                                                              getFavDataList();
                                                              getFavourit();
                                                            });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  height: 79.h,
                                                                  width: 79.h,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(12
                                                                              .h),
                                                                      color:
                                                                          lightGray),
                                                                  child: item.image ==
                                                                          null
                                                                      ? getAssetImage(
                                                                          "no_image_banner.png")
                                                                      : animation_function(
                                                                          index,
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.h),
                                                                            child: getNetworkImage(
                                                                                context,
                                                                                item.image?.src ?? "",
                                                                                double.infinity,
                                                                                double.infinity,
                                                                                boxFit: BoxFit.fill),
                                                                          ))),
                                                              getVerSpace(6.h),
                                                              Center(
                                                                  child:
                                                                      Container(
                                                                width: 79.h,
                                                                child: getCustomFont(
                                                                    item.name!,
                                                                    14.sp,
                                                                    regularBlack,
                                                                    2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                              ))
                                                            ],
                                                          ))
                                                      .paddingSymmetric(
                                                          vertical: 0.h),
                                                );
                                              },
                                            ),
                                          ).paddingSymmetric(horizontal: 0.h),
                                    getVerSpace(23.h),
                                  ],
                                ).paddingSymmetric(vertical: 0.h)),
                        getVerSpace(16.h),
                        storageController.isFlashLoad
                            ? SizedBox()
                            : Container(
                                width: double.infinity,
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomFont(
                                            S.of(context).trendingProducts,
                                            20.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w700,
                                            txtHeight: 1.5.h),
                                        GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes
                                                      .trendingPlantRoute)!
                                                  .then((value) {
                                                getFavDataList();
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 10.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.h),
                                                  color: gray),
                                              child: getCustomFont(
                                                  S.of(context).viewAll,
                                                  14.sp,
                                                  darkGray,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                  txtHeight: 1.5.h),
                                            ))
                                      ],
                                    ).marginSymmetric(horizontal: 20.h),
                                    getVerSpace(16.h),
                                    storageController.flashSaleList.isEmpty
                                        ? Container(
                                            height: 280.h,
                                            child: ListView.builder(
                                              itemCount: 3,
                                              primary: false,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.h),
                                                        border: Border.all(
                                                            color: black20),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                        left: 20.h,
                                                      ),
                                                      width: 200.h,
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            child: Container(
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                          top: 14
                                                                              .h),
                                                              height: 138.h,
                                                              width: 153.h,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topCenter,
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            height: 12.h,
                                                            width: 57.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(6.h),
                                                          Container(
                                                            height: 21.h,
                                                            width: 153.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(8.h),
                                                          Container(
                                                            height: 17.h,
                                                            width: 102.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(4.h),
                                                          Container(
                                                            height: 24.h,
                                                            width: 52.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(5.h),
                                                        ],
                                                      )),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 280.h,
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return getHorSpace(20.h);
                                              },
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.h),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: storageController
                                                          .flashSaleList
                                                          .length <
                                                      3
                                                  ? storageController
                                                      .flashSaleList.length
                                                  : 3,
                                              itemBuilder: (context, index) {
                                                WooProduct product =
                                                    storageController
                                                        .flashSaleList[index];
                                                return productDataFormateInListView(
                                                    context, () {
                                                  homeScreenController
                                                      .setSelectedWooProduct(
                                                          product);
                                                  homeScreenController
                                                      .addListVariation(
                                                          homeMainScreenController,
                                                          product.id);
                                                  storageController
                                                      .clearProductVariation();
                                                  sendToPlanDetail(
                                                    id: "${product.id}",
                                                    tag:
                                                        "Trending Products${index}${product.images[0].src}",
                                                    function: () {
                                                      getFavDataList();
                                                      getFavourit();
                                                    },
                                                    titleTag:
                                                        "Trending Products${index}${product.name}",
                                                    priceTag:
                                                        "Trending Products${index}price",
                                                    ratingTag:
                                                        "Trending Products${index}rating",
                                                  );
                                                },
                                                    product,
                                                    GestureDetector(
                                                      onTap: () {
                                                        checkInFavouriteList(
                                                            product);
                                                        List<String> strList =
                                                            favProductList
                                                                .map((i) => i
                                                                    .toString())
                                                                .toList();
                                                        PrefData()
                                                            .setFavouriteList(
                                                                strList);
                                                        getFavourit();
                                                      },
                                                      child: Obx(
                                                        () {
                                                          return getSvgImage(
                                                                  favProductList.contains(
                                                                          product
                                                                              .id
                                                                              .toString())
                                                                      ? "likefillIconnew.svg"
                                                                      : "likeIconnew.svg",
                                                                  height: 22.h,
                                                                  width: 22.h)
                                                              .marginOnly(
                                                                  top: 10.h,
                                                                  right: 14.h,
                                                                  left: 15.h);
                                                        },
                                                      ),
                                                    ),
                                                    index,
                                                    "Trending Products",
                                                    homeMainScreenController);
                                              },
                                            )),
                                    getVerSpace(20.h),
                                  ],
                                )),
                        // getRandomCategory(),
                        productController.randomCatData.isEmpty
                            ? Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 16.h),
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(20.h),
                                    Container(
                                      height: 285.h,
                                      child: ListView.builder(
                                        itemCount: 3,
                                        primary: false,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.h),
                                                  border: Border.all(
                                                      color: black20),
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: 20.h,
                                                ),
                                                width: 200.h,
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    top: 14.h),
                                                        height: 138.h,
                                                        width: 153.h,
                                                        color: Colors.white,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topCenter,
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: 12.h,
                                                      width: 57.h,
                                                      color: Colors.white,
                                                    ).paddingSymmetric(
                                                        horizontal: 12.h),
                                                    getVerSpace(6.h),
                                                    Container(
                                                      height: 21.h,
                                                      width: 153.h,
                                                      color: Colors.white,
                                                    ).paddingSymmetric(
                                                        horizontal: 12.h),
                                                    getVerSpace(8.h),
                                                    Container(
                                                      height: 17.h,
                                                      width: 102.h,
                                                      color: Colors.white,
                                                    ).paddingSymmetric(
                                                        horizontal: 12.h),
                                                    getVerSpace(4.h),
                                                    Container(
                                                      height: 24.h,
                                                      width: 52.h,
                                                      color: Colors.white,
                                                    ).paddingSymmetric(
                                                        horizontal: 12.h),
                                                    getVerSpace(5.h),
                                                  ],
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                    getVerSpace(20.h),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  getVerSpace(16.h),
                                  Container(
                                      width: double.infinity,
                                      color: regularWhite,
                                      child: Column(
                                        children: [
                                          getVerSpace(20.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              getCustomFont(
                                                  productController
                                                          .categoryList[0]
                                                          .name ??
                                                      "",
                                                  20.sp,
                                                  regularBlack,
                                                  1,
                                                  fontWeight: FontWeight.w700,
                                                  txtHeight: 1.5.h),
                                            ],
                                          ).marginSymmetric(horizontal: 20.h),
                                          getVerSpace(16.h),
                                          Container(
                                              height: 285.h,
                                              child: ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return getHorSpace(20.h);
                                                },
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.h),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: productController
                                                            .randomCatData
                                                            .length <
                                                        3
                                                    ? productController
                                                        .randomCatData.length
                                                    : 3,
                                                itemBuilder: (context, index) {
                                                  WooProduct product =
                                                      productController
                                                          .randomCatData[index];
                                                  return productDataFormateGridView1(
                                                      context, () async {
                                                    homeScreenController
                                                        .setSelectedWooProduct(
                                                            product);
                                                    homeScreenController
                                                        .addListVariation(
                                                            homeMainScreenController,
                                                            product.id);

                                                    storeController
                                                        .setSelectedWooProduct(
                                                            product);
                                                    storeController
                                                        .clearProductVariation();

                                                    sendToPlanDetail(
                                                        id: "${product.id}",
                                                        tag:
                                                            "main${index}${product.images[0].src}",
                                                        function: () {
                                                          getFavDataList();
                                                        },
                                                        titleTag:
                                                            "main${index}${product.name}",
                                                        priceTag:
                                                            "main${index}price",
                                                        ratingTag:
                                                            "main${index}rating");
                                                  },
                                                      product,
                                                      GestureDetector(
                                                        onTap: () {
                                                          checkInFavouriteList(
                                                              product);
                                                          List<String> strList =
                                                              favProductList
                                                                  .map((i) => i
                                                                      .toString())
                                                                  .toList();
                                                          PrefData()
                                                              .setFavouriteList(
                                                                  strList);
                                                          getFavourit();
                                                        },
                                                        child: Obx(
                                                          () {
                                                            return getSvgImage(
                                                                    favProductList.contains(product
                                                                            .id
                                                                            .toString())
                                                                        ? "likefillIconnew.svg"
                                                                        : "likeIconnew.svg",
                                                                    height:
                                                                        22.h,
                                                                    width: 22.h)
                                                                .marginOnly(
                                                                    top: 10.h,
                                                                    right: 14.h,
                                                                    left: 15.h);
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(),
                                                      index);
                                                },
                                              )),
                                          getVerSpace(20.h),
                                        ],
                                      )),
                                ],
                              ),
                        productController.isCouponLoad
                            ? SizedBox()
                            : Container(
                                height: 160.h,
                                margin: EdgeInsets.only(top: 16.h),
                                child: productController.modelCouponCode.isEmpty
                                    ? CarouselSlider.builder(
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.h),
                                            child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: 308.w,
                                                  height: 160.h,
                                                  decoration: BoxDecoration(
                                                    color: getColor[index],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.h),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.h),
                                                )),
                                          );
                                        },
                                        itemCount: 2,
                                        options: CarouselOptions(
                                          height: 160.h,
                                          autoPlay: true,
                                          scrollDirection: Axis.horizontal,
                                          initialPage: 1,
                                        ),
                                      )
                                    : CarouselSlider.builder(
                                        itemCount: productController
                                            .modelCouponCode.length,
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          RetrieveCoupon? coupon =
                                              productController
                                                  .modelCouponCode[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.h),
                                            child: Container(
                                              width: 308.w,
                                              height: 160.h,
                                              decoration: BoxDecoration(
                                                color: getColor[index],
                                                borderRadius:
                                                    BorderRadius.circular(16.h),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  getCustomFont(
                                                      coupon!.description,
                                                      14.sp,
                                                      regularBlack,
                                                      2,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  getVerSpace(8.h),
                                                  getCustomFont(coupon.code,
                                                      22.sp, regularBlack, 1,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  getVerSpace(8.h),
                                                  ValueListenableBuilder(
                                                    valueListenable: isRefresh,
                                                    builder: (context, value,
                                                            child) =>
                                                        getCouponButton(
                                                            PrefData.getCouponCode() ==
                                                                    coupon.code
                                                                ? "Copied"
                                                                : "Copy", () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  coupon.code));
                                                    },
                                                            buttonheight: 40.h,
                                                            fontSize: 16.sp),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                          height: 160.h,
                                          autoPlay: true,
                                          scrollDirection: Axis.horizontal,
                                          initialPage: 1,
                                        ),
                                        // viewportFraction: 0.85.h),
                                      ),
                              ),
                        controller.newArriveProductLoad == true
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(top: 16.h),
                                height: 378.h,
                                width: double.infinity,
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomFont(
                                            S.of(context).popularProducts,
                                            20.sp,
                                            regularBlack,
                                            1,
                                            fontWeight: FontWeight.w700,
                                            txtHeight: 1.5.h),
                                        GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                      Routes.popularPlantRoute)!
                                                  .then((value) {
                                                getFavDataList();
                                                getFavourit();
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 10.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.h),
                                                  color: gray),
                                              child: getCustomFont(
                                                  S.of(context).viewAll,
                                                  14.sp,
                                                  darkGray,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                  txtHeight: 1.5.h),
                                            ))
                                      ],
                                    ).paddingSymmetric(horizontal: 20.h),
                                    getVerSpace(20.h),
                                    controller.newArriveProductList.isEmpty
                                        ? Container(
                                            height: 280.h,
                                            child: ListView.builder(
                                              itemCount: 3,
                                              primary: false,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.h),
                                                        border: Border.all(
                                                            color: black20),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                        left: 20.h,
                                                      ),
                                                      width: 200.h,
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            child: Container(
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                          top: 14
                                                                              .h),
                                                              height: 138.h,
                                                              width: 153.h,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topCenter,
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            height: 12.h,
                                                            width: 57.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(6.h),
                                                          Container(
                                                            height: 21.h,
                                                            width: 153.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(8.h),
                                                          Container(
                                                            height: 17.h,
                                                            width: 102.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(4.h),
                                                          Container(
                                                            height: 24.h,
                                                            width: 52.h,
                                                            color: Colors.white,
                                                          ).paddingSymmetric(
                                                              horizontal: 12.h),
                                                          getVerSpace(5.h),
                                                        ],
                                                      )),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 280.h,
                                            child: ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.h),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: controller
                                                          .newArriveProductList
                                                          .length <
                                                      3
                                                  ? controller
                                                      .newArriveProductList
                                                      .length
                                                  : 3,
                                              itemBuilder: (context, index) {
                                                WooProduct model = controller
                                                        .newArriveProductList[
                                                    index];

                                                return GetBuilder<
                                                    HomeScreenController>(
                                                  init: HomeScreenController(),
                                                  builder: (controller) =>
                                                      productDataFormateInListView(
                                                              context, () {
                                                    homeScreenController
                                                        .setSelectedWooProduct(
                                                            model);
                                                    storageController
                                                        .setSelectedWooProduct(
                                                            model);
                                                    storageController
                                                        .clearProductVariation();

                                                    sendToPlanDetail(
                                                        id: "${model.id}",
                                                        tag:
                                                            "trending${index}${model.images[0].src}",
                                                        function: () {
                                                          getFavDataList();
                                                          getFavourit();
                                                        },
                                                        titleTag:
                                                            "trending${index}${model.name}",
                                                        priceTag:
                                                            "trending${index}price",
                                                        ratingTag:
                                                            "trending${index}rating");
                                                  },
                                                              model,
                                                              GestureDetector(
                                                                onTap: () {
                                                                  checkInFavouriteList(
                                                                      model);
                                                                  List<String>
                                                                      strList =
                                                                      favProductList
                                                                          .map((i) =>
                                                                              i.toString())
                                                                          .toList();
                                                                  PrefData()
                                                                      .setFavouriteList(
                                                                          strList);
                                                                  getFavourit();
                                                                },
                                                                child: Obx(
                                                                  () {
                                                                    return getSvgImage(
                                                                            favProductList.contains(model.id.toString())
                                                                                ? "likefillIconnew.svg"
                                                                                : "likeIconnew.svg",
                                                                            height: 22
                                                                                .h,
                                                                            width: 22
                                                                                .h)
                                                                        .marginOnly(
                                                                            top:
                                                                                10.h,
                                                                            right: 14.h,
                                                                            left: 15.h);
                                                                  },
                                                                ),
                                                              ),
                                                              index,
                                                              "trending",
                                                              homeMainScreenController)
                                                          .paddingSymmetric(
                                                              horizontal: 10.h),
                                                );
                                              },
                                            ))
                                  ],
                                )),
                        controller.postLoad == true
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(top: 16.h),
                                color: regularWhite,
                                child: Column(
                                  children: [
                                    getVerSpace(20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomFont(S.of(context).blog, 20.sp,
                                            Color(0XFF000000), 1,
                                            fontWeight: FontWeight.w700,
                                            txtHeight: 1.5.h),
                                        GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes.blogScreenRoute);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 10.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.h),
                                                  color: gray),
                                              child: getCustomFont(
                                                  S.of(context).viewAll,
                                                  14.sp,
                                                  darkGray,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                  txtHeight: 1.5.h),
                                            ))
                                      ],
                                    ).paddingSymmetric(horizontal: 20.h),
                                    getVerSpace(20.h),
                                    controller.postsList.isEmpty
                                        ? Container(
                                            height: 256.h,
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(width: 16.h);
                                              },
                                              itemCount: 3,
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 20.h,
                                                      end: 20.h,
                                                      bottom: 16.h),
                                              scrollDirection: Axis.horizontal,
                                              primary: false,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                      width: 256.h,
                                                      height: 245.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.h),
                                                          border: Border.all(
                                                              color: black20)),
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .all(12.h),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 124.h,
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(16
                                                                            .h),
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          getVerSpace(12.h),
                                                          Container(
                                                            height: 42.h,
                                                            width:
                                                                double.infinity,
                                                            color: Colors.white,
                                                          ),
                                                          getVerSpace(4.h),
                                                          Container(
                                                            height: 18.h,
                                                            width: 67.h,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 256.h,
                                            child: ListView.separated(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 20.h,
                                                      end: 20.h,
                                                      bottom: 16.h),
                                              scrollDirection: Axis.horizontal,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(width: 16.h);
                                              },
                                              itemCount: controller
                                                          .postsList.length <=
                                                      3
                                                  ? controller.postsList.length
                                                  : 3,
                                              itemBuilder: (context, index) {
                                                Posts model =
                                                    controller.postsList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.blogDetailRoute,
                                                        arguments: model);
                                                  },
                                                  child:
                                                      ListwalkingfitnessItemWidget(
                                                          model),
                                                );
                                              },
                                            )),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<List<WooProduct>?> getRandomCategoryData() async {
    try {
      if (homeMainScreenController.checkNullOperator()) {
        return null;
      }
      final response = await homeMainScreenController.api1!
          .get("products?category=${productController.categoryId}");
      List parseRes = response;
      List<WooProduct> postList =
          parseRes.map((e) => WooProduct.fromJson(e)).toList();

      return postList;
    } catch (e) {}
    return null;
  }

  Future<WooProductCategory?> getRandomCategoryDetail() async {
    try {
      if (homeMainScreenController.checkNullOperator()) {
        return null;
      }
      final response = await homeMainScreenController.api1!
          .getWithout("products/categories/${productController.categoryId}");
      // List parseRes = response;
      return WooProductCategory.fromJson(response);
    } catch (e) {}
    return null;
  }

  // getRandomCategory() {
  //   // if (!Constant.isEnable) {
  //   //   return Container();
  //   // }
  //   // return FutureBuilder(
  //   //   future: getRandomCategoryData(),
  //   //   builder: (context, snapshot) {
  //   //     if (snapshot.data == null &&
  //   //         snapshot.connectionState == ConnectionState.waiting) {
  //   //       return Container(
  //   //         width: double.infinity,
  //   //         margin: EdgeInsets.only(top: 16.h),
  //   //         color: regularWhite,
  //   //         child: Column(
  //   //           children: [
  //   //             getVerSpace(20.h),
  //   //             Container(
  //   //               height: 285.h,
  //   //               child: ListView.builder(
  //   //                 itemCount: 3,
  //   //                 primary: false,
  //   //                 scrollDirection: Axis.horizontal,
  //   //                 itemBuilder: (context, index) {
  //   //                   return Shimmer.fromColors(
  //   //                     baseColor: Colors.grey[300]!,
  //   //                     highlightColor: Colors.grey[100]!,
  //   //                     child: Container(
  //   //                         decoration: BoxDecoration(
  //   //                           borderRadius: BorderRadius.circular(16.h),
  //   //                           border: Border.all(color: black20),
  //   //                         ),
  //   //                         margin: EdgeInsets.only(
  //   //                           left: 20.h,
  //   //                         ),
  //   //                         width: 200.h,
  //   //                         height: double.infinity,
  //   //                         child: Column(
  //   //                           mainAxisAlignment: MainAxisAlignment.start,
  //   //                           crossAxisAlignment: CrossAxisAlignment.start,
  //   //                           children: [
  //   //                             Align(
  //   //                               child: Container(
  //   //                                 margin:
  //   //                                     EdgeInsetsDirectional.only(top: 14.h),
  //   //                                 height: 138.h,
  //   //                                 width: 153.h,
  //   //                                 color: Colors.white,
  //   //                               ),
  //   //                               alignment: AlignmentDirectional.topCenter,
  //   //                             ),
  //   //                             Spacer(),
  //   //                             Container(
  //   //                               height: 12.h,
  //   //                               width: 57.h,
  //   //                               color: Colors.white,
  //   //                             ).paddingSymmetric(horizontal: 12.h),
  //   //                             getVerSpace(6.h),
  //   //                             Container(
  //   //                               height: 21.h,
  //   //                               width: 153.h,
  //   //                               color: Colors.white,
  //   //                             ).paddingSymmetric(horizontal: 12.h),
  //   //                             getVerSpace(8.h),
  //   //                             Container(
  //   //                               height: 17.h,
  //   //                               width: 102.h,
  //   //                               color: Colors.white,
  //   //                             ).paddingSymmetric(horizontal: 12.h),
  //   //                             getVerSpace(4.h),
  //   //                             Container(
  //   //                               height: 24.h,
  //   //                               width: 52.h,
  //   //                               color: Colors.white,
  //   //                             ).paddingSymmetric(horizontal: 12.h),
  //   //                             getVerSpace(5.h),
  //   //                           ],
  //   //                         )),
  //   //                   );
  //   //                 },
  //   //               ),
  //   //             ),
  //   //             getVerSpace(20.h),
  //   //           ],
  //   //         ),
  //   //       );
  //   //     }
  //   //     List<WooProduct> categoryList = snapshot.data ?? [];
  //   //
  //   //     if (snapshot.data == null) {
  //   //       return SizedBox();
  //   //     }
  //   //     return FutureBuilder(
  //   //       future: getRandomCategoryDetail(),
  //   //       builder: (context, snapshot) {
  //   //         if (snapshot.data != null) {
  //   //           return Column(
  //   //             children: [
  //   //               getVerSpace(16.h),
  //   //               Container(
  //   //                   width: double.infinity,
  //   //                   color: regularWhite,
  //   //                   child: Column(
  //   //                     children: [
  //   //                       getVerSpace(20.h),
  //   //                       Row(
  //   //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //                         children: [
  //   //                           getCustomFont(snapshot.data!.name ?? '', 20.sp,
  //   //                               regularBlack, 1,
  //   //                               fontWeight: FontWeight.w700,
  //   //                               txtHeight: 1.5.h),
  //   //                         ],
  //   //                       ).marginSymmetric(horizontal: 20.h),
  //   //                       getVerSpace(16.h),
  //   //                       Container(
  //   //                           height: 285.h,
  //   //                           child: ListView.separated(
  //   //                             separatorBuilder: (context, index) {
  //   //                               return getHorSpace(20.h);
  //   //                             },
  //   //                             padding: EdgeInsets.symmetric(horizontal: 20.h),
  //   //                             scrollDirection: Axis.horizontal,
  //   //                             itemCount: categoryList.length < 3
  //   //                                 ? categoryList.length
  //   //                                 : 3,
  //   //                             itemBuilder: (context, index) {
  //   //                               WooProduct product = categoryList[index];
  //   //                               return productDataFormateGridView1(context,
  //   //                                   () async {
  //   //                                 homeScreenController
  //   //                                     .setSelectedWooProduct(product);
  //   //                                 homeScreenController.addListVariation(
  //   //                                     homeMainScreenController, product.id);
  //   //
  //   //                                 storeController
  //   //                                     .setSelectedWooProduct(product);
  //   //                                 storeController.clearProductVariation();
  //   //
  //   //                                 sendToPlanDetail(
  //   //                                     id: "${product.id}",
  //   //                                     tag:
  //   //                                         "main${index}${product.images[0].src}",
  //   //                                     function: () {
  //   //                                       getFavDataList();
  //   //                                     },
  //   //                                     titleTag: "main${index}${product.name}",
  //   //                                     priceTag: "main${index}price",
  //   //                                     ratingTag: "main${index}rating");
  //   //                               },
  //   //                                   product,
  //   //                                   GestureDetector(
  //   //                                     onTap: () {
  //   //                                       checkInFavouriteList(product);
  //   //                                       List<String> strList = favProductList
  //   //                                           .map((i) => i.toString())
  //   //                                           .toList();
  //   //                                       PrefData().setFavouriteList(strList);
  //   //                                       getFavourit();
  //   //                                     },
  //   //                                     child: Obx(
  //   //                                       () {
  //   //                                         return getSvgImage(
  //   //                                                 favProductList.contains(
  //   //                                                         product.id
  //   //                                                             .toString())
  //   //                                                     ? "likefillIconnew.svg"
  //   //                                                     : "likeIconnew.svg",
  //   //                                                 height: 22.h,
  //   //                                                 width: 22.h)
  //   //                                             .marginOnly(
  //   //                                                 top: 10.h,
  //   //                                                 right: 14.h,
  //   //                                                 left: 15.h);
  //   //                                       },
  //   //                                     ),
  //   //                                   ),
  //   //                                   SizedBox(),
  //   //                                   index);
  //   //                             },
  //   //                           )),
  //   //                       getVerSpace(20.h),
  //   //                     ],
  //   //                   )),
  //   //             ],
  //   //           );
  //   //         }
  //   //         return Container();
  //   //       },
  //   //     );
  //   //   },
  //   // );
  //   productController.randomCatData.isEmpty
  //       ? Container(
  //           width: double.infinity,
  //           margin: EdgeInsets.only(top: 16.h),
  //           color: regularWhite,
  //           child: Column(
  //             children: [
  //               getVerSpace(20.h),
  //               Container(
  //                 height: 285.h,
  //                 child: ListView.builder(
  //                   itemCount: 3,
  //                   primary: false,
  //                   scrollDirection: Axis.horizontal,
  //                   itemBuilder: (context, index) {
  //                     return Shimmer.fromColors(
  //                       baseColor: Colors.grey[300]!,
  //                       highlightColor: Colors.grey[100]!,
  //                       child: Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(16.h),
  //                             border: Border.all(color: black20),
  //                           ),
  //                           margin: EdgeInsets.only(
  //                             left: 20.h,
  //                           ),
  //                           width: 200.h,
  //                           height: double.infinity,
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Align(
  //                                 child: Container(
  //                                   margin:
  //                                       EdgeInsetsDirectional.only(top: 14.h),
  //                                   height: 138.h,
  //                                   width: 153.h,
  //                                   color: Colors.white,
  //                                 ),
  //                                 alignment: AlignmentDirectional.topCenter,
  //                               ),
  //                               Spacer(),
  //                               Container(
  //                                 height: 12.h,
  //                                 width: 57.h,
  //                                 color: Colors.white,
  //                               ).paddingSymmetric(horizontal: 12.h),
  //                               getVerSpace(6.h),
  //                               Container(
  //                                 height: 21.h,
  //                                 width: 153.h,
  //                                 color: Colors.white,
  //                               ).paddingSymmetric(horizontal: 12.h),
  //                               getVerSpace(8.h),
  //                               Container(
  //                                 height: 17.h,
  //                                 width: 102.h,
  //                                 color: Colors.white,
  //                               ).paddingSymmetric(horizontal: 12.h),
  //                               getVerSpace(4.h),
  //                               Container(
  //                                 height: 24.h,
  //                                 width: 52.h,
  //                                 color: Colors.white,
  //                               ).paddingSymmetric(horizontal: 12.h),
  //                               getVerSpace(5.h),
  //                             ],
  //                           )),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               getVerSpace(20.h),
  //             ],
  //           ),
  //         )
  //       : FutureBuilder(
  //           future: getRandomCategoryDetail(),
  //           builder: (context, snapshot) {
  //             if (snapshot.data != null) {
  //               return Column(
  //                 children: [
  //                   getVerSpace(16.h),
  //                   Container(
  //                       width: double.infinity,
  //                       color: regularWhite,
  //                       child: Column(
  //                         children: [
  //                           getVerSpace(20.h),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               getCustomFont(snapshot.data!.name ?? '', 20.sp,
  //                                   regularBlack, 1,
  //                                   fontWeight: FontWeight.w700,
  //                                   txtHeight: 1.5.h),
  //                             ],
  //                           ).marginSymmetric(horizontal: 20.h),
  //                           getVerSpace(16.h),
  //                           Container(
  //                               height: 285.h,
  //                               child: ListView.separated(
  //                                 separatorBuilder: (context, index) {
  //                                   return getHorSpace(20.h);
  //                                 },
  //                                 padding:
  //                                     EdgeInsets.symmetric(horizontal: 20.h),
  //                                 scrollDirection: Axis.horizontal,
  //                                 itemCount: productController.randomCatData.length < 3
  //                                     ? productController.randomCatData.length
  //                                     : 3,
  //                                 itemBuilder: (context, index) {
  //
  //                                   WooProduct product = productController.randomCatData[index];
  //                                   return productDataFormateGridView1(context,
  //                                       () async {
  //                                     homeScreenController
  //                                         .setSelectedWooProduct(product);
  //                                     homeScreenController.addListVariation(
  //                                         homeMainScreenController, product.id);
  //
  //                                     storeController
  //                                         .setSelectedWooProduct(product);
  //                                     storeController.clearProductVariation();
  //
  //                                     sendToPlanDetail(
  //                                         id: "${product.id}",
  //                                         tag:
  //                                             "main${index}${product.images[0].src}",
  //                                         function: () {
  //                                           getFavDataList();
  //                                         },
  //                                         titleTag:
  //                                             "main${index}${product.name}",
  //                                         priceTag: "main${index}price",
  //                                         ratingTag: "main${index}rating");
  //                                   },
  //                                       product,
  //                                       GestureDetector(
  //                                         onTap: () {
  //                                           checkInFavouriteList(product);
  //                                           List<String> strList =
  //                                               favProductList
  //                                                   .map((i) => i.toString())
  //                                                   .toList();
  //                                           PrefData()
  //                                               .setFavouriteList(strList);
  //                                           getFavourit();
  //                                         },
  //                                         child: Obx(
  //                                           () {
  //                                             return getSvgImage(
  //                                                     favProductList.contains(
  //                                                             product.id
  //                                                                 .toString())
  //                                                         ? "likefillIconnew.svg"
  //                                                         : "likeIconnew.svg",
  //                                                     height: 22.h,
  //                                                     width: 22.h)
  //                                                 .marginOnly(
  //                                                     top: 10.h,
  //                                                     right: 14.h,
  //                                                     left: 15.h);
  //                                           },
  //                                         ),
  //                                       ),
  //                                       SizedBox(),
  //                                       index);
  //                                 },
  //                               )),
  //                           getVerSpace(20.h),
  //                         ],
  //                       )),
  //                 ],
  //               );
  //             }
  //             return Container();
  //           },
  //         );
  // }

  ValueNotifier<bool> isRefresh = ValueNotifier(false);

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }

  ListwalkingfitnessItemWidget(Posts model) {
    DateTime dateTime = DateTime.parse(model.date.toString());
    String date = DateFormat("dd MMM,yyyy").format(dateTime);
    return Container(
        width: 256.h,
        height: 245.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h),
            border: Border.all(color: black20)),
        child: Column(
          children: [
            model.embedded!.wpFeaturedmedia![0] == null
                ? getAssetImage("no_image_banner.png",
                    height: 124.h, width: double.infinity)
                : Container(
                    height: 124.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.h),
                      image: DecorationImage(
                          image: NetworkImage(
                            model.embedded!.wpFeaturedmedia![0]!.sourceUrl
                                .toString(),
                          ),
                          fit: BoxFit.fill),
                    ),
                  ).paddingOnly(
                    top: 12.h, left: 12.h, right: 12.h, bottom: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomFont(
                    model.title!.rendered.toString(), 16.sp, regularBlack, 2,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis),
                getVerSpace(4.h),
                getCustomFont(date.toString(), 14.sp, regularBlack, 1,
                    fontWeight: FontWeight.w500)
              ],
            ).paddingOnly(left: 12.h, right: 12.h)
          ],
        ));
  }

  Widget indicator(HomeScreenController storageController) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 7.h,
            width: index == storageController.currentPage ? 16.h : 7.h,
            margin: EdgeInsets.symmetric(horizontal: 5.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.h),
                color: (index == storageController.currentPage)
                    ? buttonColor
                    : buttonColor.withOpacity(0.3)),
          );
        }));
  }
}
