import 'package:flutter/material.dart';
// 3rd party packages
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/utils/states/function.dart';

class TotalAmount extends StatelessWidget {
  const TotalAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _sum = Provider.of<CartProvider>(context).getSumTotal();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TOTAL:',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  letterSpacing: 0.6,
                ),
          ),
          Text(
            // 'EUR ${_sum.toStringAsFixed(2)}',
            '${_sum.toProperCurrencyString()}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  letterSpacing: 0.6,
                ),
          ),
        ],
      ),
    );
  }
}
