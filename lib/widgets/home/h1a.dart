import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/model/data_ready_status_enum.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/provider/home_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:intl/intl.dart';
import 'package:sofiqe/screens/product_detail_1_screen.dart';
import 'package:sofiqe/utils/states/function.dart';
import 'package:sofiqe/widgets/capsule_button.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/product_detail/order_notification.dart';
import 'package:sofiqe/widgets/product_error_image.dart';

class H1A extends StatelessWidget {
  H1A({Key? key}) : super(key: key);

  final HomeProvider hp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.028),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Greetings(),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: Obx(
              () {
                if (hp.dealOfTheDayList.isEmpty) {
                  return DealOfTheDayError();
                }
                if (hp.dealOfTheDayStatus.value == DataReadyStatus.COMPLETED) {
                  return DealOfTheDayItems();
                } else if (hp.dealOfTheDayStatus.value ==
                        DataReadyStatus.FETCHING ||
                    hp.dealOfTheDayStatus.value == DataReadyStatus.INACTIVE) {
                  return DealOfTheDayBuffering();
                } else if (hp.dealOfTheDayStatus.value ==
                    DataReadyStatus.ERROR) {
                  return DealOfTheDayError();
                } else {
                  return DealOfTheDayError();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Greetings extends StatelessWidget {
  const _Greetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dayDate = '';
    String timeOfDayGreetings = '';
    String name = '';
    Size size = MediaQuery.of(context).size;

    DateTime date = DateTime.now();

    dayDate = DateFormat('EEEE d MMMM').format(date);

    int hour = date.hour;
    if (hour > 18) {
      timeOfDayGreetings = 'Good Evening';
    } else if (hour > 12) {
      timeOfDayGreetings = 'Good Afternoon';
    } else if (hour > 6) {
      timeOfDayGreetings = 'Good Morning';
    } else if (hour >= 0) {
      timeOfDayGreetings = 'Good Night';
    }

    if (Provider.of<AccountProvider>(context, listen: false).isLoggedIn) {
      name =
          ', ${Provider.of<AccountProvider>(context, listen: false).user!.firstName}';
    }

    return Container(
      child: Column(
        children: [
          Text(
            '$dayDate',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.016,
                  letterSpacing: 0,
                ),
          ),
          Text(
            '$timeOfDayGreetings$name',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.019,
                  letterSpacing: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}

class DealOfTheDayItems extends StatelessWidget {
  DealOfTheDayItems({Key? key}) : super(key: key);

  final HomeProvider hp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int index = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.01),
        child: Row(
          children: hp.dealOfTheDayList.map<GestureDetector>(
            (Product p) {
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
                child: _OfferOfTheDayCard(
                  index: i,
                  total: hp.bestSellerList.length,
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

class _OfferOfTheDayCard extends StatelessWidget {
  final num index;
  final num total;
  final Product product;
  _OfferOfTheDayCard({
    Key? key,
    required this.index,
    required this.total,
    required this.product,
  }) : super(key: key);

  final HomeProvider hp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double topLeft = 10;
    double bottomLeft = 0;
    double topRight = 10;
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
      width: size.width * 0.85,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRight),
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/images/offer_of_day_background_image.png',
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x15000029),
            // color: Colors.red,
            blurRadius: 4,
            spreadRadius: 1.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: _OfferDetails(
              product: product,
            ),
          )
        ],
      ),
    );
  }
}

class _OfferDetails extends StatelessWidget {
  final Product product;
  _OfferDetails({
    Key? key,
    required this.product,
  }) : super(key: key);

  final TryItOnProvider tiop = Get.find();
  final PageProvider pp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: size.width * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.12),
          Image.network(
            '${product.image}',
            width: 100,
            height: 100,
            errorBuilder: (BuildContext c, Object o, StackTrace? st) {
              return ProductErrorImage(width: 100, height: 100);
            },
          ),
          SizedBox(height: size.height * 0.014),
          Text(
            'DEAL OF THE DAY',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: size.height * 0.015,
                  letterSpacing: 0,
                ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            height: size.height * 0.08,
            child: Text(
              '${product.name}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Text(
            '${product.discountedPrice != null ? product.discountedPrice!.toProperCurrencyString() : product.price!.toProperCurrencyString()}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Color(0xFFA09D9D),
                  fontSize: size.height * 0.02,
                ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            '${product.price!.toProperCurrencyString()}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.red[400],
                  fontSize: size.height * 0.02,
                  decoration: TextDecoration.lineThrough,
                ),
          ),
          SizedBox(height: size.height * 0.04),
          Container(
            height: size.height * 0.06,
            child: Text(
              '${product.description}',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.018,
                    letterSpacing: 0,
                  ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: CapsuleButton(
                  backgroundColor: Color(0xFFF2CA8A),
                  height: size.height * 0.07,
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
                          fontSize: size.height * 0.014,
                        ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.05),
              Flexible(
                flex: 1,
                child: CapsuleButton(
                  height: size.height * 0.07,
                  horizontalPadding: 0,
                  onPress: () async {
                    if( product.options != null && product.options!.isNotEmpty){
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
                      print("CartProvider  -->> SSs ${cartP.cartToken}");
                      await cartP.addHomeProductsToCart(product);
                      print("Name  -->> EEE ${product.image}");

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PngIcon(
                        image: 'assets/icons/add_to_cart_white.png',
                        height: size.height * 0.015,
                        width: size.height * 0.02,
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        'ADD TO BAG',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.white,
                              fontSize: size.height * 0.014,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DealOfTheDayBuffering extends StatelessWidget {
  const DealOfTheDayBuffering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double topLeft = 10;
    double bottomLeft = 10;
    double topRight = 10;
    double bottomRight = 10;

    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRight),
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/images/offer_of_day_background_image.png',
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x15000029),
            // color: Colors.red,
            blurRadius: 4,
            spreadRadius: 1.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Loading deal of the day near you!',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.black,
                fontSize: size.height * 0.025,
              ),
        ),
      ),
    );
  }
}

class DealOfTheDayError extends StatelessWidget {
  const DealOfTheDayError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double topLeft = 10;
    double bottomLeft = 10;
    double topRight = 10;
    double bottomRight = 10;

    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRight),
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/images/offer_of_day_background_image.png',
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x15000029),
            // color: Colors.red,
            blurRadius: 4,
            spreadRadius: 1.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Looks like no deal is available near you...',
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
