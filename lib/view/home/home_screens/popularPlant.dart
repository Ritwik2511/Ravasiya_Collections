// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../utils/pref_data.dart';
import '../../../woocommerce/models/products.dart';
import 'filter_sheet.dart';

class PopularPlantScreen extends StatefulWidget {
  const PopularPlantScreen({Key? key}) : super(key: key);

  @override
  State<PopularPlantScreen> createState() => _PopularPlantScreenState();
}

class _PopularPlantScreenState extends State<PopularPlantScreen>
    with SingleTickerProviderStateMixin {
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  ProductDataController productController = Get.put(ProductDataController());
  HomeMainScreenController homeMainScreenController =
  Get.put(HomeMainScreenController());
  RxList<String> favProductList = <String>[].obs;

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }

  late AnimationController animationController;
  int dialogSecond = 300;

  @override
  void initState() {
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = Duration(milliseconds: dialogSecond);
    animationController.reverseDuration = Duration(milliseconds: dialogSecond);
    Future.delayed(Duration.zero, () async {
      getFavDataList();
      homeScreenController.cleanPopularData();
      homeScreenController.fetchPopularData(homeMainScreenController);
      getFavourit();
    });

    super.initState();
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  getFavourit() {

    if(homeMainScreenController.checkNullOperator()){
      return;
    }

    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }



  Widget buildPopularView(HomeScreenController homeScreen) {
    if (homeScreen.popularList.isEmpty) {
      if (homeScreen.popularLoading) {
        return Center(child:  getProgressDialog());
      } else if (homeScreen.popularError) {
        return Center(child: CircularProgressIndicator());
      }
    }

    return AnimationLimiter(
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 280.h,
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 20.h),
        itemCount: homeScreen.popularList.length + (homeScreen.popularIsLastPage ? 0 : 1),
        itemBuilder: (BuildContext context, int index) {
          if (index == homeScreen.popularList.length - homeScreen.popularNextPageTrigger) {
            // fetchPopularData();
            homeScreenController.fetchPopularData(homeMainScreenController);
          }
          if (index == homeScreen.popularList.length) {
            if (homeScreen.popularError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return productDataFormateGridViewShimmer();
            }
          }

          WooProduct product = homeScreen.popularList[index];

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: productDataFormateGridView(context, () {
                  homeScreenController.setSelectedWooProduct(product);
                  homeScreenController.clearProductVariation();

                  sendToPlanDetail(
                    id: "${product.id}",
                      tag: 'main${index}${product.images[0].src}',
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
                        List<String> strList =
                            favProductList.map((i) => i.toString()).toList();
                        PrefData().setFavouriteList(strList);
                        getFavourit();
                      },
                      child: Obx(
                        () {
                          return getSvgImage(
                                  favProductList.contains(product.id.toString())
                                      ? "likefillIconnew.svg"
                                      : "likeIconnew.svg",
                                  height: 22.h,
                                  width: 22.h)
                              .marginOnly(top: 10.h, right: 14.h, left: 15.h);
                        },
                      ),
                    ),
                    index),
              ),
            ),
          );
        },
      ),
    );
  }

  HomeScreenController findHomeScreenController =
      Get.put(HomeScreenController());
  FilterController controller = Get.put(FilterController());
  List<WooProduct> flashSaleList = [];

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);

    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
          onWillPop: () async {
            Get.back();
            return Future.value(true);
          },
          child: Scaffold(
            backgroundColor: regularWhite,
            body: SafeArea(
              child: Container(
                color: bgColor,
                child: GetBuilder<HomeScreenController>(
                  init: HomeScreenController(),
                  builder: (homeScreen) =>  Column(
                    children: [
                      GetBuilder<FilterController>(
                        init: FilterController(),
                        builder: (controller) => Container(
                            height: 73.h,
                            width: double.infinity,
                            color: regularWhite,
                            child: simpleAppBar("Popular Products", space: 89.h,
                                function: () {
                              Get.back();
                            }, filterFunction: () {
                              showModalBottomSheet(
                                transitionAnimationController: animationController,
                                backgroundColor: regularWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.h))),
                                context: context,
                                builder: (context) {
                                  return FilterBottomsheet(
                                    Get.put(
                                      FilterController(),
                                    ),
                                  );
                                },
                              ).then((value) {
                                homeScreenController.popularFiter(controller);
                              });
                            })),
                      ),
                      getVerSpace(8.h),
                      Expanded(
                        child: Container(
                          color: regularWhite,
                          child: buildPopularView(homeScreen),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }
}
