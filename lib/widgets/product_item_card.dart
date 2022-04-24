import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/model/response.model.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:sofiqe/screens/product_detail_1_screen.dart';
import 'package:sofiqe/utils/states/function.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/product_detail/order_notification.dart';
import 'package:sofiqe/widgets/product_image.dart';
import 'package:sofiqe/widgets/wishlist.dart';
import 'package:sofiqe/widgets/round_button.dart';
import '../../provider/account_provider.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  ProductItemCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final PageProvider pp = Get.find();
  final TryItOnProvider tiop = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext c) {
              return ProductDetail1Screen(sku: product.sku!);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width * .02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WishList(
                    sku: product.sku!,
                    itemId: product.id!,
                  ),
                  IconButton(
                      onPressed: () {
                        var producturl=product.product_url;
                        Share.share(producturl);
                      },
                      icon: Icon(
                        Icons.share_outlined,
                        color: Color(0xffD0C5C5),
                        size: size.height * 0.027,
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              child: ProductImage(
                imageShortPath: product.image,
                width: size.width * 0.2,
                height: size.height * 0.1,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              height: size.height * 0.046,
              child: Text(
                '${product.name}', 
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.black,
                      fontSize: size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Row(
              children: [
                Container(
                 // height: size.height * 0.01,
                 // width: size.width * 0.23,
                  padding: const EdgeInsets.only(left: 30,top: 0,right: 0,bottom: 0),
                  alignment: Alignment.bottomRight,
                  child:
                    RatingBarIndicator(
                      rating: 3,
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                    //  itemPadding: 0,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color(0xffF2CA8A),
                      ),
                      unratedColor: Colors.white,

                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: 0,top: 5,bottom: 0),
                  width: size.width * .15,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${product.avgRating}  (${product.review_count})",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.discountedPrice != null ? product.discountedPrice!.toProperCurrencyString() : product.price!.toProperCurrencyString()}',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.black,
                          fontSize: size.height * 0.015,
                        ),
                  ),
                  Text(
                    '${product.discountedPrice != null ? '€ ${product.price}' : ''}',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.red,
                          fontSize: size.height * 0.015,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),
            ),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: size.width * 0.025 ),
               child: Row(
                children: [
                  Text(
                    "   Earn ${product.reward_points} ",
                    style: TextStyle(
                        color: Color(0xff12C171),
                        fontSize: 10),
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.yellow, // change here
                    size: 7,
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
            SizedBox(height: size.height * 0.01),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundButton(
                    backgroundColor: Color(0xFFF2CA8A),
                    size: size.height * 0.068,
                    child: Text(
                      'TRY ON',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.black,
                            fontSize: size.height * 0.012,
                          ),
                    ),
                    onPress: () {
                      tiop.received.value = product;
                      tiop.page.value = 2;
                      tiop.directProduct.value = true;
                      pp.goToPage(Pages.TRYITON);
                    },
                  ),
                  RoundButton(
                    size: size.height * 0.068,
                    child: PngIcon(image: 'assets/icons/add_to_cart_white.png'),
                    onPress: () async {
                      if((product.options != null && product.options!.isNotEmpty ) || product.hasOption == true){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext c) {
                              return ProductDetail1Screen(sku: product.sku!);
                            },
                          ),
                        );
                      }else{
                        await Provider.of<CartProvider>(context, listen: false).addHomeProductsToCart(context, product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            padding: EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            duration: Duration(seconds: 1),
                            content: Container(
                              child: CustomSnackBar(
                                sku: product.sku!,
                                image: product.image,
                                name: product.name!,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
