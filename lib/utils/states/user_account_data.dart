import 'dart:convert';
// Utils
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofiqe/utils/states/local_storage.dart';

Future<bool> sfIsLoggedIn() async {
  Map<String, dynamic> customerIdMap = await sfQueryForSharedPrefData(
      fieldName: 'customer-id', type: PreferencesDataType.INT);

  if (customerIdMap['found']) {
    return true;
  } else {
    return false;
  }
}
//locally store user address information

Future<void> sfStoreAddressInformation(Map<String, dynamic> address) async {
  sfStoreInSharedPrefData(
      fieldName: 'country',
      value: address['country'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'country_name',
      value: address['country_name'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'region',
      value: address['region'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'street',
      value: json.encode(address['street']),
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'postcode',
      value: address['postcode'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'city',
      value: address['city'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'name',
      value: '${address['firstname']} ${address['lastname']}',
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'email',
      value: address['email'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'phone-number',
      value: address['phone_number'],
      type: PreferencesDataType.STRING);
}

Future<void> sfStoreCardInformation(Map<String, dynamic> cardInfo) async {
  sfStoreInSharedPrefData(
      fieldName: 'card-number',
      value: cardInfo['cardNumber'],
      type: PreferencesDataType.STRING);
  sfStoreInSharedPrefData(
      fieldName: 'expiration',
      value: cardInfo['expiration'],
      type: PreferencesDataType.STRING);
}

Future<void> sfClearCartToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove('cart-token');
}

Future<String> getUserToken() async {
  try {
    Map<String, dynamic> result = await sfQueryForSharedPrefData(
        fieldName: 'user-token', type: PreferencesDataType.STRING);
    if (result['found']) {
      return result['user-token'];
    } else {
      throw 'User is not logged in';
    }
  } catch (err) {
    rethrow;
  }
}
