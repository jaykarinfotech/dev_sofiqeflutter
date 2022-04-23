// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofiqe/model/data_ready_status_enum.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/model/product_model_best_seller.dart';
import 'package:sofiqe/utils/api/product_list_api.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'package:sofiqe/utils/states/location_status.dart';


/// Shared Preferences field names
String dealOfTheDayListField = 'deal-of-the-day-products';
String dealOfTheDayHourField = 'deal-of-the-day-hour';
String dealOfTheDayLatitudeField = 'deal-of-the-day-latitude';
String dealOfTheDayLongitudeField = 'deal-of-the-day-longitude';

class HomeProvider extends GetxController {
  RxList<Product> bestSellerList = <Product>[].obs;
  RxList<Product1> bestSellerListt = <Product1>[].obs;

  RxList<Product> dealOfTheDayList = <Product>[].obs;

  Rx<DataReadyStatus> bestSellerListStatus = DataReadyStatus.INACTIVE.obs;
  Rx<DataReadyStatus> dealOfTheDayStatus = DataReadyStatus.INACTIVE.obs;

  HomeProvider() {
    // this.fetchBestSellersList();
    // this.fetchDealOfTheDayList();
    callAPis();
  }

  callAPis() async{
    Location location = new Location();
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        await fetchDealOfTheDayList();
      }
    }
    await fetchBestSellersList();
  }

  Future<bool> fetchBestSellersList() async {


    bestSellerListStatus.value = DataReadyStatus.FETCHING;
    try {
      Map<String, dynamic> bestSellerResponse = await sfAPIGetBestSellers();


      List<dynamic> data = bestSellerResponse["bestseller_product"];

        List<Product> list = [];


        data.forEach((p) {

          if(p['product_id'] != "5869") {
            if(p['price'].runtimeType == Null) p['price'] = 0;

            list.add(Product(
                id: int.parse(p['product_id']),
                name: p['name'] != null ? p['name'] : '',
                sku: p['sku'] != null ? p['sku'] : '',
                price:  p['price'] != null && p['price'] != "0" ? p['price'].toDouble() : 0.0,
                image: p['image'] != null ? p['image'] : '',
                description: "",
                faceSubArea: p['face_sub_area'] != null && p['face_sub_area'] != "" ? int.parse(p['face_sub_area']) : -1,
                hasOption: true,
                avgRating: p['avgrating'] != null ? p['avgrating'] : '0.0',
                product_url: p['product_url'] != null ? p['product_url'] : '',
                reward_points: p['reward_points'] != null ? p['reward_points'].toString() : '',
                review_count: p['review_count'] != null ? p['review_count'].toString() : ''
            ));
          }
        });
      print("Best  -->> PPP ${list}");

      bestSellerList.value = list;

      // var response;
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["bestseller_product"];
      //
      // print(data[0]["name"]);

      // print("Best  --firstt" );

     // Map<String, dynamic> bestSellerMap = data[0];
     //  if (!bestSellerMap.containsKey('bestseller_product')) {
     //    throw 'Missing key: bestseller_product';
     //  }
      //  bestSellerList.value = bestSellerMap['bestseller_product'].map<Product>(
      //   (p) {
      //     return Product1(
      //         id: int.parse(p['product_id']),
      //         name: p['name'],
      //         sku: p['sku'],
      //         price: double.parse(p['price']),
      //         image: p['image'],
      //         description: p.containsKey('description')
      //             ? p['description']
      //             : "Best seller of the season and a sofiqers top choice!",
      //         faceSubArea:
      //             p.containsKey('face_sub_area') ? p['face_sub_area'] : -1,
      //         options: p['options'].runtimeType == String ? [] : p['options']
      //     );
      //   },
      // ).toList();
      bestSellerListStatus.value = DataReadyStatus.COMPLETED;
    } catch (e) {
      bestSellerListStatus.value = DataReadyStatus.ERROR;
      print('Error getting best selling products: $e');
      try {
        Get.showSnackbar(
          GetBar(
            message: 'Best selling products could not be fetched',
            duration: Duration(seconds: 2),
          ),
        );
      }catch(ee){

      }
    }
    return false;
  }

  Future<bool> fetchDealOfTheDayList() async {
    print("Deal_of_the_day  --fetchDealOfTheDayList" );

    dealOfTheDayStatus.value = DataReadyStatus.FETCHING;
    try {
      DateTime time = DateTime.now();
      DateFormat format = DateFormat(DateFormat.HOUR24_MINUTE);
      String hourMinuteTime = format.format(time);

      LocationData location = await getCoordinates();
      if (location.latitude == null || location.longitude == null) {
        throw 'Location data not available';
      }
      double latitude = (location.latitude as double).toPrecision(2);

      double longitude = (location.longitude as double).toPrecision(2);
      print("Deal_of_the_day  --firstcondition" );

      if (await shouldFetchNewDealOfTheDay(time, latitude, longitude)) {
        /// Get new deal of the day
        print("Deal_of_the_day  --secondcondition" );

        List<dynamic> dealOfTheDayResponse =
            await sfAPIGetDealOfTheDay(latitude, longitude);
        dynamic dealOfTheDayMap = dealOfTheDayResponse[0];
        print("Deal_of_the_day  -->> Success ${dealOfTheDayMap}");

        List<dynamic> getVendorDealsByIdRespnse =
        await getVendorDealsById(dealOfTheDayMap);

        // if (!dealOfTheDayMap.containsKey('product')) {
        //   throw 'Missing key: product';
        // }
        if(getVendorDealsByIdRespnse.isNotEmpty){
          List<Product> list = [];
          getVendorDealsByIdRespnse.forEach((p) {
            list.add(Product(
            id: int.parse(p['product_id']),
            name: p['name'],
            sku: p['sku'],
              avgRating: p['extension_attributes'] != null && p['extension_attributes']['avgrating'] != null
                  ? p['extension_attributes']['avgrating']
                  : "0.0",
            price: double.parse(p['original_price']),
            discountedPrice: double.parse((p['discounted_price'] != null
            ? p['discounted_price']
                : p['original_price'])),
            image: p['image'],
            description: p.containsKey('description')
            ? (p['description'] != null
            ? p['description']
                : "Best seller of the season and a sofiqers top choice!")
                : "Best seller of the season and a sofiqers top choice!",
            faceSubArea:
            p.containsKey('face_sub_area') ? p['face_sub_area'] : -1,
            faceSubAreaName:
            p['sub_area'].runtimeType == String ? p['sub_area'] : '',
            options: [],
            ));
          });
          dealOfTheDayList.value = list;
        }
        // dealOfTheDayList.value = getVendorDealsByIdRespnse.map<Product>(
        //   (p) {
        //     return Product(
        //       id: int.parse(p['product_id']),
        //       name: p['name'],
        //       sku: p['sku'],
        //       price: double.parse(p['original_price']),
        //       discountedPrice: double.parse((p['discounted_price'] != null
        //           ? p['discounted_price']
        //           : p['original_price'])),
        //       image: p['image'],
        //       description: p.containsKey('description')
        //           ? (p['description'] != null
        //               ? p['description']
        //               : "Best seller of the season and a sofiqers top choice!")
        //           : "Best seller of the season and a sofiqers top choice!",
        //       faceSubArea:
        //           p.containsKey('face_sub_area') ? p['face_sub_area'] : -1,
        //       faceSubAreaName:
        //           p['sub_area'].runtimeType == String ? p['sub_area'] : '',
        //       options: [],
        //     );
        //   },
        // ).toList();
        // saveThisDealOfTheDay(
        //     dealOfTheDayMap['product'], time, latitude, longitude);
      }

      else {
        /// Use old Deal of the day
        print("Deal_of_the_day  --failedcondi" );

        SharedPreferences pref = await SharedPreferences.getInstance();
        List<dynamic> dealOfTheDayFromStorage =
            json.decode(pref.getString('$dealOfTheDayListField') as String);

        dealOfTheDayList.value = dealOfTheDayFromStorage.map<Product>(
          (p) {
            return Product(
              id: int.parse(p['product_id']),
              name: p['name'],
              sku: p['sku'],
              avgRating: p['extension_attributes'] != null && p['extension_attributes']['avgrating'] != null
                  ? p['extension_attributes']['avgrating']
                  : "0.0",
              price: double.parse(p['original_price']),
              discountedPrice: double.parse((p['discounted_price'] != null
                  ? p['discounted_price']
                  : p['original_price'])),
              image: p['image'],
              description: p.containsKey('description')
                  ? (p['description'] != null
                      ? p['description']
                      : "Best seller of the season and a sofiqers top choice!")
                  : "Best seller of the season and a sofiqers top choice!",
              faceSubArea:
                  p.containsKey('face_sub_area') ? p['face_sub_area'] : -1,
              faceSubAreaName:
                  p['sub_area'].runtimeType == String ? p['sub_area'] : '',
              options: [],
            );
          },
        ).toList();
      }
      dealOfTheDayStatus.value = DataReadyStatus.COMPLETED;
    } catch (e) {
      dealOfTheDayStatus.value = DataReadyStatus.ERROR;
      print('Error fetchDealOfTheDayList: $e');
      try {
        Get.showSnackbar(
          GetBar(
            message: 'Deal of the day could not be fetched',
            duration: Duration(seconds: 2),
          ),
        );
      }catch(ee){

      }
    }
    return false;
  }

  Future<void> saveThisDealOfTheDay(List dealOfTheDayProducts, DateTime now,
      double latitude, double longitude) async {
    print(dealOfTheDayProducts);
    try {
      await sfStoreInSharedPrefData(
          fieldName: '$dealOfTheDayListField',
          value: json.encode(dealOfTheDayProducts),
          type: PreferencesDataType.STRING);
      await sfStoreInSharedPrefData(
          fieldName: '$dealOfTheDayHourField',
          value: now.toString(),
          type: PreferencesDataType.STRING);
      await sfStoreInSharedPrefData(
          fieldName: '$dealOfTheDayLatitudeField',
          value: latitude,
          type: PreferencesDataType.DOUBLE);
      await sfStoreInSharedPrefData(
          fieldName: '$dealOfTheDayLongitudeField',
          value: longitude,
          type: PreferencesDataType.DOUBLE);
    } catch (err) {
      print('Error saveThisDealOfTheDay: $err');
    }
  }

  Future<bool> shouldFetchNewDealOfTheDay(
      DateTime now, double latitude, double longitude) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      /// Check for previously stored data
      if (!pref.containsKey('$dealOfTheDayListField')) {
        return true;
      }

      /// Read old time string
      /// convert to DateTime object
      /// compare with the current date time
      String oldTimeString = pref.getString('$dealOfTheDayHourField') as String;
      DateTime oldTime = DateTime.parse(oldTimeString);
      Duration durationSinceLastCall = now.difference(oldTime);
      if (durationSinceLastCall.inHours > 12) {
        return true;
      }

      /// Read old latitude and longitude
      /// compare with the current latitude and longitude
      double oldLatitude =
          pref.getDouble('$dealOfTheDayLatitudeField') as double;
      double oldLongitude =
          pref.getDouble('$dealOfTheDayLongitudeField') as double;

      double distance =
          calculateDistance(latitude, longitude, oldLatitude, oldLongitude);
      print(distance);

      if (distance > 10) {
        return true;
      }

      return false;
    } catch (err) {
      print('Error shouldFetchNewDealOfTheDay: $err');
      return true;
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double p = 0.017453292519943295;
    double Function(num) c = cos;
    double a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

