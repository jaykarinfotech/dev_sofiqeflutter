// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

// 3rd party packages
import 'package:http/http.dart' as http;

// Utils
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';

Future<String> sfAPILogin(String username, String password) async {
  Uri url = Uri.parse('${APIEndPoints.login}?username=$username&password=$password');
  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    }
  );
  var result = json.decode(response.body);
  if (result.runtimeType != String) {
    return 'error';
  } else {
    return result;
  }
}

Future<dynamic> sfAPIGetUserDetails(String token) async {
  Uri url = Uri.parse('${APIEndPoints.getUser}');
  print("APIEndPoints.getUser"+APIEndPoints.getUser);
  http.Response response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    throw 'token invalid';
  }
  var responseMap = json.decode(response.body);
  return responseMap;
}

Future<bool> sfAPIEmailAvailable(String email) async {
  Uri url = Uri.parse('${APIEndPoints.emailAvailability}');
  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    },
    body: json.encode(
      {'customerEmail': '$email'},
    ),
  );
  return json.decode(response.body);
}

Future<bool> sfAPISignup(Map<String, dynamic> newUserInfo) async {
  Uri url = Uri.parse('${APIEndPoints.signup}');
  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.bearerToken}',
    },
    body: json.encode(
      {
        'customer': {
          'dob': '${newUserInfo['dob']}',
          'email': '${newUserInfo['email']}',
          'firstname': '${newUserInfo['firstname']}',
          'lastname': '${newUserInfo['lastname']}',
          'middlename': '${newUserInfo['middlename']}',
          'prefix': '',
          'suffix': '',
          'gender': '${newUserInfo['gender']}'
        },
        'password': '${newUserInfo['password']}'
      },
    ),
  );
  Map<String, dynamic> responseMap = json.decode(response.body);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw '$responseMap';
  }
}

Future<void> sfAPISaveProfilePicture(File file, int customerId) async {
  List<int> imageBytes = file.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  Uri url = Uri.parse('${APIEndPoints.saveProfilePicture}');
  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${APITokens.customerSavedToken}',
    },
    body: json.encode(
      {
        "customer_id": "$customerId",
        "entry": {
          "media_type": "image",
          "content": {
            "base64_encoded_data": "$base64Image",
            "type": "image/jpeg",
            "name": "profile_picture_$customerId.jpeg",
          }
        }
      },
    ),
  );
  Map<String, dynamic> responseMap = json.decode(json.decode(response.body));
  if (response.statusCode != 200) {
    print('failed to save profile picture');
  }
}

Future<bool> sfAPISubscribeCustomerToGold(
    Map<String, String> cardDetails) async {
  Uri url = Uri.parse('${APIEndPoints.subscribe}');
  try {
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${APITokens.bearerToken}',
      },
      body: json.encode(cardDetails),
    );
    print(json.encode(cardDetails));

    if (response.statusCode != 200) {
      print(response.body);
      throw 'Could not complete subsciption';
    } else {
      Map responseBody = json.decode(json.decode(response.body));
      if (!responseBody['success']) {
        throw responseBody;
      }
      return responseBody['success'];
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

Future<bool> sfAPIResetPassword(String email) async {
  try {
    Uri url = Uri.parse(
        '${APIEndPoints.resetPassword}?email=$email&template=email_reset');
    Map<String, String> headers = {
      'Authorization': 'Bearer 3z17y9umegbw7eis72wjz682phvuvnxg',
      'Content-Type': 'application/json',
    };
    http.Request request = http.Request('PUT', url);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw (await response.stream.bytesToString());
    }
    bool responseBody = json.decode(await response.stream.bytesToString());
    return responseBody;
  } catch (err) {
    print('Error sfAPIResetPassword: $err');
    rethrow;
  }
}
