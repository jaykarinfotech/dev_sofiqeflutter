import 'dart:convert';

import 'package:get/get.dart';
import 'package:sofiqe/model/selectedProductModel.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:sofiqe/utils/constants/api_tokens.dart';

class SelectedProductController extends GetxController {
  SelectedProduct? selectedProduct;
  bool isSelectedProductLoading = false;

  ///
  /// Customize the request body
  /// [body] is the request body
  /// [url] is the url of the request
  /// [method] is the method of the request
  /// [token] is the token of the request
  /// [isAuth] is the authentication of the request

  getSelectedProduct() async {
    try {
      //TODO Change token

      isSelectedProductLoading = true;
      update();
      http.Response? response = await NetworkHandler.getMethodCall(
          url:
              "https://dev.sofiqe.com/api/index.php/api/user/allProductslist", // "http://dev.sofiqe.com/rest/V1/customer/getselectedproducts",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['error'] == true) {
          selectedProduct = null;
        } else {
          try {
            selectedProduct = SelectedProduct.fromJson(result);
          } catch (e) {
            selectedProduct = null;
          }
        }
      } else {
        selectedProduct = null;
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      }
      print("Responce of API is ${response.body}");
    } catch (e) {
      Get.snackbar('Error', "message", isDismissible: true);
    } finally {
      isSelectedProductLoading = false;
      update();
    }
  }
}
