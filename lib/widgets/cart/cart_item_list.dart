import 'package:flutter/material.dart';

// 3rd party packages
import 'package:provider/provider.dart';

// Provider
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/utils/constants/app_colors.dart';

// Custom packages
import 'package:sofiqe/widgets/cart/cart_item.dart';

class CartItemList extends StatefulWidget {
  const CartItemList({Key? key}) : super(key: key);

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> cartItems = Provider.of<CartProvider>(context).cart as List<dynamic>;
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...cartItems.map(
                        (dynamic i) {
                      return CartItem(item: i);
                    },
                  ).toList(),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
