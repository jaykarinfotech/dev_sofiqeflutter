import 'dart:convert';

import 'package:http/http.dart' as http;

// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'package:sofiqe/utils/states/user_account_data.dart';

Future<http.Response> sfAPIGetShippingAddressFromCustomerID({required int customerId}) async {
  Uri url = Uri.parse('${APIEndPoints.shippingAddressByCustomerId}?customer_id=$customerId');
  http.Response response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${APITokens.bearerToken}',
  });
  // print(response.body);
  return response;
}

Future<Map<String, dynamic>> sfAPIAddShippingAddressForGuest(Map address) async {
  String cartId = (await sfQueryForSharedPrefData(fieldName: 'cart-token', type: PreferencesDataType.STRING)).values.last;
  Uri uri = Uri.parse(APIEndPoints.addShippingAddress(cartId));
  final response = await http.post(uri, headers: APIEndPoints.headers(APITokens.bearerToken), body: jsonEncode(address));
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode != 200) {
    throw data['parameters']['message'];
  }
  return data;
}

Future<dynamic> sfAPIFetchCountryDetails() async {
  Uri uri = Uri.parse(APIEndPoints.countryDetails);
  final response = await http.get(
    uri,
    headers: APIEndPoints.headers(APITokens.bearerToken),
  );
  if (response.statusCode != 200) {
    return {'message': 'error'};
  } else {
    return json.decode(response.body);
  }
}

Future<String> sfApiPlaceOrder() async {
  String cartId = (await sfQueryForSharedPrefData(fieldName: 'cart-token', type: PreferencesDataType.STRING)).values.last;
  Uri uri = Uri.parse(APIEndPoints.placeOrder(cartId));
  final response = await http.put(uri,
      headers: APIEndPoints.headers(APITokens.bearerToken),
      body: jsonEncode({
        "paymentMethod": {"method": "checkmo"}
      }));
  print(response.body);
  var result = jsonDecode(response.body);
  if (response.statusCode != 200) {
    throw result;
  }
  await sfClearCartToken();
  return result;
}
