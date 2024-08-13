// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/category_cache.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controller/controller.dart';
import '../../generated/l10n.dart';
import '../../model/my_cart_data.dart';
import '../../utils/color_category.dart';
import '../../utils/constantWidget.dart';
import '../../utils/pref_data.dart';
import '../../woocommerce/models/products.dart';

class AllRelatedProductScreen extends StatefulWidget {
  const AllRelatedProductScreen({Key? key}) : super(key: key);

  @override
  State<AllRelatedProductScreen> createState() =>
      _AllRelatedProductScreenState();
}

class _AllRelatedProductScreenState extends State<AllRelatedProductScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  HomeScreenController storageController = Get.find<HomeScreenController>();
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  FilterController controller = Get.put(FilterController());
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  RxList<String> favProductList = <String>[].obs;
  RxInt cartIndex = 0.obs;
  List<WooProduct> flashSaleList = [];
  int page = 1;
  bool productLastPage = false;
  ProductDataController productController = Get.put(ProductDataController());

  getBestSellingList() async {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }

    final result = await homeMainScreenController.wooCommerce1!
        .getProducts(featured: true, pageKey: page);
    setState(() {
      page = page + 1;
      flashSaleList.addAll(result);
    });
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      getFavDataList();
    });
    getFavourit();
    super.initState();
  }

  getFavourit() {
    if (homeMainScreenController.checkNullOperator()) {
      return;
    }
    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: bgColor,
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: () =>
                  Future.sync(
                        () {
                      // pagingController.refresh();
                          print("====================refresh");
                          Future.delayed(Duration.zero, () async {
                            getFavDataList();
                          });
                          getFavourit();
                          for(int i=0;i<storageController.selectedProduct!.relatedIds.length;i++){
                            relatedProductCache(
                                uniqueQueryKey: valueOrDefault(
                                    storageController
                                        .selectedProduct!.relatedIds[i]
                                        .toString(),
                                    "Related Product"),
                                requestFn: () => homeMainScreenController
                                    .wooCommerce1!
                                    .getYouProduct(
                                    wooCommerceAPI:
                                    homeMainScreenController.api1!,
                                    id: storageController
                                        .selectedProduct!.relatedIds[i]));
                          }
                      _refreshController.refreshCompleted();
                    },
                  ),
              child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<FilterController>(
                  init: FilterController(),
                  builder: (controller) => Container(
                    color: regularWhite,
                    child: getAppBar(
                      S.of(context).relatedProducts,
                      function: () {
                        Get.back();
                      },
                      actionIcon: false,
                    ),
                  ),
                ),
                getVerSpace(8.h),
                Expanded(
                  child: Container(
                    color: regularWhite,
                    child: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.h, vertical: 20.h),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          storageController.selectedProduct!.relatedIds.length,
                      itemBuilder: (context, index) {
                        if (homeMainScreenController.checkNullOperator()) {
                          return Container();
                        }
                        return FutureBuilder(
                          future: relatedProductCache(
                            uniqueQueryKey: valueOrDefault(
                                storageController
                                    .selectedProduct!.relatedIds[index]
                                    .toString(),
                                "Related Product"),
                            requestFn: () => homeMainScreenController
                                .wooCommerce1!
                                .getYouProduct(
                                    wooCommerceAPI:
                                        homeMainScreenController.api1!,
                                    id: storageController
                                        .selectedProduct!.relatedIds[index]),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            if (snapshot.hasData) {
                              WooProduct product = snapshot.data as WooProduct;
                              return GetBuilder<HomeScreenController>(
                                  init: HomeScreenController(),
                                  builder: (homeScreenController) =>
                                      productDataFormateGridView(context, () {
                                        homeScreenController
                                            .setSelectedWooProduct(product);
                                        Get.back();
                                        Get.back();
                                        storageController
                                            .clearProductVariation();

                                        sendToPlanDetail(
                                          id: "${product.id}",
                                            tag:
                                                "main${index}${product.images[0].src}",
                                            titleTag:
                                                "main${index}${product.name}",
                                            priceTag: "main${index}price",
                                            ratingTag: "main${index}rating");

                                        // Get.to(PlantDetail(tag: 'main${index}${product.images[0].src}'));
                                      },
                                          product,
                                          GestureDetector(
                                            onTap: () {
                                              checkInFavouriteList(product);
                                              List<String> strList =
                                                  favProductList
                                                      .map((i) => i.toString())
                                                      .toList();
                                              PrefData()
                                                  .setFavouriteList(strList);
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
                                          index));
                            } else {
                              return productDataFormateGridViewShimmer();
                            }
                          },
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 280.h,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 20.h),
                    ),
                  ),
                ),
              ],
            ),),
          ),
        ),
        onWillPop: () async {
          return true;
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

  checkAlreadyInCart() {
    if (cartControllerNew.cartOtherInfoList.isNotEmpty) {
      var selectedId = storageController.selectedProduct!.id;

      for (int i = 0; i < cartControllerNew.cartOtherInfoList.length; i++) {
        CartOtherInfo element = cartControllerNew.cartOtherInfoList[i];
        if (element.productId == selectedId) {
          cartIndex.value = i;
          storageController.setCurrentQuantity((element.quantity ?? 1));

          setState(() {
            storageController.setPurchaseValue(true);
          });
          return;
        }
      }
    }
  }
}
