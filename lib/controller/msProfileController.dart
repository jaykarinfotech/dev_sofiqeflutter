// ignore_for_file: unused_catch_clause

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/model/profile.dart';
import 'package:sofiqe/model/recentItemModel.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/api/user_account_api.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:http/http.dart' as http;

import 'controllers.dart';

class MsProfileController extends GetxController {
  static MsProfileController instance = Get.find();
  RecentItemModel? recentItem;
  Profile? profileModle;
  var atmCards = <AtmCard>[];
  late var screen = 0.obs;
  bool isRecentLoading = false;
  bool isLoading = false;
  String selectedGender = "";

  ///
  /// TextFormFiels controllers that's will use to update profiles
  ///
  ///

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
   TextEditingController phoneNumberCodeController =
  TextEditingController(text: "+41");
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController monthCardController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController postCodeController =
      TextEditingController(text: "1242");
  TextEditingController cityController = TextEditingController(text: "test");
  TextEditingController cardNameController = TextEditingController();

  String? phoneNo;

  RxBool isShiping = RxBool(false);
  RxBool isBilling = RxBool(false);
  Future<bool> updateUserProfile() async {
    isRecentLoading = true;
    var result;
    update();

    ///
    /// Customize the request body
    ///

    ///
    ///TODO there is static region code
    /// needs to update api as well as code
    ///
    var body = {
      "customer": {
        "email": emailController.text,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "gender": getGenderCount(),
        "website_id": profileModle?.websiteId,
        "addresses": [
          {
            "region": {"region_code": "TX", "region": "Texas", "region_id": 57},
            "postcode": postCodeController.text,
            "city": cityController.text,
            "country_id": countryController.text.toUpperCase(),
            "firstname": firstNameController.text,
            "lastname": lastNameController.text,
            "street": ['${streetController.text}'],
            "telephone": '${phoneNumberCodeController.text} ${phoneController.text}',
            "default_shipping": isShiping.value,
            "default_billing": isBilling.value,
          }
        ]
      }
    };
    print(body.toString());
    try {
      http.Response? response = await NetworkHandler.patchMethodWithBodyCall(
          body: jsonEncode(body),
          url: "https://dev.sofiqe.com/rest/default/V1/customers/me",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("Responce of API is ${response?.body}");

      if (response?.statusCode == 200) {
        Get.snackbar('Succesfully', 'User profile updated Succesfully',
            isDismissible: true);
        //  Get.snackbar('Error', 'Card Api is in under Development');
        //  updateCardDetailes();
        return true;
      } else {
        result = json.decode(response!.body);
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      update();
      return false;
    }
  }

  getUserProfile() async {
    isRecentLoading = true;
    update();
    try {
      var result =
          await sfAPIGetUserDetails(await APITokens.customerSavedToken);

      if (result != null) {
        profileModle = Profile.fromJson(result);

        if (profileModle?.gender == 0) {
          selectedGender = "FEMALE";
        } else if (profileModle?.gender == 1) {
          selectedGender = "MALE";
        } else if (profileModle?.gender == 2) {
          selectedGender = "GENDERLESS";
        } else if (profileModle?.gender == 3) {
          selectedGender = "LBGT";
        }
        firstNameController.text = profileModle?.firstname ?? "";
        lastNameController.text = profileModle?.lastname ?? "";
        emailController.text = profileModle?.email ?? "";
        if (profileModle?.addresses != null &&
            profileModle?.addresses?.length != 0) {
          phoneController.text = profileModle?.addresses?[0].telephone!.split(' ').last ?? "";
          phoneNumberCodeController.text = profileModle?.addresses?[0].telephone!.split(' ').first ?? "";
          countryController.text = profileModle?.addresses?[0].countryId ?? "";

          isBilling.value = profileModle?.addresses?[0].defaultBilling ?? false;
          cityController.text = profileModle?.addresses?[0].city ?? "";
          postCodeController.text = profileModle?.addresses?[0].postcode ?? "";
          print('isShiping  ${profileModle?.addresses?[0].defaultShipping }');

          isShiping.value = profileModle?.addresses?[0].defaultShipping ?? true;
          streetController.text = profileModle?.addresses?[0].street?[0] ?? "";
        }
      } else {
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
      }
      isRecentLoading = false;
      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isRecentLoading = false;
      update();
    }
  }

  getUserQuestionsInformations() async {
    isRecentLoading = true;
    update();

    try {
      var result =
          await sfAPIGetUserDetails(await APITokens.customerSavedToken);

      if (result != null) {
        profileModle = Profile.fromJson(result);

        try {
          if (profileModle?.customAttributes!.length != 0) {
            makeOverProvider.tryitOn.value =
                profileModle?.customAttributes?[1].value != null ? true : false;
          }
        } on Exception catch (e) {
          makeOverProvider.tryitOn.value = false;
        }
      } else {
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
      }
      isRecentLoading = false;
      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isRecentLoading = false;
      update();
    }
  }

  getGenderCount() {
    if (selectedGender == "FEMALE") {
      return 0;
    } else if (selectedGender == "MALE") {
      return 1;
    } else if (selectedGender == "GENDERLESS") {
      return 2;
    } else if (selectedGender == "LBGT") {
      return 3;
    }
  }

  getUserCardDetailes() async {
    try {
      http.Response? response = await NetworkHandler.getMethodCall(
          url:
              "https://dev.sofiqe.com/rest/V1/getcardinformation?number=1&name=1&expiry_date=1&type=1",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      if (response.statusCode == 200) {
        Iterable types = json.decode(response.body);
        atmCards = types.map((e) => AtmCard.fromJson(e)).toList();
        print(atmCards.length);
        if (atmCards.length > 0) {
          cardNumberController.text = atmCards[0].number.toString();
          monthCardController.text = atmCards[0].expiryDate.toString();
          cvcController.text = atmCards[0].cvc.toString();
          cardNameController.text = atmCards[0].name.toString();
        } else {
          // Get.snackbar('Error', 'No Card Found');
        }
      } else {
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
      }
      print("Responce of API is ${response.body}");
    } catch (e) {
    } finally {
      isRecentLoading = false;
      update();
    }
  }

  Future<bool> updateCardDetailes() async {
    var body = {
      "card": {
        "number": cardNumberController.text,
        "expiry_date": monthCardController.text,
        "cvc": cvcController.text,
        "name": cardNameController.text,
      }
    };
    print(body.toString());
    try {
      http.Response? response = await NetworkHandler.postMethodCall(
          body: body,
          url: "https://dev.sofiqe.com/rest/V1/getcardinformation",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));

      if (response?.statusCode == 200) {
        Get.snackbar('Succesfully', 'User profile updated Succesfully',
            isDismissible: true);
        return true;
      } else {
        var result = json.decode(response!.body);
        Get.snackbar('Error', '${result[0]["message"]}', isDismissible: true);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Card api not working \n ${e.toString()}',
          isDismissible: true);
      isRecentLoading = false;
      update();
      return false;
    }
  }

  getRecenItems() async {
    isRecentLoading = true;
    update();
    print("_____________________________________");
    print("\t\tBeareer Token ${APITokens.bearerToken}\t\t");
    print("_____________________________________");

    try {
      http.Response? response = await NetworkHandler.getMethodCall(
          url:
              "https://dev.sofiqe.com/rest/default/V1/customer/getscannedproduct/",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        recentItem = RecentItemModel.fromJson(result[0]);
      } else {
        var result = json.decode(response.body);
        Get.snackbar('Error', '${result[0]["message"]}');
      }
      print("Responce of API is ${response.body}");
    } catch (e) {
    } finally {
      isRecentLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    //  getUserCardDetailes();
  }
}
