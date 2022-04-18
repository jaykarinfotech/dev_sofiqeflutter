import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/utils/states/function.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/product_detail/order_notification.dart';
import 'package:sofiqe/widgets/product_image.dart';

import '../screens/product_detail_1_screen.dart';

class TryOnProduct extends StatelessWidget {
  final Product? product;
  const TryOnProduct({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (product!.sku!.isEmpty) {
      return Container();
    }
    return Container(
      height: size.height * 0.12,
      decoration: BoxDecoration(
        color: Color(0xFFF2CA8A),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300] as Color),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ItemImage(
            image: product!.image,
          ),
          ItemInformation(
            areaName: product!.faceSubAreaName,
            productName: product!.name!,
            price: product!.price!,
          ),
          ColorSelector(
            color: product!.color,
          ),
          AddToBagButton(
            product: product as Product,
          ),
        ],
      ),
    );
  }
}

class ItemImage extends StatelessWidget {
  final String image;
  ItemImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.height * 0.08,
      child: ProductImage(
        imageShortPath: image,
      ),
    );
  }
}

class ItemInformation extends StatelessWidget {
  final String areaName;
  final String productName;
  final num price;
  ItemInformation(
      {Key? key,
      required this.areaName,
      required this.productName,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${areaName.toUpperCase()}',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.012,
                  letterSpacing: 0,
                ),
          ),
          Container(
            width: size.width * 0.25,
            height: size.height * 0.04,
            child: Text(
              '$productName',
              // 'L\'Oreal Socket',
              softWrap: true,
              // overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.015,
                    letterSpacing: 0,
                  ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            '€ $price',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.013,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }
}

class ColorSelector extends StatelessWidget {
  // final int code;
  final String color;
  ColorSelector({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          height: size.height * 0.08,
          child: Icon(Icons.arrow_left),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: size.height * 0.08,
            width: size.width * 0.2,
            decoration: BoxDecoration(
              color: color.toColor(),
              border: Border.all(
                color: Color(0xFF707070),
              ),
            ),
          ),
        ),
        Container(
          height: size.height * 0.08,
          child: Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}

class AddToBagButton extends StatelessWidget {
  final Product product;
  AddToBagButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: size.height * 0.08,
      child: GestureDetector(
        onTap: () async {
          if(product.options != null && product.options!.isNotEmpty){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext c) {
                  return ProductDetail1Screen(sku: product.sku!);
                },
              ),
            );
          }else{
            CartProvider cartP =
            Provider.of<CartProvider>(context, listen: false);
            await cartP.addHomeProductsToCart(product);
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
        child: Container(
          height: AppBar().preferredSize.height * 0.7,
          width: AppBar().preferredSize.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
                Radius.circular(AppBar().preferredSize.height * 0.7)),
          ),
          child: PngIcon(
            height: AppBar().preferredSize.height * 0.3,
            width: AppBar().preferredSize.height * 0.3,
            image: 'assets/icons/add_to_cart_white.png',
          ),
        ),
      ),
    );
  }
}
