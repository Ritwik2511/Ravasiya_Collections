// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';

import '../../generated/l10n.dart';
import '../../model/my_cart_data.dart';
import '../../model/product_review.dart';
import '../../routes/app_routes.dart';
import '../../woocommerce/models/product_variation.dart';
import '../../woocommerce/models/products.dart';

// ignore: must_be_immutable
class PlantDetail extends StatefulWidget {


  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail>
    with SingleTickerProviderStateMixin {
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  RxList<Attribute> selectedAttributes = <Attribute>[].obs;
  PageController sliderController = PageController();
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  HomeMainScreenController homeMainScreenController =
  Get.put(HomeMainScreenController());
  HomeScreenController putstorageController = Get.put(HomeScreenController());
  HomeScreenController storageController = Get.find<HomeScreenController>();
  LoginEmptyStateController loginController =
  Get.put(LoginEmptyStateController());
  ProductDataController productController = Get.put(ProductDataController());
  ZoomImageScreenController zoomImageScreenController =
  Get.put(ZoomImageScreenController());
  ToyDetailScreenController _toyDetailScreenController = Get.put(
      ToyDetailScreenController());


  List<WooProductVariation> listVariation = [];


  var html;
  var htmlDescription;
  var htmlDimention;


  bool blockScroll = false;

  RxList<String> favProductList = <String>[].obs;

  RxBool changeVariation = false.obs;
  late AnimationController animationController;
  int dialogSecond = 300;

  String id = "";


  List<WooProduct> plantList = [];


  Future<void> share() async {
    Share.share('${storageController.selectedProduct!.name}\n${Constant
        .webUrl}/product/' +
        storageController.selectedProduct!.name +
        '/');
  }

  getFavourit() {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  Future<List<WooProduct>> fetchData() async {
    plantList = [];
    _toyDetailScreenController.isPlantLoading.value = true;
    print("id=====================$id");
    try {
      // if (homeMainScreenController.checkNullOperator()) {
      //   return;
      // }

      final response = await homeMainScreenController.api1!.getWithout(
          "products/$id");
      WooProduct parseRes = WooProduct.fromJson(response);
      plantList.add(parseRes);
      // parseRes.map((e) => ;
      // setState(() {
      // plantList.addAll(postList);
      // if (plantList.isEmpty) {
      //   isPlantLoading = false;
      // } else {
      //   isPlantLoading = true;
      // }
      // });
      print("data=======================================${plantList}");
      _toyDetailScreenController.isPlantLoading.value = false;
      return plantList;
    } catch (e) {
      print('e============$e');
      _toyDetailScreenController.isPlantLoading.value = false;
      if (mounted) {}
    }
    _toyDetailScreenController.isPlantLoading.value = false;
    return [];
  }


  @override
  void initState() {
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = Duration(milliseconds: dialogSecond);
    animationController.reverseDuration = Duration(milliseconds: dialogSecond);

    fetchData();

    getVariations();
    cartControllerNew.getCartItem();
    Future.delayed(Duration.zero, () {
      _toyDetailScreenController.cleanReviewData();
      _toyDetailScreenController.fetchData(storageController);
    },);


    Future.delayed(
      Duration(milliseconds: 200),
          () {
        storageController.setCurrentQuantity(1, isRefresh: false);
        storageController.setPurchaseValue(false, isRefresh: false);
        checkAlreadyInCart();
      },
    );
    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });
    getFavourit();
    getCartIdList();
    getVariationIdList();
    super.initState();
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  getVariations() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }

    WooProduct selectedProduct1 = storageController.selectedProduct!;

    final response = await homeMainScreenController.api1!
        .getWithout("products/${selectedProduct1.id.toString()}/variations");
    List parseRes = response;
    listVariation =
        parseRes.map((e) => WooProductVariation.fromJson(e)).toList();

    if (listVariation.isNotEmpty) {
      if (storageController.attributeList.isNotEmpty) {
        storageController.attributeList.forEach((element) {
          selectedAttributes.add(Attribute(element.name, element.options[0]));
        });

        changeVariationValue();
      }
    }
  }

  checkAlreadyInCart() {
    if (cartControllerNew.cartOtherInfoList.isNotEmpty) {
      var selectedId = storageController.selectedProduct!.id;

      for (int i = 0; i < cartControllerNew.cartOtherInfoList.length; i++) {
        CartOtherInfo element = cartControllerNew.cartOtherInfoList[i];
        if (element.productId == selectedId) {
          storageController.setCurrentQuantity((element.quantity ?? 1));

          storageController.setPurchaseValue(true);

          return;
        }
        else {
          storageController.setCurrentQuantity(1, isRefresh: false);
          storageController.setPurchaseValue(false, isRefresh: false);
        }
      }
    }
    else {
      storageController.setCurrentQuantity(1, isRefresh: false);
      storageController.setPurchaseValue(false, isRefresh: false);
    }
  }

  List<int> cartIdList = [];

  List<int> variationIdList = [];


  getVariationIdList() async {
    variationIdList = await PrefData.getVariationIdList();
  }

  getCartIdList() async {
    cartIdList = await PrefData.getCartIdList();
  }

  @override
  Widget build(BuildContext context) {
    Tuple7<
        String?,
        String?,
        String?,
        String?,
        String?,
        String?,
        String?> tuple3 = ModalRoute
        .of(context)!
        .settings
        .arguments as Tuple7<
        String?,
        String?,
        String?,
        String?,
        String?,
        String?,
        String?>;

    id = tuple3.item1 ?? '';
    String tag = tuple3.item3 ?? '';
    String titletag = tuple3.item4 ?? '';
    String priceTag = tuple3.item5 ?? '';
    String ratingTag = tuple3.item6 ?? '';


    initializeScreenSize(context);

    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          storageController.clearProductVariation();
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
              child: Container(
                color: bgColor,
                child:
                GetBuilder<ToyDetailScreenController>(
                    init: ToyDetailScreenController(),
                    builder: (toyDetailScreenController) =>
                        // FutureBuilder(future: productDetailCache(
                        //   uniqueQueryKey: valueOrDefault("$id", "dddd"),
                        //   requestFn: () => fetchData(),),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasError) {
                        //       return Center(child: Text(
                        //           'Error${snapshot.error}'));
                        //     }
                        //     if (snapshot.hasData) {
                        //       List<WooProduct> list = snapshot.data as List<
                        //           WooProduct>;
                        //       WooProduct product = list[0];
                        //       return Stack(
                        //         children: [
                        //           SmartRefresher(
                        //             controller: refreshController,
                        //             onRefresh: () =>
                        //                 Future.sync(
                        //                       () {
                        //                     // pagingController.refresh();
                        //                     refreshController
                        //                         .refreshCompleted();
                        //                     setState(() {
                        //                       productDetailCache(
                        //                           overrideCache: true,
                        //                           uniqueQueryKey: valueOrDefault(
                        //                               "$id", "dddd"),
                        //                           requestFn: () => fetchData());
                        //                     });
                        //                     print(
                        //                         "====================refresh");
                        //                   },
                        //                 ),
                        //             child: CustomScrollView(
                        //               shrinkWrap: true,
                        //               primary: true,
                        //               physics: blockScroll
                        //                   ? NeverScrollableScrollPhysics()
                        //                   : BouncingScrollPhysics(),
                        //               slivers: [
                        //                 SliverAppBar(
                        //                   toolbarHeight: 58.h,
                        //                   backgroundColor: Colors.transparent,
                        //                   expandedHeight: 379.h,
                        //                   leadingWidth: 58.h,
                        //                   leading: GestureDetector(
                        //                     onTap: () {
                        //                       storageController
                        //                           .clearProductVariation();
                        //
                        //                       Get.back();
                        //                     },
                        //
                        //                     child: Container(
                        //                       margin: EdgeInsetsDirectional
                        //                           .only(
                        //                           top: 14.h
                        //                           , bottom: 6.h, start: 20.h),
                        //                       height: 38.h,
                        //                       width: 38.h,
                        //                       decoration: BoxDecoration(
                        //                           shape: BoxShape
                        //                               .circle,
                        //                           color: bgColor),
                        //                       child: getSvgImage(
                        //                           "arrow_square_left.svg",
                        //                           width: 24.h,
                        //                           height: 24.h,
                        //                           color: regularBlack)
                        //                           .paddingAll(9.h),
                        //                     ),
                        //                   ),
                        //
                        //                   actions: [
                        //                     GestureDetector(
                        //                       onTap: () {
                        //                         share();
                        //                       },
                        //                       child: Container(
                        //                         margin: EdgeInsetsDirectional
                        //                             .only(
                        //                             end: 16.h,
                        //                             top: 14.h,
                        //                             bottom: 6.h),
                        //                         height: 38.h,
                        //                         width: 38.h,
                        //                         decoration: BoxDecoration(
                        //                             shape: BoxShape.circle,
                        //                             color: bgColor),
                        //                         child: getSvgImage(
                        //                             "share_icon.svg")
                        //                             .paddingAll(9.h),
                        //                       ),
                        //                     ),
                        //                     getHorSpace(16.h),
                        //                     GetBuilder<CartControllerNew>(
                        //                       init: CartControllerNew(),
                        //                       builder: (controller) =>
                        //                           GestureDetector(
                        //                               onTap: () {
                        //                                 // storageController.clearProductVariation();
                        //                                 homeMainScreenController
                        //                                     .change(
                        //                                     2);
                        //                                 Get.toNamed(
                        //                                     Routes
                        //                                         .homeMainRoute);
                        //                               },
                        //                               child: Padding(
                        //                                 padding: EdgeInsetsDirectional
                        //                                     .only(
                        //                                     end: 20.h,
                        //                                     top: 14.h,
                        //                                     bottom: 6.h),
                        //                                 child: Stack(
                        //                                   children: [
                        //                                     Container(
                        //                                       height: 38.h,
                        //                                       width: 38.h,
                        //                                       decoration: BoxDecoration(
                        //                                           shape: BoxShape
                        //                                               .circle,
                        //                                           color: bgColor),
                        //                                       child: getSvgImage(
                        //                                           "cart_icon.svg",
                        //                                           color: regularBlack)
                        //                                           .paddingAll(
                        //                                           9.h),
                        //                                     ),
                        //                                     controller
                        //                                         .cartOtherInfoList
                        //                                         .isNotEmpty
                        //                                         ? Container(
                        //                                       height: 20.h,
                        //                                       width: 20.h,
                        //                                       margin: EdgeInsetsDirectional
                        //                                           .only(
                        //                                           start: 27
                        //                                               .h),
                        //                                       decoration: BoxDecoration(
                        //                                           shape: BoxShape
                        //                                               .circle,
                        //                                           color: buttonColor),
                        //                                       child: Center(
                        //                                           child: getCustomFont(
                        //                                               controller
                        //                                                   .cartOtherInfoList
                        //                                                   .length
                        //                                                   .toString(),
                        //                                               14.sp,
                        //                                               regularWhite,
                        //                                               1,
                        //                                               fontWeight:
                        //                                               FontWeight
                        //                                                   .w400)),
                        //                                     )
                        //                                     // .paddingOnly(left: 27.h)
                        //                                         : SizedBox(),
                        //                                   ],
                        //                                 ),
                        //                               )
                        //
                        //                           ),
                        //                     )
                        //                   ],
                        //                   flexibleSpace: FlexibleSpaceBar(
                        //                     background: Container(
                        //                         width: double.infinity,
                        //                         color: regularWhite,
                        //                         child: Stack(
                        //                           children: [
                        //                             // Container(
                        //                             //   height: 102.h,
                        //                             //   decoration: BoxDecoration(
                        //                             //       gradient: LinearGradient(
                        //                             //           stops: [0.0, 1.0],
                        //                             //           begin: Alignment
                        //                             //               .topCenter,
                        //                             //           end: Alignment
                        //                             //               .bottomCenter,
                        //                             //           colors: [
                        //                             //             "#52000000".toColor(),
                        //                             //             "#00000000".toColor(),
                        //                             //           ])),
                        //                             // ),
                        //                             Container(
                        //                                 margin:
                        //                                 EdgeInsets.only(
                        //                                     top: 68.h),
                        //                                 height: 261.h,
                        //                                 width: double
                        //                                     .infinity,
                        //                                 child: PageView
                        //                                     .builder(
                        //                                     controller: sliderController,
                        //                                     onPageChanged: (
                        //                                         index) {
                        //                                       toyDetailScreenController
                        //                                           .onPageChange(
                        //                                           index);
                        //                                     },
                        //                                     itemCount: storageController
                        //                                         .selectedProduct!
                        //                                         .images
                        //                                         .length,
                        //                                     itemBuilder:
                        //                                         (context,
                        //                                         index) {
                        //                                       return Padding(
                        //                                         padding:
                        //                                         EdgeInsets
                        //                                             .symmetric(
                        //                                             horizontal: 43
                        //                                                 .h),
                        //                                         child: storageController
                        //                                             .selectedProduct!
                        //                                             .images[index]
                        //                                             .src
                        //                                             .isEmpty ||
                        //                                             storageController
                        //                                                 .selectedProduct!
                        //                                                 .images[
                        //                                             index]
                        //                                                 .src ==
                        //                                                 Null
                        //                                             ? getMultilineCustomFont(
                        //                                             storageController
                        //                                                 .selectedProduct!
                        //                                                 .images[0]
                        //                                                 .alt as String,
                        //                                             16.sp,
                        //                                             regularBlack)
                        //                                             : GestureDetector(
                        //                                           onTap: () {
                        //                                             zoomImageScreenController
                        //                                                 .onPageChange(
                        //                                                 index);
                        //                                             Get
                        //                                                 .toNamed(
                        //                                                 Routes
                        //                                                     .zoomImageRoute,
                        //
                        //                                                 arguments: storageController
                        //                                                     .selectedProduct!);
                        //                                           },
                        //                                           child: Hero(
                        //                                             tag:
                        //                                             tag,
                        //
                        //                                             child:
                        //                                             CachedNetworkImage(
                        //                                                 imageUrl: storageController
                        //                                                     .selectedProduct!
                        //                                                     .images[
                        //                                                 index]
                        //                                                     .src,
                        //                                                 placeholder: (
                        //                                                     context,
                        //                                                     url) =>
                        //                                                     Center(
                        //                                                         child:
                        //                                                         CircularProgressIndicator(
                        //                                                           color: buttonColor,
                        //                                                         )),
                        //                                                 errorWidget: (
                        //                                                     context,
                        //                                                     url,
                        //                                                     error) =>
                        //                                                     getAssetImage(
                        //                                                         "no_image_banner.png")),
                        //                                             transitionOnUserGestures: true,
                        //                                           ),
                        //                                         ),
                        //                                       );
                        //                                     })),
                        //                             Align(
                        //                               alignment: Alignment
                        //                                   .bottomCenter,
                        //                               child: Row(
                        //                                 mainAxisAlignment:
                        //                                 MainAxisAlignment
                        //                                     .spaceBetween,
                        //                                 children: [
                        //                                   Container(
                        //                                       height: 36.h,
                        //                                       width: 68.h,
                        //                                       decoration: BoxDecoration(
                        //                                         borderRadius:
                        //                                         BorderRadius
                        //                                             .circular(
                        //                                             24.h),
                        //                                         color: dividerColor,
                        //                                       ),
                        //                                       child: Center(
                        //                                         child: Row(
                        //                                           mainAxisSize:
                        //                                           MainAxisSize
                        //                                               .min,
                        //                                           children: [
                        //                                             getCustomFont(
                        //                                                 "${toyDetailScreenController
                        //                                                     .currentPage +
                        //                                                     1}",
                        //                                                 16.sp,
                        //                                                 buttonColor,
                        //                                                 1,
                        //                                                 fontWeight:
                        //                                                 FontWeight
                        //                                                     .w400),
                        //                                             getCustomFont(
                        //                                                 "/${storageController
                        //                                                     .selectedProduct!
                        //                                                     .images
                        //                                                     .length
                        //                                                     .toString()}",
                        //                                                 14.sp,
                        //                                                 regularBlack,
                        //                                                 1,
                        //                                                 fontWeight:
                        //                                                 FontWeight
                        //                                                     .w400),
                        //                                           ],
                        //                                         ),
                        //                                       )),
                        //                                   storageController
                        //                                       .selectedProduct!
                        //                                       .onSale
                        //                                       ? Container(
                        //                                     padding: EdgeInsets
                        //                                         .symmetric(
                        //                                         vertical: 2.h,
                        //                                         horizontal:
                        //                                         8.h),
                        //                                     decoration: BoxDecoration(
                        //                                         color: buttonColor,
                        //                                         borderRadius:
                        //                                         BorderRadius
                        //                                             .circular(
                        //                                             12.h)),
                        //                                     child: getCustomFont(
                        //                                         S
                        //                                             .of(
                        //                                             context)
                        //                                             .sale,
                        //                                         12.sp,
                        //                                         Colors.white,
                        //                                         1,
                        //                                         fontWeight:
                        //                                         FontWeight
                        //                                             .w400,
                        //                                         textAlign: TextAlign
                        //                                             .center),
                        //                                   )
                        //                                       : SizedBox(),
                        //                                 ],
                        //                               ).paddingOnly(
                        //                                   left: 20.h,
                        //                                   right: 20.h,
                        //                                   bottom: 20.h),
                        //                             ),
                        //                           ],
                        //                         )),
                        //                   ),
                        //                 ),
                        //                 GetBuilder<HomeScreenController>(
                        //                     init: HomeScreenController(),
                        //                     builder:
                        //                         (homeScreenController) =>
                        //                         GetBuilder<
                        //                             LoginEmptyStateController>(
                        //                           init: LoginEmptyStateController(),
                        //                           builder: (loginController) =>
                        //                               SliverList(
                        //                                 delegate:
                        //                                 SliverChildListDelegate(
                        //                                     [
                        //                                       ListView(
                        //                                         primary: false,
                        //                                         shrinkWrap: true,
                        //                                         physics:
                        //                                         const NeverScrollableScrollPhysics(),
                        //                                         children: [
                        //                                           getVerSpace(
                        //                                               20.h),
                        //                                           Container(
                        //                                             color: regularWhite,
                        //                                             width: double
                        //                                                 .infinity,
                        //                                             child: Column(
                        //                                               crossAxisAlignment:
                        //                                               CrossAxisAlignment
                        //                                                   .start,
                        //                                               children: [
                        //                                                 Row(
                        //                                                   mainAxisAlignment:
                        //                                                   MainAxisAlignment
                        //                                                       .spaceBetween,
                        //                                                   crossAxisAlignment:
                        //                                                   CrossAxisAlignment
                        //                                                       .start,
                        //                                                   children: [
                        //                                                     Container(
                        //                                                       width: 243
                        //                                                           .h,
                        //                                                       child: Hero(
                        //                                                         transitionOnUserGestures: true,
                        //                                                         tag: titletag,
                        //                                                         child: getMultilineCustomFont(
                        //                                                             "${product
                        //                                                                 .name}",
                        //                                                             // "${storageController
                        //                                                             //     .selectedProduct!
                        //                                                             //     .name}",
                        //                                                             18
                        //                                                                 .sp,
                        //                                                             regularBlack,
                        //                                                             fontWeight:
                        //                                                             FontWeight
                        //                                                                 .w700,
                        //                                                             overflow:
                        //                                                             TextOverflow
                        //                                                                 .ellipsis),
                        //                                                       ),
                        //                                                     ),
                        //                                                     // GestureDetector(
                        //                                                     //   onTap: () {
                        //                                                     //     checkInFavouriteList(
                        //                                                     //         storageController
                        //                                                     //             .selectedProduct!);
                        //                                                     //     List<
                        //                                                     //         String>
                        //                                                     //     strList =
                        //                                                     //     favProductList
                        //                                                     //         .map((
                        //                                                     //         i) =>
                        //                                                     //         i
                        //                                                     //             .toString())
                        //                                                     //         .toList();
                        //                                                     //     PrefData()
                        //                                                     //         .setFavouriteList(
                        //                                                     //         strList);
                        //                                                     //   },
                        //                                                     //   child: Obx(
                        //                                                     //         () {
                        //                                                     //       return Align(
                        //                                                     //         alignment:
                        //                                                     //         Alignment
                        //                                                     //             .centerRight,
                        //                                                     //         child: getAssetImage(
                        //                                                     //             favProductList
                        //                                                     //                 .contains(
                        //                                                     //                 storageController
                        //                                                     //                     .selectedProduct!
                        //                                                     //                     .id
                        //                                                     //                     .toString())
                        //                                                     //                 ? "likefillIcon.png"
                        //                                                     //                 : "likeIcon.png",
                        //                                                     //             height: 20
                        //                                                     //                 .h,
                        //                                                     //             width:
                        //                                                     //             20
                        //                                                     //                 .h),
                        //                                                     //       );
                        //                                                     //     },
                        //                                                     //   ),
                        //                                                     // ),
                        //                                                   ],
                        //                                                 ),
                        //                                                 getVerSpace(
                        //                                                     8
                        //                                                         .h),
                        //                                                 GetBuilder<
                        //                                                     HomeScreenController>(
                        //                                                   init:
                        //                                                   HomeScreenController(),
                        //                                                   builder:
                        //                                                       (
                        //                                                       controller) {
                        //                                                     return Row(
                        //                                                       crossAxisAlignment:
                        //                                                       CrossAxisAlignment
                        //                                                           .start,
                        //                                                       children: [
                        //                                                         Hero(
                        //                                                           transitionOnUserGestures: true,
                        //                                                           tag: priceTag,
                        //                                                           child: getCustomFont(
                        //                                                               (controller
                        //                                                                   .variationModel ==
                        //                                                                   null)
                        //                                                                   ? ((storageController
                        //                                                                   .selectedProduct!
                        //                                                                   .salePrice !=
                        //                                                                   Null &&
                        //                                                                   storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .salePrice
                        //                                                                       .isNotEmpty)
                        //                                                                   ? formatStringCurrency(
                        //                                                                   total: storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .salePrice,
                        //                                                                   context: context)
                        //                                                                   : formatStringCurrency(
                        //                                                                   total: storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .price,
                        //                                                                   context: context))
                        //                                                                   : formatStringCurrency(
                        //                                                                   total: (controller
                        //                                                                       .variationModel!
                        //                                                                       .salePrice!
                        //                                                                       .isNotEmpty)
                        //                                                                       ? (controller
                        //                                                                       .variationModel!
                        //                                                                       .salePrice ??
                        //                                                                       "")
                        //                                                                       : controller
                        //                                                                       .variationModel!
                        //                                                                       .regularPrice,
                        //                                                                   context: context),
                        //                                                               20
                        //                                                                   .sp,
                        //                                                               regularBlack,
                        //                                                               1,
                        //                                                               fontWeight: FontWeight
                        //                                                                   .w700),
                        //                                                         ),
                        //                                                         getHorSpace(
                        //                                                             8
                        //                                                                 .h),
                        //                                                         storageController
                        //                                                             .selectedProduct!
                        //                                                             .onSale
                        //                                                             ? Row(
                        //                                                           children: [
                        //                                                             Text(
                        //                                                               (storageController
                        //                                                                   .selectedProduct!
                        //                                                                   .salePrice !=
                        //                                                                   Null &&
                        //                                                                   storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .salePrice
                        //                                                                       .isNotEmpty)
                        //                                                                   ? formatStringCurrency(
                        //                                                                   total: storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .regularPrice,
                        //                                                                   context: context)
                        //                                                                   : formatStringCurrency(
                        //                                                                   total: storageController
                        //                                                                       .selectedProduct!
                        //                                                                       .price,
                        //                                                                   context: context),
                        //                                                               style: TextStyle(
                        //                                                                   decoration: TextDecoration
                        //                                                                       .lineThrough,
                        //                                                                   fontSize: 18
                        //                                                                       .sp,
                        //                                                                   color: Colors
                        //                                                                       .grey,
                        //                                                                   fontWeight: FontWeight
                        //                                                                       .w400,
                        //                                                                   fontFamily: Constant
                        //                                                                       .fontsFamily),
                        //                                                             ),
                        //                                                             getHorSpace(
                        //                                                                 6
                        //                                                                     .h),
                        //                                                             (storageController
                        //                                                                 .selectedProduct!
                        //                                                                 .onSale)
                        //                                                                 ? getCustomFont(
                        //                                                                 (homeScreenController
                        //                                                                     .variationModel ==
                        //                                                                     null)
                        //                                                                     ? "${100 *
                        //                                                                     (double
                        //                                                                         .parse(
                        //                                                                         storageController
                        //                                                                             .selectedProduct!
                        //                                                                             .regularPrice) -
                        //                                                                         double
                        //                                                                             .parse(
                        //                                                                             storageController
                        //                                                                                 .selectedProduct!
                        //                                                                                 .salePrice)) ~/
                        //                                                                     double
                        //                                                                         .parse(
                        //                                                                         storageController
                        //                                                                             .selectedProduct!
                        //                                                                             .regularPrice)}% OFF"
                        //                                                                     ""
                        //                                                                     : getCurrency(
                        //                                                                     context) +
                        //                                                                     homeScreenController
                        //                                                                         .variationModel!
                        //                                                                         .regularPrice ??
                        //                                                                     "",
                        //                                                                 18
                        //                                                                     .sp,
                        //                                                                 buttonColor,
                        //                                                                 1,
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w600)
                        //                                                                 : SizedBox(),
                        //                                                           ],
                        //                                                         )
                        //                                                             : SizedBox(),
                        //                                                         getVerSpace(
                        //                                                             2.5
                        //                                                                 .h),
                        //                                                         Spacer(),
                        //                                                         storageController
                        //                                                             .selectedProduct!
                        //                                                             .stockStatus ==
                        //                                                             'outofstock'
                        //                                                             ? getCustomFont(
                        //                                                             "Out of Stock",
                        //                                                             18
                        //                                                                 .sp,
                        //                                                             buttonColor,
                        //                                                             1,
                        //                                                             fontWeight: FontWeight
                        //                                                                 .w600)
                        //                                                             : SizedBox(),
                        //                                                       ],
                        //                                                     );
                        //                                                   },
                        //                                                 ),
                        //                                                 storageController
                        //                                                     .selectedProduct!
                        //                                                     .averageRating !=
                        //                                                     "0.00"
                        //                                                     ? getVerSpace(
                        //                                                     6
                        //                                                         .h)
                        //                                                     : getVerSpace(
                        //                                                     0
                        //                                                         .h),
                        //                                                 storageController
                        //                                                     .selectedProduct!
                        //                                                     .averageRating !=
                        //                                                     "0.00"
                        //                                                     ? Column(
                        //                                                     crossAxisAlignment:
                        //                                                     CrossAxisAlignment
                        //                                                         .start,
                        //                                                     mainAxisAlignment:
                        //                                                     MainAxisAlignment
                        //                                                         .start,
                        //                                                     children: [
                        //                                                       storageController
                        //                                                           .selectedProduct!
                        //                                                           .averageRating !=
                        //                                                           "0.00"
                        //                                                           ? Hero(
                        //                                                         transitionOnUserGestures: true,
                        //                                                         tag: ratingTag,
                        //                                                         child: Row(
                        //                                                             children: [
                        //                                                               RatingBar(
                        //                                                                 ignoreGestures: true,
                        //                                                                 initialRating: double
                        //                                                                     .parse(
                        //                                                                     storageController
                        //                                                                         .selectedProduct!
                        //                                                                         .averageRating),
                        //                                                                 direction: Axis
                        //                                                                     .horizontal,
                        //                                                                 allowHalfRating: false,
                        //                                                                 itemCount: 5,
                        //                                                                 itemSize: 15
                        //                                                                     .h,
                        //                                                                 ratingWidget: RatingWidget(
                        //                                                                   full: getSvgImage(
                        //                                                                       "img_star_amber_600.svg",
                        //                                                                       height: 15
                        //                                                                           .h,
                        //                                                                       width: 15
                        //                                                                           .h),
                        //                                                                   half: getSvgImage(
                        //                                                                       "img_star_amber_600.svg",
                        //                                                                       height: 15
                        //                                                                           .h,
                        //                                                                       width: 15
                        //                                                                           .h),
                        //                                                                   empty: getSvgImage(
                        //                                                                       "img_vuesaxlinearstar.svg",
                        //                                                                       height: 15
                        //                                                                           .h,
                        //                                                                       width: 15
                        //                                                                           .h),
                        //                                                                 ),
                        //                                                                 onRatingUpdate: (
                        //                                                                     double value) {},
                        //                                                               ),
                        //                                                               Padding(
                        //                                                                   padding: EdgeInsets
                        //                                                                       .only(
                        //                                                                       left: 6
                        //                                                                           .h),
                        //                                                                   child: getCustomFont(
                        //                                                                     // "${productReviewList
                        //                                                                     //     .length} ${S
                        //                                                                     //     .of(
                        //                                                                     //     context)
                        //                                                                     //     .reviews}",
                        //                                                                       "${homeScreenController
                        //                                                                           .selectedProduct!
                        //                                                                           .ratingCount} ${S
                        //                                                                           .of(
                        //                                                                           context)
                        //                                                                           .reviews}",
                        //                                                                       14
                        //                                                                           .sp,
                        //                                                                       darkGray,
                        //                                                                       1,
                        //                                                                       fontWeight: FontWeight
                        //                                                                           .w400))
                        //                                                             ]),
                        //                                                       )
                        //                                                           : SizedBox(),
                        //                                                       getVerSpace(
                        //                                                           6
                        //                                                               .h),
                        //                                                     ])
                        //                                                     : getVerSpace(
                        //                                                     0
                        //                                                         .h),
                        //                                               ],
                        //                                             )
                        //                                                 .paddingSymmetric(
                        //                                                 horizontal: 20
                        //                                                     .h,
                        //                                                 vertical: 20
                        //                                                     .h),
                        //                                           ),
                        //
                        //                                           storageController
                        //                                               .selectedProduct!
                        //                                               .onSale &&
                        //                                               (storageController
                        //                                                   .selectedProduct!
                        //                                                   .dateOnSaleFrom ==
                        //                                                   Null ||
                        //                                                   storageController
                        //                                                       .selectedProduct!
                        //                                                       .dateOnSaleTo ==
                        //                                                       Null)
                        //                                               ? getVerSpace(
                        //                                               20.h)
                        //                                               : getVerSpace(
                        //                                               0.h),
                        //                                           storageController
                        //                                               .selectedProduct!
                        //                                               .onSale &&
                        //                                               (storageController
                        //                                                   .selectedProduct!
                        //                                                   .dateOnSaleFrom ==
                        //                                                   Null ||
                        //                                                   storageController
                        //                                                       .selectedProduct!
                        //                                                       .dateOnSaleTo ==
                        //                                                       Null)
                        //                                               ? Container(
                        //                                             width:
                        //                                             double
                        //                                                 .infinity,
                        //                                             color: regularWhite,
                        //                                             child: Column(
                        //                                               crossAxisAlignment:
                        //                                               CrossAxisAlignment
                        //                                                   .start,
                        //                                               children: [
                        //                                                 getCustomFont(
                        //                                                   S
                        //                                                       .of(
                        //                                                       context)
                        //                                                       .upcomingSaleOnThisItem,
                        //                                                   14
                        //                                                       .sp,
                        //                                                   regularBlack,
                        //                                                   1,
                        //                                                 ),
                        //                                                 getVerSpace(
                        //                                                     8
                        //                                                         .h),
                        //                                                 Container(
                        //                                                     decoration: BoxDecoration(
                        //                                                         borderRadius:
                        //                                                         BorderRadius
                        //                                                             .circular(
                        //                                                             8
                        //                                                                 .h),
                        //                                                         color: Color(
                        //                                                             0XFFECF5EF)),
                        //                                                     child: getMultilineCustomFont(
                        //                                                         "${S
                        //                                                             .of(
                        //                                                             context)
                        //                                                             .saleStartFrom} ${DateFormat(
                        //                                                             "dd MMM,yyyy")
                        //                                                             .format(
                        //                                                             storageController
                        //                                                                 .selectedProduct!
                        //                                                                 .dateOnSaleFrom)} ${S
                        //                                                             .of(
                        //                                                             context)
                        //                                                             .to} ${DateFormat(
                        //                                                             "dd MMM,yyyy")
                        //                                                             .format(
                        //                                                             storageController
                        //                                                                 .selectedProduct!
                        //                                                                 .dateOnSaleTo)}. ${S
                        //                                                             .of(
                        //                                                             context)
                        //                                                             .getAmazingDiscountOnProducts}",
                        //                                                         14
                        //                                                             .sp,
                        //                                                         regularBlack,
                        //                                                         fontWeight: FontWeight
                        //                                                             .w400)
                        //                                                         .paddingAll(
                        //                                                         10
                        //                                                             .h))
                        //                                               ],
                        //                                             )
                        //                                                 .paddingSymmetric(
                        //                                                 horizontal:
                        //                                                 20.h,
                        //                                                 vertical: 20
                        //                                                     .h),
                        //                                           )
                        //                                               : SizedBox(),
                        //                                           getVerSpace(
                        //                                               20.h),
                        //                                           Container(
                        //                                               width: double
                        //                                                   .infinity,
                        //                                               color: regularWhite,
                        //                                               child: Column(
                        //                                                   children: [
                        //                                                     Row(
                        //                                                       children: [
                        //                                                         GestureDetector(
                        //                                                             onTap:
                        //                                                                 () {
                        //                                                               toyDetailScreenController
                        //                                                                   .setcontent(
                        //                                                                   1);
                        //                                                             },
                        //                                                             child: Container(
                        //                                                                 decoration: toyDetailScreenController
                        //                                                                     .content ==
                        //                                                                     1
                        //                                                                     ? BoxDecoration(
                        //                                                                     border: Border(
                        //                                                                         bottom: BorderSide(
                        //                                                                             color: regularBlack)))
                        //                                                                     : BoxDecoration(),
                        //                                                                 child: getCustomFont(
                        //                                                                     S
                        //                                                                         .of(
                        //                                                                         context)
                        //                                                                         .description,
                        //                                                                     16
                        //                                                                         .sp,
                        //                                                                     toyDetailScreenController
                        //                                                                         .content ==
                        //                                                                         1
                        //                                                                         ? regularBlack
                        //                                                                         : darkGray,
                        //                                                                     1,
                        //                                                                     fontWeight: toyDetailScreenController
                        //                                                                         .content ==
                        //                                                                         1
                        //                                                                         ? FontWeight
                        //                                                                         .w600
                        //                                                                         : FontWeight
                        //                                                                         .w400)
                        //                                                                     .paddingOnly(
                        //                                                                     bottom: 2
                        //                                                                         .h))),
                        //                                                         getHorSpace(
                        //                                                             16
                        //                                                                 .h),
                        //                                                         product
                        //                                                             .shortDescription
                        //                                                             .isEmpty
                        //                                                             ? SizedBox()
                        //                                                             : GestureDetector(
                        //                                                             onTap:
                        //                                                                 () {
                        //                                                               toyDetailScreenController
                        //                                                                   .setcontent(
                        //                                                                   2);
                        //                                                             },
                        //                                                             child: Container(
                        //                                                                 decoration: toyDetailScreenController
                        //                                                                     .content ==
                        //                                                                     2
                        //                                                                     ? BoxDecoration(
                        //                                                                     border: Border(
                        //                                                                         bottom: BorderSide(
                        //                                                                             color: regularBlack)))
                        //                                                                     : BoxDecoration(),
                        //                                                                 child: getCustomFont(
                        //                                                                     S
                        //                                                                         .of(
                        //                                                                         context)
                        //                                                                         .information,
                        //                                                                     16
                        //                                                                         .sp,
                        //                                                                     toyDetailScreenController
                        //                                                                         .content ==
                        //                                                                         2
                        //                                                                         ? regularBlack
                        //                                                                         : darkGray,
                        //                                                                     1,
                        //                                                                     fontWeight: toyDetailScreenController
                        //                                                                         .content ==
                        //                                                                         2
                        //                                                                         ? FontWeight
                        //                                                                         .w600
                        //                                                                         : FontWeight
                        //                                                                         .w400)
                        //                                                                     .paddingOnly(
                        //                                                                     bottom: 2
                        //                                                                         .h))),
                        //                                                       ],
                        //                                                     ),
                        //                                                     toyDetailScreenController
                        //                                                         .content ==
                        //                                                         1
                        //                                                         ?
                        //                                                     htmlDescription =
                        //                                                         Html(
                        //                                                           data: product
                        //                                                               .description,
                        //                                                           style: {
                        //                                                             "h5": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     18
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w700,
                        //                                                                 color: regularBlack),
                        //                                                             "p": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     16
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w400,
                        //                                                                 color: regularBlack),
                        //                                                             "li": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     16
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w400,
                        //                                                                 color: regularBlack),
                        //                                                           },
                        //                                                         )
                        //                                                         : html =
                        //                                                         Html(
                        //                                                           data: product
                        //                                                               .shortDescription,
                        //                                                           style: {
                        //                                                             "h5": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     18
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w700,
                        //                                                                 color: regularBlack),
                        //                                                             "p": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     16
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w400,
                        //                                                                 color: regularBlack),
                        //                                                             "li": Style(
                        //                                                                 fontSize: FontSize(
                        //                                                                     16
                        //                                                                         .sp),
                        //                                                                 fontWeight: FontWeight
                        //                                                                     .w400,
                        //                                                                 color: regularBlack),
                        //                                                           },
                        //                                                         )
                        //                                                             .paddingSymmetric(
                        //                                                             horizontal: 0
                        //                                                                 .h),
                        //                                                   ])
                        //                                                   .paddingSymmetric(
                        //                                                   horizontal: 20
                        //                                                       .h,
                        //                                                   vertical: 20
                        //                                                       .h)),
                        //                                           buildReviewList(
                        //                                               toyDetailScreenController),
                        //                                           storageController
                        //                                               .selectedProduct!
                        //                                               .upsellIds
                        //                                               .isNotEmpty
                        //                                               ? getCustomContainer(
                        //                                             315.h,
                        //                                             double
                        //                                                 .infinity,
                        //                                             color: regularWhite,
                        //                                             child: Column(
                        //                                               crossAxisAlignment:
                        //                                               CrossAxisAlignment
                        //                                                   .start,
                        //                                               children: [
                        //                                                 Row(
                        //                                                   mainAxisAlignment:
                        //                                                   MainAxisAlignment
                        //                                                       .spaceBetween,
                        //                                                   children: [
                        //                                                     getCustomFont(
                        //                                                         S
                        //                                                             .of(
                        //                                                             context)
                        //                                                             .youMayAlsoLike,
                        //                                                         20
                        //                                                             .sp,
                        //                                                         regularBlack,
                        //                                                         1,
                        //                                                         txtHeight:
                        //                                                         1.5
                        //                                                             .h,
                        //                                                         fontWeight:
                        //                                                         FontWeight
                        //                                                             .w700),
                        //                                                     cartControllerNew
                        //                                                         .upsellProduct
                        //                                                         .isEmpty
                        //                                                         ? SizedBox()
                        //                                                         : GestureDetector(
                        //                                                         onTap:
                        //                                                             () {
                        //                                                           Get
                        //                                                               .toNamed(
                        //                                                               Routes
                        //                                                                   .upsellProductRoute)!
                        //                                                               .then((
                        //                                                               value) {
                        //                                                             getFavDataList();
                        //                                                           });
                        //                                                         },
                        //                                                         child:
                        //                                                         Container(
                        //                                                           height: 29
                        //                                                               .h,
                        //                                                           decoration: BoxDecoration(
                        //                                                               color: gray,
                        //                                                               borderRadius: BorderRadius
                        //                                                                   .circular(
                        //                                                                   30
                        //                                                                       .h)),
                        //                                                           alignment: Alignment
                        //                                                               .center,
                        //                                                           child: getCustomFont(
                        //                                                               S
                        //                                                                   .of(
                        //                                                                   context)
                        //                                                                   .viewAll,
                        //                                                               14
                        //                                                                   .sp,
                        //                                                               darkGray,
                        //                                                               1,
                        //                                                               fontWeight: FontWeight
                        //                                                                   .w400,
                        //                                                               txtHeight: 1.5
                        //                                                                   .h,
                        //                                                               textAlign: TextAlign
                        //                                                                   .center)
                        //                                                               .paddingSymmetric(
                        //                                                               horizontal: 10
                        //                                                                   .h),
                        //                                                         ))
                        //                                                   ],
                        //                                                 )
                        //                                                     .marginSymmetric(
                        //                                                     horizontal:
                        //                                                     20
                        //                                                         .h),
                        //                                                 getVerSpace(
                        //                                                     15
                        //                                                         .h),
                        //                                                 SizedBox(
                        //                                                   height: 280
                        //                                                       .h,
                        //                                                   child: ListView
                        //                                                       .separated(
                        //                                                     separatorBuilder: (
                        //                                                         context,
                        //                                                         index) {
                        //                                                       return getHorSpace(
                        //                                                           20
                        //                                                               .h);
                        //                                                     },
                        //                                                     padding: EdgeInsets
                        //                                                         .symmetric(
                        //                                                         horizontal:
                        //                                                         20
                        //                                                             .h),
                        //                                                     scrollDirection:
                        //                                                     Axis
                        //                                                         .horizontal,
                        //                                                     itemCount: storageController
                        //                                                         .selectedProduct!
                        //                                                         .upsellIds
                        //                                                         .length,
                        //                                                     itemBuilder:
                        //                                                         (
                        //                                                         context,
                        //                                                         index) {
                        //                                                       if (homeMainScreenController
                        //                                                           .checkNullOperator()) {
                        //                                                         return Container();
                        //                                                       }
                        //                                                       return FutureBuilder(
                        //                                                         future: homeMainScreenController
                        //                                                             .wooCommerce1!
                        //                                                             .getYouProduct(
                        //                                                             wooCommerceAPI:
                        //                                                             homeMainScreenController
                        //                                                                 .api1!,
                        //                                                             id: storageController
                        //                                                                 .selectedProduct!
                        //                                                                 .upsellIds[index]),
                        //                                                         builder:
                        //                                                             (
                        //                                                             context,
                        //                                                             snapshot) {
                        //                                                           if (snapshot
                        //                                                               .hasData &&
                        //                                                               snapshot
                        //                                                                   .data !=
                        //                                                                   null) {
                        //                                                             WooProduct
                        //                                                             product =
                        //                                                             snapshot
                        //                                                                 .data!;
                        //                                                             return productDataFormateInListView(
                        //                                                                 context, () {
                        //                                                               homeScreenController
                        //                                                                   .setSelectedWooProduct(
                        //                                                                   product);
                        //                                                               Get
                        //                                                                   .back();
                        //                                                               storageController
                        //                                                                   .clearProductVariation();
                        //
                        //
                        //                                                               sendToPlanDetail(
                        //                                                                   id: product
                        //                                                                       .id
                        //                                                                       .toString(),
                        //                                                                   tag: "You may also like${index}${product
                        //                                                                       .images[0]
                        //                                                                       .src}",
                        //                                                                   function: () {
                        //                                                                     getFavDataList();
                        //                                                                   },
                        //                                                                   titleTag:
                        //                                                                   "You may also like${index}${product
                        //                                                                       .name}",
                        //                                                                   priceTag:
                        //                                                                   "You may also like${index}price",
                        //                                                                   ratingTag:
                        //                                                                   "You may also like${index}rating");
                        //
                        //
                        //                                                               // Get
                        //                                                               //     .to(
                        //                                                               //     PlantDetail(
                        //                                                               //       tag: "You may also like${index}${product
                        //                                                               //           .images[0]
                        //                                                               //           .src}",
                        //                                                               //     ))!
                        //                                                               //     .then((
                        //                                                               //     value) {
                        //                                                               //   getFavDataList();
                        //                                                               // });
                        //                                                               // Get.to(PlantDetail(detail: plantdata[index]));
                        //                                                               // Get.to(PlantDetail(detail: popularplantdata[index],));
                        //                                                             },
                        //                                                                 product,
                        //                                                                 InkWell(
                        //                                                                   onTap: () {
                        //                                                                     checkInFavouriteList(
                        //                                                                         product);
                        //                                                                     List<
                        //                                                                         String> strList = favProductList
                        //                                                                         .map((
                        //                                                                         i) =>
                        //                                                                         i
                        //                                                                             .toString())
                        //                                                                         .toList();
                        //                                                                     PrefData()
                        //                                                                         .setFavouriteList(
                        //                                                                         strList);
                        //                                                                     getFavourit();
                        //                                                                   },
                        //                                                                   child: Obx(
                        //                                                                         () {
                        //                                                                       return getSvgImage(
                        //                                                                           favProductList
                        //                                                                               .contains(
                        //                                                                               product
                        //                                                                                   .id
                        //                                                                                   .toString())
                        //                                                                               ? "likefillIconnew.svg"
                        //                                                                               : "likeIconnew.svg",
                        //                                                                           height: 22
                        //                                                                               .h,
                        //                                                                           width: 22
                        //                                                                               .h)
                        //                                                                           .marginOnly(
                        //                                                                           top: 10
                        //                                                                               .h,
                        //                                                                           right: 14
                        //                                                                               .h,
                        //                                                                           left: 15
                        //                                                                               .h);
                        //                                                                     },
                        //                                                                   ),
                        //                                                                 ),
                        //
                        //                                                                 index,
                        //                                                                 "You may also like",
                        //                                                                 homeMainScreenController)
                        //                                                             ;
                        //                                                           } else {
                        //                                                             return Container(
                        //                                                               height: 280
                        //                                                                   .h,
                        //                                                               child: ListView
                        //                                                                   .builder(
                        //                                                                 itemCount: storageController
                        //                                                                     .selectedProduct!
                        //                                                                     .upsellIds
                        //                                                                     .length <
                        //                                                                     3
                        //                                                                     ? storageController
                        //                                                                     .selectedProduct!
                        //                                                                     .upsellIds
                        //                                                                     .length
                        //                                                                     : 3,
                        //                                                                 primary: false,
                        //                                                                 shrinkWrap: true,
                        //                                                                 scrollDirection: Axis
                        //                                                                     .horizontal,
                        //                                                                 itemBuilder: (
                        //                                                                     context,
                        //                                                                     index) {
                        //                                                                   return Shimmer
                        //                                                                       .fromColors(
                        //                                                                     baseColor: Colors
                        //                                                                         .grey[300]!,
                        //                                                                     highlightColor:
                        //                                                                     Colors
                        //                                                                         .grey[100]!,
                        //                                                                     child: Container(
                        //                                                                         decoration: BoxDecoration(
                        //                                                                           borderRadius:
                        //                                                                           BorderRadius
                        //                                                                               .circular(
                        //                                                                               16
                        //                                                                                   .h),
                        //                                                                           border: Border
                        //                                                                               .all(
                        //                                                                               color: black20),
                        //                                                                         ),
                        //                                                                         // margin: EdgeInsets.only(
                        //                                                                         //   left: 20.h,
                        //                                                                         // ),
                        //                                                                         width: 207
                        //                                                                             .h,
                        //                                                                         height: double
                        //                                                                             .infinity,
                        //                                                                         child: Column(
                        //                                                                           mainAxisAlignment:
                        //                                                                           MainAxisAlignment
                        //                                                                               .start,
                        //                                                                           crossAxisAlignment:
                        //                                                                           CrossAxisAlignment
                        //                                                                               .start,
                        //                                                                           children: [
                        //                                                                             Align(
                        //                                                                               child: Container(
                        //                                                                                 margin:
                        //                                                                                 EdgeInsetsDirectional
                        //                                                                                     .only(
                        //                                                                                     top: 14
                        //                                                                                         .h),
                        //                                                                                 height: 138
                        //                                                                                     .h,
                        //                                                                                 width: 153
                        //                                                                                     .h,
                        //                                                                                 color: Colors
                        //                                                                                     .white,
                        //                                                                               ),
                        //                                                                               alignment:
                        //                                                                               AlignmentDirectional
                        //                                                                                   .topCenter,
                        //                                                                             ),
                        //                                                                             Spacer(),
                        //                                                                             Container(
                        //                                                                               height: 12
                        //                                                                                   .h,
                        //                                                                               width: 57
                        //                                                                                   .h,
                        //                                                                               color: Colors
                        //                                                                                   .white,
                        //                                                                             )
                        //                                                                                 .paddingSymmetric(
                        //                                                                                 horizontal: 12
                        //                                                                                     .h),
                        //                                                                             getVerSpace(
                        //                                                                                 6
                        //                                                                                     .h),
                        //                                                                             Container(
                        //                                                                               height: 21
                        //                                                                                   .h,
                        //                                                                               width: 153
                        //                                                                                   .h,
                        //                                                                               color: Colors
                        //                                                                                   .white,
                        //                                                                             )
                        //                                                                                 .paddingSymmetric(
                        //                                                                                 horizontal: 12
                        //                                                                                     .h),
                        //                                                                             getVerSpace(
                        //                                                                                 8
                        //                                                                                     .h),
                        //                                                                             Container(
                        //                                                                               height: 17
                        //                                                                                   .h,
                        //                                                                               width: 102
                        //                                                                                   .h,
                        //                                                                               color: Colors
                        //                                                                                   .white,
                        //                                                                             )
                        //                                                                                 .paddingSymmetric(
                        //                                                                                 horizontal: 12
                        //                                                                                     .h),
                        //                                                                             getVerSpace(
                        //                                                                                 4
                        //                                                                                     .h),
                        //                                                                             Container(
                        //                                                                               height: 24
                        //                                                                                   .h,
                        //                                                                               width: 52
                        //                                                                                   .h,
                        //                                                                               color: Colors
                        //                                                                                   .white,
                        //                                                                             )
                        //                                                                                 .paddingSymmetric(
                        //                                                                                 horizontal: 12
                        //                                                                                     .h),
                        //                                                                             getVerSpace(
                        //                                                                                 5
                        //                                                                                     .h),
                        //
                        //                                                                           ],
                        //                                                                         )),
                        //                                                                   );
                        //                                                                 },
                        //                                                               ),
                        //                                                             );
                        //                                                           }
                        //                                                         },
                        //                                                       );
                        //                                                     },
                        //                                                   ),
                        //                                                 ),
                        //                                                 getVerSpace(
                        //                                                     20
                        //                                                         .h),
                        //                                               ],
                        //                                             )
                        //                                                 .paddingOnly(
                        //                                               top: 18
                        //                                                   .h,
                        //                                             ),
                        //                                           )
                        //                                               .paddingOnly(
                        //                                               top: 20
                        //                                                   .h)
                        //                                               : SizedBox(),
                        //
                        //                                           storageController
                        //                                               .selectedProduct!
                        //                                               .relatedIds
                        //                                               .isNotEmpty
                        //                                               ? Container(
                        //                                             width:
                        //                                             double
                        //                                                 .infinity,
                        //                                             color: regularWhite,
                        //                                             child: Column(
                        //                                               crossAxisAlignment:
                        //                                               CrossAxisAlignment
                        //                                                   .start,
                        //                                               children: [
                        //                                                 Row(
                        //                                                   mainAxisAlignment:
                        //                                                   MainAxisAlignment
                        //                                                       .spaceBetween,
                        //                                                   children: [
                        //                                                     getCustomFont(
                        //                                                         S
                        //                                                             .of(
                        //                                                             context)
                        //                                                             .relatedProduct,
                        //                                                         20
                        //                                                             .sp,
                        //                                                         regularBlack,
                        //                                                         1,
                        //                                                         txtHeight:
                        //                                                         1.5
                        //                                                             .h,
                        //                                                         fontWeight:
                        //                                                         FontWeight
                        //                                                             .w700),
                        //                                                     GestureDetector(
                        //                                                         onTap:
                        //                                                             () {
                        //                                                           Get
                        //                                                               .toNamed(
                        //                                                               Routes
                        //                                                                   .relatedRoute)!
                        //                                                               .then((
                        //                                                               value) {
                        //                                                             getFavDataList();
                        //                                                           });
                        //                                                         },
                        //                                                         child:
                        //                                                         Container(
                        //                                                           height:
                        //                                                           29
                        //                                                               .h,
                        //                                                           decoration: BoxDecoration(
                        //                                                               color: gray,
                        //                                                               borderRadius: BorderRadius
                        //                                                                   .circular(
                        //                                                                   30
                        //                                                                       .h)),
                        //                                                           alignment:
                        //                                                           Alignment
                        //                                                               .center,
                        //                                                           child:
                        //                                                           getCustomFont(
                        //                                                               S
                        //                                                                   .of(
                        //                                                                   context)
                        //                                                                   .viewAll,
                        //                                                               14
                        //                                                                   .sp,
                        //                                                               darkGray,
                        //                                                               1,
                        //                                                               fontWeight: FontWeight
                        //                                                                   .w400,
                        //                                                               txtHeight: 1.5
                        //                                                                   .h,
                        //                                                               textAlign: TextAlign
                        //                                                                   .center)
                        //                                                               .paddingSymmetric(
                        //                                                               horizontal: 10
                        //                                                                   .h),
                        //                                                         ))
                        //                                                   ],
                        //                                                 )
                        //                                                     .marginSymmetric(
                        //                                                     horizontal:
                        //                                                     20
                        //                                                         .h),
                        //                                                 getVerSpace(
                        //                                                     15
                        //                                                         .h),
                        //                                                 storageController
                        //                                                     .selectedProduct!
                        //                                                     .relatedIds
                        //                                                     .isNotEmpty
                        //                                                     ? Container(
                        //                                                   height:
                        //                                                   280
                        //                                                       .h,
                        //                                                   child: ListView
                        //                                                       .separated(
                        //                                                     separatorBuilder: (
                        //                                                         context,
                        //                                                         index) {
                        //                                                       return getHorSpace(
                        //                                                           20
                        //                                                               .h);
                        //                                                     },
                        //                                                     primary:
                        //                                                     false,
                        //                                                     shrinkWrap:
                        //                                                     true,
                        //                                                     physics:
                        //                                                     BouncingScrollPhysics(),
                        //                                                     padding:
                        //                                                     EdgeInsets
                        //                                                         .symmetric(
                        //                                                         horizontal: 20
                        //                                                             .h),
                        //                                                     scrollDirection:
                        //                                                     Axis
                        //                                                         .horizontal,
                        //                                                     itemCount: storageController
                        //                                                         .selectedProduct!
                        //                                                         .relatedIds
                        //                                                         .length,
                        //                                                     itemBuilder:
                        //                                                         (
                        //                                                         context,
                        //                                                         index) {
                        //                                                       if (homeMainScreenController
                        //                                                           .checkNullOperator()) {
                        //                                                         return Container();
                        //                                                       }
                        //                                                       return FutureBuilder(
                        //                                                         future:
                        //                                                         // productDetailRelatedProductCache(
                        //                                                         //   uniqueQueryKey: valueOrDefault(
                        //                                                         //       storageController
                        //                                                         //           .selectedProduct!
                        //                                                         //           .relatedIds[index]
                        //                                                         //           .toString(),
                        //                                                         //       "Product Detail"),
                        //                                                         //   requestFn: () =>
                        //                                                         homeMainScreenController
                        //                                                             .wooCommerce1!
                        //                                                             .getYouProduct(
                        //                                                             wooCommerceAPI: homeMainScreenController
                        //                                                                 .api1!,
                        //                                                             id: storageController
                        //                                                                 .selectedProduct!
                        //                                                                 .relatedIds[index]),
                        //                                                         // ),
                        //                                                         builder: (
                        //                                                             context,
                        //                                                             snapshot) {
                        //                                                           if (snapshot
                        //                                                               .hasData
                        //                                                               &&
                        //                                                               snapshot
                        //                                                                   .data !=
                        //                                                                   null
                        //                                                           ) {
                        //                                                             WooProduct product = snapshot
                        //                                                                 .data as WooProduct;
                        //                                                             return productDataFormateInListView(
                        //                                                                 context, () {
                        //                                                               homeScreenController
                        //                                                                   .setSelectedWooProduct(
                        //                                                                   product);
                        //                                                               Get
                        //                                                                   .back();
                        //                                                               storageController
                        //                                                                   .clearProductVariation();
                        //
                        //
                        //                                                               sendToPlanDetail(
                        //                                                                   id: product
                        //                                                                       .id
                        //                                                                       .toString(),
                        //                                                                   tag: "Related Product${index}${product
                        //                                                                       .images[0]
                        //                                                                       .src}",
                        //                                                                   titleTag:
                        //                                                                   "Related Product${index}${product
                        //                                                                       .name}",
                        //                                                                   priceTag:
                        //                                                                   "Related Product${index}price",
                        //                                                                   ratingTag:
                        //                                                                   "Related Product${index}rating");
                        //
                        //
                        //                                                               // Get
                        //                                                               //     .to(
                        //                                                               //     PlantDetail(
                        //                                                               //       tag: "Related Product${index}${product
                        //                                                               //           .images[0]
                        //                                                               //           .src}",
                        //                                                               //     ));
                        //                                                             },
                        //                                                                 product,
                        //                                                                 InkWell(
                        //                                                                   onTap: () {
                        //                                                                     checkInFavouriteList(
                        //                                                                         product);
                        //                                                                     List<
                        //                                                                         String> strList = favProductList
                        //                                                                         .map((
                        //                                                                         i) =>
                        //                                                                         i
                        //                                                                             .toString())
                        //                                                                         .toList();
                        //                                                                     PrefData()
                        //                                                                         .setFavouriteList(
                        //                                                                         strList);
                        //                                                                     getFavourit();
                        //                                                                   },
                        //                                                                   child: Obx(
                        //                                                                         () {
                        //                                                                       return getSvgImage(
                        //                                                                           favProductList
                        //                                                                               .contains(
                        //                                                                               product
                        //                                                                                   .id
                        //                                                                                   .toString())
                        //                                                                               ? "likefillIconnew.svg"
                        //                                                                               : "likeIconnew.svg",
                        //                                                                           height: 22
                        //                                                                               .h,
                        //                                                                           width: 22
                        //                                                                               .h)
                        //                                                                           .marginOnly(
                        //                                                                           top: 10
                        //                                                                               .h,
                        //                                                                           right: 14
                        //                                                                               .h,
                        //                                                                           left: 15
                        //                                                                               .h);
                        //                                                                     },
                        //                                                                   ),
                        //                                                                 ),
                        //
                        //                                                                 index,
                        //                                                                 "Related Product",
                        //                                                                 homeMainScreenController)
                        //                                                             ;
                        //                                                           } else {
                        //                                                             return
                        //                                                               // Container(
                        //                                                               // height: 280
                        //                                                               //     .h,
                        //                                                               // child: ListView
                        //                                                               //     .separated(
                        //                                                               //   separatorBuilder: (
                        //                                                               //       context,
                        //                                                               //       index) {
                        //                                                               //     return getHorSpace(
                        //                                                               //         16
                        //                                                               //             .h);
                        //                                                               //   },
                        //                                                               //   itemCount: storageController
                        //                                                               //       .selectedProduct!
                        //                                                               //       .relatedIds
                        //                                                               //       .length <
                        //                                                               //       3
                        //                                                               //       ? storageController
                        //                                                               //       .selectedProduct!
                        //                                                               //       .relatedIds
                        //                                                               //       .length
                        //                                                               //       : 3,
                        //                                                               //   primary: false,
                        //                                                               //   shrinkWrap: true,
                        //                                                               //   scrollDirection: Axis
                        //                                                               //       .horizontal,
                        //                                                               //   itemBuilder: (
                        //                                                               //       context,
                        //                                                               //       index) {
                        //                                                               //     return
                        //                                                               Shimmer
                        //                                                                   .fromColors(
                        //                                                                 baseColor: Colors
                        //                                                                     .grey[300]!,
                        //                                                                 highlightColor:
                        //                                                                 Colors
                        //                                                                     .grey[100]!,
                        //                                                                 child: Container(
                        //                                                                     decoration: BoxDecoration(
                        //                                                                       borderRadius:
                        //                                                                       BorderRadius
                        //                                                                           .circular(
                        //                                                                           16
                        //                                                                               .h),
                        //                                                                       border: Border
                        //                                                                           .all(
                        //                                                                           color: black20),
                        //                                                                     ),
                        //
                        //                                                                     width: 200
                        //                                                                         .h,
                        //                                                                     height: double
                        //                                                                         .infinity,
                        //                                                                     child: Column(
                        //                                                                       mainAxisAlignment:
                        //                                                                       MainAxisAlignment
                        //                                                                           .start,
                        //                                                                       crossAxisAlignment:
                        //                                                                       CrossAxisAlignment
                        //                                                                           .start,
                        //                                                                       children: [
                        //                                                                         Align(
                        //                                                                           child: Container(
                        //                                                                             margin:
                        //                                                                             EdgeInsetsDirectional
                        //                                                                                 .only(
                        //                                                                                 top: 14
                        //                                                                                     .h),
                        //                                                                             height: 138
                        //                                                                                 .h,
                        //                                                                             width: 153
                        //                                                                                 .h,
                        //                                                                             color: Colors
                        //                                                                                 .white,
                        //                                                                           ),
                        //                                                                           alignment:
                        //                                                                           AlignmentDirectional
                        //                                                                               .topCenter,
                        //                                                                         ),
                        //                                                                         Spacer(),
                        //                                                                         Container(
                        //                                                                           height: 12
                        //                                                                               .h,
                        //                                                                           width: 57
                        //                                                                               .h,
                        //                                                                           color: Colors
                        //                                                                               .white,
                        //                                                                         )
                        //                                                                             .paddingSymmetric(
                        //                                                                             horizontal: 12
                        //                                                                                 .h),
                        //                                                                         getVerSpace(
                        //                                                                             6
                        //                                                                                 .h),
                        //                                                                         Container(
                        //                                                                           height: 21
                        //                                                                               .h,
                        //                                                                           width: 153
                        //                                                                               .h,
                        //                                                                           color: Colors
                        //                                                                               .white,
                        //                                                                         )
                        //                                                                             .paddingSymmetric(
                        //                                                                             horizontal: 12
                        //                                                                                 .h),
                        //                                                                         getVerSpace(
                        //                                                                             8
                        //                                                                                 .h),
                        //                                                                         Container(
                        //                                                                           height: 17
                        //                                                                               .h,
                        //                                                                           width: 102
                        //                                                                               .h,
                        //                                                                           color: Colors
                        //                                                                               .white,
                        //                                                                         )
                        //                                                                             .paddingSymmetric(
                        //                                                                             horizontal: 12
                        //                                                                                 .h),
                        //                                                                         getVerSpace(
                        //                                                                             4
                        //                                                                                 .h),
                        //                                                                         Container(
                        //                                                                           height: 24
                        //                                                                               .h,
                        //                                                                           width: 52
                        //                                                                               .h,
                        //                                                                           color: Colors
                        //                                                                               .white,
                        //                                                                         )
                        //                                                                             .paddingSymmetric(
                        //                                                                             horizontal: 12
                        //                                                                                 .h),
                        //                                                                         getVerSpace(
                        //                                                                             5
                        //                                                                                 .h),
                        //                                                                         // Shimmer.fromColors(
                        //                                                                         //   baseColor:
                        //                                                                         //       Colors.grey[300]!,
                        //                                                                         //   highlightColor:
                        //                                                                         //       Colors.grey[100]!,
                        //                                                                         //   child: Container(
                        //                                                                         //     decoration:
                        //                                                                         //         getButtonDecoration(
                        //                                                                         //             gray,
                        //                                                                         //             withCorners: true,
                        //                                                                         //             corner: 12.h),
                        //                                                                         //     height: 146.h,
                        //                                                                         //     width: double.infinity,
                        //                                                                         //   ).paddingOnly(
                        //                                                                         //       top: 14.h,
                        //                                                                         //       left: 20.h,
                        //                                                                         //       right: 20.h),
                        //                                                                         // ),
                        //                                                                       ],
                        //                                                                     )),
                        //                                                               );
                        //                                                             //     },
                        //                                                             //   ),
                        //                                                             // );
                        //                                                           }
                        //                                                         },
                        //                                                       );
                        //                                                     },
                        //                                                   ),
                        //                                                 )
                        //                                                     : SizedBox(),
                        //                                                 getVerSpace(
                        //                                                     20
                        //                                                         .h),
                        //                                               ],
                        //                                             )
                        //                                                 .paddingOnly(
                        //                                               top: 18
                        //                                                   .h,
                        //                                             ),
                        //                                           )
                        //                                               .paddingOnly(
                        //                                               top: 20
                        //                                                   .h)
                        //                                               : SizedBox(),
                        //                                           getVerSpace(
                        //                                               90.h),
                        //                                         ],
                        //                                       ),
                        //                                     ]),
                        //                               ),
                        //                         )),
                        //               ],
                        //             ),),
                        //           storageController.selectedProduct!
                        //               .variations
                        //               .isNotEmpty ? Align(
                        //             alignment: Alignment.bottomCenter,
                        //             child: Container(
                        //               color: regularWhite,
                        //               child: Row(
                        //                 children: [
                        //                   buildWithVariationBuynow(context),
                        //                   getHorSpace(20.h),
                        //                   Expanded(
                        //                       child: (!cartIdList.contains(
                        //                           storageController
                        //                               .selectedProduct!.id))
                        //                           ? buildWithVariationAddToCart(
                        //                           context)
                        //                           : getCustomButton(S
                        //                           .of(context)
                        //                           .viewCart, () {
                        //                         showVariationDialog();
                        //                       },
                        //                           buttonheight: 58.h)
                        //                   )
                        //                 ],
                        //               ).paddingAll(20.h),
                        //             ),
                        //           ) :
                        //           GetBuilder<HomeScreenController>(
                        //             init: HomeScreenController(),
                        //             builder: (controller) {
                        //               return Align(
                        //                   alignment: Alignment.bottomCenter,
                        //                   child: Container(
                        //                     color: regularWhite,
                        //                     child: Row(
                        //                       children: [
                        //
                        //                         Expanded(
                        //                             child:
                        //
                        //                             controller
                        //                                 .selectedProduct!
                        //                                 .variations
                        //                                 .isNotEmpty
                        //                                 ?
                        //                             withVariationBuyNow(
                        //                                 context, controller,
                        //                                 toyDetailScreenController)
                        //                                 :
                        //                             withoutVariationBuynow(
                        //                                 context, controller,
                        //                                 toyDetailScreenController)
                        //                         ),
                        //                         getHorSpace(20.h),
                        //
                        //                         Expanded(
                        //                           child: storageController
                        //                               .selectedProduct!
                        //                               .variations
                        //                               .isNotEmpty ?
                        //                           (!cartIdList.contains(
                        //                               storageController
                        //                                   .selectedProduct!
                        //                                   .id))
                        //                               ? withVariationAddtoCart(
                        //                               context, controller,
                        //                               toyDetailScreenController)
                        //                               : withVariationViewCart(
                        //                               context, controller,
                        //                               toyDetailScreenController)
                        //                               :
                        //                           (!cartIdList.contains(
                        //                               storageController
                        //                                   .selectedProduct!
                        //                                   .id))
                        //                               ? withoutVariationAddtoCart(
                        //                               context, controller,
                        //                               toyDetailScreenController)
                        //                               : withoutVariationViewCart(
                        //                               context, controller,
                        //                               toyDetailScreenController),
                        //                         )
                        //
                        //                       ],
                        //                     ).paddingAll(20.h),
                        //                   ));
                        //             },
                        //           ),
                        //         ],
                        //       );
                        //     }
                        //     return Center(
                        //         child: CircularProgressIndicator(
                        //           color: buttonColor,));
                        //   },)
                    Stack(
                      children: [
                        SmartRefresher(
                          controller: refreshController,
                          onRefresh: () =>
                              Future.sync(
                                    () {
                                  // pagingController.refresh();
                                  refreshController
                                      .refreshCompleted();
                                  setState(() {
                                    productDetailCache(
                                        overrideCache: true,
                                        uniqueQueryKey: valueOrDefault(
                                            "$id", "dddd"),
                                        requestFn: () => fetchData());
                                  });
                                  print(
                                      "====================refresh");
                                },
                              ),
                          child: CustomScrollView(
                            shrinkWrap: true,
                            primary: true,
                            physics: blockScroll
                                ? NeverScrollableScrollPhysics()
                                : BouncingScrollPhysics(),
                            slivers: [
                              SliverAppBar(
                                toolbarHeight: 58.h,
                                backgroundColor: Colors.transparent,
                                expandedHeight: 379.h,
                                leadingWidth: 58.h,
                                leading: GestureDetector(
                                  onTap: () {
                                    storageController
                                        .clearProductVariation();

                                    Get.back();
                                  },

                                  child: Container(
                                    margin: EdgeInsetsDirectional
                                        .only(
                                        top: 14.h
                                        , bottom: 6.h, start: 20.h),
                                    height: 38.h,
                                    width: 38.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle,
                                        color: bgColor),
                                    child: getSvgImage(
                                        "arrow_square_left.svg",
                                        width: 24.h,
                                        height: 24.h,
                                        color: regularBlack)
                                        .paddingAll(9.h),
                                  ),
                                ),

                                actions: [
                                  GestureDetector(
                                    onTap: () {
                                      share();
                                    },
                                    child: Container(
                                      margin: EdgeInsetsDirectional
                                          .only(
                                          end: 16.h,
                                          top: 14.h,
                                          bottom: 6.h),
                                      height: 38.h,
                                      width: 38.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: bgColor),
                                      child: getSvgImage(
                                          "share_icon.svg")
                                          .paddingAll(9.h),
                                    ),
                                  ),
                                  getHorSpace(16.h),
                                  GetBuilder<CartControllerNew>(
                                    init: CartControllerNew(),
                                    builder: (controller) =>
                                        GestureDetector(
                                            onTap: () {
                                              // storageController.clearProductVariation();
                                              homeMainScreenController
                                                  .change(
                                                  2);
                                              Get.toNamed(
                                                  Routes
                                                      .homeMainRoute);
                                            },
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .only(
                                                  end: 20.h,
                                                  top: 14.h,
                                                  bottom: 6.h),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 38.h,
                                                    width: 38.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        color: bgColor),
                                                    child: getSvgImage(
                                                        "cart_icon.svg",
                                                        color: regularBlack)
                                                        .paddingAll(
                                                        9.h),
                                                  ),
                                                  controller
                                                      .cartOtherInfoList
                                                      .isNotEmpty
                                                      ? Container(
                                                    height: 20.h,
                                                    width: 20.h,
                                                    margin: EdgeInsetsDirectional
                                                        .only(
                                                        start: 27
                                                            .h),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        color: buttonColor),
                                                    child: Center(
                                                        child: getCustomFont(
                                                            controller
                                                                .cartOtherInfoList
                                                                .length
                                                                .toString(),
                                                            14.sp,
                                                            regularWhite,
                                                            1,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  )
                                                  // .paddingOnly(left: 27.h)
                                                      : SizedBox(),
                                                ],
                                              ),
                                            )

                                        ),
                                  )
                                ],
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Container(
                                      width: double.infinity,
                                      color: regularWhite,
                                      child: Stack(
                                        children: [
                                          // Container(
                                          //   height: 102.h,
                                          //   decoration: BoxDecoration(
                                          //       gradient: LinearGradient(
                                          //           stops: [0.0, 1.0],
                                          //           begin: Alignment
                                          //               .topCenter,
                                          //           end: Alignment
                                          //               .bottomCenter,
                                          //           colors: [
                                          //             "#52000000".toColor(),
                                          //             "#00000000".toColor(),
                                          //           ])),
                                          // ),
                                          Container(
                                              margin:
                                              EdgeInsets.only(
                                                  top: 68.h),
                                              height: 261.h,
                                              width: double
                                                  .infinity,
                                              child: PageView
                                                  .builder(
                                                  controller: sliderController,
                                                  onPageChanged: (
                                                      index) {
                                                    toyDetailScreenController
                                                        .onPageChange(
                                                        index);
                                                  },
                                                  itemCount: storageController
                                                      .selectedProduct!
                                                      .images
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    return Padding(
                                                      padding:
                                                      EdgeInsets
                                                          .symmetric(
                                                          horizontal: 43
                                                              .h),
                                                      child: storageController
                                                          .selectedProduct!
                                                          .images[index]
                                                          .src
                                                          .isEmpty ||
                                                          storageController
                                                              .selectedProduct!
                                                              .images[
                                                          index]
                                                              .src ==
                                                              Null
                                                          ? getMultilineCustomFont(
                                                          storageController
                                                              .selectedProduct!
                                                              .images[0]
                                                              .alt as String,
                                                          16.sp,
                                                          regularBlack)
                                                          : GestureDetector(
                                                        onTap: () {
                                                          zoomImageScreenController
                                                              .onPageChange(
                                                              index);
                                                          Get
                                                              .toNamed(
                                                              Routes
                                                                  .zoomImageRoute,

                                                              arguments: storageController
                                                                  .selectedProduct!);
                                                        },
                                                        child: Hero(
                                                          tag:
                                                          tag,

                                                          child:
                                                          CachedNetworkImage(
                                                              imageUrl: storageController
                                                                  .selectedProduct!
                                                                  .images[
                                                              index]
                                                                  .src,
                                                              placeholder: (
                                                                  context,
                                                                  url) =>
                                                                  Center(
                                                                      child:
                                                                      CircularProgressIndicator(
                                                                        color: buttonColor,
                                                                      )),
                                                              errorWidget: (
                                                                  context,
                                                                  url,
                                                                  error) =>
                                                                  getAssetImage(
                                                                      "no_image_banner.png")),
                                                          transitionOnUserGestures: true,
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                          Align(
                                            alignment: Alignment
                                                .bottomCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                    height: 36.h,
                                                    width: 68.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          24.h),
                                                      color: dividerColor,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                        MainAxisSize
                                                            .min,
                                                        children: [
                                                          getCustomFont(
                                                              "${toyDetailScreenController
                                                                  .currentPage +
                                                                  1}",
                                                              16.sp,
                                                              buttonColor,
                                                              1,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                          getCustomFont(
                                                              "/${storageController
                                                                  .selectedProduct!
                                                                  .images
                                                                  .length
                                                                  .toString()}",
                                                              14.sp,
                                                              regularBlack,
                                                              1,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        ],
                                                      ),
                                                    )),
                                                storageController
                                                    .selectedProduct!
                                                    .onSale
                                                    ? Container(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      vertical: 2.h,
                                                      horizontal:
                                                      8.h),
                                                  decoration: BoxDecoration(
                                                      color: buttonColor,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12.h)),
                                                  child: getCustomFont(
                                                      S
                                                          .of(
                                                          context)
                                                          .sale,
                                                      12.sp,
                                                      Colors.white,
                                                      1,
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      textAlign: TextAlign
                                                          .center),
                                                )
                                                    : SizedBox(),
                                              ],
                                            ).paddingOnly(
                                                left: 20.h,
                                                right: 20.h,
                                                bottom: 20.h),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              GetBuilder<HomeScreenController>(
                                  init: HomeScreenController(),
                                  builder:
                                      (homeScreenController) =>
                                      GetBuilder<
                                          LoginEmptyStateController>(
                                        init: LoginEmptyStateController(),
                                        builder: (loginController) =>
                                            SliverList(
                                              delegate:
                                              SliverChildListDelegate(
                                                  [
                                                    ListView(
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      physics:
                                                      const NeverScrollableScrollPhysics(),
                                                      children: [
                                                        getVerSpace(
                                                            20.h),
                                                        Container(
                                                          color: regularWhite,
                                                          width: double
                                                              .infinity,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Container(
                                                                    width: 243
                                                                        .h,
                                                                    child: Hero(
                                                                      transitionOnUserGestures: true,
                                                                      tag: titletag,
                                                                      child: getMultilineCustomFont(
                                                                          "${storageController
                                                                              .selectedProduct!.name}",
                                                                          // "${storageController
                                                                          //     .selectedProduct!
                                                                          //     .name}",
                                                                          18
                                                                              .sp,
                                                                          regularBlack,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                          overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                    ),
                                                                  ),
                                                                  // GestureDetector(
                                                                  //   onTap: () {
                                                                  //     checkInFavouriteList(
                                                                  //         storageController
                                                                  //             .selectedProduct!);
                                                                  //     List<
                                                                  //         String>
                                                                  //     strList =
                                                                  //     favProductList
                                                                  //         .map((
                                                                  //         i) =>
                                                                  //         i
                                                                  //             .toString())
                                                                  //         .toList();
                                                                  //     PrefData()
                                                                  //         .setFavouriteList(
                                                                  //         strList);
                                                                  //   },
                                                                  //   child: Obx(
                                                                  //         () {
                                                                  //       return Align(
                                                                  //         alignment:
                                                                  //         Alignment
                                                                  //             .centerRight,
                                                                  //         child: getAssetImage(
                                                                  //             favProductList
                                                                  //                 .contains(
                                                                  //                 storageController
                                                                  //                     .selectedProduct!
                                                                  //                     .id
                                                                  //                     .toString())
                                                                  //                 ? "likefillIcon.png"
                                                                  //                 : "likeIcon.png",
                                                                  //             height: 20
                                                                  //                 .h,
                                                                  //             width:
                                                                  //             20
                                                                  //                 .h),
                                                                  //       );
                                                                  //     },
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                              getVerSpace(
                                                                  8
                                                                      .h),
                                                              GetBuilder<
                                                                  HomeScreenController>(
                                                                init:
                                                                HomeScreenController(),
                                                                builder:
                                                                    (
                                                                    controller) {
                                                                  return Row(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Hero(
                                                                        transitionOnUserGestures: true,
                                                                        tag: priceTag,
                                                                        child: getCustomFont(
                                                                            (controller
                                                                                .variationModel ==
                                                                                null)
                                                                                ? ((storageController
                                                                                .selectedProduct!
                                                                                .salePrice !=
                                                                                Null &&
                                                                                storageController
                                                                                    .selectedProduct!
                                                                                    .salePrice
                                                                                    .isNotEmpty)
                                                                                ? formatStringCurrency(
                                                                                total: storageController
                                                                                    .selectedProduct!
                                                                                    .salePrice,
                                                                                context: context)
                                                                                : formatStringCurrency(
                                                                                total: storageController
                                                                                    .selectedProduct!
                                                                                    .price,
                                                                                context: context))
                                                                                : formatStringCurrency(
                                                                                total: (controller
                                                                                    .variationModel!
                                                                                    .salePrice!
                                                                                    .isNotEmpty)
                                                                                    ? (controller
                                                                                    .variationModel!
                                                                                    .salePrice ??
                                                                                    "")
                                                                                    : controller
                                                                                    .variationModel!
                                                                                    .regularPrice,
                                                                                context: context),
                                                                            20
                                                                                .sp,
                                                                            regularBlack,
                                                                            1,
                                                                            fontWeight: FontWeight
                                                                                .w700),
                                                                      ),
                                                                      getHorSpace(
                                                                          8
                                                                              .h),
                                                                      storageController
                                                                          .selectedProduct!
                                                                          .onSale
                                                                          ? Row(
                                                                        children: [
                                                                          Text(
                                                                            (storageController
                                                                                .selectedProduct!
                                                                                .salePrice !=
                                                                                Null &&
                                                                                storageController
                                                                                    .selectedProduct!
                                                                                    .salePrice
                                                                                    .isNotEmpty)
                                                                                ? formatStringCurrency(
                                                                                total: storageController
                                                                                    .selectedProduct!
                                                                                    .regularPrice,
                                                                                context: context)
                                                                                : formatStringCurrency(
                                                                                total: storageController
                                                                                    .selectedProduct!
                                                                                    .price,
                                                                                context: context),
                                                                            style: TextStyle(
                                                                                decoration: TextDecoration
                                                                                    .lineThrough,
                                                                                fontSize: 18
                                                                                    .sp,
                                                                                color: Colors
                                                                                    .grey,
                                                                                fontWeight: FontWeight
                                                                                    .w400,
                                                                                fontFamily: Constant
                                                                                    .fontsFamily),
                                                                          ),
                                                                          getHorSpace(
                                                                              6
                                                                                  .h),
                                                                          (storageController
                                                                              .selectedProduct!
                                                                              .onSale)
                                                                              ? getCustomFont(
                                                                              (homeScreenController
                                                                                  .variationModel ==
                                                                                  null)
                                                                                  ? "${100 *
                                                                                  (double
                                                                                      .parse(
                                                                                      storageController
                                                                                          .selectedProduct!
                                                                                          .regularPrice) -
                                                                                      double
                                                                                          .parse(
                                                                                          storageController
                                                                                              .selectedProduct!
                                                                                              .salePrice)) ~/
                                                                                  double
                                                                                      .parse(
                                                                                      storageController
                                                                                          .selectedProduct!
                                                                                          .regularPrice)}% OFF"
                                                                                  ""
                                                                                  : getCurrency(
                                                                                  context) +
                                                                                  homeScreenController
                                                                                      .variationModel!
                                                                                      .regularPrice ??
                                                                                  "",
                                                                              18
                                                                                  .sp,
                                                                              buttonColor,
                                                                              1,
                                                                              fontWeight: FontWeight
                                                                                  .w600)
                                                                              : SizedBox(),
                                                                        ],
                                                                      )
                                                                          : SizedBox(),
                                                                      getVerSpace(
                                                                          2.5
                                                                              .h),
                                                                      Spacer(),
                                                                      storageController
                                                                          .selectedProduct!
                                                                          .stockStatus ==
                                                                          'outofstock'
                                                                          ? getCustomFont(
                                                                          "Out of Stock",
                                                                          18
                                                                              .sp,
                                                                          buttonColor,
                                                                          1,
                                                                          fontWeight: FontWeight
                                                                              .w600)
                                                                          : SizedBox(),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                              storageController
                                                                  .selectedProduct!
                                                                  .averageRating !=
                                                                  "0.00"
                                                                  ? getVerSpace(
                                                                  6
                                                                      .h)
                                                                  : getVerSpace(
                                                                  0
                                                                      .h),
                                                              storageController
                                                                  .selectedProduct!
                                                                  .averageRating !=
                                                                  "0.00"
                                                                  ? Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    storageController
                                                                        .selectedProduct!
                                                                        .averageRating !=
                                                                        "0.00"
                                                                        ? Hero(
                                                                      transitionOnUserGestures: true,
                                                                      tag: ratingTag,
                                                                      child: Row(
                                                                          children: [
                                                                            RatingBar(
                                                                              ignoreGestures: true,
                                                                              initialRating: double
                                                                                  .parse(
                                                                                  storageController
                                                                                      .selectedProduct!
                                                                                      .averageRating),
                                                                              direction: Axis
                                                                                  .horizontal,
                                                                              allowHalfRating: false,
                                                                              itemCount: 5,
                                                                              itemSize: 15
                                                                                  .h,
                                                                              ratingWidget: RatingWidget(
                                                                                full: getSvgImage(
                                                                                    "img_star_amber_600.svg",
                                                                                    height: 15
                                                                                        .h,
                                                                                    width: 15
                                                                                        .h),
                                                                                half: getSvgImage(
                                                                                    "img_star_amber_600.svg",
                                                                                    height: 15
                                                                                        .h,
                                                                                    width: 15
                                                                                        .h),
                                                                                empty: getSvgImage(
                                                                                    "img_vuesaxlinearstar.svg",
                                                                                    height: 15
                                                                                        .h,
                                                                                    width: 15
                                                                                        .h),
                                                                              ),
                                                                              onRatingUpdate: (
                                                                                  double value) {},
                                                                            ),
                                                                            Padding(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    left: 6
                                                                                        .h),
                                                                                child: getCustomFont(
                                                                                  // "${productReviewList
                                                                                  //     .length} ${S
                                                                                  //     .of(
                                                                                  //     context)
                                                                                  //     .reviews}",
                                                                                    "${homeScreenController
                                                                                        .selectedProduct!
                                                                                        .ratingCount} ${S
                                                                                        .of(
                                                                                        context)
                                                                                        .reviews}",
                                                                                    14
                                                                                        .sp,
                                                                                    darkGray,
                                                                                    1,
                                                                                    fontWeight: FontWeight
                                                                                        .w400))
                                                                          ]),
                                                                    )
                                                                        : SizedBox(),
                                                                    getVerSpace(
                                                                        6
                                                                            .h),
                                                                  ])
                                                                  : getVerSpace(
                                                                  0
                                                                      .h),
                                                            ],
                                                          )
                                                              .paddingSymmetric(
                                                              horizontal: 20
                                                                  .h,
                                                              vertical: 20
                                                                  .h),
                                                        ),

                                                        storageController
                                                            .selectedProduct!
                                                            .onSale &&
                                                            (storageController
                                                                .selectedProduct!
                                                                .dateOnSaleFrom ==
                                                                Null ||
                                                                storageController
                                                                    .selectedProduct!
                                                                    .dateOnSaleTo ==
                                                                    Null)
                                                            ? getVerSpace(
                                                            20.h)
                                                            : getVerSpace(
                                                            0.h),
                                                        storageController
                                                            .selectedProduct!
                                                            .onSale &&
                                                            (storageController
                                                                .selectedProduct!
                                                                .dateOnSaleFrom ==
                                                                Null ||
                                                                storageController
                                                                    .selectedProduct!
                                                                    .dateOnSaleTo ==
                                                                    Null)
                                                            ? Container(
                                                          width:
                                                          double
                                                              .infinity,
                                                          color: regularWhite,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              getCustomFont(
                                                                S
                                                                    .of(
                                                                    context)
                                                                    .upcomingSaleOnThisItem,
                                                                14
                                                                    .sp,
                                                                regularBlack,
                                                                1,
                                                              ),
                                                              getVerSpace(
                                                                  8
                                                                      .h),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          8
                                                                              .h),
                                                                      color: Color(
                                                                          0XFFECF5EF)),
                                                                  child: getMultilineCustomFont(
                                                                      "${S
                                                                          .of(
                                                                          context)
                                                                          .saleStartFrom} ${DateFormat(
                                                                          "dd MMM,yyyy")
                                                                          .format(
                                                                          storageController
                                                                              .selectedProduct!
                                                                              .dateOnSaleFrom)} ${S
                                                                          .of(
                                                                          context)
                                                                          .to} ${DateFormat(
                                                                          "dd MMM,yyyy")
                                                                          .format(
                                                                          storageController
                                                                              .selectedProduct!
                                                                              .dateOnSaleTo)}. ${S
                                                                          .of(
                                                                          context)
                                                                          .getAmazingDiscountOnProducts}",
                                                                      14
                                                                          .sp,
                                                                      regularBlack,
                                                                      fontWeight: FontWeight
                                                                          .w400)
                                                                      .paddingAll(
                                                                      10
                                                                          .h))
                                                            ],
                                                          )
                                                              .paddingSymmetric(
                                                              horizontal:
                                                              20.h,
                                                              vertical: 20
                                                                  .h),
                                                        )
                                                            : SizedBox(),
                                                        getVerSpace(
                                                            20.h),
                                                        Container(
                                                            width: double
                                                                .infinity,
                                                            color: regularWhite,
                                                            child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            toyDetailScreenController
                                                                                .setcontent(
                                                                                1);
                                                                          },
                                                                          child: Container(
                                                                              decoration: toyDetailScreenController
                                                                                  .content ==
                                                                                  1
                                                                                  ? BoxDecoration(
                                                                                  border: Border(
                                                                                      bottom: BorderSide(
                                                                                          color: regularBlack)))
                                                                                  : BoxDecoration(),
                                                                              child: getCustomFont(
                                                                                  S
                                                                                      .of(
                                                                                      context)
                                                                                      .description,
                                                                                  16
                                                                                      .sp,
                                                                                  toyDetailScreenController
                                                                                      .content ==
                                                                                      1
                                                                                      ? regularBlack
                                                                                      : darkGray,
                                                                                  1,
                                                                                  fontWeight: toyDetailScreenController
                                                                                      .content ==
                                                                                      1
                                                                                      ? FontWeight
                                                                                      .w600
                                                                                      : FontWeight
                                                                                      .w400)
                                                                                  .paddingOnly(
                                                                                  bottom: 2
                                                                                      .h))),
                                                                      getHorSpace(
                                                                          16
                                                                              .h),
                                                                      storageController
                                                                          .selectedProduct!
                                                                          .shortDescription
                                                                          .isEmpty
                                                                          ? SizedBox()
                                                                          : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            toyDetailScreenController
                                                                                .setcontent(
                                                                                2);
                                                                          },
                                                                          child: Container(
                                                                              decoration: toyDetailScreenController
                                                                                  .content ==
                                                                                  2
                                                                                  ? BoxDecoration(
                                                                                  border: Border(
                                                                                      bottom: BorderSide(
                                                                                          color: regularBlack)))
                                                                                  : BoxDecoration(),
                                                                              child: getCustomFont(
                                                                                  S
                                                                                      .of(
                                                                                      context)
                                                                                      .information,
                                                                                  16
                                                                                      .sp,
                                                                                  toyDetailScreenController
                                                                                      .content ==
                                                                                      2
                                                                                      ? regularBlack
                                                                                      : darkGray,
                                                                                  1,
                                                                                  fontWeight: toyDetailScreenController
                                                                                      .content ==
                                                                                      2
                                                                                      ? FontWeight
                                                                                      .w600
                                                                                      : FontWeight
                                                                                      .w400)
                                                                                  .paddingOnly(
                                                                                  bottom: 2
                                                                                      .h))),
                                                                    ],
                                                                  ),
                                                                  toyDetailScreenController
                                                                      .content ==
                                                                      1
                                                                      ?
                                                                  htmlDescription =
                                                                      Html(
                                                                        data: storageController
                                                                            .selectedProduct!
                                                                            .description,
                                                                        style: {
                                                                          "h5": Style(
                                                                              fontSize: FontSize(
                                                                                  18
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w700,
                                                                              color: regularBlack),
                                                                          "p": Style(
                                                                              fontSize: FontSize(
                                                                                  16
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              color: regularBlack),
                                                                          "li": Style(
                                                                              fontSize: FontSize(
                                                                                  16
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              color: regularBlack),
                                                                        },
                                                                      )
                                                                      : html =
                                                                      Html(
                                                                        data: storageController
                                                                            .selectedProduct!
                                                                            .shortDescription,
                                                                        style: {
                                                                          "h5": Style(
                                                                              fontSize: FontSize(
                                                                                  18
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w700,
                                                                              color: regularBlack),
                                                                          "p": Style(
                                                                              fontSize: FontSize(
                                                                                  16
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              color: regularBlack),
                                                                          "li": Style(
                                                                              fontSize: FontSize(
                                                                                  16
                                                                                      .sp),
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              color: regularBlack),
                                                                        },
                                                                      )
                                                                          .paddingSymmetric(
                                                                          horizontal: 0
                                                                              .h),
                                                                ])
                                                                .paddingSymmetric(
                                                                horizontal: 20
                                                                    .h,
                                                                vertical: 20
                                                                    .h)),
                                                        buildReviewList(
                                                            toyDetailScreenController),
                                                        storageController
                                                            .selectedProduct!
                                                            .upsellIds
                                                            .isNotEmpty
                                                            ? getCustomContainer(
                                                          315.h,
                                                          double
                                                              .infinity,
                                                          color: regularWhite,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                          .youMayAlsoLike,
                                                                      20
                                                                          .sp,
                                                                      regularBlack,
                                                                      1,
                                                                      txtHeight:
                                                                      1.5
                                                                          .h,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                                  cartControllerNew
                                                                      .upsellProduct
                                                                      .isEmpty
                                                                      ? SizedBox()
                                                                      : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get
                                                                            .toNamed(
                                                                            Routes
                                                                                .upsellProductRoute)!
                                                                            .then((
                                                                            value) {
                                                                          getFavDataList();
                                                                        });
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        height: 29
                                                                            .h,
                                                                        decoration: BoxDecoration(
                                                                            color: gray,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                30
                                                                                    .h)),
                                                                        alignment: Alignment
                                                                            .center,
                                                                        child: getCustomFont(
                                                                            S
                                                                                .of(
                                                                                context)
                                                                                .viewAll,
                                                                            14
                                                                                .sp,
                                                                            darkGray,
                                                                            1,
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            txtHeight: 1.5
                                                                                .h,
                                                                            textAlign: TextAlign
                                                                                .center)
                                                                            .paddingSymmetric(
                                                                            horizontal: 10
                                                                                .h),
                                                                      ))
                                                                ],
                                                              )
                                                                  .marginSymmetric(
                                                                  horizontal:
                                                                  20
                                                                      .h),
                                                              getVerSpace(
                                                                  15
                                                                      .h),
                                                              SizedBox(
                                                                height: 280
                                                                    .h,
                                                                child: ListView
                                                                    .separated(
                                                                  separatorBuilder: (
                                                                      context,
                                                                      index) {
                                                                    return getHorSpace(
                                                                        20
                                                                            .h);
                                                                  },
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      20
                                                                          .h),
                                                                  scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                                  itemCount: storageController
                                                                      .selectedProduct!
                                                                      .upsellIds
                                                                      .length,
                                                                  itemBuilder:
                                                                      (
                                                                      context,
                                                                      index) {
                                                                    if (homeMainScreenController
                                                                        .checkNullOperator()) {
                                                                      return Container();
                                                                    }
                                                                    return FutureBuilder(
                                                                      future: homeMainScreenController
                                                                          .wooCommerce1!
                                                                          .getYouProduct(
                                                                          wooCommerceAPI:
                                                                          homeMainScreenController
                                                                              .api1!,
                                                                          id: storageController
                                                                              .selectedProduct!
                                                                              .upsellIds[index]),
                                                                      builder:
                                                                          (
                                                                          context,
                                                                          snapshot) {
                                                                        if (snapshot
                                                                            .hasData &&
                                                                            snapshot
                                                                                .data !=
                                                                                null) {
                                                                          WooProduct
                                                                          product =
                                                                          snapshot
                                                                              .data!;
                                                                          return productDataFormateInListView(
                                                                              context, () {
                                                                            homeScreenController
                                                                                .setSelectedWooProduct(
                                                                                product);
                                                                            Get
                                                                                .back();
                                                                            storageController
                                                                                .clearProductVariation();


                                                                            sendToPlanDetail(
                                                                                id: product
                                                                                    .id
                                                                                    .toString(),
                                                                                tag: "You may also like${index}${product
                                                                                    .images[0]
                                                                                    .src}",
                                                                                function: () {
                                                                                  getFavDataList();
                                                                                },
                                                                                titleTag:
                                                                                "You may also like${index}${product
                                                                                    .name}",
                                                                                priceTag:
                                                                                "You may also like${index}price",
                                                                                ratingTag:
                                                                                "You may also like${index}rating");


                                                                            // Get
                                                                            //     .to(
                                                                            //     PlantDetail(
                                                                            //       tag: "You may also like${index}${product
                                                                            //           .images[0]
                                                                            //           .src}",
                                                                            //     ))!
                                                                            //     .then((
                                                                            //     value) {
                                                                            //   getFavDataList();
                                                                            // });
                                                                            // Get.to(PlantDetail(detail: plantdata[index]));
                                                                            // Get.to(PlantDetail(detail: popularplantdata[index],));
                                                                          },
                                                                              product,
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  checkInFavouriteList(
                                                                                      product);
                                                                                  List<
                                                                                      String> strList = favProductList
                                                                                      .map((
                                                                                      i) =>
                                                                                      i
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
                                                                                        favProductList
                                                                                            .contains(
                                                                                            product
                                                                                                .id
                                                                                                .toString())
                                                                                            ? "likefillIconnew.svg"
                                                                                            : "likeIconnew.svg",
                                                                                        height: 22
                                                                                            .h,
                                                                                        width: 22
                                                                                            .h)
                                                                                        .marginOnly(
                                                                                        top: 10
                                                                                            .h,
                                                                                        right: 14
                                                                                            .h,
                                                                                        left: 15
                                                                                            .h);
                                                                                  },
                                                                                ),
                                                                              ),

                                                                              index,
                                                                              "You may also like",
                                                                              homeMainScreenController)
                                                                          ;
                                                                        } else {
                                                                          return Container(
                                                                            height: 280
                                                                                .h,
                                                                            child: ListView
                                                                                .builder(
                                                                              itemCount: storageController
                                                                                  .selectedProduct!
                                                                                  .upsellIds
                                                                                  .length <
                                                                                  3
                                                                                  ? storageController
                                                                                  .selectedProduct!
                                                                                  .upsellIds
                                                                                  .length
                                                                                  : 3,
                                                                              primary: false,
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis
                                                                                  .horizontal,
                                                                              itemBuilder: (
                                                                                  context,
                                                                                  index) {
                                                                                return Shimmer
                                                                                    .fromColors(
                                                                                  baseColor: Colors
                                                                                      .grey[300]!,
                                                                                  highlightColor:
                                                                                  Colors
                                                                                      .grey[100]!,
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            16
                                                                                                .h),
                                                                                        border: Border
                                                                                            .all(
                                                                                            color: black20),
                                                                                      ),
                                                                                      // margin: EdgeInsets.only(
                                                                                      //   left: 20.h,
                                                                                      // ),
                                                                                      width: 207
                                                                                          .h,
                                                                                      height: double
                                                                                          .infinity,
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
                                                                                              height: 138
                                                                                                  .h,
                                                                                              width: 153
                                                                                                  .h,
                                                                                              color: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                            alignment:
                                                                                            AlignmentDirectional
                                                                                                .topCenter,
                                                                                          ),
                                                                                          Spacer(),
                                                                                          Container(
                                                                                            height: 12
                                                                                                .h,
                                                                                            width: 57
                                                                                                .h,
                                                                                            color: Colors
                                                                                                .white,
                                                                                          )
                                                                                              .paddingSymmetric(
                                                                                              horizontal: 12
                                                                                                  .h),
                                                                                          getVerSpace(
                                                                                              6
                                                                                                  .h),
                                                                                          Container(
                                                                                            height: 21
                                                                                                .h,
                                                                                            width: 153
                                                                                                .h,
                                                                                            color: Colors
                                                                                                .white,
                                                                                          )
                                                                                              .paddingSymmetric(
                                                                                              horizontal: 12
                                                                                                  .h),
                                                                                          getVerSpace(
                                                                                              8
                                                                                                  .h),
                                                                                          Container(
                                                                                            height: 17
                                                                                                .h,
                                                                                            width: 102
                                                                                                .h,
                                                                                            color: Colors
                                                                                                .white,
                                                                                          )
                                                                                              .paddingSymmetric(
                                                                                              horizontal: 12
                                                                                                  .h),
                                                                                          getVerSpace(
                                                                                              4
                                                                                                  .h),
                                                                                          Container(
                                                                                            height: 24
                                                                                                .h,
                                                                                            width: 52
                                                                                                .h,
                                                                                            color: Colors
                                                                                                .white,
                                                                                          )
                                                                                              .paddingSymmetric(
                                                                                              horizontal: 12
                                                                                                  .h),
                                                                                          getVerSpace(
                                                                                              5
                                                                                                  .h),

                                                                                        ],
                                                                                      )),
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              getVerSpace(
                                                                  20
                                                                      .h),
                                                            ],
                                                          )
                                                              .paddingOnly(
                                                            top: 18
                                                                .h,
                                                          ),
                                                        )
                                                            .paddingOnly(
                                                            top: 20
                                                                .h)
                                                            : SizedBox(),

                                                        storageController
                                                            .selectedProduct!
                                                            .relatedIds
                                                            .isNotEmpty
                                                            ? Container(
                                                          width:
                                                          double
                                                              .infinity,
                                                          color: regularWhite,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                          .relatedProduct,
                                                                      20
                                                                          .sp,
                                                                      regularBlack,
                                                                      1,
                                                                      txtHeight:
                                                                      1.5
                                                                          .h,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get
                                                                            .toNamed(
                                                                            Routes
                                                                                .relatedRoute)!
                                                                            .then((
                                                                            value) {
                                                                          getFavDataList();
                                                                        });
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        height:
                                                                        29
                                                                            .h,
                                                                        decoration: BoxDecoration(
                                                                            color: gray,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                30
                                                                                    .h)),
                                                                        alignment:
                                                                        Alignment
                                                                            .center,
                                                                        child:
                                                                        getCustomFont(
                                                                            S
                                                                                .of(
                                                                                context)
                                                                                .viewAll,
                                                                            14
                                                                                .sp,
                                                                            darkGray,
                                                                            1,
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            txtHeight: 1.5
                                                                                .h,
                                                                            textAlign: TextAlign
                                                                                .center)
                                                                            .paddingSymmetric(
                                                                            horizontal: 10
                                                                                .h),
                                                                      ))
                                                                ],
                                                              )
                                                                  .marginSymmetric(
                                                                  horizontal:
                                                                  20
                                                                      .h),
                                                              getVerSpace(
                                                                  15
                                                                      .h),
                                                              storageController
                                                                  .selectedProduct!
                                                                  .relatedIds
                                                                  .isNotEmpty
                                                                  ? Container(
                                                                height:
                                                                280
                                                                    .h,
                                                                child: ListView
                                                                    .separated(
                                                                  separatorBuilder: (
                                                                      context,
                                                                      index) {
                                                                    return getHorSpace(
                                                                        20
                                                                            .h);
                                                                  },
                                                                  primary:
                                                                  false,
                                                                  shrinkWrap:
                                                                  true,
                                                                  physics:
                                                                  BouncingScrollPhysics(),
                                                                  padding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 20
                                                                          .h),
                                                                  scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                                  itemCount: storageController
                                                                      .selectedProduct!
                                                                      .relatedIds
                                                                      .length,
                                                                  itemBuilder:
                                                                      (
                                                                      context,
                                                                      index) {
                                                                    if (homeMainScreenController
                                                                        .checkNullOperator()) {
                                                                      return Container();
                                                                    }
                                                                    return FutureBuilder(
                                                                      future:
                                                                      // productDetailRelatedProductCache(
                                                                      //   uniqueQueryKey: valueOrDefault(
                                                                      //       storageController
                                                                      //           .selectedProduct!
                                                                      //           .relatedIds[index]
                                                                      //           .toString(),
                                                                      //       "Product Detail"),
                                                                      //   requestFn: () =>
                                                                      homeMainScreenController
                                                                          .wooCommerce1!
                                                                          .getYouProduct(
                                                                          wooCommerceAPI: homeMainScreenController
                                                                              .api1!,
                                                                          id: storageController
                                                                              .selectedProduct!
                                                                              .relatedIds[index]),
                                                                      // ),
                                                                      builder: (
                                                                          context,
                                                                          snapshot) {
                                                                        if (snapshot
                                                                            .hasData
                                                                            &&
                                                                            snapshot
                                                                                .data !=
                                                                                null
                                                                        ) {
                                                                          WooProduct product = snapshot
                                                                              .data as WooProduct;
                                                                          return productDataFormateInListView(
                                                                              context, () {
                                                                            homeScreenController
                                                                                .setSelectedWooProduct(
                                                                                product);
                                                                            Get
                                                                                .back();
                                                                            storageController
                                                                                .clearProductVariation();


                                                                            sendToPlanDetail(
                                                                                id: product
                                                                                    .id
                                                                                    .toString(),
                                                                                tag: "Related Product${index}${product
                                                                                    .images[0]
                                                                                    .src}",
                                                                                titleTag:
                                                                                "Related Product${index}${product
                                                                                    .name}",
                                                                                priceTag:
                                                                                "Related Product${index}price",
                                                                                ratingTag:
                                                                                "Related Product${index}rating");


                                                                            // Get
                                                                            //     .to(
                                                                            //     PlantDetail(
                                                                            //       tag: "Related Product${index}${product
                                                                            //           .images[0]
                                                                            //           .src}",
                                                                            //     ));
                                                                          },
                                                                              product,
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  checkInFavouriteList(
                                                                                      product);
                                                                                  List<
                                                                                      String> strList = favProductList
                                                                                      .map((
                                                                                      i) =>
                                                                                      i
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
                                                                                        favProductList
                                                                                            .contains(
                                                                                            product
                                                                                                .id
                                                                                                .toString())
                                                                                            ? "likefillIconnew.svg"
                                                                                            : "likeIconnew.svg",
                                                                                        height: 22
                                                                                            .h,
                                                                                        width: 22
                                                                                            .h)
                                                                                        .marginOnly(
                                                                                        top: 10
                                                                                            .h,
                                                                                        right: 14
                                                                                            .h,
                                                                                        left: 15
                                                                                            .h);
                                                                                  },
                                                                                ),
                                                                              ),

                                                                              index,
                                                                              "Related Product",
                                                                              homeMainScreenController)
                                                                          ;
                                                                        } else {
                                                                          return
                                                                            // Container(
                                                                            // height: 280
                                                                            //     .h,
                                                                            // child: ListView
                                                                            //     .separated(
                                                                            //   separatorBuilder: (
                                                                            //       context,
                                                                            //       index) {
                                                                            //     return getHorSpace(
                                                                            //         16
                                                                            //             .h);
                                                                            //   },
                                                                            //   itemCount: storageController
                                                                            //       .selectedProduct!
                                                                            //       .relatedIds
                                                                            //       .length <
                                                                            //       3
                                                                            //       ? storageController
                                                                            //       .selectedProduct!
                                                                            //       .relatedIds
                                                                            //       .length
                                                                            //       : 3,
                                                                            //   primary: false,
                                                                            //   shrinkWrap: true,
                                                                            //   scrollDirection: Axis
                                                                            //       .horizontal,
                                                                            //   itemBuilder: (
                                                                            //       context,
                                                                            //       index) {
                                                                            //     return
                                                                            Shimmer
                                                                                .fromColors(
                                                                              baseColor: Colors
                                                                                  .grey[300]!,
                                                                              highlightColor:
                                                                              Colors
                                                                                  .grey[100]!,
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        16
                                                                                            .h),
                                                                                    border: Border
                                                                                        .all(
                                                                                        color: black20),
                                                                                  ),

                                                                                  width: 200
                                                                                      .h,
                                                                                  height: double
                                                                                      .infinity,
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
                                                                                          height: 138
                                                                                              .h,
                                                                                          width: 153
                                                                                              .h,
                                                                                          color: Colors
                                                                                              .white,
                                                                                        ),
                                                                                        alignment:
                                                                                        AlignmentDirectional
                                                                                            .topCenter,
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Container(
                                                                                        height: 12
                                                                                            .h,
                                                                                        width: 57
                                                                                            .h,
                                                                                        color: Colors
                                                                                            .white,
                                                                                      )
                                                                                          .paddingSymmetric(
                                                                                          horizontal: 12
                                                                                              .h),
                                                                                      getVerSpace(
                                                                                          6
                                                                                              .h),
                                                                                      Container(
                                                                                        height: 21
                                                                                            .h,
                                                                                        width: 153
                                                                                            .h,
                                                                                        color: Colors
                                                                                            .white,
                                                                                      )
                                                                                          .paddingSymmetric(
                                                                                          horizontal: 12
                                                                                              .h),
                                                                                      getVerSpace(
                                                                                          8
                                                                                              .h),
                                                                                      Container(
                                                                                        height: 17
                                                                                            .h,
                                                                                        width: 102
                                                                                            .h,
                                                                                        color: Colors
                                                                                            .white,
                                                                                      )
                                                                                          .paddingSymmetric(
                                                                                          horizontal: 12
                                                                                              .h),
                                                                                      getVerSpace(
                                                                                          4
                                                                                              .h),
                                                                                      Container(
                                                                                        height: 24
                                                                                            .h,
                                                                                        width: 52
                                                                                            .h,
                                                                                        color: Colors
                                                                                            .white,
                                                                                      )
                                                                                          .paddingSymmetric(
                                                                                          horizontal: 12
                                                                                              .h),
                                                                                      getVerSpace(
                                                                                          5
                                                                                              .h),
                                                                                      // Shimmer.fromColors(
                                                                                      //   baseColor:
                                                                                      //       Colors.grey[300]!,
                                                                                      //   highlightColor:
                                                                                      //       Colors.grey[100]!,
                                                                                      //   child: Container(
                                                                                      //     decoration:
                                                                                      //         getButtonDecoration(
                                                                                      //             gray,
                                                                                      //             withCorners: true,
                                                                                      //             corner: 12.h),
                                                                                      //     height: 146.h,
                                                                                      //     width: double.infinity,
                                                                                      //   ).paddingOnly(
                                                                                      //       top: 14.h,
                                                                                      //       left: 20.h,
                                                                                      //       right: 20.h),
                                                                                      // ),
                                                                                    ],
                                                                                  )),
                                                                            );
                                                                          //     },
                                                                          //   ),
                                                                          // );
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                                  : SizedBox(),
                                                              getVerSpace(
                                                                  20
                                                                      .h),
                                                            ],
                                                          )
                                                              .paddingOnly(
                                                            top: 18
                                                                .h,
                                                          ),
                                                        )
                                                            .paddingOnly(
                                                            top: 20
                                                                .h)
                                                            : SizedBox(),
                                                        getVerSpace(
                                                            90.h),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                      )),
                            ],
                          ),),
                        storageController.selectedProduct!
                            .variations
                            .isNotEmpty ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: regularWhite,
                            child: Row(
                              children: [
                                buildWithVariationBuynow(context),
                                getHorSpace(20.h),
                                Expanded(
                                    child: (!cartIdList.contains(
                                        storageController
                                            .selectedProduct!.id))
                                        ? buildWithVariationAddToCart(
                                        context)
                                        : getCustomButton(S
                                        .of(context)
                                        .viewCart, () {
                                      showVariationDialog();
                                    },
                                        buttonheight: 58.h)
                                )
                              ],
                            ).paddingAll(20.h),
                          ),
                        ) :
                        GetBuilder<HomeScreenController>(
                          init: HomeScreenController(),
                          builder: (controller) {
                            return Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: regularWhite,
                                  child: Row(
                                    children: [

                                      Expanded(
                                          child:

                                          controller
                                              .selectedProduct!
                                              .variations
                                              .isNotEmpty
                                              ?
                                          withVariationBuyNow(
                                              context, controller,
                                              toyDetailScreenController)
                                              :
                                          withoutVariationBuynow(
                                              context, controller,
                                              toyDetailScreenController)
                                      ),
                                      getHorSpace(20.h),

                                      Expanded(
                                        child: storageController
                                            .selectedProduct!
                                            .variations
                                            .isNotEmpty ?
                                        (!cartIdList.contains(
                                            storageController
                                                .selectedProduct!
                                                .id))
                                            ? withVariationAddtoCart(
                                            context, controller,
                                            toyDetailScreenController)
                                            : withVariationViewCart(
                                            context, controller,
                                            toyDetailScreenController)
                                            :
                                        (!cartIdList.contains(
                                            storageController
                                                .selectedProduct!
                                                .id))
                                            ? withoutVariationAddtoCart(
                                            context, controller,
                                            toyDetailScreenController)
                                            : withoutVariationViewCart(
                                            context, controller,
                                            toyDetailScreenController),
                                      )

                                    ],
                                  ).paddingAll(20.h),
                                ));
                          },
                        ),
                      ],
                    )
                ),
              )),
        ),
      ),
    );
  }

  Widget withoutVariationViewCart(BuildContext context,
      HomeScreenController controller, var toyDetailScreenController) {
    return getCustomButton(
        S
            .of(context)
            .viewCart, () async {
      if (cartControllerNew
          .cartOtherInfoList
          .isEmpty) {
        cartControllerNew
            .changeCoupon(
            false);
      }

      bool i = await checkIsCartAlreadyAdded(
          storageController
              .selectedProduct!
              .id);

      if (!i) {
        await EasyLoading.show();
        final snackBar = SnackBar(
          content: Text(
              S
                  .of(context)
                  .addedToCart),
          duration: Duration(
              seconds: 2),
        );
        ScaffoldMessenger.of(
            context)
            .showSnackBar(
            snackBar);
        cartControllerNew
            .addItemInfo(
            CartOtherInfo(
              variationId:
              (controller
                  .variationModel !=
                  null)
                  ? controller
                  .variationModel!
                  .id
                  : 0,
              variationList:
              (controller
                  .variationModel !=
                  null)
                  ? controller
                  .variationModel!
                  .attributes
                  : [],
              productId: storageController
                  .selectedProduct!
                  .id,
              quantity: storageController
                  .currentQuantity
                  .value,
              stockStatus: storageController
                  .selectedProduct!
                  .stockStatus,
              type: storageController
                  .selectedProduct!
                  .type,
              productName: storageController
                  .selectedProduct!
                  .name,
              productImage: storageController
                  .selectedProduct!
                  .images[0].src,
              productPrice: (controller
                  .variationModel !=
                  null)
                  ? (parseWcPrice(
                  controller
                      .variationModel!
                      .salePrice) <=
                  0)
                  ? parseWcPrice(
                  controller
                      .variationModel!
                      .regularPrice)
                  : parseWcPrice(
                  controller
                      .variationModel!
                      .salePrice)
                  : (parseWcPrice(
                  storageController
                      .selectedProduct!
                      .salePrice) <=
                  0)
                  ? parseWcPrice(
                  storageController
                      .selectedProduct!
                      .regularPrice)
                  : parseWcPrice(
                  storageController
                      .selectedProduct!
                      .salePrice),
              taxClass: storageController
                  .selectedProduct!
                  .taxClass,
            ));
        await EasyLoading
            .dismiss();
        checkAlreadyInCart();
      } else {
        for (int i = 0;
        i <
            cartControllerNew
                .cartOtherInfoList
                .length;
        i++) {
          CartOtherInfo element =
          cartControllerNew
              .cartOtherInfoList[i];

          if (element.productId ==
              storageController
                  .selectedProduct!
                  .id) {
            element
                .variationList =
            (controller
                .variationModel !=
                null)
                ? controller
                .variationModel!
                .attributes
                : [];
            element.variationId =
            (controller
                .variationModel !=
                null)
                ? controller
                .variationModel!
                .id
                : 0;
            element.productPrice =
            (controller
                .variationModel !=
                null)
                ? (parseWcPrice(
                controller
                    .variationModel!
                    .salePrice) <=
                0)
                ? parseWcPrice(
                controller
                    .variationModel!
                    .regularPrice)
                : parseWcPrice(
                controller
                    .variationModel!
                    .salePrice)
                : (parseWcPrice(
                storageController
                    .selectedProduct!
                    .salePrice) <=
                0)
                ? parseWcPrice(
                storageController
                    .selectedProduct!
                    .regularPrice)
                : parseWcPrice(
                storageController
                    .selectedProduct!
                    .salePrice);
            cartControllerNew
                .alreadyAddItem();

            Get.toNamed(
                Routes
                    .cartScreenRoute,
                arguments: true)!
                .then((value) async {
              checkAlreadyInCart();
              // setState(() {
              getCartIdList();
              getVariationIdList();
              // });
              toyDetailScreenController.update();
            });
          }
        }
      }
      cartControllerNew
          .creatUpsellListClear();
    }, buttonheight: 58.h);
  }

  Widget withoutVariationAddtoCart(BuildContext context,
      HomeScreenController controller, var toyDetailScreenController) {
    return getCustomButton(
      S
          .of(context)
          .addToCart,
          () async {
        if (storageController
            .selectedProduct!
            .stockStatus !=
            'outofstock') {
          if (cartControllerNew
              .cartOtherInfoList
              .isEmpty) {
            cartControllerNew
                .changeCoupon(
                false);
          }
          if (!cartIdList.contains(
              storageController
                  .selectedProduct!
                  .id)) {
            await EasyLoading
                .show();
            final snackBar = SnackBar(
              content: Text(
                  S
                      .of(context)
                      .addedToCart),
              duration: Duration(
                  seconds: 2),
            );
            ScaffoldMessenger.of(
                context)
                .showSnackBar(
                snackBar);
            cartControllerNew
                .addItemInfo(
                CartOtherInfo(
                  variationId:
                  (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .id
                      : 0,
                  variationList: (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .attributes
                      : [],
                  productId: storageController
                      .selectedProduct!
                      .id,
                  quantity: storageController
                      .currentQuantity
                      .value,
                  stockStatus: storageController
                      .selectedProduct!
                      .stockStatus,
                  type: storageController
                      .selectedProduct!
                      .type,
                  productName: storageController
                      .selectedProduct!
                      .name,
                  productImage: storageController
                      .selectedProduct!
                      .images[0]
                      .src,
                  productPrice: (controller
                      .variationModel !=
                      null)
                      ? (parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      controller
                          .variationModel!
                          .regularPrice)
                      : parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice)
                      : (parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      storageController
                          .selectedProduct!
                          .regularPrice)
                      : parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice),
                  taxClass: storageController
                      .selectedProduct!
                      .taxClass,
                ));
            await EasyLoading
                .dismiss();


            checkAlreadyInCart();
            // setState(() {
            getCartIdList();
            getVariationIdList();
            toyDetailScreenController.update();
            // });
          } else {
            for (int i = 0; i <
                cartControllerNew
                    .cartOtherInfoList
                    .length; i++) {
              CartOtherInfo element = cartControllerNew
                  .cartOtherInfoList[i];

              if (element
                  .productId ==
                  storageController
                      .selectedProduct!
                      .id) {
                element
                    .variationList =
                (controller
                    .variationModel !=
                    null)
                    ? controller
                    .variationModel!
                    .attributes
                    : [];
                element
                    .variationId =
                (controller
                    .variationModel !=
                    null)
                    ? controller
                    .variationModel!
                    .id
                    : 0;
                element
                    .productPrice =
                (controller
                    .variationModel !=
                    null)
                    ? (parseWcPrice(
                    controller
                        .variationModel!
                        .salePrice) <=
                    0)
                    ? parseWcPrice(
                    controller
                        .variationModel!
                        .regularPrice)
                    : parseWcPrice(
                    controller
                        .variationModel!
                        .salePrice)
                    : (parseWcPrice(
                    storageController
                        .selectedProduct!
                        .salePrice) <=
                    0)
                    ? parseWcPrice(
                    storageController
                        .selectedProduct!
                        .regularPrice)
                    : parseWcPrice(
                    storageController
                        .selectedProduct!
                        .salePrice);
              }
            }
          }
        }
        else {
          showCustomToast(
              S
                  .of(context)
                  .productIsOutOfStock);
        }
      },
      color: buttonColor,
      buttonheight: 58.h,
      decoration: ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          overlayColor: MaterialStatePropertyAll(
              lightGreen),
          surfaceTintColor: MaterialStatePropertyAll(
              Colors.white),
          backgroundColor: MaterialStatePropertyAll(
              regularWhite),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity,
                58.h),
          ),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .circular(
                      16.h),
                  side: BorderSide(
                      color: buttonColor)))),
    );
  }

  Widget withVariationViewCart(BuildContext context,
      HomeScreenController controller, var toyDetailScreenController) {
    return getCustomButton(
        S
            .of(context)
            .viewCart, () async {
      if (controller
          .variationModel !=
          null) {
        if (cartControllerNew
            .cartOtherInfoList
            .isEmpty) {
          cartControllerNew
              .changeCoupon(
              false);
        }

        bool i = await checkIsCartAlreadyAdded(
            storageController
                .selectedProduct!
                .id);

        if (!i) {
          await EasyLoading
              .show();
          final snackBar = SnackBar(
            content: Text(
                S
                    .of(context)
                    .addedToCart),
            duration: Duration(
                seconds: 2),
          );
          ScaffoldMessenger.of(
              context)
              .showSnackBar(
              snackBar);
          cartControllerNew
              .addItemInfo(
              CartOtherInfo(
                variationId:
                (controller
                    .variationModel !=
                    null)
                    ? controller
                    .variationModel!
                    .id
                    : 0,
                variationList:
                (controller
                    .variationModel !=
                    null)
                    ? controller
                    .variationModel!
                    .attributes
                    : [],
                productId: storageController
                    .selectedProduct!
                    .id,
                quantity: storageController
                    .currentQuantity
                    .value,
                stockStatus: storageController
                    .selectedProduct!
                    .stockStatus,
                type: storageController
                    .selectedProduct!
                    .type,
                productName: storageController
                    .selectedProduct!
                    .name,
                productImage: storageController
                    .selectedProduct!
                    .images[0]
                    .src,
                productPrice: (controller
                    .variationModel !=
                    null)
                    ? (parseWcPrice(
                    controller
                        .variationModel!
                        .salePrice) <=
                    0)
                    ? parseWcPrice(
                    controller
                        .variationModel!
                        .regularPrice)
                    : parseWcPrice(
                    controller
                        .variationModel!
                        .salePrice)
                    : (parseWcPrice(
                    storageController
                        .selectedProduct!
                        .salePrice) <=
                    0)
                    ? parseWcPrice(
                    storageController
                        .selectedProduct!
                        .regularPrice)
                    : parseWcPrice(
                    storageController
                        .selectedProduct!
                        .salePrice),
                taxClass: storageController
                    .selectedProduct!
                    .taxClass,
              ));
          await EasyLoading
              .dismiss();
          checkAlreadyInCart();
        } else {
          for (int i = 0;
          i <
              cartControllerNew
                  .cartOtherInfoList
                  .length;
          i++) {
            CartOtherInfo element =
            cartControllerNew
                .cartOtherInfoList[i];

            if (element
                .productId ==
                storageController
                    .selectedProduct!
                    .id) {
              element
                  .variationList =
              (controller
                  .variationModel !=
                  null)
                  ? controller
                  .variationModel!
                  .attributes
                  : [];
              element
                  .variationId =
              (controller
                  .variationModel !=
                  null)
                  ? controller
                  .variationModel!
                  .id
                  : 0;
              element
                  .productPrice =
              (controller
                  .variationModel !=
                  null)
                  ? (parseWcPrice(
                  controller
                      .variationModel!
                      .salePrice) <=
                  0)
                  ? parseWcPrice(
                  controller
                      .variationModel!
                      .regularPrice)
                  : parseWcPrice(
                  controller
                      .variationModel!
                      .salePrice)
                  : (parseWcPrice(
                  storageController
                      .selectedProduct!
                      .salePrice) <=
                  0)
                  ? parseWcPrice(
                  storageController
                      .selectedProduct!
                      .regularPrice)
                  : parseWcPrice(
                  storageController
                      .selectedProduct!
                      .salePrice);
              cartControllerNew
                  .alreadyAddItem();
              // storageController.clearProductVariation();
              Get.toNamed(Routes
                  .cartScreenRoute,
                  arguments: true)!
                  .then((value) async {
                checkAlreadyInCart();
                // setState(() {
                getCartIdList();
                getVariationIdList();
                toyDetailScreenController.update();
                // });
              });
            }
          }
        }
        cartControllerNew
            .creatUpsellListClear();
      } else {
        showCustomToast(
            S
                .of(context)
                .pleaseWaitVariationsAreLoading);
      }
    }, buttonheight: 58.h);
  }

  Widget withVariationAddtoCart(BuildContext context,
      HomeScreenController controller, var toyDetailScreenController) {
    return getCustomButton(
      S
          .of(context)
          .addToCart,
          () async {
        if (controller
            .variationModel !=
            null) {
          if (storageController
              .selectedProduct!
              .stockStatus !=
              'outofstock') {
            if (cartControllerNew
                .cartOtherInfoList
                .isEmpty) {
              cartControllerNew
                  .changeCoupon(
                  false);
            }
            if (!cartIdList.contains(
                storageController
                    .selectedProduct!
                    .id)) {
              await EasyLoading
                  .show();
              final snackBar = SnackBar(
                content: Text(
                    S
                        .of(context)
                        .addedToCart),
                duration: Duration(
                    seconds: 2),
              );
              ScaffoldMessenger.of(
                  context)
                  .showSnackBar(
                  snackBar);
              cartControllerNew
                  .addItemInfo(
                  CartOtherInfo(
                    variationId:
                    (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .id
                        : 0,
                    variationList: (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .attributes
                        : [],
                    productId: storageController
                        .selectedProduct!
                        .id,
                    quantity: storageController
                        .currentQuantity
                        .value,
                    stockStatus: storageController
                        .selectedProduct!
                        .stockStatus,
                    type: storageController
                        .selectedProduct!
                        .type,
                    productName: storageController
                        .selectedProduct!
                        .name,
                    productImage: storageController
                        .selectedProduct!
                        .images[0]
                        .src,
                    productPrice: (controller
                        .variationModel !=
                        null)
                        ? (parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        controller
                            .variationModel!
                            .regularPrice)
                        : parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice)
                        : (parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        storageController
                            .selectedProduct!
                            .regularPrice)
                        : parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice),
                    taxClass: storageController
                        .selectedProduct!
                        .taxClass,
                  ));
              await EasyLoading
                  .dismiss();

              checkAlreadyInCart();
              // setState(() {
              getCartIdList();
              getVariationIdList();
              toyDetailScreenController.update();
              // });
            } else {
              for (int i = 0; i <
                  cartControllerNew
                      .cartOtherInfoList
                      .length; i++) {
                CartOtherInfo element = cartControllerNew
                    .cartOtherInfoList[i];

                if (element
                    .productId ==
                    storageController
                        .selectedProduct!
                        .id) {
                  element
                      .variationList =
                  (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .attributes
                      : [];
                  element
                      .variationId =
                  (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .id
                      : 0;
                  element
                      .productPrice =
                  (controller
                      .variationModel !=
                      null)
                      ? (parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      controller
                          .variationModel!
                          .regularPrice)
                      : parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice)
                      : (parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      storageController
                          .selectedProduct!
                          .regularPrice)
                      : parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice);
                }
              }
            }
          }
          else {
            showCustomToast(
                S
                    .of(context)
                    .productIsOutOfStock);
          }
        } else {
          showCustomToast(
              S
                  .of(context)
                  .pleaseWaitVariationsAreLoading);
        }
      },
      color: buttonColor,
      buttonheight: 58.h,
      decoration: ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          overlayColor: MaterialStatePropertyAll(
              lightGreen),
          surfaceTintColor: MaterialStatePropertyAll(
              Colors.white),
          backgroundColor: MaterialStatePropertyAll(
              regularWhite),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity,
                58.h),
          ),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .circular(
                      12.h),
                  side: BorderSide(
                      color: buttonColor,
                      width: 1.5)))),
    );
  }

  Widget withoutVariationBuynow(BuildContext context,
      HomeScreenController controller, var toyDetailScreenController) {
    return getCustomButton(
        S
            .of(context)
            .buyNow,

            () async {
          if (storageController
              .selectedProduct!
              .stockStatus !=
              'outofstock') {
            if (cartControllerNew
                .cartOtherInfoList
                .isEmpty) {
              cartControllerNew
                  .changeCoupon(
                  false);
            }

            bool i = await checkIsCartAlreadyAdded(
                storageController
                    .selectedProduct!
                    .id);

            if (!i) {
              await EasyLoading
                  .show();
              Duration(seconds: 5);
              cartControllerNew
                  .addItemInfo(
                  CartOtherInfo(
                    variationId:
                    (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .id : 0,
                    variationList: (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .attributes
                        : [],
                    productId:
                    storageController
                        .selectedProduct!
                        .id,
                    quantity: controller
                        .currentQuantity
                        .value,
                    stockStatus: storageController
                        .selectedProduct!
                        .stockStatus,
                    type: storageController
                        .selectedProduct!
                        .type,
                    productName:
                    storageController
                        .selectedProduct!
                        .name,
                    productImage: storageController
                        .selectedProduct!
                        .images[0]
                        .src,
                    productPrice:
                    (controller
                        .variationModel !=
                        null)
                        ? (parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        controller
                            .variationModel!
                            .regularPrice)
                        : parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice)
                        : (parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        storageController
                            .selectedProduct!
                            .regularPrice)
                        : parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice),
                    taxClass: storageController
                        .selectedProduct!
                        .taxClass,
                  ));
              await EasyLoading
                  .dismiss();
              checkAlreadyInCart();
            } else {
              for (int i = 0;
              i <
                  cartControllerNew
                      .cartOtherInfoList
                      .length;
              i++) {
                CartOtherInfo element =
                cartControllerNew
                    .cartOtherInfoList[i];
                if (element
                    .productId ==
                    storageController
                        .selectedProduct!
                        .id) {
                  element
                      .variationList =
                  (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .attributes
                      : [];
                  element
                      .variationId =
                  (controller
                      .variationModel !=
                      null)
                      ? controller
                      .variationModel!
                      .id
                      : 0;
                  element
                      .productPrice =
                  (controller
                      .variationModel !=
                      null)
                      ? (parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      controller
                          .variationModel!
                          .regularPrice)
                      : parseWcPrice(
                      controller
                          .variationModel!
                          .salePrice)
                      : (parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice) <=
                      0)
                      ? parseWcPrice(
                      storageController
                          .selectedProduct!
                          .regularPrice)
                      : parseWcPrice(
                      storageController
                          .selectedProduct!
                          .salePrice);
                }
              }
              cartControllerNew
                  .alreadyAddItem();
            }


            if (homeMainScreenController
                .currentCustomer !=
                null) {
              List<CartOtherInfo>
              cartOtherInfoList = [
              ];
              PrefData.getCartList()
                  .then((value) {
                cartOtherInfoList =
                    value;
                Get.toNamed(Routes
                    .cartBeforePaymentRoute,
                    arguments: cartOtherInfoList)!
                    .then((value) {
                  checkAlreadyInCart();
                  // setState(() {
                  getCartIdList();
                  getVariationIdList();
                  toyDetailScreenController.update();
                  // });
                });
              });
            } else {
              loginController
                  .setLoginIsBuynow(
                  true);
              homeMainScreenController
                  .changeIsLogin(
                  true);
              // storageController.clearProductVariation();
              Get.toNamed(
                  Routes
                      .loginRoute)!
                  .then((value) {
                checkAlreadyInCart();
                // setState(() {
                getCartIdList();
                getVariationIdList();
                toyDetailScreenController.update();
                // });
              });
            }
          }
          else {
            showCustomToast(
                S
                    .of(context)
                    .productIsOutOfStock);
          }
        }, buttonheight: 58.h);
  }

  Widget withVariationBuyNow(BuildContext context,
      HomeScreenController controller, toyDetailScreenController) {
    return getCustomButton(
        S
            .of(context)
            .buyNow,

            () async {
          if (controller
              .variationModel !=
              null) {
            if (storageController
                .selectedProduct!
                .stockStatus !=
                'outofstock') {
              if (cartControllerNew
                  .cartOtherInfoList
                  .isEmpty) {
                cartControllerNew
                    .changeCoupon(
                    false);
              }

              bool i = await checkIsCartAlreadyAdded(
                  storageController
                      .selectedProduct!
                      .id);

              if (!i) {
                await EasyLoading
                    .show();
                Duration(
                    seconds: 5);
                cartControllerNew
                    .addItemInfo(
                    CartOtherInfo(
                      variationId:
                      (controller
                          .variationModel !=
                          null)
                          ? controller
                          .variationModel!
                          .id
                          : 0,
                      variationList: (controller
                          .variationModel !=
                          null)
                          ? controller
                          .variationModel!
                          .attributes
                          : [],
                      productId:
                      storageController
                          .selectedProduct!
                          .id,
                      quantity: controller
                          .currentQuantity
                          .value,
                      stockStatus: storageController
                          .selectedProduct!
                          .stockStatus,
                      type: storageController
                          .selectedProduct!
                          .type,
                      productName:
                      storageController
                          .selectedProduct!
                          .name,
                      productImage: storageController
                          .selectedProduct!
                          .images[0]
                          .src,
                      productPrice:
                      (controller
                          .variationModel !=
                          null)
                          ? (parseWcPrice(
                          controller
                              .variationModel!
                              .salePrice) <=
                          0)
                          ? parseWcPrice(
                          controller
                              .variationModel!
                              .regularPrice)
                          : parseWcPrice(
                          controller
                              .variationModel!
                              .salePrice)
                          : (parseWcPrice(
                          storageController
                              .selectedProduct!
                              .salePrice) <=
                          0)
                          ? parseWcPrice(
                          storageController
                              .selectedProduct!
                              .regularPrice)
                          : parseWcPrice(
                          storageController
                              .selectedProduct!
                              .salePrice),
                      taxClass: storageController
                          .selectedProduct!
                          .taxClass,
                    ));
                await EasyLoading
                    .dismiss();
                checkAlreadyInCart();
              } else {
                for (int i = 0;
                i <
                    cartControllerNew
                        .cartOtherInfoList
                        .length;
                i++) {
                  CartOtherInfo element =
                  cartControllerNew
                      .cartOtherInfoList[i];
                  if (element
                      .productId ==
                      storageController
                          .selectedProduct!
                          .id) {
                    element
                        .variationList =
                    (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .attributes
                        : [];
                    element
                        .variationId =
                    (controller
                        .variationModel !=
                        null)
                        ? controller
                        .variationModel!
                        .id
                        : 0;
                    element
                        .productPrice =
                    (controller
                        .variationModel !=
                        null)
                        ? (parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        controller
                            .variationModel!
                            .regularPrice)
                        : parseWcPrice(
                        controller
                            .variationModel!
                            .salePrice)
                        : (parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice) <=
                        0)
                        ? parseWcPrice(
                        storageController
                            .selectedProduct!
                            .regularPrice)
                        : parseWcPrice(
                        storageController
                            .selectedProduct!
                            .salePrice);
                  }
                }
                cartControllerNew
                    .alreadyAddItem();
              }


              if (homeMainScreenController
                  .currentCustomer !=
                  null) {
                List<CartOtherInfo>
                cartOtherInfoList = [
                ];
                PrefData
                    .getCartList()
                    .then((value) {
                  cartOtherInfoList =
                      value;
                  Get.toNamed(Routes
                      .cartBeforePaymentRoute,
                      arguments: cartOtherInfoList)!
                      .then((value) {
                    checkAlreadyInCart();
                    // setState(() {
                    getCartIdList();
                    getVariationIdList();
                    toyDetailScreenController.update();
                    // });
                  });
                });
              } else {
                loginController
                    .setLoginIsBuynow(
                    true);
                homeMainScreenController
                    .changeIsLogin(
                    true);
                Get.toNamed(
                    Routes
                        .loginRoute)!
                    .then((value) {
                  checkAlreadyInCart();
                  // setState(() {
                  getCartIdList();
                  getVariationIdList();
                  toyDetailScreenController.update();
                  // });
                });
              }
            }
            else {
              showCustomToast(
                  S
                      .of(context)
                      .productIsOutOfStock);
            }
          }
          else {
            showCustomToast(
                S
                    .of(context)
                    .pleaseWaitVariationsAreLoading);
          }
        }, buttonheight: 58.h);
  }

  Widget buildWithVariationAddToCart(BuildContext context) {
    return getCustomButton(
        S
            .of(context)
            .addToCart, () {
      showVariationDialog();
    },
        color: buttonColor,
        buttonheight: 58.h,
        decoration: ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            overlayColor:
            MaterialStatePropertyAll(
                lightGreen),
            surfaceTintColor:
            MaterialStatePropertyAll(
                Colors.white),
            backgroundColor:
            MaterialStatePropertyAll(
                regularWhite),
            maximumSize:
            MaterialStatePropertyAll(
              Size(double.infinity, 58.h),
            ),
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        12.h),
                    side: BorderSide(
                        color: buttonColor,
                        width: 1.5)))));
  }

  Expanded buildWithVariationBuynow(BuildContext context) {
    return Expanded(
        child: getCustomButton(S
            .of(context)
            .buyNow, () {
          showVariationDialog();
        },
            buttonheight: 58.h));
  }

  Widget indicater() {
    return GetBuilder<ToyDetailScreenController>(
      init: ToyDetailScreenController(),
      builder: (controller) =>
          GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              primary: false,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: storageController.selectedProduct!.images
                    .length > 4
                    ? 4
                    : storageController.selectedProduct!.images.length,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 0.h,
                mainAxisExtent: 100.h,
              ),
              itemCount: storageController.selectedProduct!.images.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    sliderController.animateToPage(index,
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 100));
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                            child: storageController.selectedProduct!
                                .images[index]
                                .src.isEmpty ||
                                storageController
                                    .selectedProduct!.images[index].src ==
                                    Null
                                ? getMultilineCustomFont(
                                storageController.selectedProduct!.images[index]
                                    .alt! as String,
                                16.sp,
                                regularBlack)
                                : CachedNetworkImage(
                              imageUrl: storageController
                                  .selectedProduct!.images[index].src,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  Center(
                                      child: CircularProgressIndicator(
                                        color: buttonColor,
                                      )),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )

                        ),
                        index == controller.currentPage
                            ? SizedBox()
                            : Container(
                          width: 100.h,
                          color: regularWhite.withOpacity(0.40),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 0.h),
                  ),
                ).paddingSymmetric(horizontal: 5.h);
              }),
    );
  }

  void changeVariationValue() {
    putstorageController.changeVariation(listVariation[listVariation
        .indexOf(WooProductVariation(attributes: selectedAttributes))]);
    if (!variationIdList.contains(storageController.variationModel!.id)) {
      changeVariation.value = true;
    }
    else {
      changeVariation.value = false;
    }
  }

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }

  void getFavDataList() async {
    favProductList.value = await PrefData().getFavouriteList();
  }

  Widget ProductdetailItemWidget(ModelReviewProduct productdetailItemModelObj) {
    DateTime dateTime =
    DateTime.parse(productdetailItemModelObj.dateCreated ?? "");
    String date = DateFormat("dd MMM,yyyy").format(dateTime);
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getAssetImage("img_ellipse152.png",
                      height: 48.h, width: 48.h),
                  getHorSpace(14.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                          productdetailItemModelObj.reviewer.toString(),
                          14.sp,
                          regularBlack,
                          1,
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
      ),
    );
  }


  showVariationDialog() {
    if (cartControllerNew.cartOtherInfoList.isNotEmpty) {
      var selectedId = storageController.selectedProduct!.id;

      for (int i = 0; i < cartControllerNew.cartOtherInfoList.length; i++) {
        CartOtherInfo element = cartControllerNew.cartOtherInfoList[i];
        if (element.productId == selectedId) {
          storageController.currentQuantity.value = cartControllerNew
              .cartOtherInfoList[i]
              .quantity!.toInt();
        }
        else {
          storageController.currentQuantity.value = 1;
        }
      }
    }
    else {
      storageController.currentQuantity.value = 1;
    }

    showModalBottomSheet(
      transitionAnimationController: animationController,
      backgroundColor: regularWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius
              .vertical(
              top: Radius.circular(16.h))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: Constant.getSetDirection(context) ==
                  ui.TextDirection.ltr
                  ? ui.TextDirection.ltr
                  : ui.TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                    color: regularWhite,
                    borderRadius: BorderRadius
                        .vertical(
                        top: Radius.circular(
                            16.h))),
                width: double.infinity,

                child: Column(
                  mainAxisSize: MainAxisSize
                      .min,
                  children: [
                    10.h.verticalSpace,
                    Container(
                      height: 4.h,
                      width: 48.h,
                      decoration: BoxDecoration(
                          color: '#1A12121D'
                              .toColor(),
                          borderRadius:
                          BorderRadius.circular(
                              10.h)),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 20.h, top: 20.h),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: getCustomFont(S
                            .of(context)
                            .variation, 20.sp, regularBlack, 1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    10.h.verticalSpace,
                    ObxValue((p0) {
                      return (selectedAttributes
                          .length ==
                          storageController
                              .attributeList
                              .length)
                          ? ListView
                          .builder(
                        physics:
                        const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets
                            .symmetric(
                            vertical:
                            10.h),
                        itemBuilder:
                            (context,
                            index1) {
                          WooProductItemAttribute
                          itemAttributs =
                          storageController
                              .attributeList[
                          index1];
                          if (itemAttributs
                              .visible) {
                            if (itemAttributs
                                .name ==
                                colorVariation) {}
                          }
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              getCustomFont(
                                  itemAttributs
                                      .name
                                      .toString(),
                                  14.sp,
                                  regularBlack,
                                  1,
                                  fontWeight:
                                  FontWeight
                                      .w400),
                              getVerSpace(
                                  6.h),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12
                                          .h),
                                  border: Border
                                      .all(
                                      color:
                                      black20),
                                  color: regularWhite,
                                ),
                                child: DropdownButton<
                                    String>(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12
                                          .h),
                                  onChanged:
                                      (value) {
                                    selectedAttributes[index1] =
                                        Attribute(
                                            itemAttributs
                                                .name,
                                            value
                                                .toString());
                                    changeVariationValue();
                                  },
                                  isExpanded:
                                  true,
                                  value: selectedAttributes[
                                  index1]
                                      .option,
                                  items: itemAttributs
                                      .options
                                      .map((e) =>
                                      DropdownMenuItem<
                                          String>(
                                        value: e,
                                        child: Padding(
                                          padding: EdgeInsetsDirectional
                                              .only(
                                              end: 21
                                                  .h),
                                          child: getCustomFont(
                                              e,
                                              16
                                                  .sp,
                                              darkGray,
                                              1,
                                              fontWeight: FontWeight
                                                  .w500),
                                        ),
                                      ))
                                      .toList(),
                                  icon: getSvgImage(
                                      "arrow_down.svg",
                                      height: 16
                                          .h,
                                      width:
                                      16
                                          .h),
                                  underline:
                                  Container(),
                                )
                                    .paddingSymmetric(
                                    horizontal:
                                    20.h),
                              )
                            ],
                          )
                              .paddingSymmetric(
                              horizontal:
                              20.h,
                              vertical:
                              8.h);
                        },
                        itemCount:
                        storageController
                            .attributeList
                            .length,
                        shrinkWrap: true,
                      )
                          : Shimmer.fromColors(
                        child: Container(
                          margin: EdgeInsets
                              .symmetric(
                              horizontal:
                              20.h,
                              vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                12
                                    .h),
                            border: Border
                                .all(
                                color:
                                black20),
                            color: regularWhite,
                          ),
                          child: DropdownButton<
                              String>(
                            onChanged: null,
                            borderRadius:
                            BorderRadius
                                .circular(
                                12
                                    .h),
                            isExpanded:
                            true,
                            value: "variation",
                            items: [
                              DropdownMenuItem<
                                  String>(
                                value: "variation",
                                child: Padding(
                                  padding: EdgeInsetsDirectional
                                      .only(
                                      end: 21
                                          .h),
                                  child: getCustomFont(
                                      "variation",
                                      16
                                          .sp,
                                      darkGray,
                                      1,
                                      fontWeight: FontWeight
                                          .w500),
                                ),
                              )
                            ],
                            icon: getSvgImage(
                                "arrow_down.svg",
                                height: 16
                                    .h,
                                width:
                                16
                                    .h),
                            underline:
                            Container(),
                          ),
                        ),
                        baseColor:
                        Colors.grey[300]!,
                        highlightColor:
                        Colors.grey[100]!,);
                    }, selectedAttributes),
                    10.h.verticalSpace,
                    GetBuilder<HomeScreenController>(
                      init: HomeScreenController(),
                      builder: (controller) =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  getadd_remove_button(
                                      "remove_icon.svg", function: () {
                                    if (controller
                                        .currentQuantity
                                        .value >
                                        1) {
                                      controller
                                          .removeCurrentQuantity();
                                    }
                                  },
                                      color: bgColor,
                                      padding: 5.h,
                                      height: 28.h,
                                      width: 28.h),
                                  getHorSpace(17.h),
                                  getCustomFont(
                                      "${controller
                                          .currentQuantity
                                          .value
                                          .toString()}", 14.sp,
                                      Color(0XFF000000),
                                      1,
                                      fontWeight: FontWeight.w400),
                                  getHorSpace(17.h),
                                  getadd_remove_button(
                                      "add_icon.svg", function: () {
                                    controller
                                        .addCurrentQuantity();
                                  },
                                      color: bgColor,
                                      padding: 5.h,
                                      height: 28.h,
                                      width: 28.h),
                                ],
                              ),
                              getCustomFont(
                                  (controller
                                      .variationModel ==
                                      null)
                                      ? ((storageController
                                      .selectedProduct!
                                      .salePrice !=
                                      Null &&
                                      storageController
                                          .selectedProduct!
                                          .salePrice
                                          .isNotEmpty)
                                      ? formatStringCurrency(
                                      total: (double.parse(storageController
                                          .selectedProduct!
                                          .salePrice) *
                                          controller.currentQuantity.value)
                                          .toString(),
                                      context: context)
                                      : formatStringCurrency(
                                      total:
                                      (double.parse(storageController
                                          .selectedProduct!
                                          .price) *
                                          controller.currentQuantity.value)
                                          .toString(),
                                      context: context))
                                      : formatStringCurrency(
                                      total: (controller
                                          .variationModel!
                                          .salePrice!
                                          .isNotEmpty)
                                          ? (controller
                                          .variationModel!
                                          .salePrice ??
                                          "")
                                          :
                                      (double.parse(controller
                                          .variationModel!
                                          .regularPrice!) *
                                          controller.currentQuantity.value)
                                          .toString(),
                                      context: context),
                                  20.sp,
                                  regularBlack,
                                  1,
                                  fontWeight: FontWeight
                                      .w700),
                            ],
                          ).paddingSymmetric(horizontal: 20.h),
                    ),
                    60.h.verticalSpace,
                    GetBuilder<
                        HomeScreenController>(
                      init: HomeScreenController(),
                      builder: (controller) {
                        return Align(
                            alignment: Alignment
                                .bottomCenter,
                            child: Container(
                              color: regularWhite,
                              child: Row(
                                children: [

                                  Expanded(
                                      child:

                                      controller
                                          .selectedProduct!
                                          .variations
                                          .isNotEmpty
                                          ?
                                      getCustomButton(
                                          S
                                              .of(context)
                                              .buyNow,

                                              () async {
                                            if (controller
                                                .variationModel !=
                                                null) {
                                              if (storageController
                                                  .selectedProduct!
                                                  .stockStatus !=
                                                  'outofstock') {
                                                if (cartControllerNew
                                                    .cartOtherInfoList
                                                    .isEmpty) {
                                                  cartControllerNew
                                                      .changeCoupon(
                                                      false);
                                                }


                                                if (!cartIdList
                                                    .contains(
                                                    storageController
                                                        .selectedProduct!
                                                        .id) ||
                                                    changeVariation.value) {
                                                  await EasyLoading
                                                      .show();
                                                  Duration(
                                                      seconds: 5);
                                                  cartControllerNew
                                                      .addItemInfo(
                                                      CartOtherInfo(
                                                        variationId:
                                                        (controller
                                                            .variationModel !=
                                                            null)
                                                            ? controller
                                                            .variationModel!
                                                            .id
                                                            : 0,
                                                        variationList: (controller
                                                            .variationModel !=
                                                            null)
                                                            ? controller
                                                            .variationModel!
                                                            .attributes
                                                            : [
                                                        ],
                                                        productId: storageController
                                                            .selectedProduct!
                                                            .id,
                                                        quantity: storageController
                                                            .currentQuantity
                                                            .value,
                                                        stockStatus: storageController
                                                            .selectedProduct!
                                                            .stockStatus,
                                                        type: storageController
                                                            .selectedProduct!
                                                            .type,
                                                        productName: storageController
                                                            .selectedProduct!
                                                            .name,
                                                        productImage: storageController
                                                            .selectedProduct!
                                                            .images[0]
                                                            .src,
                                                        productPrice: (controller
                                                            .variationModel !=
                                                            null)
                                                            ? (parseWcPrice(
                                                            controller
                                                                .variationModel!
                                                                .salePrice) <=
                                                            0)
                                                            ? parseWcPrice(
                                                            controller
                                                                .variationModel!
                                                                .regularPrice)
                                                            : parseWcPrice(
                                                            controller
                                                                .variationModel!
                                                                .salePrice)
                                                            : (parseWcPrice(
                                                            storageController
                                                                .selectedProduct!
                                                                .salePrice) <=
                                                            0)
                                                            ? parseWcPrice(
                                                            storageController
                                                                .selectedProduct!
                                                                .regularPrice)
                                                            : parseWcPrice(
                                                            storageController
                                                                .selectedProduct!
                                                                .salePrice),
                                                        taxClass: storageController
                                                            .selectedProduct!
                                                            .taxClass,
                                                      ));
                                                  await EasyLoading
                                                      .dismiss();
                                                  setState(() {
                                                    getCartIdList();
                                                    getVariationIdList();
                                                  });
                                                  changeVariation.value = false;
                                                } else {
                                                  if (homeMainScreenController
                                                      .currentCustomer !=
                                                      null) {
                                                    for (int i = 0; i <
                                                        cartControllerNew
                                                            .cartOtherInfoList
                                                            .length; i++) {
                                                      CartOtherInfo element =
                                                      cartControllerNew
                                                          .cartOtherInfoList[i];


                                                      if (element
                                                          .productId ==
                                                          storageController
                                                              .selectedProduct!
                                                              .id) {
                                                        if (element
                                                            .variationId !=
                                                            controller
                                                                .variationModel!
                                                                .id) {
                                                          element.quantity =
                                                              element.quantity;
                                                        }
                                                        else {
                                                          element.quantity =
                                                              controller
                                                                  .currentQuantity
                                                                  .value;
                                                        }

                                                        element
                                                            .variationList =
                                                            element
                                                                .variationList;

                                                        element
                                                            .variationId =
                                                            element.variationId;

                                                        element
                                                            .productPrice =
                                                            element
                                                                .productPrice;
                                                        cartControllerNew
                                                            .alreadyAddItem();
                                                        Get.back();
                                                        Get.toNamed(
                                                            Routes
                                                                .cartBeforePaymentRoute,
                                                            arguments: cartControllerNew
                                                                .cartOtherInfoList)
                                                            ?.then((
                                                            value) async {
                                                          getCartIdList();
                                                          getVariationIdList();
                                                          checkAlreadyInCart();
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    for (int i = 0; i <
                                                        cartControllerNew
                                                            .cartOtherInfoList
                                                            .length; i++) {
                                                      CartOtherInfo element =
                                                      cartControllerNew
                                                          .cartOtherInfoList[i];


                                                      if (element
                                                          .productId ==
                                                          storageController
                                                              .selectedProduct!
                                                              .id) {
                                                        if (element
                                                            .variationId !=
                                                            controller
                                                                .variationModel!
                                                                .id) {
                                                          element.quantity =
                                                              element.quantity;
                                                        }
                                                        else {
                                                          element.quantity =
                                                              controller
                                                                  .currentQuantity
                                                                  .value;
                                                        }

                                                        element
                                                            .variationList =
                                                            element
                                                                .variationList;

                                                        element
                                                            .variationId =
                                                            element.variationId;

                                                        element
                                                            .productPrice =
                                                            element
                                                                .productPrice;
                                                        cartControllerNew
                                                            .alreadyAddItem();
                                                        loginController
                                                            .setLoginIsBuynow(
                                                            true);
                                                        homeMainScreenController
                                                            .changeIsLogin(
                                                            true);
                                                        Get.back();
                                                        Get
                                                            .toNamed(
                                                            Routes.loginRoute)!
                                                            .then((value) {
                                                          checkAlreadyInCart();
                                                          // setState(() {
                                                          getCartIdList();
                                                          getVariationIdList();
                                                          // });
                                                        });
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                              else {
                                                showCustomToast(
                                                    S
                                                        .of(context)
                                                        .productIsOutOfStock);
                                              }
                                            }
                                            else {
                                              showCustomToast(
                                                  S
                                                      .of(context)
                                                      .pleaseWaitVariationsAreLoading);
                                            }
                                          },
                                          buttonheight: 58
                                              .h)
                                          :
                                      getCustomButton(
                                          S
                                              .of(context)
                                              .buyNow,

                                              () async {
                                            if (storageController
                                                .selectedProduct!
                                                .stockStatus !=
                                                'outofstock') {
                                              if (cartControllerNew
                                                  .cartOtherInfoList
                                                  .isEmpty) {
                                                cartControllerNew
                                                    .changeCoupon(
                                                    false);
                                              }

                                              bool i = await checkIsCartAlreadyAdded(
                                                  storageController
                                                      .selectedProduct!
                                                      .id);

                                              if (!i) {
                                                await EasyLoading
                                                    .show();
                                                Duration(
                                                    seconds: 5);
                                                cartControllerNew
                                                    .addItemInfo(
                                                    CartOtherInfo(
                                                      variationId:
                                                      (controller
                                                          .variationModel !=
                                                          null)
                                                          ? controller
                                                          .variationModel!
                                                          .id
                                                          : 0,
                                                      variationList: (controller
                                                          .variationModel !=
                                                          null)
                                                          ? controller
                                                          .variationModel!
                                                          .attributes
                                                          : [
                                                      ],
                                                      productId:
                                                      storageController
                                                          .selectedProduct!
                                                          .id,
                                                      quantity: controller
                                                          .currentQuantity
                                                          .value,
                                                      stockStatus: storageController
                                                          .selectedProduct!
                                                          .stockStatus,
                                                      type: storageController
                                                          .selectedProduct!
                                                          .type,
                                                      productName:
                                                      storageController
                                                          .selectedProduct!
                                                          .name,
                                                      productImage: storageController
                                                          .selectedProduct!
                                                          .images[0]
                                                          .src,
                                                      productPrice:
                                                      (controller
                                                          .variationModel !=
                                                          null)
                                                          ? (parseWcPrice(
                                                          controller
                                                              .variationModel!
                                                              .salePrice) <=
                                                          0)
                                                          ? parseWcPrice(
                                                          controller
                                                              .variationModel!
                                                              .regularPrice)
                                                          : parseWcPrice(
                                                          controller
                                                              .variationModel!
                                                              .salePrice)
                                                          : (parseWcPrice(
                                                          storageController
                                                              .selectedProduct!
                                                              .salePrice) <=
                                                          0)
                                                          ? parseWcPrice(
                                                          storageController
                                                              .selectedProduct!
                                                              .regularPrice)
                                                          : parseWcPrice(
                                                          storageController
                                                              .selectedProduct!
                                                              .salePrice),
                                                      taxClass: storageController
                                                          .selectedProduct!
                                                          .taxClass,
                                                    ));
                                                await EasyLoading
                                                    .dismiss();
                                                checkAlreadyInCart();
                                              } else {
                                                for (int i = 0;
                                                i <
                                                    cartControllerNew
                                                        .cartOtherInfoList
                                                        .length;
                                                i++) {
                                                  CartOtherInfo element =
                                                  cartControllerNew
                                                      .cartOtherInfoList[i];
                                                  if (element
                                                      .productId ==
                                                      storageController
                                                          .selectedProduct!
                                                          .id) {
                                                    element
                                                        .variationList =
                                                    (controller
                                                        .variationModel !=
                                                        null)
                                                        ? controller
                                                        .variationModel!
                                                        .attributes
                                                        : [
                                                    ];
                                                    element
                                                        .variationId =
                                                    (controller
                                                        .variationModel !=
                                                        null)
                                                        ? controller
                                                        .variationModel!
                                                        .id
                                                        : 0;
                                                    element
                                                        .productPrice =
                                                    (controller
                                                        .variationModel !=
                                                        null)
                                                        ? (parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .salePrice) <=
                                                        0)
                                                        ? parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .regularPrice)
                                                        : parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .salePrice)
                                                        : (parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .salePrice) <=
                                                        0)
                                                        ? parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .regularPrice)
                                                        : parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .salePrice);
                                                  }
                                                }
                                                cartControllerNew
                                                    .alreadyAddItem();
                                              }


                                              if (homeMainScreenController
                                                  .currentCustomer !=
                                                  null) {
                                                List<
                                                    CartOtherInfo> cartOtherInfoList = [
                                                ];
                                                PrefData
                                                    .getCartList()
                                                    .then((value) {
                                                  cartOtherInfoList =
                                                      value;
                                                  Get.back();
                                                  Get.toNamed(Routes
                                                      .cartBeforePaymentRoute,
                                                      arguments: cartOtherInfoList)!
                                                      .then((value) {
                                                    checkAlreadyInCart();
                                                    setState(() {
                                                      getCartIdList();
                                                      getVariationIdList();
                                                    });
                                                  });
                                                });
                                              } else {
                                                loginController
                                                    .setLoginIsBuynow(
                                                    true);
                                                homeMainScreenController
                                                    .changeIsLogin(
                                                    true);
                                                // storageController.clearProductVariation();
                                                Get.back();
                                                Get
                                                    .to(
                                                    Routes.loginRoute)!
                                                    .then((value) {
                                                  checkAlreadyInCart();
                                                  setState(() {
                                                    getCartIdList();
                                                    getVariationIdList();
                                                  });
                                                });
                                              }
                                            }
                                            else {
                                              showCustomToast(
                                                  S
                                                      .of(context)
                                                      .productIsOutOfStock);
                                            }
                                          },
                                          buttonheight: 58
                                              .h)),
                                  getHorSpace(
                                      20.h),

                                  Expanded(
                                    child: storageController
                                        .selectedProduct!
                                        .variations
                                        .isNotEmpty
                                        ?
                                    (!cartIdList
                                        .contains(
                                        storageController
                                            .selectedProduct!
                                            .id) || changeVariation.value)
                                        ? getCustomButton(
                                      S
                                          .of(context)
                                          .addToCart,
                                          () async {
                                        if (controller
                                            .variationModel !=
                                            null) {
                                          if (storageController
                                              .selectedProduct!
                                              .stockStatus !=
                                              'outofstock') {
                                            if (cartControllerNew
                                                .cartOtherInfoList
                                                .isEmpty) {
                                              cartControllerNew
                                                  .changeCoupon(
                                                  false);
                                            }
                                            if (!cartIdList
                                                .contains(
                                                storageController
                                                    .selectedProduct!
                                                    .id) ||
                                                changeVariation.value) {
                                              await EasyLoading
                                                  .show();
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    S
                                                        .of(context)
                                                        .addedToCart),
                                                duration: Duration(
                                                    seconds: 2),
                                              );
                                              ScaffoldMessenger
                                                  .of(
                                                  context)
                                                  .showSnackBar(
                                                  snackBar);
                                              cartControllerNew
                                                  .addItemInfo(
                                                  CartOtherInfo(
                                                    variationId:
                                                    (controller
                                                        .variationModel !=
                                                        null)
                                                        ? controller
                                                        .variationModel!
                                                        .id
                                                        : 0,
                                                    variationList: (controller
                                                        .variationModel !=
                                                        null)
                                                        ? controller
                                                        .variationModel!
                                                        .attributes
                                                        : [
                                                    ],
                                                    productId: storageController
                                                        .selectedProduct!
                                                        .id,
                                                    quantity: storageController
                                                        .currentQuantity
                                                        .value,
                                                    stockStatus: storageController
                                                        .selectedProduct!
                                                        .stockStatus,
                                                    type: storageController
                                                        .selectedProduct!
                                                        .type,
                                                    productName: storageController
                                                        .selectedProduct!
                                                        .name,
                                                    productImage: storageController
                                                        .selectedProduct!
                                                        .images[0]
                                                        .src,
                                                    productPrice: (controller
                                                        .variationModel !=
                                                        null)
                                                        ? (parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .salePrice) <=
                                                        0)
                                                        ? parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .regularPrice)
                                                        : parseWcPrice(
                                                        controller
                                                            .variationModel!
                                                            .salePrice)
                                                        : (parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .salePrice) <=
                                                        0)
                                                        ? parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .regularPrice)
                                                        : parseWcPrice(
                                                        storageController
                                                            .selectedProduct!
                                                            .salePrice),
                                                    taxClass: storageController
                                                        .selectedProduct!
                                                        .taxClass,
                                                  ));
                                              await EasyLoading
                                                  .dismiss();
                                              setState(() {
                                                getCartIdList();
                                                getVariationIdList();
                                              });
                                              changeVariation.value = false;
                                            } else {
                                              for (int i = 0; i <
                                                  cartControllerNew
                                                      .cartOtherInfoList
                                                      .length; i++) {
                                                CartOtherInfo element = cartControllerNew
                                                    .cartOtherInfoList[i];

                                                if (element
                                                    .productId ==
                                                    storageController
                                                        .selectedProduct!
                                                        .id) {
                                                  element
                                                      .variationList =
                                                  (controller
                                                      .variationModel !=
                                                      null)
                                                      ? controller
                                                      .variationModel!
                                                      .attributes
                                                      : [
                                                  ];
                                                  element
                                                      .variationId =
                                                  (controller
                                                      .variationModel !=
                                                      null)
                                                      ? controller
                                                      .variationModel!
                                                      .id
                                                      : 0;
                                                  element
                                                      .productPrice =
                                                  (controller
                                                      .variationModel !=
                                                      null)
                                                      ? (parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .salePrice) <=
                                                      0)
                                                      ? parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .regularPrice)
                                                      : parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .salePrice)
                                                      : (parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .salePrice) <=
                                                      0)
                                                      ? parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .regularPrice)
                                                      : parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .salePrice);
                                                }
                                              }
                                              changeVariation.value = false;
                                            }
                                          }
                                          else {
                                            showCustomToast(
                                                S
                                                    .of(context)
                                                    .productIsOutOfStock);
                                          }
                                        } else {
                                          showCustomToast(
                                              S
                                                  .of(context)
                                                  .pleaseWaitVariationsAreLoading);
                                        }
                                      },
                                      color: buttonColor,
                                      buttonheight: 58
                                          .h,
                                      decoration: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(
                                              0),
                                          overlayColor: MaterialStatePropertyAll(
                                              lightGreen),
                                          surfaceTintColor: MaterialStatePropertyAll(
                                              Colors
                                                  .white),
                                          backgroundColor: MaterialStatePropertyAll(
                                              regularWhite),
                                          maximumSize: MaterialStatePropertyAll(
                                            Size(
                                                double
                                                    .infinity,
                                                58
                                                    .h),
                                          ),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      12
                                                          .h),
                                                  side: BorderSide(
                                                      color: buttonColor,
                                                      width: 1.5)))),
                                    )
                                        : getCustomButton(
                                        S
                                            .of(context)
                                            .viewCart, () async {
                                      if (controller
                                          .variationModel !=
                                          null) {
                                        if (cartControllerNew
                                            .cartOtherInfoList
                                            .isEmpty) {
                                          cartControllerNew
                                              .changeCoupon(
                                              false);
                                        }
                                        for (int i = 0; i <
                                            cartControllerNew.cartOtherInfoList
                                                .length; i++) {
                                          CartOtherInfo element =
                                          cartControllerNew
                                              .cartOtherInfoList[i];


                                          if (element
                                              .productId ==
                                              storageController
                                                  .selectedProduct!
                                                  .id) {
                                            if (element.variationId !=
                                                controller.variationModel!.id) {
                                              element.quantity =
                                                  element.quantity;
                                            }
                                            else {
                                              element.quantity = controller
                                                  .currentQuantity
                                                  .value;
                                            }

                                            element
                                                .variationList =
                                                element.variationList;

                                            element
                                                .variationId =
                                                element.variationId;

                                            element
                                                .productPrice =
                                                element.productPrice;
                                            cartControllerNew
                                                .alreadyAddItem();
                                            Get.back();
                                            Get.toNamed(
                                                Routes.cartScreenRoute)
                                                ?.then((value) async {
                                              getCartIdList();
                                              getVariationIdList();
                                              checkAlreadyInCart();
                                            });
                                          }
                                        }
                                        cartControllerNew
                                            .creatUpsellListClear();
                                      } else {
                                        showCustomToast(
                                            S
                                                .of(context)
                                                .pleaseWaitVariationsAreLoading);
                                      }
                                    },
                                        buttonheight: 58
                                            .h)
                                        :
                                    (!cartIdList
                                        .contains(
                                        storageController
                                            .selectedProduct!
                                            .id))
                                        ? getCustomButton(
                                      S
                                          .of(context)
                                          .addToCart,
                                          () async {
                                        if (storageController
                                            .selectedProduct!
                                            .stockStatus !=
                                            'outofstock') {
                                          if (cartControllerNew
                                              .cartOtherInfoList
                                              .isEmpty) {
                                            cartControllerNew
                                                .changeCoupon(
                                                false);
                                          }
                                          if (!cartIdList
                                              .contains(
                                              storageController
                                                  .selectedProduct!
                                                  .id)) {
                                            await EasyLoading
                                                .show();
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  S
                                                      .of(context)
                                                      .addedToCart),
                                              duration: Duration(
                                                  seconds: 2),
                                            );
                                            ScaffoldMessenger
                                                .of(
                                                context)
                                                .showSnackBar(
                                                snackBar);
                                            cartControllerNew
                                                .addItemInfo(
                                                CartOtherInfo(
                                                  variationId:
                                                  (controller
                                                      .variationModel !=
                                                      null)
                                                      ? controller
                                                      .variationModel!
                                                      .id
                                                      : 0,
                                                  variationList: (controller
                                                      .variationModel !=
                                                      null)
                                                      ? controller
                                                      .variationModel!
                                                      .attributes
                                                      : [
                                                  ],
                                                  productId: storageController
                                                      .selectedProduct!
                                                      .id,
                                                  quantity: storageController
                                                      .currentQuantity
                                                      .value,
                                                  stockStatus: storageController
                                                      .selectedProduct!
                                                      .stockStatus,
                                                  type: storageController
                                                      .selectedProduct!
                                                      .type,
                                                  productName: storageController
                                                      .selectedProduct!
                                                      .name,
                                                  productImage: storageController
                                                      .selectedProduct!
                                                      .images[0]
                                                      .src,
                                                  productPrice: (controller
                                                      .variationModel !=
                                                      null)
                                                      ? (parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .salePrice) <=
                                                      0)
                                                      ? parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .regularPrice)
                                                      : parseWcPrice(
                                                      controller
                                                          .variationModel!
                                                          .salePrice)
                                                      : (parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .salePrice) <=
                                                      0)
                                                      ? parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .regularPrice)
                                                      : parseWcPrice(
                                                      storageController
                                                          .selectedProduct!
                                                          .salePrice),
                                                  taxClass: storageController
                                                      .selectedProduct!
                                                      .taxClass,
                                                ));
                                            await EasyLoading
                                                .dismiss();


                                            checkAlreadyInCart();
                                            setState(() {
                                              getCartIdList();
                                              getVariationIdList();
                                            });
                                          } else {
                                            for (int i = 0; i <
                                                cartControllerNew
                                                    .cartOtherInfoList
                                                    .length; i++) {
                                              CartOtherInfo element = cartControllerNew
                                                  .cartOtherInfoList[i];

                                              if (element
                                                  .productId ==
                                                  storageController
                                                      .selectedProduct!
                                                      .id) {
                                                element
                                                    .variationList =
                                                (controller
                                                    .variationModel !=
                                                    null)
                                                    ? controller
                                                    .variationModel!
                                                    .attributes
                                                    : [
                                                ];
                                                element
                                                    .variationId =
                                                (controller
                                                    .variationModel !=
                                                    null)
                                                    ? controller
                                                    .variationModel!
                                                    .id
                                                    : 0;
                                                element
                                                    .productPrice =
                                                (controller
                                                    .variationModel !=
                                                    null)
                                                    ? (parseWcPrice(
                                                    controller
                                                        .variationModel!
                                                        .salePrice) <=
                                                    0)
                                                    ? parseWcPrice(
                                                    controller
                                                        .variationModel!
                                                        .regularPrice)
                                                    : parseWcPrice(
                                                    controller
                                                        .variationModel!
                                                        .salePrice)
                                                    : (parseWcPrice(
                                                    storageController
                                                        .selectedProduct!
                                                        .salePrice) <=
                                                    0)
                                                    ? parseWcPrice(
                                                    storageController
                                                        .selectedProduct!
                                                        .regularPrice)
                                                    : parseWcPrice(
                                                    storageController
                                                        .selectedProduct!
                                                        .salePrice);
                                              }
                                            }
                                          }
                                        }
                                        else {
                                          showCustomToast(
                                              S
                                                  .of(context)
                                                  .productIsOutOfStock);
                                        }
                                      },
                                      color: buttonColor,
                                      buttonheight: 58
                                          .h,
                                      decoration: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(
                                              0),
                                          overlayColor: MaterialStatePropertyAll(
                                              lightGreen),
                                          surfaceTintColor: MaterialStatePropertyAll(
                                              Colors
                                                  .white),
                                          backgroundColor: MaterialStatePropertyAll(
                                              regularWhite),
                                          maximumSize: MaterialStatePropertyAll(
                                            Size(
                                                double
                                                    .infinity,
                                                58
                                                    .h),
                                          ),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      16
                                                          .h),
                                                  side: BorderSide(
                                                      color: buttonColor)))),
                                    )
                                        : getCustomButton(
                                        S
                                            .of(context)
                                            .viewCart, () async {
                                      if (cartControllerNew
                                          .cartOtherInfoList
                                          .isEmpty) {
                                        cartControllerNew
                                            .changeCoupon(
                                            false);
                                      }

                                      bool i = await checkIsCartAlreadyAdded(
                                          storageController
                                              .selectedProduct!
                                              .id);

                                      if (!i) {
                                        await EasyLoading
                                            .show();
                                        final snackBar = SnackBar(
                                          content: Text(
                                              S
                                                  .of(context)
                                                  .addedToCart),
                                          duration: Duration(
                                              seconds: 2),
                                        );
                                        ScaffoldMessenger
                                            .of(
                                            context)
                                            .showSnackBar(
                                            snackBar);
                                        cartControllerNew
                                            .addItemInfo(
                                            CartOtherInfo(
                                              variationId:
                                              (controller
                                                  .variationModel !=
                                                  null)
                                                  ? controller
                                                  .variationModel!
                                                  .id
                                                  : 0,
                                              variationList:
                                              (controller
                                                  .variationModel !=
                                                  null)
                                                  ? controller
                                                  .variationModel!
                                                  .attributes
                                                  : [
                                              ],
                                              productId: storageController
                                                  .selectedProduct!
                                                  .id,
                                              quantity: storageController
                                                  .currentQuantity
                                                  .value,
                                              stockStatus: storageController
                                                  .selectedProduct!
                                                  .stockStatus,
                                              type: storageController
                                                  .selectedProduct!
                                                  .type,
                                              productName: storageController
                                                  .selectedProduct!
                                                  .name,
                                              productImage: storageController
                                                  .selectedProduct!
                                                  .images[0]
                                                  .src,
                                              productPrice: (controller
                                                  .variationModel !=
                                                  null)
                                                  ? (parseWcPrice(
                                                  controller
                                                      .variationModel!
                                                      .salePrice) <=
                                                  0)
                                                  ? parseWcPrice(
                                                  controller
                                                      .variationModel!
                                                      .regularPrice)
                                                  : parseWcPrice(
                                                  controller
                                                      .variationModel!
                                                      .salePrice)
                                                  : (parseWcPrice(
                                                  storageController
                                                      .selectedProduct!
                                                      .salePrice) <=
                                                  0)
                                                  ? parseWcPrice(
                                                  storageController
                                                      .selectedProduct!
                                                      .regularPrice)
                                                  : parseWcPrice(
                                                  storageController
                                                      .selectedProduct!
                                                      .salePrice),
                                              taxClass: storageController
                                                  .selectedProduct!
                                                  .taxClass,
                                            ));
                                        await EasyLoading
                                            .dismiss();
                                        checkAlreadyInCart();
                                      } else {
                                        for (int i = 0;
                                        i <
                                            cartControllerNew
                                                .cartOtherInfoList
                                                .length;
                                        i++) {
                                          CartOtherInfo element =
                                          cartControllerNew
                                              .cartOtherInfoList[i];

                                          if (element
                                              .productId ==
                                              storageController
                                                  .selectedProduct!
                                                  .id) {
                                            element
                                                .variationList =
                                            (controller
                                                .variationModel !=
                                                null)
                                                ? controller
                                                .variationModel!
                                                .attributes
                                                : [
                                            ];
                                            element
                                                .variationId =
                                            (controller
                                                .variationModel !=
                                                null)
                                                ? controller
                                                .variationModel!
                                                .id
                                                : 0;
                                            element
                                                .productPrice =
                                            (controller
                                                .variationModel !=
                                                null)
                                                ? (parseWcPrice(
                                                controller
                                                    .variationModel!
                                                    .salePrice) <=
                                                0)
                                                ? parseWcPrice(
                                                controller
                                                    .variationModel!
                                                    .regularPrice)
                                                : parseWcPrice(
                                                controller
                                                    .variationModel!
                                                    .salePrice)
                                                : (parseWcPrice(
                                                storageController
                                                    .selectedProduct!
                                                    .salePrice) <=
                                                0)
                                                ? parseWcPrice(
                                                storageController
                                                    .selectedProduct!
                                                    .regularPrice)
                                                : parseWcPrice(
                                                storageController
                                                    .selectedProduct!
                                                    .salePrice);
                                            cartControllerNew
                                                .alreadyAddItem();
                                            Get.back();
                                            Get.toNamed(
                                                Routes.cartScreenRoute)!
                                                .then((value) async {
                                              getCartIdList();
                                              getVariationIdList();
                                              checkAlreadyInCart();
                                            });
                                          }
                                        }
                                      }
                                      cartControllerNew
                                          .creatUpsellListClear();
                                    },
                                        buttonheight: 58
                                            .h),
                                  )

                                ],
                              ).paddingAll(
                                  20.h),
                            ));
                      },
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },).then((value) {
      checkAlreadyInCart();
      setState(() {
        getCartIdList();
        getVariationIdList();
      });
    });
  }

  Widget buildReviewList(ToyDetailScreenController toyDetailScreenController) {
    if (toyDetailScreenController.productReviewList.isEmpty) {
      if (toyDetailScreenController.loading) {
        return SizedBox();
      } else if (toyDetailScreenController.error) {
        return SizedBox();
      }
    }
    return Container(
      color: regularWhite,
      child: Column(
        children: [
          storageController
              .selectedProduct!
              .averageRating !=
              "0.00"
              ? Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              getVerSpace(
                  20.h),
              Row(mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
                  children: [
                    getCustomFont(
                        "${S
                            .of(
                            context)
                            .reviews} (${toyDetailScreenController
                            .productReviewList
                            .length})",
                        16.sp,
                        regularBlack,
                        1,
                        fontWeight: FontWeight
                            .w600,
                        txtHeight: 1.5
                            .h),
                    Padding(
                        padding: EdgeInsets
                            .only(
                            top: 2
                                .h),
                        child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.ratingDataRoute, arguments: [
                                toyDetailScreenController.productReviewList,
                                storageController
                                    .selectedProduct!
                              ]);
                            },
                            child: Container(
                              height: 29
                                  .h,
                              decoration: BoxDecoration(
                                  color: gray,
                                  borderRadius: BorderRadius
                                      .circular(
                                      30
                                          .h)),
                              alignment: Alignment
                                  .center,
                              child: getCustomFont(
                                  S
                                      .of(
                                      context)
                                      .viewAll,
                                  14
                                      .sp,
                                  darkGray,
                                  1,
                                  fontWeight: FontWeight
                                      .w400,
                                  txtHeight: 1.5
                                      .h,
                                  textAlign: TextAlign
                                      .center)
                                  .paddingSymmetric(
                                  horizontal: 10
                                      .h),
                            )))
                  ]),
              getVerSpace(
                  20.h),
              ListView
                  .separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context,
                      index) {
                    return getVerSpace(
                        17.h);
                  },
                  itemCount: toyDetailScreenController.productReviewList
                      .length +
                      (toyDetailScreenController.isLastPage ? 0 : 1) >
                      2 ? 2 : toyDetailScreenController.productReviewList
                      .length +
                      (toyDetailScreenController.isLastPage ? 0 : 1),
                  itemBuilder: (context,
                      index) {
                    if (index ==
                        toyDetailScreenController.productReviewList.length -
                            toyDetailScreenController.nextPageTrigger) {
                      _toyDetailScreenController.fetchData(storageController);
                    }
                    if (index ==
                        toyDetailScreenController.productReviewList.length) {
                      if (toyDetailScreenController.error) {
                        return SizedBox();
                      } else {
                        return SizedBox();
                      }
                    }
                    ModelReviewProduct model = toyDetailScreenController
                        .productReviewList[index];

                    return ProductdetailItemWidget(
                        model);
                  }),
            ],
          ).paddingSymmetric(
              horizontal:
              20.h)

              : SizedBox(),
        ],
      ),
    ).paddingOnly(
        top: 16.h);
  }
}
