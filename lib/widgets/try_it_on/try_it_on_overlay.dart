// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/round_button.dart';
import 'package:sofiqe/widgets/try_on_product.dart';

import '../../provider/cart_provider.dart';
import '../../provider/page_provider.dart';
import '../../screens/shopping_bag_screen.dart';

class TryItOnOverlay extends StatefulWidget {
  final CameraController camera;
  const TryItOnOverlay({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _TryItOnOverlayState createState() => _TryItOnOverlayState();
}

class _TryItOnOverlayState extends State<TryItOnOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }



  final TryItOnProvider tiop = Get.find();

  bool open = false;





  Future<bool> captureImageAndShare() async {
    try {
      XFile image = await widget.camera.takePicture();
      var dir = (await getExternalStorageDirectory());
      File file = File(join(dir!.path, 'scanned_product_try_on.jpg'));
      if (await file.exists()) {
        await file.delete();
      }
      await image.saveTo(file.path);
      await Share.shareFiles([file.path]);
      return true;
    } catch (e) {
      Get.showSnackbar(
        GetBar(
          message: 'Error occured: $e',
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool cameraShouldWait = false;
    var cartItems = Provider.of<CartProvider>(context).itemCount;
    String name = '';

    if (Provider.of<AccountProvider>(context, listen: false).isLoggedIn) {
      name =
          Provider.of<AccountProvider>(context, listen: false).user!.firstName;
    }

    return Container(
      width: size.width,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10,top: 20),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        print('Back pressed');
                        Navigator.pop(context);
                        final PageProvider pp = Get.find();
                        pp.goToPage(Pages.MAKEOVER);
                        //Navigator.pop(context);
                        // if(tiop.page.value == 2){
                        //   tiop.page.value = 0;
                        // }
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'sofiqe',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: size.height * 0.044,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      '${name.isNotEmpty ? '$name,' : ''} you look sofiqe today',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: size.height * 0.018,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 10,top: 20),
                  child: RoundButton(
                    backgroundColor: Colors.black,
                    size: size.height * 0.05,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext c) {
                            return ShoppingBagScreen();
                          },
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        PngIcon(image: 'assets/icons/add_to_cart_white.png'),
                        cartItems == 0 ? SizedBox() :
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                            ),
                            padding: EdgeInsets.all(5),
                            child: Text(
                                cartItems.toString()
                            )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.03),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoundButton(
                      size: size.height * 0.08,
                      backgroundColor: Color(0xFFF2CA8A),
                      onPress: () {

                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset(
                                'assets/svg/star_filled.svg',
                                color: Colors.black),
                          ),
                          Text(
                            "Review".toUpperCase(),
                            style: TextStyle(fontSize: 10,color: Colors.black,decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    RoundButton(
                      size: size.height * 0.08,
                      backgroundColor: Color(0xFFF2CA8A),
                      onPress: () async {
                        if (!cameraShouldWait) {
                          cameraShouldWait = true;
                          await captureImageAndShare();
                          cameraShouldWait = false;
                        } else {
                          print('Wait for previous Image to be processed');
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: PngIcon(
                              image: 'assets/icons/share/send@3x.png',
                              padding: EdgeInsets.zero,
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            "Share".toUpperCase(),
                            style: TextStyle(fontSize: 10,color: Colors.black,decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(()=>tiop.directProduct.value ? Container() : Material(
            child: Container(
              alignment: Alignment.centerRight,
              width: size.width,
              height: size.height * 0.06,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              decoration: BoxDecoration(
                color: Color(0xFFF4F2F0),
              ),
              child: Obx(
                    () {
                  return IconButton(
                    onPressed: () async {
                      if (tiop.received.value.sku!.isEmpty) {
                        return;
                      }
                      if (tiop.bottomSheetVisible.value) {
                        await _controller.reverse();
                        tiop.toggleBottomSheetVisibility();
                      } else {
                        tiop.toggleBottomSheetVisibility();
                        await _controller.forward();
                      }
                    },
                    icon: PngIcon(
                      image: tiop.bottomSheetVisible.value
                          ? 'assets/icons/push_down_black.png'
                          : 'assets/icons/push_up_black.png',
                    ),
                  );
                },
              ),
            ),
          )),
          Obx(()=>tiop.directProduct.value ? Container(
            height: size.height * 0.12,
            color: Color(0xFFF4F2F0),
            child: Obx(
                  () {
                return TryOnProduct(
                  product: tiop.received.value,
                );
              },
            ),
          ) : SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: Container(
              height: size.height * 0.12,
              color: Color(0xFFF4F2F0),
              child: Obx(
                    () {
                  print("dfb");
                  return TryOnProduct(
                    product: tiop.received.value,
                  );
                },
              ),
            ),
          ))

        ],
      ),
    );
  }
}
