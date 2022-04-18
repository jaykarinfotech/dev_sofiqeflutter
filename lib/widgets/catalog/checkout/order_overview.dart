import 'package:flutter/material.dart';

// Custom packages
import 'package:sofiqe/widgets/catalog/checkout/checkout_items.dart';
import 'package:sofiqe/widgets/catalog/checkout/additional_charges.dart';
import 'package:sofiqe/widgets/catalog/checkout/total_amount.dart';

class OrderOverView extends StatelessWidget {
  const OrderOverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 29),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          SizedBox(height: 11),
          CheckoutItems(),
          SizedBox(height: 11),
          AdditionalCharges(),
          SizedBox(height: 14.5),
          TotalAmount(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'ORDER OVERVIEW',
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black,
              fontSize: 13,
              letterSpacing: 0.55,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
