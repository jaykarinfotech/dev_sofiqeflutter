import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sofiqe/model/lookms3model.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

class LooksController extends GetxController {
  LooksMs3Model? lookModel;
  bool isLookLoading = false;

  ///
/////  Get Collection api
  ///  @param [String] collectionId
  ///
  ///
  getLookList() async {
    isLookLoading = true;
    update();
    try {
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "http://dev.sofiqe.com/rest/default/V1/look/getCollection",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("Looks Api Status Code :  ${response!.statusCode}");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        lookModel = LooksMs3Model.fromJson(result[0]);
      } else {
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
      }
      print("Responce of API is ${response.body}");
    } catch (e) {
      lookModel = null;
    } finally {
      isLookLoading = false;
      update();
    }
  }
}
