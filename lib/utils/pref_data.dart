import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_cart_data.dart';

class PrefData {
  static String prefName = "com.ravasiya.collection";

  static String isIntro = "${prefName}isIntro";
  static String signIn = "${prefName}signIn";
  static String homeScreen = "${prefName}homeScreen";
  static String cartStoreList = "${prefName}cartStoreList";
  static String firstLoad = "${prefName}firstLoad";
  static String favouriteList = "${prefName}productFav";
  static String appLanguage =  "${prefName}appLanguage";
  static String lang = "${prefName}languageSe";
  static String couponCode = "${prefName}couponCode";

  static Future<List<CartOtherInfo>> getCartList() async {

    
    String? rawJson = _sharedPreferences!.getString(cartStoreList);

    List<CartOtherInfo> cartList;
    if (rawJson != null) {
      cartList = cartOtherInfoFromJson(rawJson);
    } else {
      cartList = [];
    }
    return cartList;
  }

  static Future<List<int>> getCartIdList() async {
    List<CartOtherInfo> list = await getCartList();

    List<int> i = [];

    list.forEach((filename) async {
      i.add(filename.productId!);


    });

    return i;
  }
  static SharedPreferences? _sharedPreferences;


  PrefData() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get getPref async {
    return _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }



  static setAppLanguage(String sizes)  {
    _sharedPreferences!.setString(appLanguage, sizes);
  }

  getAppLanguage()  {
    String intValue = _sharedPreferences!.getString(appLanguage) ?? "en";
    return intValue;
  }

  static setLanguageSelection(bool s)  {
    _sharedPreferences!.setBool(lang, s);
  }


  static  String getCouponCode()  {
    String intValue = _sharedPreferences!.getString(couponCode) ?? "";
    return intValue;
  }

  static setCouponCode(String s)  {
    _sharedPreferences!.setString(couponCode, s);
  }

  static getLanguageSelection()  {
    return _sharedPreferences!.getBool(lang) ?? true;
  }


  static Future<List<int>> getVariationIdList() async {
    List<CartOtherInfo> list = await getCartList();

    List<int> i = [];

    list.forEach((filename) async {
      i.add(filename.variationId!);
    });

    return i;
  }

  static setCartList(List<CartOtherInfo> cartOtherInfo)  {


    if(cartOtherInfo.isEmpty){
      PrefData.setCouponCode('');
    }
    String rawJson = cartOtherInfoToJson(cartOtherInfo);
    _sharedPreferences!.setString(cartStoreList, rawJson);
  }

  static setIsIntro(bool sizes)  {
    
     _sharedPreferences!.setBool(isIntro, sizes);
  }

  static getIsIntro()  {
    
    bool intValue = _sharedPreferences!.getBool(isIntro) ?? true;
    return intValue;
  }

  static setIsSignIn(bool isFav)  {

    _sharedPreferences!.setBool(signIn, isFav);
  }

  static getIsSignIn()  {
    
    return _sharedPreferences!.getBool(signIn) ?? true;
  }



  static setFirstLoad(bool value)  {

    _sharedPreferences!.setBool(firstLoad, value);
  }

  static  getFirstLoad()  {
    
    bool? value = _sharedPreferences!.getBool(firstLoad);
    return value ?? false;
  }


  List<String> getFavouriteList()  {
    List<String>? value = _sharedPreferences!.getStringList(favouriteList);
    return value ?? [];
  }

  setFavouriteList(List<String> sizes)  {

    _sharedPreferences!.setStringList(favouriteList, sizes);
  }
}
