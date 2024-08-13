// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';
import '../../../utils/storage.dart';
import '../../../woocommerce/models/product_variation.dart';
import '../../../woocommerce/models/products.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchScreenController searchScreenController =
      Get.put(SearchScreenController());

  HomeScreenController findHomeScreenController =
      Get.find<HomeScreenController>();
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  ProductDataController productController = Get.find<ProductDataController>();

  RxList<String> favProductList = <String>[].obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getFavDataList();
      searchScreenController.getAllCartList();
    });
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }

  getSeachData() {}

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          searchScreenController.groupFiftySixController.text = '';
          searchScreenController.clearData();
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
              child: Container(
            color: bgColor,
            child: GetBuilder<SearchScreenController>(
              init: SearchScreenController(),
              builder: (searchScreenController) => Column(
                children: [
                  Container(
                    color: regularWhite,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          height: 60.h,
                          color: regularWhite,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: GestureDetector(
                                    onTap: () {
                                      searchScreenController
                                          .groupFiftySixController.text = '';
                                      searchScreenController.clearData();

                                      Get.back();
                                    },
                                    child: getSvgImage("arrow_square_left.svg",
                                            height: 24.h, width: 24.h)
                                        .marginOnly(right: 20.h, left: 20.h)),
                              ),
                            ],
                          ),
                        ),
                        getSearchField(S.of(context).search,
                            searchScreenController.groupFiftySixController,
                            fontweight: FontWeight.w500,
                            function: () {},
                            autofocus: true,
                            onFieldSubmitted: (value) {
                              if (homeMainScreenController
                                  .checkNullOperator()) {
                                return;
                              }
                              if (value.isNotEmpty) {
                                searchScreenController.loadData(value,
                                    homeMainScreenController.wooCommerce1!);
                                if (value.isNotEmpty) {
                                  List<String> hisList = [];
                                  if (getData(keySearchHistory) != null) {
                                    hisList = List<String>.from(
                                        getData(keySearchHistory));
                                  }
                                  if (!hisList.contains(value)) {
                                    hisList.add(value);
                                    setData(keySearchHistory, hisList);
                                  }
                                  searchScreenController.listChange.refresh();
                                } else {
                                  showCustomToast("No item found");
                                }
                              }
                            },
                            textInputAction: TextInputAction.done,
                            prefixiconimage: "searchIcon.png",
                            suffixiconimage: "filterIcon.png",
                            suffixfunction: () {
                              showModalBottomSheet(
                                  backgroundColor: regularWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.h),
                                  ),
                                  context: context,
                                  builder: (context) => SizedBox());
                            }).paddingSymmetric(horizontal: 20.h),
                      ],
                    ).paddingOnly(bottom: 20.h),
                  ),
                  getVerSpace(20.h),
                  Expanded(
                    child: ListView(
                      primary: false,
                      shrinkWrap: false,
                      children: [
                        GetBuilder<SearchScreenController>(
                          init: SearchScreenController(),
                          builder: (controller) {
                            if (getData(keySearchHistory) != null) {
                              List<String> hisList =
                                  List<String>.from(getData(keySearchHistory));
                              if (hisList.isNotEmpty) {
                                return Container(
                                    color: regularWhite,
                                    width: double.maxFinite,
                                    child: Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        padding: EdgeInsets.only(
                                            left: 20.h,
                                            top: 16.h,
                                            right: 20.h,
                                            bottom: 16.h),
                                        decoration: BoxDecoration(),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getCustomFont(
                                                          S.of(context).recent,
                                                          18.sp,
                                                          regularBlack,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      GestureDetector(
                                                        onTap: () {
                                                          hisList.clear();
                                                          setData(
                                                              keySearchHistory,
                                                              hisList);
                                                          controller.listChange
                                                              .refresh();
                                                          controller
                                                              .clearData();
                                                        },
                                                        child: getCustomFont(
                                                            S
                                                                .of(context)
                                                                .clearAll,
                                                            14.sp,
                                                            buttonColor,
                                                            1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  )),
                                              getDivider(
                                                  color: dividerColor,
                                                  horPadding: 0.h),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15.h),
                                                  child: ListView.separated(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return getVerSpace(
                                                            16.h);
                                                      },
                                                      itemCount:
                                                          hisList.length >= 5
                                                              ? 5
                                                              : hisList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            if (homeMainScreenController
                                                                .checkNullOperator()) {
                                                              return;
                                                            }

                                                            searchScreenController
                                                                .loadData(
                                                                    hisList[
                                                                        index],
                                                                    homeMainScreenController
                                                                        .wooCommerce1!);
                                                            searchScreenController
                                                                    .groupFiftySixController
                                                                    .text =
                                                                hisList[index];
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              getCustomFont(
                                                                  hisList[
                                                                      index],
                                                                  16.sp,
                                                                  regularBlack,
                                                                  1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              Spacer(),
                                                              GetBuilder<
                                                                  SearchScreenController>(
                                                                builder:
                                                                    (controller) =>
                                                                        GestureDetector(
                                                                  onTap: () {
                                                                    hisList.removeAt(
                                                                        index);
                                                                    setData(
                                                                        keySearchHistory,
                                                                        hisList);
                                                                    controller
                                                                        .listChange
                                                                        .refresh();
                                                                    controller
                                                                        .clearData();
                                                                  },
                                                                  child: getSvgImage(
                                                                      "close_icon_circuler.svg",
                                                                      height:
                                                                          24.h,
                                                                      width:
                                                                          24.h),
                                                                ),
                                                                init:
                                                                    SearchScreenController(),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      })),
                                            ])));
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        GetBuilder<SearchScreenController>(
                          init: SearchScreenController(),
                          builder: (controller) => controller.loader
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: getProgressDialog(),
                                  ),
                                )
                              : controller.searchItemList.isEmpty
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getAssetImage(
                                              Constant.searchEmptyLogo,
                                              height: 140.h,
                                              width: 140.h),
                                          getVerSpace(30.h),
                                          getCustomFont(
                                              S.of(context).noResultsFound,
                                              22.sp,
                                              regularBlack,
                                              1,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center,
                                              txtHeight: 1.5.h),
                                          getVerSpace(8.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 61.h),
                                            child: getMultilineCustomFont(
                                                S
                                                    .of(context)
                                                    .tryUsingSimplerSearchTermsAndThenFilteringTheCorrect,
                                                16.sp,
                                                regularBlack,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.center,
                                                txtHeight: 1.5.h),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      color: regularWhite,
                                      width: double.maxFinite,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return getVerSpace(20.h);
                                        },
                                        itemCount:
                                            controller.searchItemList.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.h, vertical: 20.h),
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          WooProduct item =
                                              controller.searchItemList[index];
                                          return GestureDetector(
                                              onTap: () {
                                                homeScreenController
                                                    .setSelectedWooProduct(
                                                        item);
                                                homeScreenController
                                                    .addListVariation(
                                                        homeMainScreenController,
                                                        item.id);
                                                findHomeScreenController
                                                    .clearProductVariation();

                                                sendToPlanDetail(
                                                  id: "${item.id}",
                                                    tag:
                                                        "search${index}${item.images[0].src}",
                                                    function: () {
                                                      getFavDataList();
                                                    });

                                                // Get.to(PlantDetail(
                                                //         tag:
                                                //             "search${index}${item.images[0].src}"))!
                                                //     .then((value) {
                                                //   getFavDataList();
                                                // });
                                              },
                                              child: Container(
                                                width: 111.h,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 111.h,
                                                      width: 111.h,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: lightGray,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.h)),
                                                      // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
                                                      child:
                                                          // ignore: unnecessary_null_comparison
                                                          item.images[0].src ==
                                                                  null
                                                              ? SizedBox()
                                                              : Hero(
                                                                  tag:
                                                                      "search${index}${item.images[0].src}",
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        "${item.images[0].src}",
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                Shimmer.fromColors(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20.h),
                                                                        width:
                                                                            111.h,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              111.h,
                                                                          height:
                                                                              111.h,
                                                                          decoration:
                                                                              getButtonDecoration(
                                                                            gray,
                                                                            withCorners:
                                                                                true,
                                                                            corner:
                                                                                22.h,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                    )),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ).paddingOnly(
                                                                          top: 19
                                                                              .h,
                                                                          right: 19
                                                                              .h,
                                                                          left: 20
                                                                              .h,
                                                                          bottom:
                                                                              20.h),
                                                                ),
                                                    ),
                                                    getHorSpace(12.h),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: item.name
                                                                        .length >
                                                                    30
                                                                ? 41.h
                                                                : 21.h,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: getCustomFont(
                                                                      "${item.name}",
                                                                      14.sp,
                                                                      regularBlack,
                                                                      2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      txtHeight:
                                                                          1.5.h)
                                                                  .paddingSymmetric(
                                                                horizontal:
                                                                    12.h,
                                                              ),
                                                            ),
                                                          ),
                                                          // getVerSpace(7.h),
                                                          item.averageRating ==
                                                                  "0.00"
                                                              ? SizedBox()
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 7
                                                                              .h),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      getSvgImage(
                                                                          "gray_star_icon.svg",
                                                                          height: 12
                                                                              .h,
                                                                          width:
                                                                              12.h),
                                                                      getHorSpace(
                                                                          4.h),
                                                                      getCustomFont(
                                                                          "${item.averageRating}(${item.ratingCount.toString()})",
                                                                          12.sp,
                                                                          regularBlack,
                                                                          1,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ],
                                                                  ).paddingSymmetric(
                                                                      horizontal:
                                                                          12.h),
                                                                ),
                                                          // getVerSpace(6.h),
                                                          item.onSale
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 6
                                                                              .h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        (item.salePrice.isNotEmpty)
                                                                            ? formatStringCurrency(
                                                                                total: item.regularPrice,
                                                                                context: context)
                                                                            : formatStringCurrency(total: item.regularPrice, context: context),
                                                                        style: TextStyle(
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                            fontSize: 12.sp,
                                                                            color: Colors.grey,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: Constant.fontsFamily),
                                                                      ),
                                                                      getHorSpace(
                                                                          6.h),
                                                                      (item.salePrice
                                                                              .isNotEmpty)
                                                                          ? getCustomFont(
                                                                              (homeScreenController.variationModel == null) ? "${100 * (double.parse(item.regularPrice) - double.parse(item.salePrice)) ~/ double.parse(item.regularPrice)}% OFF" : getCurrency(context) + homeScreenController.variationModel!.regularPrice ?? "",
                                                                              14.sp,
                                                                              buttonColor,
                                                                              1,
                                                                              fontWeight: FontWeight.w500)
                                                                          : SizedBox(),
                                                                    ],
                                                                  ).paddingSymmetric(
                                                                      horizontal:
                                                                          12.h),
                                                                )
                                                              : SizedBox(
                                                                  height: 0),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 6.h),
                                                            child: homeMainScreenController
                                                                    .checkNullOperator()
                                                                ? Container()
                                                                : FutureBuilder<
                                                                    List<
                                                                        WooProductVariation>>(
                                                                    future: homeMainScreenController.wooCommerce1!.getProductVariations(
                                                                        homeMainScreenController
                                                                            .api1!,
                                                                        productId:
                                                                            item.id),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        if (item
                                                                            .variations
                                                                            .isEmpty) {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 12.h, bottom: 12.h),
                                                                            child:
                                                                                Container(height: 24.h, child: getCustomFont(formatStringCurrency(total: item.onSale ? item.salePrice : item.price, context: context), 16.sp, regularBlack, 1, fontWeight: FontWeight.w600)),
                                                                          );
                                                                        } else {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 12.h, bottom: 12.h),
                                                                            child:
                                                                                Container(height: 24.h, child: getCustomFont("\$${snapshot.data!.last.price} - \$${snapshot.data!.first.price}", 16.sp, regularBlack, 1, fontWeight: FontWeight.w600)),
                                                                          );
                                                                        }
                                                                      } else {
                                                                        return Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 12.h,
                                                                              bottom: 12.h),
                                                                          child: Container(
                                                                              height: 24.h,
                                                                              child: getCustomFont(formatStringCurrency(total: item.onSale ? item.salePrice : item.price, context: context), 16.sp, regularBlack, 1, fontWeight: FontWeight.w600)),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
