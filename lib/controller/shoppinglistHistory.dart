import 'dart:convert';

import 'package:get/get.dart';
import 'package:sofiqe/model/shoppingHistoryModel.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:http/http.dart' as http;

import '../utils/states/local_storage.dart';

class ShoppingHistory extends GetxController {
  bool isShoppingListLoading = false;
  String isShoppingListError = "Forbidden";
  ShoppingHistoryModel? historyList;
  getShoppingHistory() async {
    isShoppingListLoading = true;
    update();
    var result;
    try {
      Map uidMap = await sfQueryForSharedPrefData(
          fieldName: 'uid', type: PreferencesDataType.INT);
      int uid = uidMap['uid'];
      print('uuuuuu id  ${uid}');
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "https://dev.sofiqe.com/rest/V1/ms2/orders/customer/$uid",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      print("after api  https://dev.sofiqe.com/rest/V1/ms2/orders/customer/$uid");
      if (response.statusCode == 200) {
        print("1111111111");
        result = json.decode(response.body);
        print("2222222222"+response.body.toString());
        // isShoppingListError = result[0]["message"];
        print("333333333333");
        try {
          print("historyList");
          (result[0]["result"] == "error")
              ? historyList = null
              : historyList = ShoppingHistoryModel.fromJson(result[0]);
        } catch (e) {
          historyList = null;
          Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'User Session Token Expire', isDismissible: true);
      } else {
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
      }
      print("Responce of API is ${response.body}");
    } catch (e) {
    } finally {
      isShoppingListLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getShoppingHistory();
  }

}
