import 'dart:convert';

import 'package:http/http.dart' as http;

// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

///
/// Api Call Request sfAPIGetRecommendedColours
/// [body] is the request body
/// [url] is the url of the request
/// [method] is the method of the request
/// [token] is the token of the request
///

Future<List> sfAPIGetRecommendedColours(
    int uid, String token, String faceSubAreaName) async {
  Uri url = Uri.parse('${APIEndPoints.getRecommendedColors}');
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', url);
  request.body = json.encode(
    {
      "eye_color": "green",
      "lip_color": "pink",
      "hair_color": "#000000",
      "skin_tone": "#ffccaa",
      "face_sub_area": "$faceSubAreaName",
      "customerId": uid,
    },
  );
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  try {
    if (response.statusCode == 200) {
      List responseBody = json.decode(await response.stream.bytesToString());
      return responseBody;
    } else {
      throw await response.stream.bytesToString();
    }
  } catch (e) {
    return [];
  }
}

///
/// Api Call Request sfAPIFetchFaceAreasAndParameters
/// [body] is the request body
/// [url] is the url of the request
/// [method] is the method of the request
/// [token] is the token of the request

Future<List> sfAPIGetNonRecommendedColours(String area) async {
  Uri url = Uri.parse('${APIEndPoints.getNonRecommendedColors}');

  http.Request request = http.Request('POST', url);
  request.body = json.encode(
    {
      "FacSubarea": 5685,
      "page": 1,
    },
  );
  request.headers
      .addAll(APIEndPoints.headers(await APITokens.customerSavedToken));

  http.StreamedResponse response = await request.send();

  if (response.statusCode != 200) {
    print(json.decode(await response.stream.bytesToString()));
  }
  List result = json.decode(await response.stream.bytesToString());
  return result;
}

///
/// Api Call Request sfAPIFetchFaceAreasAndParameters
/// [body] is the request body
/// [url] is the url of the request
/// [method] is the method of the request
/// [token] is the token of the request
/// [isAuth] is the authentication of the request

Future<Map> sfAPIGetNonRecommendedColourProducts(String id) async {
  try {
    Uri url = Uri.parse('${APIEndPoints.nonRecommendedColourProducts(id)}');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    };
    http.Request request = http.Request('GET', url);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map responseBody = json.decode(await response.stream.bytesToString());
      return responseBody;
    } else {
      throw json.decode(await response.stream.bytesToString());
    }
  } catch (err) {
    rethrow;
  }
}
