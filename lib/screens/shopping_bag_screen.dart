import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/screens/my_sofiqe.dart';
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/widgets/cart/cart_item_list.dart';
import 'package:sofiqe/widgets/cart/empty_bag.dart';
import 'package:sofiqe/widgets/cart/shopping_bag_bottom_tab.dart';

class ShoppingBagScreen extends StatefulWidget {
  const ShoppingBagScreen({Key? key}) : super(key: key);

  @override
  _ShoppingBagScreenState createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context).itemCount;
    var cart = Provider.of<CartProvider>(context).cart;
    final args = ModalRoute.of(context)!.settings.arguments;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          toolbarHeight: size.height * 0.15,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 30.0, left: 20),
              child: Container(
                child: Image.asset(
                  "assets/icons/Path_11_1.png",
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'sofiqe',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.white, fontSize: 25, letterSpacing: 2.5),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'SHOPPING BAG (' +
                    Provider.of<CartProvider>(context).itemCount.toString() +
                    ")",
                style: TextStyle(
                    color: Colors.white, fontSize: 12, letterSpacing: 1),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: cartItems != 0
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: HexColor("#EB7AC1"),
                        height: 25,
                        width: size.width,
                        child: Center(
                            child: Text(
                              Provider.of<CartProvider>(context).itemCount == 0 ? 'Free shipping above €XXX' : 'Add € XXX to your cart to get free shipping',
                          style: TextStyle(fontSize: 12),
                        ))),
                    Expanded(
                      child: CartItemList(),
                    ),
                    ShoppingBagBottomTab(),
                  ],
                ),
              )
            : cart != null && cart.isNotEmpty
                ? Center(child: CircularProgressIndicator())
                : EmptyBagPage(
                    emptyBagButtonText: args != null
                        ? (args as Map)['empty_bag_button_text']
                        : null,
                  ),
      ),
    );
  }
}
