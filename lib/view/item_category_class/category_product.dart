import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes.dart';
import '../../utils/constant.dart';
import '../../utils/constantWidget.dart';
import '../../utils/pref_data.dart';
import '../../woocommerce/models/product_category.dart';
import '../../woocommerce/models/products.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({Key? key}) : super(key: key);

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  HomeMainScreenController homeScreenContainerController =
      Get.put(HomeMainScreenController());

  HomeMainScreenController homeController = Get.put(HomeMainScreenController());

  StorageController storeController = Get.put(StorageController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  late List<WooProduct> plantList;

  late bool categoryIsLastPage;
  late bool categoryError;
  late bool categoryLoading;
  late List<WooProductCategory> categoryList;
  bool isCategoryLoading = true;
  bool isPlantLoading = true;
  ProductDataController productController = Get.put(ProductDataController());

  Future<List<WooProduct>> fetchData() async {
    // if(homeController.checkNullOperator()){
    //   return;
    // }
    try {
      final response = await homeController.api1!.get(
          "products?category=${storeController.productId.value.toString()}");
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
      print("plantList.length ${plantList.length}");
      return postList;
    } catch (e) {
      setState(() {});
      return [];
    }
  }

  Widget buildPlantView() {
    // if (plantList.isEmpty) {
    //   if (_loading) {
    //     return GridView.builder(
    //       itemCount: 6,
    //       physics: NeverScrollableScrollPhysics(),
    //       padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
    //       shrinkWrap: true,
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         mainAxisExtent: 280.h,
    //         crossAxisCount: 2,
    //         mainAxisSpacing: 16.h,
    //         crossAxisSpacing: 16.h,
    //       ),
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
      future: subCategoryDetailCache(
        uniqueQueryKey:
            valueOrDefault(storeController.productId.value.toString(), "ddddd"),
        requestFn: () => fetchData(),
      ),
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
                        homeScreenController.setSelectedWooProduct(product);
                        homeScreenController.clearProductVariation();

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

  Future<void> getCategoryData() async {
    try {
      if (homeController.checkNullOperator()) {
        return;
      }
      final response = await homeController.api1!.get(
          "products/categories?parent=${homeController.currentcategory!.id}");
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
    } catch (e) {
      setState(() {
        categoryLoading = false;
        categoryError = true;
      });
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
    categoryIsLastPage = false;
    categoryLoading = true;
    categoryError = false;
    getCategoryData();

    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });
    getFavourit();
    super.initState();
  }

  getFavourit() {
    if (homeController.checkNullOperator()) {
      return;
    }
    productController.getAllFavouriteList(homeController.wooCommerce1!);
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
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryList.length,
          padding:
              EdgeInsets.only(top: 24.h, right: 20.h, left: 20.h, bottom: 20.h),
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            WooProductCategory product = categoryList[index];
            return GestureDetector(
              onTap: () {
                storeController.changeProductId(product.id!.toInt());
                storeController.changeCategoryName(product.name.toString());
                homeController.setIsnavigatesubcat(true);
                homeController.setSubcategory(product);
                Get.back();
                Get.toNamed(Routes.categoryProdyctRoute)!.then((value) {
                  getFavDataList();
                });
              },
              child: Column(
                children: [
                  Container(
                    height: 173.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: black20),
                        color: regularWhite),
                    padding: EdgeInsets.all(50.h),
                    child: getNetworkImage(
                        context,
                        "${product.image!.src}".toString(),
                        double.infinity,
                        double.infinity,
                        boxFit: BoxFit.fill),
                  ),
                  getVerSpace(8.h),
                  getCustomFont(product.name!, 16.sp, regularBlack, 1,
                      fontWeight: FontWeight.w600)
                ],
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 205.h,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.h),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: Scaffold(
        backgroundColor: regularWhite,
        body: SafeArea(
            child: Container(
          color: bgColor,
          width: double.infinity,
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: () => Future.sync(
              () {
                // pagingController.refresh();
                print("====================refresh");
                Future.delayed(Duration.zero, () async {
                  getFavDataList();
                });
                plantList = [];
                subCategoryDetailCache(
                  overrideCache: true,
                  uniqueQueryKey: valueOrDefault(
                      storeController.productId.value.toString(), "ddddd"),
                  requestFn: () => fetchData(),
                );

                categoryList = [];
                categoryIsLastPage = false;
                categoryLoading = true;
                categoryError = false;
                getCategoryData();

                Future.delayed(Duration.zero, () async {
                  getFavDataList();
                });
                getFavourit();
                _refreshController.refreshCompleted();
              },
            ),
            child: Column(
              children: [
                Container(
                    height: 73.h,
                    width: double.infinity,
                    color: regularWhite,
                    child: GetBuilder<HomeMainScreenController>(
                      init: HomeMainScreenController(),
                      builder: (controller) => getAppBar(
                          storeController.categoryName.value,
                          space: 109.h, function: () {
                        controller.issubcatNavigate
                            ? controller.setIsnavigatesubcat(false)
                            : SizedBox();
                        Get.back();
                      }),
                    )),
                !isPlantLoading && !isCategoryLoading
                    ? Expanded(
                        child: Center(
                          child: getEmptyWidget(
                              context,
                              Constant.noProductLogo,
                              S.of(context).noProductsYet,
                              S
                                  .of(context)
                                  .yourProductsListIsEmptyPleaseWaitForSomeTime,
                              S.of(context).goToHome, () {
                            homeMainScreenController.change(0);
                            homeMainScreenController.tabController!.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                            Get.toNamed(Routes.homeMainRoute);
                          }).paddingSymmetric(horizontal: 20.h),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          children: [
                            !isPlantLoading
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Container(
                                      color: regularWhite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [buildPlantView()],
                                      ),
                                    ),
                                  ),
                            !isCategoryLoading
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.only(top: 8.h),
                                    color: regularWhite,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [buildCategoryView()],
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
    );
  }
}
