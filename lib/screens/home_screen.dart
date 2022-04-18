import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/msProfileController.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/catalog_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/total_make_over_provider.dart';
import 'package:sofiqe/utils/constants/route_names.dart';
import 'package:sofiqe/widgets/home/home_page.dart';

// Custom packages
import 'package:sofiqe/widgets/png_icon.dart';

import '../provider/cart_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageProvider pp = Get.find();
  final CatalogProvider catp = Get.find();
  MsProfileController profileController = Get.put(MsProfileController());
  TotalMakeOverProvider tm = Get.put(TotalMakeOverProvider());


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    profileController.getUserQuestionsInformations();
    var cartItems = Provider.of<CartProvider>(context).itemCount;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                pp.goToPage(Pages.SHOP);
                catp.unhideSeachBar();
                print(Provider.of<AccountProvider>(context, listen: false)
                    .userToken);
              },
              child: Container(
                height: AppBar().preferredSize.height * 0.7,
                width: AppBar().preferredSize.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppBar().preferredSize.height * 0.7)),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: PngIcon(
                  image: 'assets/icons/search_white.png',
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'sofiqe',
          style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.white,
              fontSize: size.height * 0.035,
              letterSpacing: 0.6),
        ),
        actions: [
          Container(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height * 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.cartScreen);
                },
                child: Container(
                  height: AppBar().preferredSize.height * 0.7,
                  width: AppBar().preferredSize.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppBar().preferredSize.height * 0.7)),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      PngIcon(
                        image: 'assets/images/Path_6.png',
                      ),
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
              ),
            ),
          ),
        ],
      ),
      body: HomePage(),
    );
  }
}
