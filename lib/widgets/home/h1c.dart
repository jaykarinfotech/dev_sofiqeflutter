import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/model/data_ready_status_enum.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/model/product_model_best_seller.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/provider/home_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:sofiqe/screens/product_detail_1_screen.dart';
import 'package:sofiqe/widgets/capsule_button.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/product_detail/order_notification.dart';
import 'package:sofiqe/widgets/product_error_image.dart';

class H1C extends StatelessWidget {
  H1C({Key? key}) : super(key: key);

  final HomeProvider hp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/home_h1c_background.png',
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'BESTSELLERS',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.015,
                ),
          ),
          Container(
            width: size.width * 0.7,
            child: Text(
              'PRODUCTS THAT ARE LOVED BY SOFIQERS',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.024,
                    height: 1,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          Obx(
            () {
              if (hp.bestSellerListt.isEmpty) {
                return BestSellerError();
              }
              if (hp.bestSellerListStatus.value == DataReadyStatus.COMPLETED) {
                return BestSellerItems();
              } else if (hp.bestSellerListStatus.value == DataReadyStatus.FETCHING || hp.bestSellerListStatus.value == DataReadyStatus.INACTIVE) {
                return BestSellerBuffering();
              } else if (hp.bestSellerListStatus.value == DataReadyStatus.ERROR) {
                return BestSellerError();
              } else {
                return BestSellerError();
              }
            },
          ),
        ],
      ),
    );
  }
}

class BestSellerItems extends StatelessWidget {
  BestSellerItems({Key? key}) : super(key: key);

  final HomeProvider hp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int index = 0;
    if (hp.bestSellerListt.isEmpty) {
      return BestSellerError();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: size.height * 0.65,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Row(
          children: hp.bestSellerListt.map<GestureDetector>(
            (Product1 p) {
              int i = index++;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext c) {
                        return ProductDetail1Screen(sku: p.sku!);
                      },
                    ),
                  );
                },
                child: BestSellerItem(
                  index: i,
                  total: hp.bestSellerListt.length,
                  product: p,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class BestSellerItem extends StatelessWidget {
  final int index;
  final int total;
  final Product1 product;
  const BestSellerItem({
    Key? key,
    required this.index,
    required this.total,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topLeft = 0;
    double bottomLeft = 0;
    double topRight = 0;
    double bottomRight = 0;
    if (index == 0) {
      topLeft = 10;
      bottomLeft = 10;
    }
    if (index == total - 1) {
      topRight = 10;
      bottomRight = 10;
    }
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.005),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRight),
          bottomRight: Radius.circular(bottomRight),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            '${product.image}',
            width: size.width * 0.45,
            height: size.width * 0.45,
            errorBuilder: (BuildContext c, Object o, StackTrace? s) {
              return ProductErrorImage(
                width: size.width * 0.45,
                height: size.width * 0.45,
              );
            },
          ),
          // Container(
          //   width: size.width * 0.6,
          //   child: Text(
          //     '${product.faceSubAreaName.capitalizeFirst}',
          //     textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.headline2!.copyWith(
          //           color: Colors.black,
          //           fontSize: size.height * 0.015,
          //         ),
          //   ),
          // ),
          Container(
            width: size.width * 0.6,
            height: size.height * 0.05,
            child: Text(
              '${product.name}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Container(
            width: size.width * 0.6,
            child: Text(
              '€ ${product.price}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.018,
                  ),
            ),
          ),
          // Container(
          //   width: size.width * 0.6,
          //   height: size.height * 0.04,
          //   child: Text(
          //     '${product.description}',
          //     textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.headline2!.copyWith(
          //           color: Colors.black,
          //           fontSize: size.height * 0.0165,
          //         ),
          //   ),
          // ),
          Row(
            children: [
              SizedBox(width: size.width * 0.05),
              Expanded(
                child: _TryOnButtonnn(
                  product1: product,
                ),
              ),
              SizedBox(width: size.width * 0.05),
              Expanded(
                child: _AddToBagButton(
                  onPress: () async {
                    if(product.options != null && product.options!.isNotEmpty){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext c) {
                            return ProductDetail1Screen(sku: product.sku!);
                          },
                        ),
                      );
                    }else {
                      CartProvider cartP = Provider.of<CartProvider>(context, listen: false);
                      await cartP.addHomeProductsToCartt(context, product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 1),
                          content: Container(
                            child: CustomSnackBar(
                              sku: product.sku!,
                              image: product.image.replaceAll(
                                  RegExp(
                                      'https://dev.sofiqe.com/media/catalog/product'),
                                  ''),
                              name: product.name!,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: size.width * 0.05),
            ],
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }
}

class _TryOnButton extends StatelessWidget {
  final Product product;
  _TryOnButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final TryItOnProvider tiop = Get.find();
  final PageProvider pp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: CapsuleButton(
        height: size.height * 0.06,
        backgroundColor: Color(0xFFF2CA8A),
        onPress: () {
          tiop.received.value = product;
          tiop.page.value = 2;
          tiop.directProduct.value = true;
          pp.goToPage(Pages.TRYITON);
        },
        child: Text(
          'TRY ON',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.black,
                fontSize: size.width * 0.024,
              ),
        ),
      ),
    );
  }
}

class _TryOnButtonnn extends StatelessWidget {
  final Product1 product1;
  _TryOnButtonnn({
    Key? key,
    required this.product1,
  }) : super(key: key);

  final TryItOnProvider tiop = Get.find();
  final PageProvider pp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: CapsuleButton(
        height: size.height * 0.06,
        backgroundColor: Color(0xFFF2CA8A),
        onPress: () {
          var data = Product(id: product1.id, name: product1.name, sku: product1.sku, price: product1.price, image: product1.image, description: "", faceSubArea: 0, avgRating: "0");
          tiop.received.value = data;
          tiop.page.value = 2;
          tiop.directProduct.value = true;
            pp.goToPage(Pages.TRYITON);
        },
        child: Text(
          'TRY ON',
          style: Theme.of(context).textTheme.headline2!.copyWith(
            color: Colors.black,
            fontSize: size.width * 0.024,
          ),
        ),
      ),
    );
  }
}


class _AddToBagButton extends StatelessWidget {
  final void Function() onPress;
  const _AddToBagButton({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: CapsuleButton(
        height: size.height * 0.06,
        onPress: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PngIcon(
              image: 'assets/icons/add_to_cart_white.png',
              width: size.width * 0.03,
            ),
            Text(
              'ADD TO BAG',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: size.width * 0.024,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class BestSellerBuffering extends StatelessWidget {
  const BestSellerBuffering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class BestSellerError extends StatelessWidget {
  const BestSellerError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.65,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          '"Oops, looks like the best selling products are not available right now..."',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.black,
                fontSize: size.height * 0.025,
              ),
        ),
      ),
    );
  }
}
