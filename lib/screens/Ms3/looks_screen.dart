import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sofiqe/controller/looksController.dart';
import 'package:sofiqe/screens/MS8/looks_package_details.dart';
import 'package:sofiqe/screens/evaluate_screen.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/make_over_try_on.dart';

import '../../provider/account_provider.dart';
import '../../provider/cart_provider.dart';
import '../../utils/constants/route_names.dart';
import '../../widgets/png_icon.dart';
import '../../widgets/product_detail/order_notification.dart';
import '../../widgets/wishlist.dart';
import '../my_sofiqe.dart';
import '../premium_subscription_screen.dart';

class LooksScreen extends StatefulWidget {
  const LooksScreen({Key? key}) : super(key: key);

  @override
  _LooksScreenState createState() => _LooksScreenState();
}

class _LooksScreenState extends State<LooksScreen> {
  LooksController looksController = Get.put(LooksController());
  bool isLoading = false;

  @override
  void initState() {
    looksController.getLookList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context).itemCount;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: Container(
          // width: size.width * 0.20,
          // height: size.width * 0.20,
          //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: BackButtonApp(
            flowFromMs: false,
            child: Transform.rotate(
              angle: 3.1439,
              child: PngIcon(
                color: Colors.white,
                image: 'assets/icons/arrow-2-white.png',
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'sofiqe',
          style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.white,
              fontSize: size.height * 0.035,
              letterSpacing: 0.6),
        ),
        actions: [
          Container(
            // height: AppBar().preferredSize.height,
            // width: AppBar().preferredSize.height * 1,
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
                      cartItems == 0
                          ? SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              padding: EdgeInsets.all(5),
                              child: Text(cartItems.toString()))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.black,
              width: Get.width,
              child: Center(
                child: Text(
                  'LOOKS',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        color: HexColor("#EB7AC1"),
                        height: 25,
                        width: size.width,
                        child: Center(
                            child: Text(
                          Provider.of<CartProvider>(context).itemCount == 0
                              ? 'Free shipping above €' +
                                  Provider.of<AccountProvider>(context, listen: false)
                                      .freeShippingAmount
                              : 'Add €'+ (double.parse(Provider.of<AccountProvider>(context, listen: false)
                              .freeShippingAmount) - double.parse(Provider.of<CartProvider>(context).chargesList[0]['amount'].toString())).toString()+' to your cart to get free shipping',
                          style: TextStyle(fontSize: 12),
                        ))),
                    GetBuilder<LooksController>(builder: (controller) {
                      if (controller.isLookLoading) {
                        return Container(
                            height: Get.height,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                      }
                      if (controller.lookModel == null) {
                        return Container();
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 15, left: 5, right: 5),
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.57,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 5),
                        itemCount: controller.lookModel!.items!.length,
                        itemBuilder: (ctx, i) {
                          return Card(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => LookPackageMS8(
                                      image: controller.lookModel!.items![i].imageUrl,
                                  look: controller.lookModel!.items![i].name,
                                    ));
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(controller
                                                  .lookModel!.items![i].imageUrl
                                                  .toString()),
                                              fit: BoxFit.cover)),
                                      child: Column(
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                WishListNew(
                                                  sku: controller
                                                      .lookModel!.items![i].sku
                                                      .toString(),
                                                  itemId: int.parse(controller
                                                      .lookModel!.items![i].entityId
                                                      .toString()),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Share.share(
                                                          controller.lookModel!
                                                              .items![i].productUrl
                                                              .toString(),
                                                          subject: controller
                                                              .lookModel!
                                                              .items![i]
                                                              .name
                                                              .toString());
                                                    },
                                                    child: Icon(Icons.share,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => EvaluateScreen(controller
                                                  .lookModel!.items![i].imageUrl
                                                  .toString(), controller
                                                  .lookModel!.items![i].sku, controller
                                                  .lookModel!.items![i].name));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RatingBar.builder(
                                                  ignoreGestures: true,
                                                  itemSize: 15,
                                                  initialRating: double.parse(
                                                      controller.lookModel!.items![i]
                                                          .avgrating!),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 4,
                                                  itemPadding: EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      controller.lookModel!.items![i]
                                                              .avgrating =
                                                          rating.toString();
                                                    });
                                                    print(rating);
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  controller
                                                      .lookModel!.items![i].avgrating
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '(${controller.lookModel!.items![i].entityId.toString()})',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${controller.lookModel!.items![i].name}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "${controller.lookModel!.items![i].description}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "€ ${controller.lookModel!.items![i].price!.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              // Text("price!",style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontSize: 10,),),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => MakeOverTryOn());
                                                },
                                                child: CircleAvatar(
                                                  radius: 27,
                                                  backgroundColor: Color(0xffF2CA8A),
                                                  child: Center(
                                                    child: Text(
                                                      "TRY ON",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    !Provider.of<AccountProvider>(
                                                                context,
                                                                listen: false)
                                                            .isLoggedIn
                                                        ? false
                                                        : true,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .addToCart(
                                                            context,
                                                            controller.lookModel!
                                                                .items![i].sku!,
                                                            [],
                                                            1);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                      padding: EdgeInsets.all(0),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      duration: Duration(seconds: 1),
                                                      content: Container(
                                                        child: CustomSnackBar(
                                                          sku: controller.lookModel!
                                                              .items![i].sku!,
                                                          image: controller.lookModel!
                                                              .items![i].image
                                                              .toString(),
                                                          name: controller.lookModel!
                                                              .items![i].name!,
                                                        ),
                                                      ),
                                                    ));
                                                    // Get.showSnackbar(GetBar(
                                                    //   message:
                                                    //       'This Section is in under-development',
                                                    //   duration: Duration(seconds: 1),
                                                    // ));
                                                    // Navigator.pushNamed(context, RouteNames.cartScreen);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor: Colors.black,
                                                    child: Center(
                                                      child: Image.asset(
                                                        'assets/images/Path_6.png',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 15)
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
