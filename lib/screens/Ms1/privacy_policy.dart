// ignore_for_file: unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final bool isTerm;

  const PrivacyPolicyScreen({Key? key, required this.isTerm}) : super(key: key);

  @override
  createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.isTerm ? 'Terms and Conditions' : 'Privacy Policy',
          style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins-Regular",
              ),
        ),
      ),
      // custom
      body: Container(
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.all(3),
          child: WebView(
              backgroundColor: Colors.white,
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.isTerm
                  ? 'http://dev.sofiqe.com/sTermsNConditions.htm'
                  : 'http://dev.sofiqe.com/sPrivacyPolicy.htm')),

      // body: SingleChildScrollView(
      //
      //   child: Column(
      //     children: [
      //       Container(
      //
      //         padding: EdgeInsets.only(top: 8),
      //
      //          height:  MediaQuery.of(context).size.height/2,
      //           child: WebView(
      //               key: _key,
      //               javascriptMode: JavascriptMode.unrestricted,
      //               initialUrl: widget.scoreurl)),
      //               Container(
      //                 height: MediaQuery.of(context).size.height/3,
      //
      //                 // flex:2,
      //           child: WebView(
      //               key: _key,
      //               javascriptMode: JavascriptMode.unrestricted,
      //               initialUrl: url))
      //     ],
      //   ),
      // )
    );
  }
}
      //                 height: MediaQuery.of(context).size.height/3,