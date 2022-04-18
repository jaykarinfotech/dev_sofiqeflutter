import 'package:flutter/material.dart';

// 3rd party packages
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/widgets/makeover/make_over_gallery.dart';
import 'package:sofiqe/widgets/makeover/make_over_login_prompt.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/total_make_over.dart';

// Custom packages
import 'package:sofiqe/widgets/selfie_camera.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var widgetToBuild;
        if (makeOverProvider.screen.value == 1) {
          widgetToBuild = Container(
            child: FutureBuilder(
              future: availableCameras(),
              builder: (BuildContext _,
                  AsyncSnapshot<List<CameraDescription>> snapshot) {
                if (snapshot.hasData) {
                  return SelfieCamera(cameras: snapshot.data);
                } else {
                  return Container();
                }
              },
            ),
          );
        } else if (makeOverProvider.screen.value == 2) {
          widgetToBuild = MakeOverGallery();
        } else if (makeOverProvider.screen.value == 3) {
          widgetToBuild = MakeOverLoginPrompt();
        } else if (makeOverProvider.screen.value == 4) {
          if (!Provider.of<AccountProvider>(context, listen: false)
              .isLoggedIn) {
            makeOverProvider.screen.value = 3;
            widgetToBuild = MakeOverLoginPrompt();
          } else {
            widgetToBuild = Container(
              child: FutureBuilder(
                future: availableCameras(),
                builder: (BuildContext _,
                    AsyncSnapshot<List<CameraDescription>> snapshot) {
                  if (snapshot.hasData) {
                    return TotalMakeOver(cameras: snapshot.data);
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }
        } else {
          widgetToBuild = Container();
        }
        return widgetToBuild;
      },
    );
  }

  SizedBox buttonPadding() => SizedBox(
        height: Get.height * 0.023,
      );
}
