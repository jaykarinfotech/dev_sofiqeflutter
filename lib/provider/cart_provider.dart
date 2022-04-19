// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Model
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/model/product_model_best_seller.dart';
import 'package:sofiqe/utils/api/shopping_cart_api.dart';
import 'package:sofiqe/utils/states/local_storage.dart';

import '../model/lookms3model.dart';
import 'account_provider.dart';

class CartProvider extends ChangeNotifier {
  late List<Map<String, dynamic>> chargesList;
  late String cartToken;
  List<dynamic>? cart;
  Map<String, dynamic>? cartDetails;
  var itemCount = 0;

  CartProvider() {
  _initData();
  }

  _initData() async{
    chargesList = [
      {
        'name': 'Subtotal',
        'amount': 0,
        'display': '0',
      },
      {
        'name': 'Delivery',
        'amount': 3.95,
        'display': '3.95',
      },
      {
        'name': 'VAT',
        'amount': 0,
        'display': 'Included',
      },
      {
        'name': 'Total',
        'amount': 0,
        'display': '0',
      },
    ];
    await initializeCart();
  }

  Future<void> initializeCart() async {
    String token = await sfAPIInitializeGuestShoppingCart();
    cartToken = token;
    print("CartToken  -->> succ ${cartToken}");

    await sfStoreInSharedPrefData(fieldName: 'cart-token', value: '$cartToken', type: PreferencesDataType.STRING);
    await fetchCartDetails();
  }

  Future<bool> fetchCartDetails() async {
    try {

      itemCount = 0;
      cart= await sfAPIGetGuestCartList(cartToken);
      cartDetails= await sfAPIGetGuestCartDetails(cartToken);

      // print(cart);
      _setItemCount();
      calculateCartPrice();
      return true;
    } catch (err) {
      print('Error fetchCartDetails: $err');
      await sfRemoveFromSharedPrefData(fieldName: 'cart-token');
      initializeCart();
      return false;
    }
  }

  Future<void> deleteCart() async {
    await sfRemoveFromSharedPrefData(fieldName: 'cart-token');
  }

  Future<void> addToCart(BuildContext context, String sku, List simpleProductOptions, int type,
      {bool refresh = true, int quantity = 0}) async {
    try {
      !Provider.of<AccountProvider>(context, listen: false).isLoggedIn ?
      await sfAPIAddItemToCart(cartToken, cartDetails!['id'], sku, simpleProductOptions, type, 'Guest',  quantity: quantity)
      : await sfAPIAddItemToCart(cartToken, cartDetails!['id'], sku, simpleProductOptions, type, 'LoggedIn', quantity: quantity);
      if (refresh) {
        await fetchCartDetails();
      }
      notifyListeners();
    } catch (e) {
      print('Error adding product to cart: $e');
      Map message = e as Map;
      if (message['message'].compareTo('The requested qty is not available') == 0) {
        Get.showSnackbar(
          GetBar(
            message: 'The product is out of stock',
            duration: Duration(seconds: 2),
            isDismissible: true,
          ),
        );
      } else {
        Get.showSnackbar(
          GetBar(
            message: 'Could not add product to cart',
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> addHomeProductsToCart(BuildContext context, Product product) async {
    addToCart(context, product.sku!, [], product.hasOption ? 1 : 0);
  }

  Future<void> addHomeProductsToCartt(BuildContext context, Product1 product) async {
    addToCart(context, product.sku!, [], 1);
  }

  Future<void> removeFromCart(String itemId, {bool refresh = true}) async {
    await sfAPIRemoveItemFromCart(cartToken, itemId);
    if (refresh) {
      await fetchCartDetails();
    }
    notifyListeners();
  }

  void _setItemCount() {
    itemCount = cart == null ? 0 : cart!.length;
    notifyListeners();
  }

  Future<bool> calculateCartPrice() async {
    if (cart != null) {
      // Calculate subtotal
      chargesList[0]['amount'] = 0;
      cart!.forEach(
        (item) {
          chargesList[0]['amount'] += (item['price'] * item['qty']);
        },
      );
      chargesList[0]['display'] = '${chargesList[0]['amount']}';

      // Calculate total
      chargesList[3]['amount'] = 0;
      chargesList.forEach(
        (Map<String, dynamic> charge) {
          if (charge['name'] != 'Total') {
            chargesList[3]['amount'] += charge['amount'];
          }
        },
      );
      chargesList[3]['display'] = chargesList[3]['amount'];
    }

    return true;
  }

  void setDeliverCharges(double charge) {
    chargesList[1]['amount'] = charge;
    chargesList[1]['display'] = '$charge';
    notifyListeners();
  }

  double getSumTotal() {
    return chargesList[3]['amount'];
  }
}
