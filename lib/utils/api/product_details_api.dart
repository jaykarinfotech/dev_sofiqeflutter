import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

//TODO Change this to a POST TOKEN
Future<http.Response> sfAPIGetProductDetailsFromSKU(
    {required String sku}) async {
  Uri url = Uri.parse('${APIEndPoints.productBySKU}$sku');
  http.Response response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${APITokens.adminBearerId}',
  });
  print('${APIEndPoints.productBySKU}$sku');
  print(APITokens.adminBearerId);
  return response;
}

Future<dynamic> sfAPIGetProductStatic() async {
  Uri url = Uri.parse('${APIEndPoints.productStatic}');
  try {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cer, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set(
      'Accept',
      'application/json',
    );
    request.headers.set(
      'Authorization',
      'Bearer ${APITokens.bearerToken}',
    );
    request.add(utf8.encode(json.encode(
      {
        'value': '1',
      },
    )));
    HttpClientResponse res = await request.close();
    String body = await res.transform(utf8.decoder).join();
    if (res.statusCode != 200) {
      throw 'Could not load data: $body';
    }
    return json.decode(body);
  } catch (e) {
    print(e);
  }
}

Future<List> sfAPIScanProduct(
    String token, Map<String, String> scanResult) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.scanProduct}');
    // Uri url = Uri.parse('http://3.109.228.199/rest/V1/custom/scanProduct');
    print(url.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    http.Request request = http.Request(
      'POST',
      url,
    );
    request.body = json.encode(scanResult);
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
