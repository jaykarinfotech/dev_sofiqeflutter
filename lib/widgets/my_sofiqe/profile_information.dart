import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/screens/Ms1/sofiqueEditProfile.dart';
import 'package:sofiqe/screens/premium_subscription_screen.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/profile_picture.dart';
import 'package:sofiqe/widgets/round_button.dart';

import '../../provider/page_provider.dart';
import '../makeover/make_over_login_custom_widget.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AccountProvider ap = Provider.of<AccountProvider>(context);
    String? name = "Guest";
    if (ap.isLoggedIn && ap.user != null) {
      name = '${ap.user!.firstName} ${ap.user!.lastName}';
    }
    String membership = "Not Signed Up Yet";

    if (ap.isLoggedIn) {
      membership = 'Premium Member';
    }

    return Container(
      padding: EdgeInsets.only(left: 20),
      height: size.height * 0.15,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    pp.goToPage(Pages.HOME);
                  },
                  child: SvgPicture.asset('assets/svg/arrow.svg'),
                ),
              ),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () async {
                  !ap.isLoggedIn
                      ? profileController.screen.value = 1
                      : Get.to(() => SofiqueEditProfile());
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    ProfilePicture(),
                    Container(
                      height: 25,
                      width: 25,
                      child: Container(
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: Color(0xFFAFA0A0)),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/edit_profile.svg',
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //todo: This need to fixed.
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'sofiqe',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                        fontSize: size.height * 0.032,
                      ),
                ),
                Text(
                  '$name',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.white,
                        fontSize: size.height * 0.020,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  membership,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Color(0xFFAFA0A0),
                        fontSize: size.height * 0.012,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundButton(
                  size: size.height * 0.07,
                  backgroundColor: Color(0xFFF2CA8A),
                  onPress: () async {
                    await FlutterShare.share(
                        title: 'a',
                        text: ' ',
                        linkUrl:
                            'https://play.google.com/store/apps/details?id=com.sofiqe.app',
                        chooserTitle: '');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: PngIcon(
                          image: 'assets/icons/share/send@3x.png',
                          padding: EdgeInsets.only(left: size.width * 0.01),
                          height: size.height * 0.090,
                          width: size.height * 0.090,
                        ),
                      ),
                      Text(
                        'SHARE\nAPP',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.black,
                              fontSize: size.height * 0.01,
                            ),
                      ),
                    ],
                  ),
                ),
                ap.isLoggedIn
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          profileController.screen.value = 1;
                        },
                        child: Text(
                          'UPGRADE',
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: Color(0xFFF2CA8A),
                                    fontSize: size.height * 0.01,
                                  ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
