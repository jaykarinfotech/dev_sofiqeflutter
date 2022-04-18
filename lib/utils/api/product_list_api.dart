import 'dart:convert';

import 'package:http/http.dart' as http;
// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

Future<Map> sfAPIGetCatalogUnfilteredItems(int page) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.catalogUnfiltereditems}$page');
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer n0y2a0zdfd2xwk24d4c2ucslncm9qovv',
      //'Bearer ${APITokens.bearerToken}',
    });
    if (response.statusCode != 200) {
      throw response.body;
    }
    Map resultMap = json.decode(response.body);
    return resultMap;
  } catch (err) {
    print(err);
    throw 'Could not fetch item list';
  }
}

Future<Map> sfAPIGetUnfilteredFaceAreaItems(int page, int faceArea) async {
  try {
    Uri url =
        Uri.parse('${APIEndPoints.unfilteredFaceAreaItems(page, faceArea)}');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer n0y2a0zdfd2xwk24d4c2ucslncm9qovv',
      //'Bearer ${APITokens.bearerToken}',
    };

    http.Request request = http.Request('GET', url);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }

    Map responseBody = json.decode(await response.stream.bytesToString());

    return responseBody;
  } catch (err) {
    rethrow;
  }
}

Future<Map> sfAPIFetchProductItems(int page, int faceSubArea) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.productItems(page, faceSubArea)}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer n0y2a0zdfd2xwk24d4c2ucslncm9qovv',
      //'Bearer ${APITokens.bearerToken}',
    };

    http.Request request = http.Request('GET', url);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }

    Map responseBody = json.decode(await response.stream.bytesToString());

    return responseBody;
  } catch (err) {
    rethrow;
  }
}

Future<List> sfAPIFetchBrandFilteredItems(
    int page, String brand, String faceArea) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.brandFilteredItems}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer n0y2a0zdfd2xwk24d4c2ucslncm9qovv',
      //'Bearer ${APITokens.bearerToken}',
    };

    http.Request request = http.Request('POST', url);
    request.body = json.encode(
      {
        'brand': '$brand',
        'face_sub_area': '$faceArea',
        'page': page,
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }

    List responseBody = json.decode(await response.stream.bytesToString());

    return responseBody;
  } catch (err) {
    rethrow;
  }
}

Future<List> sfAPIGetCatalogPopularItems(int page) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.catalogPopularItems}');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    };
    http.Request request = http.Request('POST', url);
    request.body = json.encode(
      {
        "page": page,
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }
    List resultMap = json.decode(await response.stream.bytesToString());

    return resultMap;
  } catch (err) {
    print(err);
    throw 'Could not fetch item list';
  }
}

Future<List> sfAPIGetCatalogBetweenPriceItems(
    int page, int minPrice, int maxPrice) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.catalogBetweenPriceItems}');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    };
    http.Request request = http.Request('POST', url);
    request.body = json.encode(
      {
        "min_price": minPrice,
        "max_price": maxPrice,
        "page": page,
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }
    List resultMap = json.decode(await response.stream.bytesToString());

    return resultMap;
  } catch (err) {
    print(err);
    throw 'Request Error $err';
  }
}

Future<Map<String, dynamic>> sfAPIGetBestSellers() async {
  Uri url = Uri.parse('${APIEndPoints.getBestSellersList}');
  // Uri url = Uri.parse('http://3.109.228.199/rest/V1/custom/bestsellers');
  http.Response response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    // List<dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    print("Best  -->> first ${map}");

    // List<dynamic> data = map["bestseller_product"];
    // print(data[0]["name"]);
    //
    // print("Best  -->> second ${data[0]["name"]}");

    return map;
  } else {
    print(response.body);
    throw 'Could not fetch bestsellers';
  }
}

  Future<List<dynamic>> sfAPIGetDealOfTheDay(double lat, double long) async {
  Uri url = Uri.parse('${APIEndPoints.getDealOfTheDay}');
  // Uri url = Uri.parse('http://3.109.228.199/rest/V1/custom/getDeals');
  // http.Response response = await http.post(
  //   url,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${APITokens.bearerToken}',
  //   },
  //   body: json.encode(
  //     {
  //       'lat': '$lat',
  //       'long': '$long',
  //       'time': '$time',
  //     },
  //   ),
  // );
  // if (response.statusCode == 200) {
  //   List<dynamic> responseBody = json.decode(response.body);
  //   return responseBody;
  // } else {
  //   print(response.body);
  //   throw 'Could not fetch deals';
  // }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${APITokens.bearerToken}',
  };
  http.Request request = http.Request('POST', url);
  // request.body = json.encode({"lat": "$lat", "long": "$long", "time": "$time"});
  request.body = json.encode({"lat": "$lat", "long": "$long"});

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print(response);
  print("get_deal:>>  ");

  if (response.statusCode == 200) {
    String responseString = await response.stream.bytesToString();
    print("get_deal  -->> 1 ${json.decode(responseString)}");

    List<dynamic> responseBody = json.decode(responseString);
    return responseBody;
  } else {
    print(response.reasonPhrase);
    print("get_deal  -->> 2");
    throw 'Could not fetch deals';
  }
}
Future<List<dynamic>> getVendorDealsById(dynamic seller_id) async {
  Uri url = Uri.parse('${APIEndPoints.getVendorDealsById}');
  // Uri url = Uri.parse('http://3.109.228.199/rest/V1/custom/getDeals');
  // http.Response response = await http.post(
  //   url,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${APITokens.bearerToken}',
  //   },
  //   body: json.encode(
  //     {
  //       'lat': '$lat',
  //       'long': '$long',
  //       'time': '$time',
  //     },
  //   ),
  // );
  // if (response.statusCode == 200) {
  //   List<dynamic> responseBody = json.decode(response.body);
  //   return responseBody;
  // } else {
  //   print(response.body);
  //   throw 'Could not fetch deals';
  // }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${APITokens.bearerToken}',
  };
  http.Request request = http.Request('POST', url);
  // request.body = json.encode({"lat": "$lat", "long": "$long", "time": "$time"});
  request.body = json.encode({"seller_id": "$seller_id"});

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print(response);
  print("Vendor_deal:>>  ");

  if (response.statusCode == 200) {
    String responseString = await response.stream.bytesToString();
    print("Vendor_deal  -->> 1 ${json.decode(responseString)}");

    List<dynamic> responseBody = json.decode(responseString);
    return responseBody;
  } else {
    print(response.reasonPhrase);
    print("Vendor_deal  -->> 2");
    throw 'Could not fetch deals';
  }
}

Future<Map> sfAPIGetSearchedItems(String query) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.searchedItems(query)}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    };

    http.Request request = http.Request('GET', url);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }
    Map responseBody = json.decode(await response.stream.bytesToString());
    return responseBody;
  } catch (err) {
    rethrow;
  }
}

Future<List> sfAPIFetchCentralColorProducts(
  String token,
  String color,
  String undertone,
  String faceSubArea,
  int colorDepth,
) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.centralColorProducts}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Request request = http.Request('POST', url);
    request.body = json.encode(
      {
        'color': '$color',
        'face_sub_area': '$faceSubArea',
        'undertone': '$undertone',
        'color_depth': '$colorDepth',
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw await response.stream.bytesToString();
    }

    List responseBody = json.decode(await response.stream.bytesToString());
    return responseBody;
  } catch (err) {
    rethrow;
  }
}
