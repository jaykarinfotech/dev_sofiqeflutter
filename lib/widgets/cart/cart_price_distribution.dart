import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/utils/states/function.dart';

class CartPriceDistribution extends StatelessWidget {
  const CartPriceDistribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CartProvider>(context).calculateCartPrice(),
      builder: (BuildContext _, snapshote) {
        List<Map<String, dynamic>> charges = Provider.of<CartProvider>(context).chargesList;
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SUBTOTAL',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Regular',
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Text(
                      '${(charges[0]['amount'] as num).toDouble().toProperCurrencyString()}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Regular',
                        color: SplashScreenPageColors.backgroundColor,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DELIVERY',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Regular',
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Text(
                      '${(charges[1]['amount'] as num).toDouble().toProperCurrencyString()}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Regular',
                        color: SplashScreenPageColors.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Bold',
                        fontWeight: FontWeight.bold,
                        color: SplashScreenPageColors.backgroundColor,
                      ),
                    ),
                    Text(
                      // 'EUR ${charges[3]['amount']}',
                      '${(charges[3]['amount'] as num).toDouble().toProperCurrencyString()}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Arial, Bold',
                        fontWeight: FontWeight.bold,
                        color: SplashScreenPageColors.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
