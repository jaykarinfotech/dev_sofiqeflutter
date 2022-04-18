import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

import '../../model/CategoryResponse.dart';

 ///
  /// Api Call Request sfAPIFetchFaceAreasAndParameters
  /// [body] is the request body
  /// [url] is the url of the request
  /// [method] is the method of the request
  /// [token] is the token of the request
  /// [isAuth] is the authentication of the request

Future<List> sfAPIFetchFaceAreasAndParameters(int faceArea) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.faceAreasAndParameters}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    };

    http.Request request = http.Request('POST', url);
    request.body = json.encode({
      "face_area": faceArea,
    });
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

Future<CategoryResponse> sfAPIFetchFaceCategory() async {
  try {
    Uri url = Uri.parse('${APIEndPoints.faceAreaCategory}');
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
    print("categopry response");
    print(response.statusCode);

    CategoryResponse responseBody = CategoryResponse.fromJson(json.decode(await response.stream.bytesToString()));
    return responseBody;
  } catch (err) {
    print(err.toString());
    rethrow;
  }
}

 ///
  /// Api Call Request sfAPIGetBrandNames
  /// [body] is the request body
  /// [url] is the url of the request
  /// [method] is the method of the request
  /// [token] is the token of the request
  /// [isAuth] is the authentication of the request
  /// 
Future<List> sfAPIGetBrandNames(String faceArea) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.brandNames}${faceArea.isEmpty ? '' : '?face_area=$faceArea'}');
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

    List responseBody = json.decode(await response.stream.bytesToString());

    return responseBody;
  } catch (err) {
    rethrow;
  }
}
