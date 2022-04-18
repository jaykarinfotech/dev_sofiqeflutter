import 'package:flutter/material.dart';

// Custom packages
import 'package:sofiqe/widgets/catalog/checkout/order_overview.dart';
import 'package:sofiqe/widgets/catalog/checkout/shipping_options.dart';
import 'package:sofiqe/widgets/catalog/checkout/payment_options.dart';
import 'package:sofiqe/widgets/catalog/checkout/add_promo.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            OrderOverView(),
            SizedBox(height: 1),
            AddPromo(),
            SizedBox(height: 7),
            ShippingOptions(),
            SizedBox(height: 7),
            PaymentOptionsAndCheckout(),
          ],
        ),
      ),
    );
  }
}
