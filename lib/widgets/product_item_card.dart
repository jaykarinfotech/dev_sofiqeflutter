import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/model/product_model.dart';
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
              child: Row(
                children: [
                  WishList(
                    sku: product.sku!,
                    itemId: product.id!,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              child: ProductImage(
                imageShortPath: product.image,
                width: size.width * 0.2,
                height: size.height * 0.15,
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
                        await Provider.of<CartProvider>(context, listen: false).addHomeProductsToCart(product);
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
