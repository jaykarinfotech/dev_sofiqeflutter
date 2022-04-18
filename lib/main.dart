import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/controller/questionController.dart';
import 'package:sofiqe/provider/make_over_provider.dart';
import 'package:sofiqe/provider/wishlist_provider.dart';
import 'package:sofiqe/sofiqe.dart';
import 'controller/msProfileController.dart';

///
/// we put controller at the start only for testing purpose
/// you can put on exect location

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(WishListProvider());
  Get.put(MsProfileController());
  Get.put(QuestionsController());
  Get.put(MakeOverProvider());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(Sofiqe());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
