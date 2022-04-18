import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageShortPath;
  final double width;
  final double height;
  ProductImage({
    Key? key,
    this.imageShortPath = '',
    this.width = 400,
    this.height = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = imageShortPath;
    if (imageShortPath.startsWith('http')) {
      image = image.replaceAll(
          RegExp(r'https://dev.sofiqe.com/media/catalog/product'), '');
    }

    return Container(
      width: width,
      height: height,
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/checkout_product_image.png',
        image:
            'https://dev.sofiqe.com/media/catalog/product/cache/983707a945d60f44d700277fbf98de57$image',
        // errorBuilder: (BuildContext c, Object o, StackTrace? st) {
        //   return ProductErrorImage(
        //     width: width,
        //     height: height,
        //   );
        // },
        //  ),
      ),
    );
  }
}
