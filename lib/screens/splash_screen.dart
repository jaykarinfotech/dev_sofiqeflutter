// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
// Utils
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/utils/constants/route_names.dart';
import 'package:sofiqe/utils/states/launch_status.dart';
import 'package:sofiqe/utils/db/startup_routine.dart';

import '../provider/home_provider.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    ///todo: uncomment
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _setUpDB();
  }

  Future<void> _setUpDB() async {
    if (!_isSet) {
      await sfDBStartupRoutine();
      // mop.questions= await  ques.getAnaliticalQuestions();
      // makeOverProvider.ingredients.value= await sfAPIgetIngredients();
      // await makeOverProvider.getQuestionnaireList();
      // mop.ingredients = await sfAPIgetIngredients();
    }
  }

  static bool _isSet = false;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    if (!SplashScreen._isSet) {
      _setNextRoute(context);
      // final HomeProvider hp = Get.find();
      // hp.callAPis();
      SplashScreen._isSet = true;
    }

    // return widget
    return Scaffold(
      backgroundColor: SplashScreenPageColors.backgroundColor,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Shimmer.fromColors(
          highlightColor: Colors.grey[800] as Color,
            baseColor: Colors.white,
              child:Text(
                'sofiqe',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: SplashScreenPageColors.textColor,
                  fontSize: 50,
                ),
              ),
          ),
              Text(
                'beauty your way',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: SplashScreenPageColors.textColor,
                  fontSize: 16,
                ),

              ),
              // FutureBuilder(
              //     future: Future.delayed(Duration(seconds: 5)),
              //     builder: (c, s) => s.connectionState != ConnectionState.done
              //         ?  Text(
              //       'beauty your way',
              //       style: Theme.of(context).textTheme.headline1!.copyWith(
              //         color: SplashScreenPageColors.textColor,
              //         fontSize: 16,
              //       ),
              //     )
              //         : Text('')
              // )

            ],
          ),
        ),

    );
  }

  void _setNextRoute(BuildContext c) {
     Timer(
      Duration(seconds: 4),
          () async {
        if (await sfDidAppLaunchFirstTime()) {
          Navigator.pushReplacementNamed(c, RouteNames.wizardScreen);
        } else {
          // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          ///todo: uncomment
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          Navigator.pushReplacementNamed(c, RouteNames.homeScreen);
          // Navigator.pushReplacementNamed(c, RouteNames.wizardScreen);
        }
      },
    );
  }
}

// // ignore_for_file: deprecated_member_use
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shimmer/shimmer.dart';
//
// // Utils
// import 'package:sofiqe/utils/constants/app_colors.dart';
// import 'package:sofiqe/utils/constants/route_names.dart';
// import 'package:sofiqe/utils/states/launch_status.dart';
// import 'package:sofiqe/utils/db/startup_routine.dart';
//
// class SplashScreen extends StatefulWidget {
//   SplashScreen() {
//     SystemChrome.setEnabledSystemUIOverlays([]);
//
//     ///todo: uncomment
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//     _setUpDB();
//   }
//   Future<void> _setUpDB() async {
//     if (!_isSet) {
//       await sfDBStartupRoutine();
//       // mop.questions= await  ques.getAnaliticalQuestions();
//       // makeOverProvider.ingredients.value= await sfAPIgetIngredients();
//       // await makeOverProvider.getQuestionnaireList();
//       // mop.ingredients = await sfAPIgetIngredients();
//     }
//   }
//
//   static bool _isSet = false;
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     if (!SplashScreen._isSet) {
//       SplashScreen._isSet = true;
//       _setNextRoute(context);
//     }
//
//     // return widget
//     return Scaffold(
//       backgroundColor: SplashScreenPageColors.backgroundColor,
//       body: Center(
//         child: Shimmer.fromColors(
//           highlightColor: Colors.grey[800] as Color,
//           baseColor: Colors.white,
//           child: Text(
//             'sofiqe',
//             style: Theme.of(context).textTheme.headline1!.copyWith(
//               color: SplashScreenPageColors.textColor,
//               fontSize: 50,
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   void _setNextRoute(BuildContext c) {
//     Timer(
//       Duration(seconds: 1),
//           () async {
//         if (await sfDidAppLaunchFirstTime()) {
//           Navigator.pushReplacementNamed(c, RouteNames.wizardScreen);
//         } else {
//           // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//           ///todo: uncomment
//           // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//           Navigator.pushReplacementNamed(c, RouteNames.homeScreen);
//           // Navigator.pushReplacementNamed(c, RouteNames.wizardScreen);
//         }
//       },
//     );
//   }
// }
