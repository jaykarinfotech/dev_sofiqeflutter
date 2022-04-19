// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/model/user_model.dart';
import 'package:sofiqe/provider/wishlist_provider.dart';
import 'package:sofiqe/utils/api/user_account_api.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AccountProvider extends ChangeNotifier {
  late String userToken;
  late int customerId;
  late bool isLoggedIn;
  late bool goldPremium;
  late User? user;

  AccountProvider() {
    _initData();
  }

  _initData() async {
    // userToken = '';
    customerId = -1;
    isLoggedIn = false;
    goldPremium = false;
    await checkSavedAccount();
  }

  Future<void> checkSavedAccount() async {
    Map userTokenMap = await sfQueryForSharedPrefData(
        fieldName: 'user-token', type: PreferencesDataType.STRING);
    if (userTokenMap['found']) {
      getUserDetails(userTokenMap['user-token']);
      userToken = userTokenMap['user-token'];
      print("USERTOKEN = " + userToken.toString());
    }
  }

  Future<void> getUserDetails(String userToken) async {
    try {
      Map userMap = await sfAPIGetUserDetails(userToken);
      print(userMap);
      user = User(
        id: userMap['id'],
        email: userMap['email'],
        firstName: userMap['firstname'],
        lastName: userMap['lastname'],
        addresses: userMap['addresses'],
      );
      customerId = user!.id;
      isLoggedIn = true;
      await sfStoreInSharedPrefData(
          fieldName: 'uid',
          value: userMap['id'],
          type: PreferencesDataType.INT);
      await sfStoreInSharedPrefData(
          fieldName: 'email',
          value: userMap['email'],
          type: PreferencesDataType.STRING);
      await sfStoreInSharedPrefData(
          fieldName: 'name',
          value: '${userMap['firstname']} ${userMap['lastname']}',
          type: PreferencesDataType.STRING);
      notifyListeners();
    } catch (e) {
      print(e);
      //  await sfRemoveFromSharedPrefData(fieldName: 'user-token');
    }
  }

  Future<void> saveProfilePicture() async {
    var dir = (await getExternalStorageDirectory());
    File file = File(join(dir!.path, 'profile_picture.jpg'));
    sfAPISaveProfilePicture(file, customerId);
  }

  Future<bool> login(String username, String password) async {
    var result = await sfAPILogin(username, password);
    if (result != 'error') {
      isLoggedIn = true;
      userToken = result;
      await sfStoreInSharedPrefData(
          fieldName: 'user-token',
          value: result,
          type: PreferencesDataType.STRING);
      await getUserDetails(userToken);

      notifyListeners();

      /// Fetch wishlist
      WishListProvider wp = Get.find();
      wp.login();

      ///

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    userToken = '';
    customerId = -1;
    isLoggedIn = false;
    goldPremium = false;
    user = null;
    await sfRemoveFromSharedPrefData(fieldName: 'user-token');
    await sfRemoveFromSharedPrefData(fieldName: 'uid');

    /// Remove wishlist
    WishListProvider wp = Get.find();
    wp.logout();

    ///

    notifyListeners();
  }

  Future<bool> subscribe(Map<String, String> cardDetails) async {
    Map<String, String> cardMap = {
      "customerId": "$customerId",
      "ccNu": "${cardDetails['card_number']}",
      "cvvNu": "${cardDetails['cvv']}",
      "expDate":
          "${(cardDetails['expiration_date'] as String).replaceAll('/', '')}",
      "isSubcribe": "1",
    };
    try {
      bool success = await sfAPISubscribeCustomerToGold(cardMap);
      if (success) {
        goldPremium = true;
        notifyListeners();
      } else {
        Get.showSnackbar(
          GetBar(
            message: 'Could not complete request, please try again',
            duration: Duration(seconds: 2),
          ),
        );
      }
      return success;
    } catch (e) {
      Get.showSnackbar(
        GetBar(
          message: 'Could not complete subsciption process: $e',
          duration: Duration(seconds: 2),
        ),
      );
    }
    return false;
  }
}
