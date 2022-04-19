import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/screens/catalog_sign_in_screen.dart';
import 'package:sofiqe/screens/checkout_screen.dart';
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/widgets/cart/cart_price_distribution.dart';

class ShoppingBagBottomTab extends StatelessWidget {
  const ShoppingBagBottomTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          // height: 197,
          color: SplashScreenPageColors.textColor,
          child: Column(
            children: [
              CartPriceDistribution(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 56,
                    width: 315,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        primary: AppColors.navigationBarSelectedColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext _) {
                              if (Provider.of<AccountProvider>(context, listen: false).isLoggedIn) {
                                return CheckoutScreen();
                              } else {
                                return CatalogSignInScreen();
                              }
                            },
                          ),
                        );
                      },
                      child: Text(
                        'NEXT',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                          color:Color(0xFFF2CA8A),
                          fontSize: 16,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("or €2.50/month with Splitit"),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
