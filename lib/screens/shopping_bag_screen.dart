import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
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

          // leading: Icon(
          //   Icons.close,
          //   color: Colors.white,
          // ),
          centerTitle: true,
          title: Text(
            'sofiqe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Colors.white, fontSize: 25, letterSpacing: 2.5),
          ),
          backgroundColor: Colors.black,
        ),
        body: cartItems != 0
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:  CartItemList(),
                    ),
                    ShoppingBagBottomTab(),
                  ],
                ),
              )
            : cart != null && cart.isNotEmpty ? Center(child: CircularProgressIndicator()) :

        EmptyBagPage(
                emptyBagButtonText: args != null
                    ? (args as Map)['empty_bag_button_text']
                    : null,
              ),
      ),
    );
  }
}
