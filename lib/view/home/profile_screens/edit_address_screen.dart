// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tuple/tuple.dart';

import '../../../controller/controller.dart';
import '../../../csc_picker/csc_picker.dart';
import '../../../generated/l10n.dart';
import '../../../utils/category_cache.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/customer.dart';

// ignore: must_be_immutable
class EditAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditAddressScreen();
  }
}

class _EditAddressScreen extends State<EditAddressScreen> {
  backClick(BuildContext context) {
    backToPrev(context);
  }

  StorageController storageController = Get.find<StorageController>();
  HomeMainScreenController homeController =
  Get.find<HomeMainScreenController>();
  HomeScreenController findhomeScreenController =
  Get.find<HomeScreenController>();
  HomeScreenController putstorageController = Get.put(HomeScreenController());

  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController add1Controller = TextEditingController();
  TextEditingController add2Controller = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String countryValue = "";
  String stateValue = "";

  // String cityValue = "";
  ShippingAddressController shippingCont = Get.put(ShippingAddressController());
  String phoneCode = "";
  String phone = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Tuple4<bool, Shipping?, Billing?, bool?> tuple4 = ModalRoute.of(context)!
          .settings
          .arguments as Tuple4<bool, Shipping?, Billing?, bool?>;

      if (ModalRoute.of(context)!.settings.arguments == null) {
        return;
      }

      bool isBilling = tuple4.item1;
      Shipping? wooCustomer = tuple4.item2;
      Billing? shippingAddress = tuple4.item3;

      if (isBilling == true && wooCustomer != null) {
        fullNameController.text = wooCustomer.firstName!;
        lastNameController.text = wooCustomer.lastName!;
        emailController.text = "";
        phoneController.text = wooCustomer.phone!;
        add1Controller.text = wooCustomer.address1!;
        add2Controller.text = wooCustomer.address2!;
        countryValue = wooCustomer.country!;
        stateValue = wooCustomer.state!;
        // cityValue = wooCustomer.city!;
        cityController.text = wooCustomer.city!;
        pincodeController.text = wooCustomer.postcode!;
        phone = wooCustomer.phone!;

        if (wooCustomer.country!.isNotEmpty) {
          shippingCont.changeCountry(wooCustomer.country ?? "");
        }
        if (wooCustomer.state!.isNotEmpty) {
          shippingCont.changeState(wooCustomer.state ?? "");
        }
        // if (wooCustomer.city!.isNotEmpty) {
        //   shippingCont.changeCity(wooCustomer.city ?? "");
        // }
      } else if (shippingAddress != null) {
        fullNameController.text = shippingAddress.firstName!;
        lastNameController.text = "";
        emailController.text = shippingAddress.email!;
        phoneController.text = shippingAddress.phone!;
        add1Controller.text = shippingAddress.address1!;
        add2Controller.text = "";
        countryValue = shippingAddress.country!;
        stateValue = shippingAddress.state!;
        // cityValue = shippingAddress.city!;
        cityController.text = shippingAddress.city!;
        pincodeController.text = shippingAddress.postcode!;
        phone = shippingAddress.phone!;

        if (shippingAddress.country!.isNotEmpty) {
          shippingCont.changeCountry(shippingAddress.country ?? "");
        }
        if (shippingAddress.state!.isNotEmpty) {
          shippingCont.changeState(shippingAddress.state ?? "");
        }
        // if (shippingAddress.city!.isNotEmpty) {
        //   shippingCont.changeCity(shippingAddress.city ?? "");
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Tuple4<bool, Shipping?, Billing?, bool?> tuple4 = ModalRoute.of(context)!
        .settings
        .arguments as Tuple4<bool, Shipping?, Billing?, bool?>;

    bool isBilling = tuple4.item1;

    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          backClick(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
            child: Container(
              color: bgColor,
              child: Column(
                children: [
                  Container(
                    color: regularWhite,
                    child: getAppBar(S.of(context).editAddress, function: () {
                      Get.back();
                    }),
                  ),
                  getVerSpace(12.h),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: regularWhite,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        shrinkWrap: true,
                        children: [
                          getVerSpace(24.h),
                          getTextField(
                            S.of(context).name,
                            controller: fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseEnterValidName;
                              }
                              return null;
                            },
                          ),
                          getVerSpace(22.h),
                          getTextField(
                            S.of(context).address,
                            controller: add1Controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S
                                    .of(context)
                                    .pleaseEnterValidAddressLine1;
                              }
                              return null;
                            },
                            maxline: 5,
                          ),
                          getVerSpace(22.h),
                          getTextField(
                            S.of(context).pinCode,
                            controller: pincodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseEnterValidPincode;
                              }
                              return null;
                            },
                          ),
                          getVerSpace(22.h),
                          GetBuilder<ShippingAddressController>(
                            init: ShippingAddressController(),
                            builder: (controller) {
                              return CSCPicker(
                                countryDropdownLabel: countryValue,
                                stateDropdownLabel: stateValue,
                                showStates: true,
                                disabledDropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    12.h,
                                  ),
                                  color: gray,
                                ),
                                showCities: true,
                                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                                selectedItemStyle: TextStyle(
                                  color: regularBlack,
                                  fontSize: 16.sp,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.24.h,
                                ),
                                onCountryChanged: (value) async {
                                  shippingCont.changeCountry(value!);
                                },
                                onStateChanged: (value) {
                                  if (value != null) {
                                    shippingCont.changeState(value);
                                  }
                                },
                                // onCityChanged: (value) {
                                //   if (value != null) {
                                //     shippingCont.changeCity(value);
                                //   }
                                // },
                              ).marginSymmetric(horizontal: 0.h);
                            },
                          ),
                          getVerSpace(16.h),
                          getTextField(
                            "City",
                            controller: cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter city";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          getVerSpace(16.h),
                          getTextField(S.of(context).phoneNumber,
                              controller: phoneController, validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterValidPhoneNumber;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.done,
                              length: 10),
                          getVerSpace(15.h),
                        ],
                      ),
                    ),
                  ),
                  GetBuilder<ShippingAddressController>(
                    init: ShippingAddressController(),
                    builder: (controller) =>
                        getCustomButton(S.of(context).save, () async {
                          if (fullNameController.text.isEmpty) {
                            showCustomToast(S.of(context).addFullName);
                          } else if (controller.countryValue.isEmpty) {
                            showCustomToast(S.of(context).addCountryName);
                          }
                          else if (cityController.text.isEmpty) {
                            showCustomToast(S.of(context).addCity);
                          } else if (pincodeController.text.isEmpty) {
                            showCustomToast(S.of(context).addValidPinCode);
                          } else if (add1Controller.text.isEmpty) {
                            showCustomToast(S.of(context).addValidAddress);
                          } else if (phoneController.text.isEmpty ||
                              phoneController.text.length < 10) {
                            showCustomToast(S.of(context).addValidPhoneNumber);
                          } else if (controller.countryValue.isNotEmpty) {
                            if (isBilling == true) {
                              Shipping billing = Shipping(
                                  firstName: fullNameController.text.toString(),
                                  lastName: "",
                                  phone: phoneController.text.toString(),
                                  country: controller.countryValue,
                                  city: cityController.text,
                                  state: controller.stateValue,
                                  address1: add1Controller.text,
                                  address2: "",
                                  postcode: pincodeController.text);
                              context.loaderOverlay.show();

                              if (homeController.checkNullOperator()) {
                                return;
                              }

                              await homeController.wooCommerce1!
                                  .updateCustomerShipping(
                                  id: homeController.currentCustomer!.id!,
                                  data: billing);
                              homeController.updateCurrentCustomer();
                              context.loaderOverlay.hide();
                              findhomeScreenController.cleareShipping();
                              findhomeScreenController.clearShippingMethod();
                              putstorageController.changeShippingIndex(-1);
                              putstorageController.changeShippingTax(0.0);
                              Future.delayed(
                                Duration.zero,
                                    () {
                                  backClick(context);
                                },
                              );
                            } else {
                              Billing billing = Billing(
                                  phone: phoneController.text.toString(),
                                  email: emailController.text.toString(),
                                  firstName: fullNameController.text.toString(),
                                  lastName: lastNameController.text.toString(),
                                  country: controller.countryValue,
                                  city: cityController.text,
                                  state: controller.stateValue,
                                  address1: add1Controller.text,
                                  address2: add2Controller.text,
                                  postcode: pincodeController.text);
                              context.loaderOverlay.show();

                              if (homeController.checkNullOperator()) {
                                return;
                              }
                              await homeController.wooCommerce1!
                                  .updateCustomerBilling(
                                  id: homeController.currentCustomer!.id!,
                                  data: billing);
                              homeController.updateCurrentCustomer();
                              context.loaderOverlay.hide();
                              findhomeScreenController.cleareShipping();
                              findhomeScreenController.clearShippingMethod();
                              putstorageController.changeShippingIndex(-1);
                              putstorageController.changeShippingTax(0.0);
                              Future.delayed(
                                Duration.zero,
                                    () {
                                  backClick(context);
                                },
                              );
                            }
                          }
                        }).paddingOnly(bottom: 30.h, left: 20.h, right: 20.h),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
