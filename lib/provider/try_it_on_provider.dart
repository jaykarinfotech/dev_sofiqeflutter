// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/model/product_model_best_seller.dart';
import 'package:sofiqe/utils/api/product_details_api.dart';
import 'package:http/http.dart' as http;
import 'package:sofiqe/utils/states/user_account_data.dart';

class TryItOnProvider extends GetxController {
  late RxInt page;
  late RxInt scan;
  late RxBool bottomSheetVisible;


  late RxBool faceSubAreaOptionsVisible;
  late RxBool notFound;
  late RxString selectedFaceArea;
  late RxString selectedFaceSubArea;
  late List<String> capturedFileName = [
    'product_label',
    'product_color',
  ];
  late Rx<ScannedResult> scannedResult;
  late Rx<Product> received; // Sent by the API


  late Product? retrieved; // Requested by the APP for full details
  late RxBool exact = true.obs;
  late AnimationController? faceAreaErrorController;

  TextEditingController brandNameController = TextEditingController();
  TextEditingController productLabelController = TextEditingController();

  var brandName = "".obs;
  var produceLabel = "".obs;
  var dialogShowing = false.obs;
  RxBool directProduct = false.obs;
  /// CONSTRUCTOR

  TryItOnProvider() {
    setDefault();
  }

  /// METHODS

  void setPage(int pageNo) {
    page.value = pageNo;
  }

  void nextScan() {
    if (scan.value == 0) {
      if (selectedFaceSubArea.isEmpty) {
        // Get.showSnackbar(GetBar(
        //   message: 'Select a area where the makeup is applied on before proceeding',
        //   duration: Duration(seconds: 2),
        // ));
        if (faceAreaErrorController != null) {
          faceAreaErrorController!.forward();
        }
        return;
      }
    }
    scan.value += 1;
    // if (scan.value >= capturedFileName.length) {
    //   page.value += 1;
    //   if (page.value == 2) {
    //     this.getScanResults();
    //   }
    // }
  }

  void toggleBottomSheetVisibility() {
    bottomSheetVisible.value = !bottomSheetVisible.value;
  }

  void showFaceSubAreaOptions() {
    selectedFaceSubArea.value = '';
    faceSubAreaOptionsVisible.value = true;
  }

  void hideFaceSubAreaOptions() {
    faceSubAreaOptionsVisible.value = false;
  }


  Future<bool> getScanResults() async {
    try {
      String token = await getUserToken();

      scannedResult.value.label = brandName.value;
      scannedResult.value.ingredients = produceLabel.value;
      //TODO set color
      scannedResult.value.color = "#ffe7d5";

      List responseList = await sfAPIScanProduct(token, scannedResult.value.mapped());
      if (responseList.isEmpty) {
        throw 'No response received from server';
      }
      Map responseMap = responseList[0];

      exact.value = responseMap['exact'];
      Map tempProduct = {};
      if (responseMap['products'].isEmpty) {
        throw 'Product list empty';
      }
      responseMap['products'].forEach((p) {
        tempProduct = p;
      });

      received.value = Product.fromMap(tempProduct['product']);
      return true;
    } catch (err) {
      notFound.value = true;
      print('Error finding scanned product: $err');
      Get.showSnackbar(
        GetBar(
          message: 'Looks like we could not find results for your scan. Please try a new scan.',
          duration: Duration(seconds: 2),
        ),
      );
    }
    return false;
  }

  Future<bool> getFullProductDetails() async {
    try {
      http.Response response = await sfAPIGetProductDetailsFromSKU(sku: received.value.sku!);
      Map responseBody = json.decode(response.body);
      retrieved = Product(
        id: responseBody['id'],
        sku: responseBody['sku'],
        name: responseBody['name'],
        description: '',
        avgRating: responseBody['extension_attributes'] != null && responseBody['extension_attributes']['avgrating'] != null
            ? responseBody['extension_attributes']['avgrating']
            : "0.0",
        price: responseBody['price'],
        faceSubArea: received.value.faceSubArea,
        image: received.value.image,
        options: responseBody['options'],
      );
      return true;
    } catch (err) {
      print('Error fetching full product details: $err');
    }
    return false;
  }

  /// DEFAULTS

  setDefault() {
    page = 0.obs;
    scan = 0.obs;
    bottomSheetVisible = false.obs;
    faceSubAreaOptionsVisible = false.obs;
    notFound = false.obs;
    selectedFaceArea = ''.obs;
    selectedFaceSubArea = ''.obs;
    scannedResult = ScannedResult().obs;
    exact = false.obs;
    received = Product(
      name: '',
      description: '',
      faceSubArea: -1,
      price: 0.0,
      image: '',
      sku: '',
      id: -1,
      avgRating: "0.0",
    ).obs;
    retrieved = null;
  }
}

class ScannedResult {
  late String label;
  late String ingredients;
  late String color;

  ScannedResult({
    this.label = '',
    this.ingredients = '',
    this.color = '',
  });

  bool success() {
    if (this.label.isEmpty || this.ingredients.isEmpty || this.color.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Map<String, String> mapped() {
    return {
      "name_string": "$label",
      "product_label": "$ingredients",
      "detected_color": "$color",
    };
  }

}
