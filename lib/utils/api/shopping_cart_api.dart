import 'dart:convert';

// 3rd party packages
import 'package:http/http.dart' as http;

// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:sofiqe/utils/states/local_storage.dart';

Future<String> sfAPIInitializeGuestShoppingCart() async {
  Map<String, dynamic> prefResultMap = await sfQueryForSharedPrefData(
      fieldName: 'cart-token', type: PreferencesDataType.STRING);
  if (prefResultMap['found']) {
    return prefResultMap['cart-token'];
  }

  String cartToken = await _sfAPICreateRemoteCart();
  if (cartToken != 'error') {
    sfStoreInSharedPrefData(
        fieldName: 'cart-token',
        value: '$cartToken',
        type: PreferencesDataType.STRING);
    return cartToken;
  }

  return 'error';
}

Future<List<dynamic>> sfAPIGetGuestCartList(String cartToken) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.guestCartList(cartToken)}');
    http.Response response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${APITokens.adminBearerId}',
      },
    );

    List<dynamic> responseMap = json.decode(response.body);
    return responseMap;
  } catch (err) {
    print('Error sfAPIGetGuestCartList: $err');
    rethrow;
  }
}


Future<List<dynamic>> sfAPIGetUserCartList() async {
  try {
    Uri url = Uri.parse('${APIEndPoints.userCartList}');
    http.Response response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await APITokens.customerSavedToken}',
      },
    );

    List<dynamic> responseMap = json.decode(response.body);
    return responseMap;
  } catch (err) {
    print('Error sfAPIGetUserCartList: $err');
    rethrow;
  }
}

Future<Map<String, dynamic>> sfAPIGetGuestCartDetails(String cartToken) async {
  Uri url = Uri.parse('${APIEndPoints.guestCartDetails}$cartToken');
  http.Response response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    },
  );

  Map<String, dynamic> responseMap = json.decode(response.body);
  return responseMap;
}

Future<Map<String, dynamic>> sfAPIGetUserCartDetails() async {
  Uri url = Uri.parse('${APIEndPoints.userCartDetails}');
  http.Response response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await APITokens.customerSavedToken}',
    },
  );

  Map<String, dynamic> responseMap = json.decode(response.body);
  return responseMap;
}

Future<String> _sfAPICreateRemoteCart() async {
  Uri url = Uri.parse('${APIEndPoints.guestCartNewInstance}');
  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    },
  );
  if (response.statusCode == 200) {
    String token = json.decode(response.body);
    return token;
  } else {
    return 'error';
  }
}

//TODO Change this to a POST TOKEN
Future<void> sfAPIAddItemToCart(String token, int qouteId, String sku,
    List simpleProductOptions, int type, String userType,
    {int quantity = 0}) async {
  Uri url = Uri.parse('');
  if (userType == 'Guest') {
    url = Uri.parse('${APIEndPoints.addToCartGuest(cartId: token)}');
    print('addToCartGuest  ${url.toString()}');
  } else {
    url = Uri.parse('${APIEndPoints.addToCartCustomer(cartId: token)}');
    print('addToCartUser  ${url.toString()}');
  }

  var requestData= (type == 0)
      ? userType == 'Guest'
      ? {
    'cartItem': {
      'sku': '$sku',
      'qty': quantity == 0 ? 1 : quantity
    },
  }
      : {
    'cartItem': {
      'sku': '$sku',
      'qty': quantity == 0 ? 1 : quantity,
      'quote_id': '$token',
    },
  }
      : {
    'cartItem': {
      'sku': '$sku',
      'qty': quantity == 0 ? 1 : quantity,
      'quote_id': '$token',
      "product_option": {
        "extension_attributes": {
          "configurable_item_options":
          json.encode(simpleProductOptions),
        },
      },
    },
  };

  print("JSON Response : ${requestData}");

  http.Response response = await http.post(
    url,
    headers: userType == 'Guest'
        ? {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${APITokens.bearerToken}',
          }
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await APITokens.customerSavedToken}',
          },
    body: json.encode(requestData),
  );
  print(response.body);
  if (response.statusCode != 200) {
    throw json.decode(response.body);
  }
  // }
}

Future<void> sfAPIRemoveItemFromCart(String token, String itemId) async {
  Uri url = Uri.parse(
      '${APIEndPoints.removeFromCart(cartId: token, itemId: itemId)}');
  http.Response response = await http.delete(
    url,
    headers: APIEndPoints.headers(APITokens.bearerToken),
  );
  if (response.statusCode != 200) {
    throw "Failed";
  }
}
