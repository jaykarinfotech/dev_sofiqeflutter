import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/controller/natural_me_controller.dart';
import 'package:sofiqe/model/natural_me_ms4/natural_me_model.dart';
import 'package:sofiqe/screens/MS5/my_selection.dart';
import 'package:sofiqe/screens/premium_subscription_screen.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/widgets/capsule_button.dart';
import 'package:sofiqe/widgets/my_sofiqe/profile_information.dart';
import 'package:sofiqe/widgets/translucent_background.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MySofiqe extends StatefulWidget {
  const MySofiqe({Key? key}) : super(key: key);

  @override
  State<MySofiqe> createState() => _MySofiqeState();
}

class _MySofiqeState extends State<MySofiqe> {
  // NaturalMeController controller1 = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  controller1.getNaturalMe();
  }

  @override
  Widget build(BuildContext context) {
    NaturalMeController controller = Get.put(NaturalMeController());

    return Scaffold(
      body: Obx(() => controller.isNaturalMeLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Profile(controller),
            )),
    );
  }
}

class Profile extends StatefulWidget {
  NaturalMeController controller;

  Profile(this.controller);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<File> getProfilePicture() async {
    var dir = (await getExternalStorageDirectory());
    File file = File(join(dir!.path, 'front_facing.jpg'));
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
      // color: Color(0xFFF2F2F2),
      child: Column(
        children: [
          ProfileInformation(),
          SizedBox(height: 30),
          Obx(() => Column(
                children: [
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.15),
                      width: size.width * 0.6,
                      height: size.height * 0.38,
                      child: Image.network(
                        APIEndPoints.mediaBaseUrl +
                            "${widget.controller.naturalMeModelNew.value.getUserImagePath()}",
                        fit: BoxFit.cover,
                        //  height: size.height * 0.1,
                        //width: size.height * 0.1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Skin colour:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.controller.naturalMeModelNew.value.getSkin()}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      width: 21,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.controller
                                                  .naturalMeModelNew.value
                                                  .getSkin()
                                                  .toString().contains('#') ? Color(0xff707070) : Colors.white),
                                          color: widget.controller
                                              .naturalMeModelNew.value
                                              .getSkin()
                                              .toString().contains('#') ? HexColor(widget.controller
                                              .naturalMeModelNew.value
                                              .getSkin()
                                              .toString()) : Colors.white)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Skin undertone: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.controller.naturalMeModelNew.value.getSkinUndertone()}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      width: 21,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.controller
                                                  .naturalMeModelNew.value
                                                  .getSkinUndertone()
                                                  .toString().contains('#') ? Color(0xff707070) : Colors.white),
                                          color: widget.controller
                                              .naturalMeModelNew.value
                                              .getSkinUndertone()
                                              .toString().contains('#') ? HexColor(widget.controller
                                              .naturalMeModelNew.value
                                              .getSkinUndertone()
                                              .toString()) : Colors.white)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Eye colour:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.controller.naturalMeModelNew.value.getEyeColor()}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      width: 21,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.controller
                                                  .naturalMeModelNew.value
                                                  .getEyeColor()
                                                  .toString().contains('#') ? Color(0xff707070) : Colors.white),
                                          color: widget.controller
                                              .naturalMeModelNew.value
                                              .getEyeColor()
                                              .toString().contains('#') ? HexColor(widget.controller
                                              .naturalMeModelNew.value
                                              .getEyeColor()
                                              .toString()) : Colors.white)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Hair colour:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.controller.naturalMeModelNew.value.getHairColor()}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      width: 21,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.controller
                                                  .naturalMeModelNew.value
                                                  .getHairColor()
                                                  .toString().contains('#') ? Color(0xff707070) : Colors.white),
                                          color: widget.controller
                                              .naturalMeModelNew.value
                                              .getHairColor()
                                              .toString().contains('#') ? HexColor(widget.controller
                                              .naturalMeModelNew.value
                                              .getHairColor()
                                              .toString()) : Colors.white)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Lip colour:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.controller.naturalMeModelNew.value.getLipColor()}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      width: 21,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.controller
                                                  .naturalMeModelNew.value
                                                  .getLipColor()
                                                  .toString().contains('#') ? Color(0xff707070) : Colors.white),
                                          color: widget.controller
                                              .naturalMeModelNew.value
                                              .getLipColor()
                                              .toString().contains('#') ? HexColor(widget.controller
                                              .naturalMeModelNew.value
                                              .getLipColor()
                                              .toString()) : Colors.white)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Allergic to:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.controller.aller
                                        .toString()
                                        .replaceAll('[', '')
                                        .replaceAll(']', '')
                                        .replaceAll('\' ', ''),
                                    //  widget.controller.naturalMeModelNew.value.customAttributes![1].value.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,child: Center())
                            ],
                          ),
                          SizedBox(height: 21),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

          // ListView.builder(
          //   itemCount: controller.naturalMe[i].length,
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemBuilder: (ctx, i) {
          //     return Column(
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           height: size.height * 0.4,
          //           child: InteractiveViewer(
          //               child: Image.network(
          //                   // 'assets/images/mysofiqe.png'
          //                   APIEndPoints.mediaBaseUrl +
          //                       "${controller.naturalMe[i].items.image.toString()}")),
          //         ),
          //         SizedBox(height: 30),
          //         Container(
          //           padding: EdgeInsets.symmetric(horizontal: 20),
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "Skin colour:",
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "${controller.naturalMe[i].items.skinColour}",
          //                         style: TextStyle(
          //                             color: Colors.black, fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                       child: Center(
          //                     child: Container(
          //                       width: 21,
          //                       height: 19,
          //                       decoration: BoxDecoration(
          //                           border:
          //                               Border.all(color: Color(0xff707070)),
          //                           color: HexColor(controller
          //                               .naturalMe[i].items.skinColour)),
          //                     ),
          //                   ))
          //                 ],
          //               ),
          //               SizedBox(height: 12),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "Skin undertone:",
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "${controller.naturalMe[i].items.skinUndertone}",
          //                         style: TextStyle(
          //                             color: Colors.black, fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(child: Center())
          //                 ],
          //               ),
          //               SizedBox(height: 15),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "Hair colour:",
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "${controller.naturalMe[i].items.hairColourWord}",
          //                         style: TextStyle(
          //                             color: Colors.black, fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                       child: Center(
          //                     child: Container(
          //                       width: 21,
          //                       height: 19,
          //                       decoration: BoxDecoration(
          //                           border:
          //                               Border.all(color: Color(0xff707070)),
          //                           color: HexColor(controller
          //                               .naturalMe[i].items.hairColour)),
          //                     ),
          //                   ))
          //                 ],
          //               ),
          //               SizedBox(height: 11),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "Lip colour:",
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "${controller.naturalMe[i].items.lipColourWord}",
          //                         style: TextStyle(
          //                             color: Colors.black, fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                       child: Center(
          //                     child: Container(
          //                       width: 21,
          //                       height: 19,
          //                       decoration: BoxDecoration(
          //                           border:
          //                               Border.all(color: Color(0xff707070)),
          //                           color: HexColor(controller
          //                               .naturalMe[i].items.lipColour)),
          //                     ),
          //                   ))
          //                 ],
          //               ),
          //               SizedBox(height: 9),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "Allergic to:",
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(
          //                       child: Text(
          //                         "${controller.naturalMe[i].items.allergicTo}",
          //                         style: TextStyle(
          //                             color: Colors.black, fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: Center(),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(height: 21),
          //             ],
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          //
          // ),

          MaterialButton(
            minWidth: size.width * 0.7,
            height: 40,
            shape: StadiumBorder(),
            color: Color(0xffF2CA8A),
            onPressed: () {
              Get.to(() => MySelectionMS5());
            },
            child: Text(
              'RECOMMENDATIONS',
              style: TextStyle(
                  color: Colors.black, fontSize: 12, letterSpacing: 1),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 11),
          // MainButtons(
          //   icon: SvgPicture.asset('assets/svg/lipstick_2.svg'),
          //   title: Text(
          //     'My Shopping',
          //   ),
          //   onTap: () {},
          // ),
          // SizedBox(height: 1),
          // MainButtons(
          //   icon: SvgPicture.asset('assets/svg/user.svg'),
          //   title: Text(
          //     'Natural Me',
          //   ),
          //   onTap: () {},
          // ),
          // SizedBox(height: 1),
          // MainButtons(
          //   title: Text(
          //     'Looks',
          //   ),
          //   icon: SvgPicture.asset('assets/svg/eye_primary.svg'),
          //   onTap: () {},
          // ),
          // SizedBox(height: 8),
          // MainButtons(
          //   title: Text('Reviews/Wishlist'),
          //   icon: PngIcon(image: 'assets/icons/reviews_wishlist.png', padding: EdgeInsets.zero),
          //   onTap: () {},
          // ),
          // RecentProducts(),
          // UnlimitedSofiqe(),
          // NotificationSwitch(),
          // MainButtons(
          //   title: Text('Privacy Policy'),
          //   onTap: () {},
          // ),
          // MainButtons(
          //   title: Text('Terms & Conditions'),
          //   onTap: () {},
          // ),
        ],
      ),
    ));
  }
}

class UnlimitedSofiqe extends StatelessWidget {
  const UnlimitedSofiqe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                'assets/images/my_sofiqe_upgrade_background.png',
              ),
            ),
          ),
        ),
        Container(
          width: size.width,
          height: size.height * 0.3,
          child: TranslucentBackground(opacity: 0.3),
        ),
        Container(
          width: size.width,
          height: size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Unlock Unlimited Sofiqe',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: size.height * 0.02,
                    ),
              ),
              SizedBox(height: size.height * 0.04),
              CapsuleButton(
                width: size.width * 0.75,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext c) {
                        return PremiumSubscriptionScreen();
                      },
                    ),
                  );
                },
                backgroundColor: Color(0xFFF2CA8A),
                child: Text(
                  'Subscribe',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: size.width * 0.045,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationSwitch extends StatelessWidget {
  const NotificationSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width,
      color: Colors.white,
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
