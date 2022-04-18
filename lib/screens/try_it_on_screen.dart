import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:sofiqe/screens/general_account_screen.dart';
import 'package:sofiqe/widgets/back_camera.dart';
import 'package:sofiqe/widgets/try_it_on/try_it_on_overlay.dart';
import 'package:sofiqe/widgets/try_it_on/try_it_on_scan.dart';

import '../provider/page_provider.dart';

class TryItOnScreen extends StatefulWidget {
  TryItOnScreen({Key? key}) : super(key: key);

  @override
  _TryItOnScreenState createState() => _TryItOnScreenState();
}

class _TryItOnScreenState extends State<TryItOnScreen> {
  final TryItOnProvider tiop = Get.find();

  @override
  void dispose() {
    tiop.setDefault();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> tiop.page.value == 2 ? TryItOnProduct() : Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: InkWell(
            onTap: (){
              if(Navigator.canPop(context)){
                Get.back();
              }else{
                final PageProvider pp = Get.find();
                pp.goToPage(Pages.HOME);
              }
            },
            child: Icon(
              Icons.close,
              size: 30,
            )),
        centerTitle: true,
      ),
      body: Obx(
            () {
          int p = tiop.page.value;
          if (p == 0) {
            return TryItOnScan();
          } else if (p == 1) {
            if (Provider.of<AccountProvider>(context, listen: false).isLoggedIn) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                tiop.nextScan();
              });
              return Container();
            } else {
              return GeneralAccountScreen(
                message: 'Wow, that is a cool colour!',
                prompt: 'To see how beautiful you will look, sign in or become a free Sofiqe member',
                onSuccess: () {
                  tiop.nextScan();
                },
              );
            }
          } else {
            return Container();
          }
        },
      ),
    ));
  }
}

class TryItOnProduct extends StatelessWidget {
  TryItOnProduct({Key? key}) : super(key: key);

  final TryItOnProvider tiop = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availableCameras(),
      builder: (BuildContext c, AsyncSnapshot<List<CameraDescription>> snapshot) {
        if (snapshot.hasData) {
          CameraController camera = CameraController(snapshot.data![1], ResolutionPreset.veryHigh, enableAudio: false);
          return Stack(
            children: [
              BackCamera(controller: camera),
              TryItOnOverlay(camera: camera)
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class OnScreenWindowNotification extends StatelessWidget {
  final String message;
  final void Function() closeCallback;
  const OnScreenWindowNotification({
    Key? key,
    required this.message,
    required this.closeCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.6,
        // height: size.height * 0.2,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Color(0xFFF2CA8A)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                Text(
                  'sofiqe',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Color(0xFFF2CA8A),
                        fontSize: size.height * 0.04,
                        height: 1,
                      ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: closeCallback,
                    child: Icon(Icons.close, color: Color(0xFFF2CA8A)),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              '$message',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: size.height * 0.02,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
