import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/looksController.dart';
import 'package:sofiqe/screens/MS8/looks_package_details.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/make_over_try_on.dart';

import '../../provider/cart_provider.dart';
import '../../utils/constants/route_names.dart';
import '../../widgets/png_icon.dart';
import '../../widgets/product_detail/order_notification.dart';
import '../../widgets/wishlist.dart';
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.black,
      //     elevation: 0.0,
      //     leading: InkWell(
      //         onTap: () => Get.back(),
      //         child: Icon(
      //           Icons.close,
      //           size: 30,
      //         )),
      //     centerTitle: true,
      //     title: Text(
      //       'MY SHOPPING',
      //       style: TextStyle(
      //         fontSize: 12,
      //       ),
      //     )),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.23),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          leading: Container(
            width: size.width * 0.20,
            height: size.width * 0.20,
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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'sofiqe',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: size.height * 0.035,
                    ),
              ),
              SizedBox(height: 5),
              Text(
                'LOOKS',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RouteNames.cartScreen);
              },
              child: Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(right: 20, bottom: 5),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Image.asset(
                  'assets/images/Path_6.png',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  padding: EdgeInsets.only(bottom: 15,left: 5,right: 5),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.57,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: controller.lookModel!.items!.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      child: GestureDetector(
                        onTap: (){
                          Get.to(() => LookPackageMS8(
                            image: controller
                                .lookModel!.items![i].imageUrl,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: WishListNew(
                                            sku: controller
                                                .lookModel!.items![i].sku.toString(),
                                            itemId: int.parse(controller
                                                .lookModel!.items![i].entityId.toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating:  controller.lookModel!.items![i].rating!,
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
                                              controller.lookModel!.items![i].rating =rating;
                                            });
                                            print(rating);
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              controller.lookModel!.items![i].rating.toString(),
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 10),
                                            ),
                                            SizedBox( width: 15),
                                            Text(
                                              '(${controller.lookModel!.items![i].entityId.toString()})',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                       Container(width: 50,)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${controller.lookModel!.items![i].name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
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
                                                  fontSize: 10),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "£ ${controller.lookModel!.items![i].price.toString()}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Text("price!",style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontSize: 10,),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                    color: Colors.black, fontSize: 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {

                                            await Provider.of<CartProvider>(context, listen: false).addToCart(controller.lookModel!.items![i].sku!, [], 1);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  padding: EdgeInsets.all(0),
                                                  backgroundColor: Colors.transparent,
                                                  duration: Duration(seconds: 1),
                                                  content: Container(
                                                    child: CustomSnackBar(
                                                      sku: controller.lookModel!.items![i].sku!,
                                                      image: controller.lookModel!.items![i].image.toString(),
                                                      name: controller.lookModel!.items![i].name!,
                                                    ),
                                                  ),
                                                ) );
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
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                             SizedBox(height: 15)
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
    );
  }
}
