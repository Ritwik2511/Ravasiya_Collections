// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/constant.dart';

import '../../controller/controller.dart';
import '../../generated/l10n.dart';
import '../../utils/color_category.dart';
import '../../utils/constantWidget.dart';
import '../../utils/pref_data.dart';
import '../../woocommerce/models/products.dart';
import '../home/home_screens/filter_sheet.dart';

class UpsellProductScreen extends StatefulWidget {
  UpsellProductScreen({Key? key}) : super(key: key);

  @override
  State<UpsellProductScreen> createState() => _UpsellProductScreenState();
}

class _UpsellProductScreenState extends State<UpsellProductScreen>
    with SingleTickerProviderStateMixin {
  HomeScreenController storageController = Get.find<HomeScreenController>();
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  FilterController controller = Get.put(FilterController());
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  RxList<String> favProductList = <String>[].obs;
  RxInt cartIndex = 0.obs;
  ProductDataController productController = Get.put(ProductDataController());
  late AnimationController animationController;
  int dialogSecond = 300;

  getFavourit() {

    if(homeMainScreenController.checkNullOperator()){
      return;
    }
    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  @override
  void initState() {
    // TODO: implement initState
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = Duration(milliseconds: dialogSecond);
    animationController.reverseDuration = Duration(milliseconds: dialogSecond);
    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });
    getFavourit();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
              child: Container(
            color: bgColor,
            child: Column(
              children: [
                GetBuilder<FilterController>(
                  init: FilterController(),
                  builder: (controller) => Container(
                      height: 73.h,
                      width: double.infinity,
                      color: regularWhite,
                      child: getAppBar(
                          cartControllerNew.upsellProduct.length < 2
                              ? S.of(context).moreProduct
                              : S.of(context).moreProducts,
                          iconpermmition: true,
                          widget: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  transitionAnimationController:
                                      animationController,
                                  backgroundColor: regularWhite,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.h))),
                                  context: context,
                                  builder: (context) {
                                    return FilterBottomsheet(
                                      Get.put(
                                        FilterController(),
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  setState(() {
                                    if (controller.sortItem.value
                                            .toLowerCase() ==
                                        "new added") {
                                      cartControllerNew.upsellProduct
                                          .sort((a, b) {
                                        return a.dateCreated
                                            .compareTo(b.dateCreated);
                                      });
                                    } else if (controller.sortItem.value
                                            .toLowerCase() ==
                                        "highest price") {
                                      cartControllerNew.upsellProduct
                                          .sort((a, b) {
                                        return int.parse(b.price)
                                            .compareTo(int.parse(a.price));
                                      });
                                    } else if (controller.sortItem.value
                                            .toLowerCase() ==
                                        "lowest price") {
                                      cartControllerNew.upsellProduct
                                          .sort((a, b) {
                                        return int.parse(a.price)
                                            .compareTo(int.parse(b.price));
                                      });
                                    }
                                  });
                                });
                              },
                              child: getSvgImage("filterIcon.svg")),
                          function: () {
                        Get.back();
                      }, actionIcon: true)),
                ),
                getVerSpace(8.h),
                Expanded(
                  child: Container(
                    color: regularWhite,
                    child: GetBuilder<HomeScreenController>(
                        init: HomeScreenController(),
                        builder: (controller) => cartControllerNew
                                .upsellProduct.isEmpty
                            ? GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.h, vertical: 20.h),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 280.h,
                                        mainAxisSpacing: 20.h,
                                        crossAxisSpacing: 20.h),
                                itemCount:
                                    cartControllerNew.upsellProduct.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return productDataFormateGridViewShimmer();
                                },
                              )
                            : GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.h, vertical: 20.h),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 280.h,
                                        mainAxisSpacing: 20.h,
                                        crossAxisSpacing: 20.h),
                                itemCount:
                                    cartControllerNew.upsellProduct.length,
                                itemBuilder: (BuildContext context, int index) {
                                  WooProduct product =
                                      cartControllerNew.upsellProduct[index];

                                  return productDataFormateGridView(context,
                                      () {
                                    homeScreenController
                                        .setSelectedWooProduct(product);
                                    storageController.clearProductVariation();

                                    sendToPlanDetail(
                                      id: "${product.id}",
                                        tag:
                                            "main${index}${product.images[0].src}",
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
                                                    favProductList.contains(
                                                            product.id
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
                                      index);
                                },
                              )),
                  ),
                )
              ],
            ),
          )),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        },
      ),
    );
  }

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }
}
