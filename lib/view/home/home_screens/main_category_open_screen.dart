// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../generated/l10n.dart';
import '../../../model/product_review.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constant.dart';
import '../../../utils/pref_data.dart';
import '../../../woocommerce/models/product_category.dart';
import '../../../woocommerce/models/products.dart';

class MainCategoryScreen extends StatefulWidget {
  const MainCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  HomeMainScreenController homeScreenContainerController =
      Get.put(HomeMainScreenController());
  HomeScreenController storageController = Get.put(HomeScreenController());

  StorageController storeController = Get.put(StorageController());

  HomeMainScreenController homeMainScreenControllerFind =
      Get.find<HomeMainScreenController>();
  ProductDataController productController = Get.put(ProductDataController());

  bool isCategoryLoading = true;
  bool isPlantLoading = true;

  late List<WooProduct> plantList;
  late bool categoryError;
  late bool categoryLoading;
  late List<WooProductCategory> categoryList;

  Future<List<WooProduct>> fetchData() async {
    try {
      // if (homeMainScreenController.checkNullOperator()) {
      //   return;
      // }

      final response = await homeScreenContainerController.api1!.get(
          "products?category=${homeMainScreenControllerFind.categoryIndex.toString()}");
      List parseRes = response;
      List<WooProduct> postList =
          parseRes.map((e) => WooProduct.fromJson(e)).toList();
      setState(() {
        plantList.addAll(postList);
        if (plantList.isEmpty) {
          isPlantLoading = false;
        } else {
          isPlantLoading = true;
        }
      });
      print("plantList.length =========${plantList}");
      return postList;
    } catch (e) {
      if (mounted) {}
    }
    return [];
  }

  Future<List<WooProductCategory>> getCategoryData() async {
    try {
      // if (homeScreenContainerController.checkNullOperator()) {
      //   return;
      // }
      final response = await homeScreenContainerController.api1!.get(
          "products/categories?parent=${homeScreenContainerController.categoryIndex.value}");
      List parseRes = response;
      List<WooProductCategory> postList =
          parseRes.map((e) => WooProductCategory.fromJson(e)).toList();

      setState(() {
        categoryList.addAll(postList);
        if (categoryList.isEmpty) {
          isCategoryLoading = false;
        } else {
          isCategoryLoading = true;
        }
      });
      return postList;
    } catch (e) {
      categoryLoading = false;
      categoryError = true;
      return [];
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });

    plantList = [];

    fetchData();

    categoryList = [];
    categoryLoading = true;
    categoryError = false;
    getCategoryData();

    getFavourit();
    // TODO: implement initState
    super.initState();
  }

  getFavourit() {
    if (homeScreenContainerController.checkNullOperator()) {
      return;
    }

    productController
        .getAllFavouriteList(homeScreenContainerController.wooCommerce1!);
  }

  Widget buildPlantView() {
    // if (plantList.isEmpty) {
    //   if (_loading) {
    //     return GridView.builder(
    //       primary: false,
    //       shrinkWrap: true,
    //       padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           mainAxisExtent: 280.h,
    //           mainAxisSpacing: 20.h,
    //           crossAxisSpacing: 20.h),
    //       itemCount: 6,
    //       itemBuilder: (BuildContext context, int index) {
    //         return productDataFormateGridViewShimmer();
    //       },
    //     );
    //   } else if (_error) {
    //     return Center(
    //         child: CircularProgressIndicator(
    //       color: buttonColor,
    //     ));
    //   }
    // }

    return FutureBuilder(
      future: categoryDetailCache(
          uniqueQueryKey: valueOrDefault(
              homeMainScreenControllerFind.categoryIndex.toString(), "dsfdf"),
          requestFn: () => fetchData()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        if (snapshot.hasData) {
          List<WooProduct> plantList = snapshot.data as List<WooProduct>;
          return GridView.builder(
            itemCount: plantList.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 280.h,
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.h,
            ),
            itemBuilder: (context, index) {
              WooProduct product = plantList[index];
              return GetBuilder<StorageController>(
                  init: StorageController(),
                  builder: (findHomeScreenController) =>
                      productDataFormateGridView(context, () {
                        storageController.setSelectedWooProduct(product);
                        storageController.clearProductVariation();

                        sendToPlanDetail(
                            id: "${product.id}",
                            tag: "main${index}${product.images[0].src}",
                            function: () {
                              getFavDataList();
                            },
                            titleTag: "main${index}${product.name}",
                            priceTag: "main${index}price",
                            ratingTag: "main${index}rating");
                      },
                          product,
                          GestureDetector(
                            onTap: () {
                              checkInFavouriteList(product);
                              List<String> strList = favProductList
                                  .map((i) => i.toString())
                                  .toList();
                              PrefData().setFavouriteList(strList);
                              getFavourit();
                            },
                            child: Obx(
                              () {
                                return getSvgImage(
                                        favProductList
                                                .contains(product.id.toString())
                                            ? "likefillIconnew.svg"
                                            : "likeIconnew.svg",
                                        height: 22.h,
                                        width: 22.h)
                                    .marginOnly(
                                        top: 10.h, right: 14.h, left: 15.h);
                              },
                            ),
                          ),
                          index));
            },
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: buttonColor,
          ),
        );
      },
    );
  }

  Widget buildCategoryView() {
    if (categoryList.isEmpty) {
      if (categoryLoading) {
        return SizedBox();
      } else if (categoryError) {
        return Center(child: CircularProgressIndicator());
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 20.h, top: 20.h),
          child: getCustomFont(
              S.of(context).subCategory, 20.sp, regularBlack, 1,
              fontWeight: FontWeight.w700),
        ),
        FutureBuilder(
          future: subCategoryCache(
            uniqueQueryKey: valueOrDefault(
                "${homeScreenContainerController.categoryIndex.value}",
                "ddddd"),
            requestFn: () => getCategoryData(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              List<WooProductCategory> categoryList =
                  snapshot.data as List<WooProductCategory>;
              return GridView.builder(
                itemCount: categoryList.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    top: 20.h, right: 20.h, left: 20.h, bottom: 20.h),
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 205.h,
                    mainAxisSpacing: 20.h,
                    crossAxisSpacing: 20.h),
                itemBuilder: (context, index) {
                  WooProductCategory product = categoryList[index];
                  return product.image == null
                      ? SizedBox()
                      : product.image!.src!.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 9.h),
                              child: GestureDetector(
                                onTap: () {
                                  storeController
                                      .changeProductId(product.id!.toInt());
                                  storeController.changeCategoryName(
                                      product.name.toString());
                                  homeScreenContainerController
                                      .setIsnavigatesubcat(true);
                                  homeScreenContainerController
                                      .setSubcategory(product);

                                  Get.toNamed(Routes.categoryProdyctRoute)!
                                      .then((value) {
                                    getFavDataList();
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 168.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.h),
                                          // border: Border.all(color: black20),
                                          color: regularWhite),
                                      // padding: EdgeInsets.all(50.h),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.h),
                                        child: product.image!.src!.isEmpty
                                            ? getAssetImage(
                                                "no_image_banner.png")
                                            : getNetworkImage(
                                                context,
                                                "${product.image!.src}"
                                                    .toString(),
                                                double.infinity,
                                                double.infinity,
                                                boxFit: BoxFit.fill),
                                      ),
                                    ),
                                    getVerSpace(8.h),
                                    Center(
                                      child: getCustomFont(
                                          product.name!, 16.sp, regularBlack, 1,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            );
                },
              );
            }
            return Center(
              child: getProgressDialog(),
            );
          },
        )
      ],
    );
  }

  Future<List<ModelReviewProduct>> getReviewList() async {
    if (homeScreenContainerController.checkNullOperator()) {
      return [];
    }

    var result = await homeScreenContainerController.wooCommerce1!
        .getProductReviewByProductId(
            productId: storageController.selectedProduct!.id,
            wooCommerceAPI: homeScreenContainerController.api1!);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    setStatusBar();
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          homeScreenContainerController.issubcatNavigate
              ? homeScreenContainerController.setIsnavigatesubcat(false)
              : SizedBox();
          Get.back();
          return Future.value(true);
        },
        child: Scaffold(
            backgroundColor: regularWhite,
            body: SafeArea(
              child: Container(
                color: bgColor,
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () => Future.sync(
                              () {
                                // pagingController.refresh();
                                Future.delayed(Duration.zero, () async {
                                  getFavDataList();
                                });

                                plantList = [];

                                categoryDetailCache(
                                    overrideCache: true,
                                    uniqueQueryKey: valueOrDefault(
                                        homeMainScreenControllerFind
                                            .categoryIndex
                                            .toString(),
                                        "dsfdf"),
                                    requestFn: () => fetchData());

                                categoryList = [];
                                categoryLoading = true;
                                categoryError = false;
                                subCategoryCache(
                                    overrideCache: true,
                                    uniqueQueryKey: valueOrDefault(
                                        "${homeScreenContainerController.categoryIndex.value}",
                                        "ddddd"),
                                    requestFn: () => getCategoryData());

                                getFavourit();
                                print("====================refresh");
                                _refreshController.refreshCompleted();
                              },
                            ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 73.h,
                                  width: double.infinity,
                                  color: regularWhite,
                                  child: GetBuilder<HomeMainScreenController>(
                                    init: HomeMainScreenController(),
                                    builder: (controller) => getAppBar(
                                        homeScreenContainerController
                                            .mainCatName!,
                                        space: 109.h, function: () {
                                      controller.issubcatNavigate
                                          ? controller
                                              .setIsnavigatesubcat(false)
                                          : SizedBox();
                                      Get.back();
                                    }),
                                  )),
                              getVerSpace(8.h),
                              GetBuilder<HomeScreenController>(
                                init: HomeScreenController(),
                                builder: (controller) {
                                  return !isPlantLoading && !isCategoryLoading
                                      ? Expanded(
                                          child: Center(
                                            child: getEmptyWidget(
                                                context,
                                                Constant.noProductLogo,
                                                S.of(context).noProductsYet,
                                                S.of(context).yourProductsListIsEmptyPleaseWaitForSomeTime,
                                                S.of(context).goToHome, () {
                                              homeMainScreenController
                                                  .change(0);
                                              homeMainScreenController
                                                  .tabController!
                                                  .animateTo(
                                                0,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                              Get.toNamed(Routes.homeMainRoute);
                                            }).paddingSymmetric(
                                                horizontal: 20.h),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView(
                                            children: [
                                              !isPlantLoading
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 12.h),
                                                      child: Container(
                                                        color: regularWhite,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            buildPlantView(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              !isCategoryLoading
                                                  ? SizedBox()
                                                  : Container(
                                                      color: regularWhite,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          buildCategoryView()
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        );
                                  // );
                                },
                              )
                            ]))),
              ),
            )),
      ),
    );
  }

  RxList<String> favProductList = <String>[].obs;

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

  onTapArrowleft9() {
    Get.back();
  }
}
