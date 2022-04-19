import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/controller/msProfileController.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/screens/MS6/reviews.dart';
import 'package:sofiqe/screens/Ms1/privacy_policy.dart';
import 'package:sofiqe/screens/Ms2/my_shopping_history.dart';
import 'package:sofiqe/screens/Ms3/looks_screen.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/widgets/makeover/make_over_login_custom_widget.dart';
import 'package:sofiqe/widgets/my_sofiqe/profile_information.dart';
import '../my_sofiqe.dart';
import '../premium_subscription_screen.dart';
import '../shopping_bag_screen.dart';
import '../try_it_on_screen.dart';

class Ms1Profile extends StatefulWidget {
  const Ms1Profile({Key? key}) : super(key: key);

  @override
  _Ms1ProfileState createState() => _Ms1ProfileState();
}

class _Ms1ProfileState extends State<Ms1Profile>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<RecentScan> recenScan = [
    RecentScan(
        image: 'assets/images/dior1.png',
        title: 'Rouge Dior Ultra Care - Batom',
        type: 'DIOR'),
    RecentScan(
        image: 'assets/images/dior2.png',
        title: 'Dior Addict Lacquer Plump',
        type: 'DIOR'),
    RecentScan(
        image: 'assets/images/dior3.png',
        title: 'Dior Addict Lips Stellar Shine 3 g',
        type: 'DIOR'),
    RecentScan(
        image: 'assets/images/dior1.png',
        title: 'Rouge Dior Ultra Care - Batom',
        type: 'DIOR'),
  ];

  bool notification = false;

  @override
  void initState() {
    super.initState();
    profileController.screen.value = 0;
    profileController.getRecenItems();
    profileController.getUserProfile();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.screen.value == 1) {
        return MakeOverCustomWidget();
      } else if (profileController.screen.value == 2) {
        return MakeOvarSingle(
          description:
              'For this section you have to complete your Makeover first',
          title: 'We are sofiqe',
        );
      } else if (profileController.screen.value == 3) {
        return MySofiqe();
      } else if (profileController.screen.value == 4) {
        return MyShoppingHistory();
        //return ShoppingBagScreen();
      } else
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: mySofiqe(context),
            ),
          ),
        );
    });
  }

  Container mySofiqe(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AccountProvider account = Provider.of<AccountProvider>(context);

    return Container(
        child: Column(
      children: [
        ProfileInformation(),
        displayTile(
            leading: "lipstick.png",
            title: "My Shopping History",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () async {
              !Provider.of<AccountProvider>(context, listen: false).isLoggedIn
                  ? profileController.screen.value = 1
                  : profileController.screen.value = 4;
            }),
        Divider(),
        displayTile(
            leading: "user.png",
            title: "Natural Me",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () async {
              !makeOverProvider.tryitOn.value
                  ? profileController.screen.value = 2
                  : profileController.screen.value = 3;
            }),
        Divider(),
        displayTile(
            leading: "eye.png",
            title: "Looks",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () async {
              !Provider.of<AccountProvider>(context, listen: false).isLoggedIn
                  ? profileController.screen.value = 2
                  : Get.to(() => LooksScreen());
            }),
        Divider(),
        //here comment
        displayTile(
            leading: "scantry.png",
            title: "Scan & Try on",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () async {
              !Provider.of<AccountProvider>(context, listen: false).isLoggedIn
                  ? profileController.screen.value = 1
                  : Get.to(() => TryItOnScreen());
            }),
        Divider(),
        displayTile(
            leading: "review.png",
            title: "Reviews/Wishlist",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () async {
              !Provider.of<AccountProvider>(context, listen: false).isLoggedIn
                  ? profileController.screen.value = 1
                  : Get.to(() => ReviewsMS6());
            }),
        Divider(),
        SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: new TabBar(
            indicatorPadding: EdgeInsets.zero,
            isScrollable: true,
            indicatorColor: Color(0xffF2CA8A),
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 12, color: Colors.black),
            controller: _controller,
            tabs: [
              new Tab(
                text: 'RECENT SCANS',
              ),
              new Tab(
                text: 'RECENT COLOURS',
              ),
            ],
          ),
        ),
        Container(
          height: (profileController.recentItem == null ||
                  profileController.recentItem!.data!.items!.length == 0)
              ? MediaQuery.of(context).size.height * 0.23
              : MediaQuery.of(context).size.height * 0.23,
          child: new TabBarView(
            controller: _controller,
            children: <Widget>[
              GetBuilder<MsProfileController>(builder: (contrl) {
                return (contrl.isRecentLoading)
                    ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
                    : (contrl.recentItem == null ||
                            contrl.recentItem!.data!.items!.length == 0 ||
                            contrl.recentItem!.data!.items!.first.id == '')
                        ? Container(
                            alignment: Alignment.center,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  !Provider.of<AccountProvider>(context,
                                              listen: false)
                                          .isLoggedIn
                                      ? profileController.screen.value = 1
                                      : Get.to(() => TryItOnScreen());
                                },
                                child: Container(
                                  height: 50,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF2CA8A),
                                      borderRadius: BorderRadius.circular(50)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Scan products or colours",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: double.infinity,
                            // color: Colors.green,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 20,
                                        //margin: EdgeInsets.only(top: 30),
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 15,
                                        ),
                                      )),
                                  Expanded(
                                      child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        contrl.recentItem!.data!.items!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          //Get.to(() => MyShoppingHistory());
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                width: 96,
                                                child: Container(
                                                  height: 96,
                                                  width: 96,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Image.network(
                                                      APIEndPoints
                                                              .mediaBaseUrl +
                                                          "${contrl.recentItem!.data!.items![index].image}",
                                                      // recenScan[0].image!,
                                                      height: 52,
                                                      width: 33,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              contrl.recentItem!.data!
                                                  .items![index].brand!,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Color(0xff938282)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 90,
                                              child: Text(
                                                contrl.recentItem!.data!
                                                    .items![index].name!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Container(
                                              child: RatingBar.builder(
                                                initialRating: 3,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 12.0,
                                                itemPadding: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              'REVIEW',
                                              style: TextStyle(fontSize: 9),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 20,
                                      // margin: EdgeInsets.only(top: 30),
                                      // color:Colors.pink,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
              }),
              GetBuilder<MsProfileController>(builder: (contrl) {
                return (contrl.isRecentLoading)
                    ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
                    : (contrl.recentItem == null ||
                            contrl.recentItem!.data!.items!.length == 0)
                        ? Container(
                            alignment: Alignment.center,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  !Provider.of<AccountProvider>(context,
                                              listen: false)
                                          .isLoggedIn
                                      ? profileController.screen.value = 1
                                      : Get.to(() => TryItOnScreen());
                                },
                                child: Container(
                                  height: 50,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF2CA8A),
                                      borderRadius: BorderRadius.circular(50)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Scan products or colours",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 20,
                                        //margin: EdgeInsets.only(top: 30),
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 15,
                                        ),
                                      )),
                                  Expanded(
                                      child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        contrl.recentItem!.data!.items!.length,
                                    itemBuilder: (context, index) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            width: 96,
                                            child: Container(
                                              width: 96,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 96,
                                                    width: 96,
                                                    decoration: BoxDecoration(
                                                        color: HexColor(contrl
                                                            .recentItem!
                                                            .data!
                                                            .items![index]
                                                            .scanColour
                                                            .toString()),
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1.5)),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Hex' +
                                                          contrl
                                                              .recentItem!
                                                              .data!
                                                              .items![index]
                                                              .scanColour
                                                              .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 20,
                                      // margin: EdgeInsets.only(top: 30),
                                      // color:Colors.pink,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
              }),
            ],
          ),
        ),
        Container(
          height: 187,
          width: Get.width,
          decoration: BoxDecoration(
              color: Color(0x4D000000),
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/my_sofiqe_upgrade_background.png"),
                  fit: BoxFit.cover)),
          child: account.isLoggedIn
              ? Center(
                  child: Text(
                    'YOU ARE SOFIQE',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.white,
                          fontSize: size.height * 0.028,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Unlock Unlimited Sofiqe",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => PremiumSubscriptionScreen());
                      },
                      child: Container(
                        height: 50,
                        width: Get.width * 0.6,
                        decoration: BoxDecoration(
                            color: Color(0xffF2CA8A),
                            borderRadius: BorderRadius.circular(50)),
                        alignment: Alignment.center,
                        child: Text(
                          "Subscribe",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
        ),
        displayTile(
            leading: "",
            title: "Notifications",
            trailing: Switch(
                value: notification,
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.red,
                onChanged: (val) {
                  notification = val;
                  setState(() {});
                }),
            handler: () {}),
        Divider(),
        displayTile(
            leading: "",
            title: "Privacy policy",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () {
              Get.to(() => PrivacyPolicyScreen(
                    isTerm: false, isReturnPolicy: false,
                  ));
            }),
        Divider(),
        displayTile(
            leading: "",
            title: "Terms and conditions",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () {
              Get.to(() => PrivacyPolicyScreen(
                    isTerm: true, isReturnPolicy: false,
                  ));
            }),
        Divider(),
        displayTile(
            leading: "",
            title: "Return Policy",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            handler: () {
              Get.to(() => PrivacyPolicyScreen(
                isTerm: true, isReturnPolicy: true,
              ));
            }),
      ],
    ));
  }

  Widget displayTile(
      {String? leading,
      String? title,
      Widget? trailing,
      required Function handler}) {
    print("assets/images/$leading");
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListTile(
        onTap: () => handler(),
        leading: leading!.isEmpty
            ? SizedBox()
            : Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                    // color: Colors.black
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/$leading"))),
              ),
        title: Transform.translate(
          offset: Offset(-25, 0),
          child: Text(
            '$title',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}

class RecentScan {
  String? image;
  String? title;
  String? type;

  RecentScan({this.image, this.title, this.type});
}
