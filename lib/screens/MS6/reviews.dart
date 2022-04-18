import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/reviewController.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/wishlist_provider.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/widgets/cart/empty_bag.dart';

import '../../provider/cart_provider.dart';
import '../../utils/constants/route_names.dart';
import '../../widgets/product_detail/order_notification.dart';
import '../product_detail_1_screen.dart';
import 'package:sofiqe/model/product_model.dart' as product;

class ReviewsMS6 extends StatefulWidget {
  const ReviewsMS6({Key? key}) : super(key: key);

  @override
  _ReviewsMS6State createState() => _ReviewsMS6State();
}

class _ReviewsMS6State extends State<ReviewsMS6> {
  PageProvider pp = Get.find();
  int selectedReview = 0;

  changeReview(int i) {
    setState(() {
      selectedReview = i;
    });
  }

  ReviewController reviewController = Get.put(ReviewController());
  final WishListProvider wp = Get.find();

  @override
  void initState() {
    reviewController.getMyRiviewsData();
    reviewController.getGloableReviews();
    reviewController.getWishListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context).itemCount;
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => SafeArea(
                child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: Get.height * 0.15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/myReviews.png',
                              ),
                              fit: BoxFit.cover)),
                      child: Stack(
                        alignment: Alignment.center,
                      //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  "sofiqe",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize:
                                            AppBar().preferredSize.height * 0.5,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteNames.cartScreen);
                              },
                              child: Stack( alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    width: Get.width * 0.10,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/Path_6.png",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
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
                          )

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              changeReview(0);
                            },
                            child: IntrinsicWidth(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "MY REVIEWS",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  selectedReview == 0
                                      ? Container(
                                          // width: 65.w,
                                          height: 2,
                                          color: Color(0xffF2CA8A),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              changeReview(1);
                            },
                            child: IntrinsicWidth(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SOFIQE REVIEWS",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  selectedReview == 1
                                      ? Container(
                                          //  width: 85.w,
                                          height: 2,
                                          color: Color(0xffF2CA8A),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              changeReview(2);
                            },
                            child: IntrinsicWidth(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "WISHLIST",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  selectedReview == 2
                                      ? Container(
                                          // width: 50.w,
                                          height: 2,
                                          color: Color(0xffF2CA8A),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    selectedReview == 2
                        ? GetBuilder<ReviewController>(builder: (wshCntrl) {
                            return wshCntrl.isWishListLoading
                                ? Container(
                                    height: Get.height * 0.5,
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )
                                :wshCntrl.wishlistModel != null || wshCntrl.wishlistModel!.result!.length > 0
                                    ? Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: Get.width * 0.10,
                                            color: Color(0xffF4F2F0),
                                            child: Center(
                                              child: Text(
                                                'YOU ARE SAVVY! ${wshCntrl.wishlistModel!.result!.length} DIFFERENT MAKEUPS',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount: wshCntrl
                                                .wishlistModel!.result!.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (ctx, i) {
                                              try {
                                                wshCntrl.wishlistModel!
                                                    .result![i].review!
                                                    .forEach((element) {
                                                });
                                              } catch (e) {
                                              }
                                              return Container(
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      height: 88,
                                                      width: double.infinity,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              // width: Get.width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "${wshCntrl.wishlistModel!.result![i].product!.name}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  // Row(
                                                                  //   children: [
                                                                  //     Icon(
                                                                  //       Icons
                                                                  //           .star,
                                                                  //       color: Color(
                                                                  //           0xffF2CA8A),
                                                                  //     ),
                                                                  //     SizedBox(
                                                                  //       width:
                                                                  //           5,
                                                                  //     ),
                                                                  //     Text(rate
                                                                  //         .toString())
                                                                  //   ],
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .translucent,
                                                            onTap: () async {
                                                              print(
                                                                  "USER MISSING??");
                                                              try {
                                                                if (Provider.of<
                                                                            AccountProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .isLoggedIn) {
                                                                  if (await wp.removeItemToWishList(
                                                                      wshCntrl
                                                                          .wishlistModel!
                                                                          .result![
                                                                              i]
                                                                          .product!
                                                                          .sku!
                                                                      )) {
                                                                    wshCntrl.wishlistModel!.result!.removeWhere((element) =>
                                                                        element
                                                                            .wishlistItemId ==
                                                                        wshCntrl
                                                                            .wishlistModel!
                                                                            .result![i]
                                                                            .wishlistItemId!);
                                                                    await reviewController
                                                                        .getWishListData();
                                                                  } else {
                                                                    print(
                                                                        "UPDATE FAILED");
                                                                  }
                                                                } else {
                                                                  print(
                                                                      "USER MISSING");
                                                                }
                                                              } on Exception catch (e) {
                                                                print(e
                                                                    .toString());
                                                              }
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                width:
                                                                    Get.width *
                                                                        0.020,
                                                                // color: Colors.orange,
                                                                child: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          c) {
                                                                    return ProductDetail1Screen(
                                                                        sku: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![i]
                                                                            .product!
                                                                            .sku!);
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                                width:
                                                                    Get.width *
                                                                        0.18,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                // color: Colors.green,
                                                                child: Image
                                                                    .network(
                                                                  // 'assets/images/product.png',
                                                                  APIEndPoints
                                                                          .mediaBaseUrl +
                                                                      "${wshCntrl.wishlistModel!.result![i].product!.image}",
                                                                  width: 72,
                                                                  height: 72,
                                                                )),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (wshCntrl
                                                                          .wishlistModel!
                                                                          .result![
                                                                              i]
                                                                          .product!
                                                                          .options !=
                                                                      null &&
                                                                  wshCntrl
                                                                      .wishlistModel!
                                                                      .result![
                                                                          i]
                                                                      .product!
                                                                      .options!
                                                                      .isNotEmpty) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (BuildContext
                                                                            c) {
                                                                      return ProductDetail1Screen(
                                                                          sku: wshCntrl
                                                                              .wishlistModel!
                                                                              .result![i]
                                                                              .product!
                                                                              .sku!);
                                                                    },
                                                                  ),
                                                                );
                                                              } else {
                                                                CartProvider
                                                                    cartP =
                                                                    Provider.of<
                                                                            CartProvider>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                //   print("CartProvider  -->> SSs ${cartP.cartToken}");
                                                                await cartP.addHomeProductsToCart(product
                                                                    .Product(
                                                                        name: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![
                                                                                i]
                                                                            .product!
                                                                            .name,
                                                                        id: int
                                                                            .parse(
                                                                          wshCntrl
                                                                              .wishlistModel!
                                                                              .result![i]
                                                                              .productId
                                                                              .toString(),
                                                                        ),
                                                                        image: wshCntrl.wishlistModel!.result![i].product!.image
                                                                            .toString(),
                                                                        price: double.parse(wshCntrl
                                                                            .wishlistModel!
                                                                            .result![
                                                                                i]
                                                                            .product!
                                                                            .price
                                                                            .toString()),
                                                                        sku: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![i]
                                                                            .product!
                                                                            .sku
                                                                            .toString(),
                                                                        color: wshCntrl.wishlistModel!.result![i].product!.shadeColor.toString(),
                                                                        description: wshCntrl.wishlistModel!.result![i].product!.shortDescription.toString(),
                                                                        faceSubArea: 0,avgRating: "0.0"));
                                                                print(
                                                                    "Name  -->> EEE ${wshCntrl.wishlistModel!.result![i].product!.image}");

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    content:
                                                                        Container(
                                                                      child:
                                                                          CustomSnackBar(
                                                                        sku: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![i]
                                                                            .product!
                                                                            .sku!,
                                                                        image: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![
                                                                                i]
                                                                            .product!
                                                                            .image!
                                                                            .replaceAll(RegExp('https://dev.sofiqe.com/media/catalog/product'),
                                                                                ''),
                                                                        name: wshCntrl
                                                                            .wishlistModel!
                                                                            .result![i]
                                                                            .product!
                                                                            .name!,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              // reviewController
                                                              //     .productAddtoBag(wshCntrl
                                                              //         .wishlistModel!
                                                              //         .result![i].product.shadeColor,wshCntrl
                                                              //         .wishlistModel!
                                                              //         .result![i].productId,wshCntrl
                                                              //         .wishlistModel!
                                                              //         .result![i].product.price.toString());
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              width: Get.width *
                                                                  0.16,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 28,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                child: Center(
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/Path_6.png",
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : CustomEmptyBagPage(
                                        title:
                                            'Oops we cannot find what your wish list is',
                                        ontap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        emptyBagButtonText: 'Go TO SHOPPING',
                                      );
                          })
                        : (selectedReview == 0)
                            ? GetBuilder<ReviewController>(
                                builder: (revContrl) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: (reviewController.isReviewLoading)
                                        ? Container(
                                            height: Get.height * 0.5,
                                            width: Get.width,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ))
                                        : reviewController.myReviewModel!.items!
                                                    .length >
                                                0
                                            ? Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: Get.width * 0.10,
                                                    color: Color(0xffF4F2F0),
                                                    child: Center(
                                                      child: Text(
                                                        'YOU ARE SAVVY! ${reviewController.myReviewModel!.items!.length} DIFFERENT MAKEUPS',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      itemCount:
                                                          reviewController
                                                              .myReviewModel!
                                                              .items!
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (ctx, ii) {
                                                        int rate = 0;
                                                        try {
                                                          reviewController
                                                              .myReviewModel!
                                                              .items![ii]
                                                              .ratings!
                                                              .forEach(
                                                                  (element) {
                                                            rate +=
                                                                element.value!;
                                                          });
                                                        } catch (e) {
                                                          rate = 0;
                                                        }
                                                        // reviewController.getMyRiviewsBySkuData(reviewController
                                                        //     .myReviewModel!
                                                        //     .items![ii].sku.toString()).then((value) {
                                                        //     if(value != false){
                                                        //       print('getMyRiviewsBySkuData lllllll ${reviewController.myReviewBySkuModel!.name.toString()}');
                                                        //     }
                                                        //   });

                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 88,
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Container(
                                                                      width: Get
                                                                              .width *
                                                                          0.4,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                reviewController.reviewName.isNotEmpty && reviewController.reviewName.length>ii  ?"${reviewController.reviewName[ii].toString()}": ''  ,
                                                                                // "${reviewController.myReviewModel!.items![ii].title}",
                                                                                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                                                                              )),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Color(0xffF2CA8A),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(rate.toString())
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (BuildContext c) {
                                                                              return ProductDetail1Screen(sku: reviewController.myReviewModel!.items![ii].storeId!.toString());
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                          width: Get.width * 0.3,
                                                                          child: reviewController.reviewImage.isNotEmpty&& reviewController.reviewImage.length>ii?Image.network(
                                                                            // 'assets/images/product.png',
                                                                            APIEndPoints.mediaBaseUrl +
                                                                                "${reviewController.reviewImage[ii]}",
                                                                            width:
                                                                            72,
                                                                            height:
                                                                            72,
                                                                          ):Container() )
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await Provider.of<CartProvider>(context, listen: false).addToCart(
                                                                            reviewController.myReviewModel!.items![ii].sku!,
                                                                            [],
                                                                            1);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          padding:
                                                                              EdgeInsets.all(0),
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          duration:
                                                                              Duration(seconds: 1),
                                                                          content:
                                                                              Container(
                                                                            child:
                                                                                CustomSnackBar(
                                                                              sku: reviewController.myReviewModel!.items![ii].sku!,
                                                                              image: reviewController.myReviewModel!.items![ii].image.toString(),
                                                                              name: reviewController.myReviewModel!.items![ii].nickname!,
                                                                            ),
                                                                          ),
                                                                        ));
                                                                        // reviewController.productAddtoBag("NA",reviewController.myReviewModel!.items![ii].);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: Get.width *
                                                                            0.2,
                                                                        //  color: Colors.red,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              30,
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/Path_6.png",
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              )
                                            : CustomEmptyBagPage(
                                                title:
                                                    'Oops we are missing your reviews',
                                                // title: 'Oops You have no reviews yet,\nwant to go to shopping? ',
                                                ontap: () async {
                                                  //      profileController.screen.value = 0;
                                                  Get.back();
                                                  pp.goToPage(Pages.SHOP);
                                                },
                                                emptyBagButtonText:
                                                    'Go TO SHOPPING',
                                              ));
                              })
                            : GetBuilder<ReviewController>(
                                builder: (revContrl) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: (reviewController.isGlobaleReviews)
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : reviewController.reviewModel!.items!
                                                    .length >
                                                0
                                            ? Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height:
                                                            Get.width * 0.10,
                                                        color:
                                                            Color(0xffF4F2F0),
                                                        child: Center(
                                                          child: Text(
                                                            'YOU ARE SAVVY! ${reviewController.reviewModel!.items!.length} DIFFERENT MAKEUPS',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                          itemCount:
                                                              reviewController
                                                                  .reviewModel!
                                                                  .items!
                                                                  .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (ctx, ii) {
                                                            int rate = 0;
                                                            try {
                                                              reviewController
                                                                  .reviewModel!
                                                                  .items![ii]
                                                                  .ratings!
                                                                  .forEach(
                                                                      (element) {
                                                                rate += element
                                                                    .value!;
                                                              });
                                                            } catch (e) {
                                                              rate = 0;
                                                            }
                                                            return Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 88,
                                                                    width: double
                                                                        .infinity,
                                                                    child: Row(
                                                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              Get.width * 0.4,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    reviewController.reviewGlobaleName.isNotEmpty && reviewController.reviewGlobaleName.length>ii  ?  "${reviewController.reviewGlobaleName[ii]}":"",
                                                                                   // "${reviewController.reviewModel!.items![ii].title}",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                                                                  )),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.star,
                                                                                    color: Color(0xffF2CA8A),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(rate.toString())
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (BuildContext c) {
                                                                                  return ProductDetail1Screen(sku: reviewController.reviewModel!.items![ii].storeId.toString());
                                                                                },
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              width: Get.width * 0.3,
                                                                              child: reviewController.reviewGlobaleImage.isEmpty&& reviewController.reviewGlobaleImage.length>ii?Image.network(
                                                                                // 'assets/images/product.png',
                                                                                APIEndPoints.mediaBaseUrl + "${reviewController.reviewGlobaleImage[ii]}",
                                                                                width: 72,
                                                                                height: 72,
                                                                              ):Container() ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            await Provider.of<CartProvider>(context, listen: false).addToCart(
                                                                                reviewController.reviewModel!.items![ii].sku!,
                                                                                [],
                                                                                1);
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              padding: EdgeInsets.all(0),
                                                                              backgroundColor: Colors.transparent,
                                                                              duration: Duration(seconds: 1),
                                                                              content: Container(
                                                                                child: CustomSnackBar(
                                                                                  sku: reviewController.reviewModel!.items![ii].sku!,
                                                                                  image: reviewController.reviewModel!.items![ii].image.toString(),
                                                                                  name: reviewController.reviewModel!.items![ii].nickname!,
                                                                                ),
                                                                              ),
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                Get.width * 0.2,
                                                                            //  color: Colors.red,
                                                                            child:
                                                                                CircleAvatar(
                                                                              radius: 30,
                                                                              backgroundColor: Colors.black,
                                                                              child: Center(
                                                                                child: Image.asset(
                                                                                  "assets/images/Path_6.png",
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                ],
                                                              ),
                                                            );

                                                            // return ListView.builder(
                                                            //   itemCount:
                                                            //       reviewController
                                                            //           .reviewModel!
                                                            //           .items![ii]
                                                            //           .ratings!
                                                            //           .length,
                                                            //   shrinkWrap: true,
                                                            //   physics:
                                                            //       NeverScrollableScrollPhysics(),
                                                            //   itemBuilder: (ctx, i) {

                                                            //   },
                                                            // );
                                                          }),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : CustomEmptyBagPage(
                                                title:
                                                    'Oops You have no reviews yet,\nwant to go to shopping? ',
                                                ontap: () async {
                                                  //      profileController.screen.value = 0;
                                                  Get.back();
                                                  pp.goToPage(Pages.SHOP);
                                                },
                                                emptyBagButtonText:
                                                    'Go TO SHOPPING',
                                              ) /*Container(
                                                child: Center(
                                                  child: Text(
                                                      'Oops! INo Reviews Yet '),
                                                ),
                                              )*/

                                    //  CustomEmptyBagPage(
                                    //     title:
                                    //         'Hey! You have no reviews yet',
                                    //     ontap: () async {
                                    //       await Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder:
                                    //               (BuildContext _) {
                                    //             return MakeOverLoginPrompt();
                                    //           },
                                    //         ),
                                    //       );
                                    //     },
                                    //     emptyBagButtonText:
                                    //         'JOIN SOFIQE FOR FREE',

                                    //   )

                                    );
                              })
                  ],
                ),
              ),
            )));
  }
}
