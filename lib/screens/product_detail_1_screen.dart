// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

// 3rd party packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';

// Utils
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/utils/api/product_details_api.dart';
import 'package:sofiqe/utils/constants/route_names.dart';
import 'package:sofiqe/utils/states/function.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/product_detail/additional_details.dart';
import 'package:sofiqe/widgets/product_detail/color_selector.dart';
import 'package:sofiqe/widgets/product_detail/order_notification.dart';

// Custom packages
import 'package:sofiqe/widgets/product_detail/product_options_drop_down.dart';
import 'package:sofiqe/widgets/product_detail/static_details.dart';
import 'package:sofiqe/widgets/product_image.dart';
import 'package:sofiqe/widgets/review.dart';
import 'package:sofiqe/widgets/wishlist.dart';
import '../../provider/account_provider.dart';
import 'evaluate_screen.dart';

class ProductDetail1Screen extends StatefulWidget {
  final String sku;

  const ProductDetail1Screen({Key? key, this.sku = 'MT-45230167'})
      : super(key: key);

  @override
  _ProductDetail1ScreenState createState() => _ProductDetail1ScreenState();
}

class _ProductDetail1ScreenState extends State<ProductDetail1Screen> {
  Future<http.Response> getProductDetails() async {
    return sfAPIGetProductDetailsFromSKU(sku: '${widget.sku}');
  }

  var freeshippingData;
  List simpleProductOptions = [];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    ///todo: uncomment
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();

  }

  void setOptions(index, optionMap) {
    simpleProductOptions[index] = optionMap;
    print(simpleProductOptions);
  }

  final TryItOnProvider tiop = Get.find();
  final PageProvider pp = Get.find();

  @override
  Widget build(BuildContext context) {
    String pdt1 = 'Sofiqe';
    // String pdt6 = 'IN STOCK';
    Size size = MediaQuery.of(context).size;
    var cartItems = Provider.of<CartProvider>(context).itemCount;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Image.asset(
              "assets/icons/Path_11_1.png",
            ),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          pdt1.toLowerCase(),
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.white, fontSize: 25, letterSpacing: 2.5),
        ),
        actions: [
          Container(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height * 1.3,
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
      body: FutureBuilder(
        future: getProductDetails(),
        builder: (BuildContext _, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            Map<String, dynamic> responseBody = json.decode(snapshot.data.body);

            Product product = Product.fromDefaultMap(responseBody);

            // String shortDescription = (responseBody['custom_attributes'][18]['value'] as String).replaceAll(RegExp(r'<p>|</p>'), '');
            String description = '';
            if (responseBody['custom_attributes'] != null) {
              (responseBody['custom_attributes'] as List).forEach((customAttr) {
                if (customAttr['attribute_code'] == 'description') {
                  description = (customAttr['value'] as String);
                }
              });
            }
            if (responseBody['custom_attributes'] != null) {
              if (description.isEmpty) {
                (responseBody['custom_attributes'] as List)
                    .forEach((customAttr) {
                  if (customAttr['attribute_code'] == 'short_description') {
                    description = (customAttr['value'] as String);
                  }
                });
              }
            }
            List options = [];
            var type;
            if (responseBody['type_id'] == 'configurable') {
              options = responseBody['extension_attributes']
              ['configurable_product_options'];
              type = 0;
            } else {
              options = responseBody['options'];
              type = 1;
            }
            if (options.length != 0) {
              options.forEach((item) {
                if (item['title'] == 'Color') {
                  if ((item['values'][0]['title'] as String).startsWith('#')) {
                    item['type'] = 'dot_selector';
                  }
                }
                if (item['option_type_id'] == null &&
                    item['values'] != null &&
                    item['values'] is List &&
                    (item['values'] as List).isNotEmpty) {
                  var tempList = item['values'] as List;
                  item['option_type_id'] = "${tempList[0]['option_type_id']}";
                }
              });
            }

            simpleProductOptions = List.generate(options.length, (index) => {});
            int index = 0;
            int colorIndex = 0;
            int qty = responseBody['extension_attributes']['stock_item']['qty'];

            return Column(
              children: [
                Container(
                  height: 17,
                  color: Color(0xffEB7AC1),
                  alignment: Alignment.center,
                  child: Text(
                    Provider.of<CartProvider>(context).itemCount == 0 ? 'Free shipping above €'+Provider.of<AccountProvider>(context, listen: false).freeShippingAmount : 'Add € XXX to your cart to get free shipping',
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.navigationBarSelectedColor,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: size.height * 0.01,
                              //       horizontal: size.width * 0.03),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       WishList(
                              //           sku: responseBody['sku'],
                              //           itemId: responseBody['id']),
                              //       Text(
                              //         'WISHLIST',
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headline2!
                              //             .copyWith(
                              //               color: Colors.white,
                              //               fontSize: size.height * 0.01,
                              //             ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Center(
                                  child: ProductImage(
                                    imageShortPath: '${product.image}',
                                    width: size.width * 0.4,
                                    height: size.width * 0.4,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  // child: ColorSelector(), // here is color selector
                                  child: Column(
                                    children: [
                                      ...options.map(
                                            (items) {
                                          int localIndex = colorIndex++;
                                          if (items['type'] == 'dot_selector') {
                                            return ColorSelector(
                                              // Here is options
                                              type: type,
                                              optionMap: items,
                                              options: (optionMap) {
                                                setOptions(
                                                    localIndex, optionMap);
                                                items['option_type_id'] =
                                                optionMap['optionValue'];
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ).toList()
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(
                                    //     ".",
                                    //     style: TextStyle(),
                                    //   ),
                                    // ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.15),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${responseBody['name'].toString().toUpperCase()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                          SplashScreenPageColors.textColor,
                                          fontFamily: 'Arial_regular',
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    //  //TODO:
                                    //  Add review icon
                                    // Review(sku: responseBody['sku']),
                                  ],
                                ),
                              ),

                              Row(
                                children: [

                                  GestureDetector(
                                    onTap: () {
                                      print("tap");
                                      Get.to(() => EvaluateScreen(product.image, product.sku, product.name));
                                    },
                                    child: Container(
                                      height: size.height * 0.03,
                                      width: size.width * 0.67,
                                      alignment: Alignment.centerRight,

                                      child:
                                      RatingBarIndicator(
                                        rating: double.parse(
                                            responseBody['extension_attributes']
                                            ['avgrating']),
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Color(0xffF2CA8A),
                                        ),
                                        unratedColor: Colors.white,

                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: size.width * 0.21,
                                    // margin: EdgeInsets.only(
                                    //     left: size.width * 0.06),
                                    padding: EdgeInsets.fromLTRB(
                                        size.width * .14, 14, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        WishListNew(
                                            sku: responseBody['sku'],
                                            itemId: responseBody['id']),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width * 0.12,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 10,
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            )),
                                        SizedBox(
                                          child: IconButton(
                                              onPressed: () {
                                                var product_url = responseBody[
                                                'extension_attributes']
                                                ['product_url'];
                                                Share.share(product_url);
                                              },
                                              icon: Icon(
                                                Icons.share_outlined,
                                                color: Color(0xffD0C5C5),
                                                size: size.width * 0.06,
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.05),
                                      child: Text(
                                        // '€ ${(responseBody['price'] as num).toStringAsFixed(2)}',
                                        '${(responseBody['price'] as num).toDouble().toProperCurrencyString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                          color: SplashScreenPageColors
                                              .textColor,
                                          fontSize: size.height * 0.021,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.height * 0.01),
                                      child: Row(
                                        children: [
                                          Text(
                                            "   Earn ${responseBody['extension_attributes']['reward_points']} ",
                                            style: TextStyle(
                                                color: Color(0xff12C171),
                                                fontSize: 10),
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Colors.yellow, // change here
                                            size: size.height * 0.011,
                                          ),
                                          Text(
                                            " VIP points",
                                            style: TextStyle(
                                                color: Color(0xff12C171),
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            right: size.width * 0.04),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Icon(
                                                Icons.circle,
                                                color: qty > 0
                                                    ? AppColors.primaryColor
                                                    : Colors.red, // change here
                                                size: 5,
                                              ),
                                            ),
                                            Text(
                                              qty > 0
                                                  ? 'IN STOCK'
                                                  : 'OUT OF STOCK',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                fontSize: 10,
                                                color:
                                                SplashScreenPageColors
                                                    .textColor,
                                                fontFamily:
                                                'Arial, Regular',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        top: size.height * 0.03),
                                    child: Text(
                                      "or 4 interest-freeinstalment ",
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI, Regular',
                                          color: Colors.white,
                                          fontSize: size.height * 0.021),
                                    ),
                                  ),

                                ],
                              ),

                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        top: size.width * 0.01),

                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "of € ${((responseBody['price'] as num)/4).toDouble()} with",
                                      style: TextStyle(
                                          fontFamily: 'Arial, Regular',
                                          color: Colors.white,
                                          fontSize: size.height * 0.019),
                                    ),
                                  ),

                                  Expanded(flex: 1,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.only(top: size.height*0.005),
                                        margin: const EdgeInsets.only(left: 5, right: 5),
                                        alignment: Alignment.centerLeft,
                                        // width: size.width * .50,
                                        // color: Colors.white,
                                        child: Image(
                                          image: AssetImage(
                                            "assets/images/clearpay3.png",
                                          ),
                                          width: 90,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 3,
                                    child: Container(
                                      width: size.width * .01,
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: size.height * 0.017,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(20.0),
                              //   child: Container(
                              //     child: Text(
                              //       '$description',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontFamily: 'Arial, Regular',
                              //         fontSize: 14.0,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  height: 0,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              ...options.map(
                                    (items) {
                                  int localIndex = index++;
                                  if (items['type'] == 'dot_selector') {
                                    return Container();
                                  }
                                  return ProductOptionsDropDown(
                                    // Here is options
                                    type: type,
                                    optionMap: items,
                                    options: (optionMap) {
                                      setOptions(localIndex, optionMap);
                                      items['option_type_id'] =
                                      optionMap['optionValue'];
                                    },
                                  );
                                },
                              ).toList(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 10),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Container(
                                          child: Text(
                                            '$description',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Arial, Regular',
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Padding(
                                      //         padding: const EdgeInsets.all(0),
                                      //         child: Text(
                                      //           // '€ ${(responseBody['price'] as num).toStringAsFixed(2)}',
                                      //           '${(responseBody['price'] as num).toDouble().toProperCurrencyString()}',
                                      //           style: Theme.of(context)
                                      //               .textTheme
                                      //               .headline2!
                                      //               .copyWith(
                                      //                 color:
                                      //                     SplashScreenPageColors
                                      //                         .textColor,
                                      //                 fontSize: 16.0,
                                      //               ),
                                      //         ),
                                      //       ),
                                      //       Padding(
                                      //         padding:
                                      //             const EdgeInsets.all(0.0),
                                      //         child: Row(
                                      //           children: [
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       right: 8.0),
                                      //               child: Icon(
                                      //                 Icons.circle,
                                      //                 color: qty > 0
                                      //                     ? AppColors
                                      //                         .primaryColor
                                      //                     : Colors
                                      //                         .red, // change here
                                      //                 size: 5,
                                      //               ),
                                      //             ),
                                      //             Text(
                                      //               qty > 0
                                      //                   ? 'IN STOCK'
                                      //                   : 'OUT OF STOCK',
                                      //               style: Theme.of(context)
                                      //                   .textTheme
                                      //                   .headline2!
                                      //                   .copyWith(
                                      //                     fontSize: 10,
                                      //                     color:
                                      //                         SplashScreenPageColors
                                      //                             .textColor,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Divider(
                                  height: 0,
                                  color: AppColors.secondaryColor,
                                ),
                              ),

                              AdditionalOptions(
                                  details: responseBody['custom_attributes']),
                              // Add addional options here

                              FutureBuilder(
                                future: sfAPIGetProductStatic(),
                                builder: (BuildContext _, snapshot) {
                                  if (snapshot.hasData) {
                                    return StaticDetails(
                                        data: json
                                            .decode(snapshot.data as String));
                                  } else {
                                    return Container(
                                      height: size.height,
                                      color: Colors.black,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 155,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              primary: AppColors.primaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                            tiop.received.value = product;
                            tiop.page.value = 2;
                            tiop.directProduct.value = true;
                            pp.goToPage(Pages.TRYITON);
                          },
                          child: Text(
                            'TRY ON',
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Arial, Regular',
                                color: AppColors.navigationBarSelectedColor),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 155,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              primary: SplashScreenPageColors.textColor),
                          onPressed: () async {
                            // try {
                            if (qty == 0) {
                              Get.showSnackbar(
                                GetBar(
                                  message: 'The product is out of stock',
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }

                            if (options.isNotEmpty) {
                              options.forEach((po) {
                                if (po['is_required'] == true &&
                                    po['option_type_id'] == null) {
                                  Get.showSnackbar(
                                    GetBar(
                                      message: 'Select ${po['title']} first!!',
                                      duration: Duration(seconds: 2),
                                      isDismissible: true,
                                    ),
                                  );
                                  return;
                                }
                              });

                              List<Map> selectedOptions = [];
                              options.forEach((element) {
                                selectedOptions.add(
                                  {
                                    "option_id": "${element['option_id']}",
                                    "option_value": element['option_type_id'],
                                  },
                                );
                              });

                              await Provider.of<CartProvider>(context,
                                  listen: false)
                                  .addToCart(context, responseBody['sku'], selectedOptions, 1);
                              qty--;
                              setState(() {});
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                padding: EdgeInsets.all(0),
                                backgroundColor: AppColors.transparent,
                                duration: Duration(seconds: 1),
                                content: Container(
                                  child: CustomSnackBar(
                                      sku: responseBody['sku'],
                                      image: '${product.image}',
                                      name: responseBody['name']
                                          .toString()
                                          .toUpperCase()),
                                ),
                              ));
                            } else {
                              await Provider.of<CartProvider>(context,
                                  listen: false)
                                  .addToCart(context, responseBody['sku'], [], responseBody['type_id'] == 'simple' ? 0 : 1);
                              qty--;
                              setState(() {});
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                padding: EdgeInsets.all(0),
                                backgroundColor: AppColors.transparent,
                                duration: Duration(seconds: 1),
                                content: Container(
                                  child: CustomSnackBar(
                                      sku: responseBody['sku'],
                                      image: '${product.image}',
                                      name: responseBody['name']
                                          .toString()
                                          .toUpperCase()),
                                ),
                              ));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/Path_6.png",
                              ),
                              Text(
                                'ADD TO BAG',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Arial, Regular',
                                    color:
                                    AppColors.navigationBarSelectedColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
