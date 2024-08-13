import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

// import 'package:event_app/base/pref_data.dart';
// import 'package:event_app/plugins_utils/api_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// import '../app/view/profile/model/model_image.dart';
// import '../base/constant.dart';

int statusCodeCreated = 201;
int statusDone = 200;
int statusInternalServerError = 500;
int statusAuthorError = 403;
int statusBadRequest = 400;
int statusNotContent = 204;

class HttpService {
  final String postsURL = "REPLACE_POST_URL";
  final String getURL = "REPLACE_GET_URL";

  static checkNetwork() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  static Future<Map<String, dynamic>> postResponse(
      BuildContext context, var data, Uri url, int statusCode,
      {bool isCheckNetwork = false}) async {
    if (isCheckNetwork) {
      if (!await checkNetwork()) {
        // Constant.showNetworkSnackBar(context);

        return {};
      }
    }
    try {
      var res = await http.post(url, body: data);
      print("res===${res.statusCode}====${res.body}==");

      if (res.statusCode == statusCode) {
        return jsonDecode(res.body);
      } else {
        return {};
      }
    } on SocketException {
      // showHostError();
      print('No Internet connection 😑');
    } on HttpException {
      // print("Couldn't find the post 😱");
    } on FormatException {
      // print("Bad response format 👎");
    }
    return {};
  }

  static Future<Map<String, dynamic>> postResponseWithRaw(
      BuildContext context, var data, Uri url, int statusCode,
      {bool isCheckNetwork = false}) async {
    if (isCheckNetwork) {
      if (!await checkNetwork()) {
        // Constant.showNetworkSnackBar(context);
        return {};
      }
    }
    try {
      var res = await http.post(url, body: json.encode(data), headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      print("res1===${res.statusCode}====${res.body}==");
      if (res.statusCode == statusCode) {
        return jsonDecode(res.body);
      } else {
        return {};
      }
    } on SocketException {
      // showHostError();
      print('No Internet connection 😑');
    } on HttpException {
      // print("Couldn't find the post 😱");
    } on FormatException {
      // print("Bad response format 👎");
    }
    return {};
  }

// static Future<Map<String, dynamic>> postResponseWithToken(
//     Map<String, dynamic> data, Uri url, int statusCode, BuildContext context,
//     {bool isCheckNetwork = false}) async {
//   if (isCheckNetwork) {
//     if (!await checkNetwork()) {
//       // Constant.showNetworkSnackBar(context);
//       return {};
//     }
//   }
//   try {
//     String token = await PrefUtils.getAuthToken();
//     var res;
//     if (data.isEmpty) {
//       res = await http.post(url, headers: {
//         HttpHeaders.contentTypeHeader: 'application/json',
//         HttpHeaders.authorizationHeader: "Bearer $token",
//       });
//     } else {
//       res = await http.post(url, body: jsonEncode(data), headers: {
//         HttpHeaders.contentTypeHeader: 'application/json',
//         HttpHeaders.authorizationHeader: "Bearer $token",
//       });
//     }
//     print("res===${res.statusCode}==gfjfgjjgj==${res.body}==");
//     if (res.statusCode == statusCode) {
//       return jsonDecode(res.body);
//     } else {
//       return {};
//     }
//   } on SocketException {
//     // showHostError();
//     // Constant.showNetworkSnackBar(context);
//     // print('No Internet connection 😑');
//   } on HttpException {
//     // print("Couldn't find the post 😱");
//   } on FormatException {
//     // print("Bad response format 👎");
//   }
//   return {};
// }

  // static Future<Map<String, dynamic>> uploadImageWithToken(
  //     String data, BuildContext context, Function(String) function,
  //     {bool isCheckNetwork = false}) async {
  //   if (isCheckNetwork) {
  //     if (!await checkNetwork()) {
  //       // Constant.showNetworkSnackBar(context);
  //       return {};
  //     }
  //   }
  //   try {
  //     String token = await PrefUtils.getAuthToken();
  //     var request = http.MultipartRequest("POST", ApiEndPoints.uploadImage);
  //     var pic = await http.MultipartFile.fromPath("avatar", data);
  //     request.headers.addAll({
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: "Bearer $token",
  //     });
  //     request.files.add(pic);
  //     var res = await request.send();
  //     res.stream.transform(utf8.decoder).listen((value) {
  //       print("image==ok=========$value======");
  //
  //       UploadImageModel modelImage = UploadImageModel.fromJson(jsonDecode(value));
  //
  //       if (modelImage.code == 1 && modelImage.image != null) {
  //         function(modelImage.image!.avatar!);
  //         print("image===${modelImage.image!.avatar}======-=-=-=-=-=-=======");
  //       }
  //     });
  //     print("image===${res.reasonPhrase}======");
  //     // if (res.statusCode == statusCode) {
  //     //   return jsonDecode(res.body);
  //     // } else {
  //     return {};
  //     // }
  //   } on SocketException {
  //     // showHostError();
  //     // Constant.showNetworkSnackBar(context);
  //     // print('No Internet connection 😑');
  //   } on HttpException {
  //     // print("Couldn't find the post 😱");
  //   } on FormatException {
  //     print("Bad response format 👎");
  //   }
  //   return {};
  // }
}

// static Future<Map<String, dynamic>> postResponseWithRaw(
//   var data,
//   Uri url,
//   int statusCode,
// ) async {
//   try {
//     var res = await http.post(url, body: jsonEncode(data));
//     print("res===${res.statusCode}====${res.body}==");
//     if (res.statusCode == statusCode) {
//       return jsonDecode(res.body);
//     } else {
//       return {};
//     }
//   } on SocketException {
//     // showHostError();
//     print('No Internet connection 😑');
//   } on HttpException {
//     //   print("Couldn't find the post 😱");
//   } on FormatException {
//     //   print("Bad response format 👎");
//   }
//   return {};
// }

