import 'package:flutter/material.dart';

// 3rd party packages
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/widgets/makeover/make_over_gallery.dart';
import 'package:sofiqe/widgets/makeover/make_over_login_prompt.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/make_over_try_on.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/total_make_over.dart';

// Custom packages
import 'package:sofiqe/widgets/selfie_camera.dart';

class MakeOverScreen extends StatefulWidget {
  MakeOverScreen({Key? key}) : super(key: key);

  @override
  State<MakeOverScreen> createState() => _MakeOverScreenState();
}

class _MakeOverScreenState extends State<MakeOverScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    makeOverProvider.colorAna.value == true ? true : false;
    makeOverProvider.questions.value = questionsController.makeover;
    makeOverProvider.update();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (makeOverProvider.colorAna.value == true) {
        var widgetToBuild;
        if (makeOverProvider.screen.value == 1) {
          widgetToBuild = skinAnalysis(widgetToBuild);
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
        } else if (makeOverProvider.screen.value == 5) {
          widgetToBuild = colourAnalysis(widgetToBuild);
        } else if (makeOverProvider.screen.value == 6) {
          widgetToBuild = MakeOverTryOn();

          // Container(
          //   child: FutureBuilder(
          //     future: availableCameras(),
          //     builder: (BuildContext _,
          //         AsyncSnapshot<List<CameraDescription>> snapshot) {
          //       if (snapshot.hasData) {
          //         return MakeOverTryOn(cameras: snapshot.data);
          //       } else {
          //         return Container();
          //       }
          //     },
          //   ),
          // );

          makeOverProvider.colorAna.value = false;
          makeOverProvider.screen.value = 1;
        } else {
          widgetToBuild = Container();
        }
        return widgetToBuild;
      } else
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/makeovebg.png'),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.053,
              ),
              Text(
                'sofiqe',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              Spacer(),
              Text(
                'Please select',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              buttonPadding(),
              ElevatedButton(
                onPressed: () {
                  makeOverProvider.colorAna.value = true;

                  setState(() {});
                  //Get.to(() => MakeOverGallery());
                },
                child: Container(
                    height: 50,
                    width: Get.width * 0.7,
                    alignment: Alignment.center,
                    child: Text('Skin and colour analysis')),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
              ),
              buttonPadding(),
              ElevatedButton(
                onPressed: () {
                  makeOverProvider.colorAna.value = true;
                  makeOverProvider.currentQuestion.value = 6;
                  setState(() {});
                  //Get.to(() => MakeOverGallery());
                },
                child: Container(
                    height: 50,
                    width: Get.width * 0.7,
                    alignment: Alignment.center,
                    child: Text('Colour analysis')),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
              ),
              buttonPadding(),
              Obx(() => ElevatedButton(
                    onPressed: makeOverProvider.tryitOn.value
                        ? () {
                            makeOverProvider.screen.value = 6;
                            makeOverProvider.colorAna.value = true;
                          }
                        : () {},
                    child: Container(
                        height: 50,
                        width: Get.width * 0.7,
                        alignment: Alignment.center,
                        child: Text(
                          'Try My Selections on',
                          style: TextStyle(color: Colors.black),
                        )),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: makeOverProvider.tryitOn.value
                          ? Colors.white
                          : Colors.grey[700],
                      onPrimary: makeOverProvider.tryitOn.value
                          ? Colors.black
                          : Colors.white,
                    ),
                  )),
              buttonPadding(),
            ],
          ),
        );
    });
  }

  skinAnalysis(widgetToBuild) {
    widgetToBuild = Container(
      child: FutureBuilder(
        future: availableCameras(),
        builder:
            (BuildContext _, AsyncSnapshot<List<CameraDescription>> snapshot) {
          if (snapshot.hasData) {
            return SelfieCamera(cameras: snapshot.data);
          } else {
            return Container();
          }
        },
      ),
    );
    return widgetToBuild;
  }

  colourAnalysis(widgetToBuild) {
    widgetToBuild = Container(
      child: FutureBuilder(
        future: availableCameras(),
        builder:
            (BuildContext _, AsyncSnapshot<List<CameraDescription>> snapshot) {
          if (snapshot.hasData) {
            return SelfieCamera(cameras: snapshot.data);
          } else {
            return Container();
          }
        },
      ),
    );
    return widgetToBuild;
  }

  SizedBox buttonPadding() => SizedBox(
        height: Get.height * 0.023,
      );
}
