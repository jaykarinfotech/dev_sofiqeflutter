import 'package:sofiqe/utils/states/local_storage.dart';

class APITokens {
  //TODO Change TOKEN

  static String get bearerToken {
    return 'n0y2a0zdfd2xwk24d4c2ucslncm9qovv';
  }

  static String get bearerTokenOld {
    return 'n3z1i4phrahoflb64tb1ej0fpu62b5y3';
  }

  static String get adminBearerId {
    return 'n0y2a0zdfd2xwk24d4c2ucslncm9qovv';
  }

  ///
  /// Token from local storage
  ///
  static Future<String> get customerSavedToken async {
    Map userTokenMap = await sfQueryForSharedPrefData(
        fieldName: 'user-token', type: PreferencesDataType.STRING);
    String token = userTokenMap['user-token'];
    print("USERTOKEN = " + token.toString());
    return token;
  }
}
