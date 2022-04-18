import 'dart:convert';

import 'package:get/get.dart';
import 'package:sofiqe/model/natural_me_ms4/natural_me_model.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:http/http.dart' as http;

class NaturalMeController extends GetxController {
  var naturalMe = [].obs;
  var isNaturalMeLoading = false.obs;


  Rx<NaturalMeModelNew> naturalMeModelNew = NaturalMeModelNew().obs;
  List<CustomAttribute>? customAttributes1;
  List<String> aller =[];

  getNaturalMe() async {
    isNaturalMeLoading(true);
    ///
    /// await APITokens.customerSavedToken
    ///
    /// Customize the request body
    ///
    try {
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "https://dev.sofiqe.com/index.php/rest/V1/customers/me/",
          // url: "https://dev.sofiqe.com/rest/V1/customer/personalColours",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${(await APITokens.customerSavedToken)}");
      print("after api  ${response!.statusCode}");
      print("after api body  ${response.body}");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        NaturalMeModelNew model = NaturalMeModelNew.fromJson(result);
        naturalMeModelNew.value = model;
        //customAttributes1 = json.decode(naturalMeModelNew.value.customAttributes![1].value.toString());
        var dataSp = naturalMeModelNew.value.customAttributes![1].value!.split(',');
       String mapData = '';
        dataSp.forEach((element) {
          if(element.toString()!='{}'){
            var a=element.split(':').last.toString().replaceAll('[', '').replaceAll(']', '').replaceAll('{', '').replaceAll('}', '').replaceAll(',', '');
          print("AAAAA---->"+a.length.toString());
          if(a.toString()!=" "){
            aller.add(a.replaceAll('\"', ''));
          }

          //  mapData=mapData+ element.split(':')[1];
            // mapData[element.split(':')[0]] = element.split(':')[1];
          }
          print('element---->'+element.toString());

        });
        update();

     //   print('naturalMeModelNew---->'+mapData.toString());

        // for (int i = 0; i < result.length; i++) {
        //   NaturalMeModel model = NaturalMeModel.fromJson(result[i]);
        //   naturalMe.add(model);
        // }
        isNaturalMeLoading(false);
        print("_____________________________________");
        print(result);
        print("_____________________________________");
      } else {
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
        isNaturalMeLoading(false);

      }
      print("Responce of API is--- ${response.body}");
    } catch (e) {
      isNaturalMeLoading(false);

      print("XXXXXXXXXXXXXXXXXXXXXXXXXXX");
      print("Error in get natural me $e");
      print("XXXXXXXXXXXXXXXXXXXXXXXXXXX");
    } finally {
      isNaturalMeLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getNaturalMe();
  }
}
