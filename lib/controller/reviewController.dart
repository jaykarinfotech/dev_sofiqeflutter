import 'dart:convert';
import 'package:get/get.dart';
import 'package:sofiqe/model/reviewModel.dart';
import 'package:sofiqe/model/wishListModel.dart';
import 'package:sofiqe/network_service/network_service.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:sofiqe/utils/constants/api_tokens.dart';

import '../model/my_review_by_sku.dart' as mRBS;

class ReviewController extends GetxController {
  ReviewModel? reviewModel;
  ReviewModel? myReviewModel =ReviewModel();
  mRBS.MyReviewSkuModel? myReviewBySkuModel =mRBS.MyReviewSkuModel();

  RxInt globleReviewCount = 0.obs;
  RxInt myReviewCount = 0.obs;
  RxInt wishList = 0.obs;

  bool isReviewLoading = false;
  bool isReviewBySkuLoading = false;
  bool isGlobaleReviews = false;
  String customerToken = '';
  List<String> reviewName = [];
  List<String> reviewImage = [];
  List<String> reviewGlobaleName = [];
  List<String> reviewGlobaleImage = [];

  ///
  /// Customize the request body
  /// [body] is the request body
  /// [url] is the url of the request
  /// [method] is the method of the request
  /// [token] is the token of the request
  /// [isAuth] is the authentication of the request
  ///
  ///
  getGloableReviews() async {
    var result;
    try {
      isGlobaleReviews = true;
      update();
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "https://dev.sofiqe.com/rest/V1/reviews",
          headers: APIEndPoints.headers(APITokens.bearerToken));
      print("after api  ${response!.statusCode}");
      print("getGloableReviews  ${response.body}");
      if (response.statusCode == 200) {
        reviewModel?.items = [];
        var result = json.decode(response.body);
        reviewModel = ReviewModel.fromJson(result);
        globleReviewCount.value = reviewModel!.items!.length;
        for(int i =0; i <reviewModel!.items!.length; i++){
          getMyRiviewsBySkuData(reviewModel!.items![i].sku.toString()).then((value) {
            if(value != null){
              reviewGlobaleName.add(value.name.toString());
              update();
              if(value.mediaGalleryEntries!.isNotEmpty){
                reviewGlobaleImage.add(value.mediaGalleryEntries![0].file.toString());
              }
              update();
              print('getMyRiviewsBySkuData lllllll ${value.name.toString()}');
            }
          });
        }
        print(globleReviewCount.value);
      } else {
        result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      }
      print("Responce of API is ${response.body}");
      isGlobaleReviews = false;
    } catch (e) {
      Get.snackbar('Error', '${result["message"]}', isDismissible: true);
    } finally {
      isGlobaleReviews = false;
      update();
    }
  }

  productAddtoBag(Result result) async {
    update();
    var body = {
      'color': result.product?.shadeColor,
      'quantity': '1',
      'product_id': result.productId,
      'total_price': result.product?.price
    };
    http.Response? response = await NetworkHandler.postMethodCall(
        body: body,
        url: "https://dev.sofiqe.com/api/index.php/api/user/addToCartProduct",
        headers: APIEndPoints.headers(await APITokens.customerSavedToken));
    print("After api  ${response!.statusCode}");
    if (response.statusCode == 200) {
      Get.snackbar('Successfully', 'product added in to Cart list',
          isDismissible: true);
    } else {
      Get.snackbar('Error', 'Error add to cart', isDismissible: true);
    }
  }

  getMyRiviewsData() async {
    var result;
    try {
      isReviewLoading = true;
      update();
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "http://dev.sofiqe.com/rest/default/V1/customer/reviews/",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      print("getMyRiviewsData  ${response.body}");
      if (response.statusCode == 200) {
        myReviewModel?.items = [];
        result = json.decode(response.body);
        myReviewModel = ReviewModel.fromJson(result);
        print('myReviewModel  ---> ${myReviewModel!.items!.length}');
        myReviewCount.value = myReviewModel!.items!.length;
        for(int i =0; i <myReviewModel!.items!.length; i++){
          getMyRiviewsBySkuData(myReviewModel!.items![i].sku.toString()).then((value) {
            if(value != null){
              reviewName.add(value.name.toString());
              update();
              if(value.mediaGalleryEntries!.isNotEmpty){
                reviewImage.add(value.mediaGalleryEntries![0].file.toString());
              }
              update();
              print('getMyRiviewsBySkuData lllllll ${value.name.toString()}');
            }
          });
        }

      } else {
        result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      }
      print("Responce of API is  ${response.body}");
    } catch (e) {
      Get.snackbar('Error', '${result["message"]}', isDismissible: true);
    } finally {
      isReviewLoading = false;
      update();
    }
  }


  WishlistModel? wishlistModel;
  bool isWishListLoading = false;

  getWishListData() async {
    var result;
    try {
      isWishListLoading = true;
      update();
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "https://dev.sofiqe.com/rest/V1/wishlist/items",
          headers: APIEndPoints.headers(await APITokens.customerSavedToken));
      print("after api  ${response!.statusCode}");
      print("getWishListData  ${response.body}");
      if (response.statusCode == 200) {
        wishlistModel?.result = [];
        result = json.decode(response.body);
        wishlistModel = WishlistModel.fromJson(result);
        wishList.value = wishlistModel!.result!.length;
      } else {
        result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      }
      print("Responce of API is getWishListData ${response.body}");
    } catch (e) {
      Get.snackbar('Error', '${result["message"]}', isDismissible: true);
    } finally {
      isWishListLoading = false;
      update();
    }
  }


  Future <mRBS.MyReviewSkuModel?> getMyRiviewsBySkuData(String sku) async {
    var result;
    try {
      isReviewBySkuLoading = true;
      update();
      http.Response? response = await NetworkHandler.getMethodCall(
          url: "https://dev.sofiqe.com/rest/V1/products/$sku",
          headers: APIEndPoints.headers(await APITokens.adminBearerId));
      print("after api  ${response!.statusCode}");
      print("getMyRiviewsBySkuData  ${response.body}");
      if (response.statusCode == 200) {
        result = json.decode(response.body);
        myReviewBySkuModel = mRBS.MyReviewSkuModel.fromJson(result);
        print('myReviewBySkuModel  ---> ${myReviewBySkuModel!}');
        return myReviewBySkuModel;
      } else {
        result = json.decode(response.body);
        Get.snackbar('Error', '${result["message"]}', isDismissible: true);
        return null;
      }
      print("Responce of API is  ${response.body}");
    } catch (e) {
      Get.snackbar('Error', '${result["message"]}', isDismissible: true);
      return null;
    } finally {
      isReviewBySkuLoading = false;
      update();
    }
  }
}
