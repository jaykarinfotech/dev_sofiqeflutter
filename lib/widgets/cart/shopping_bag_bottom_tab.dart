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
                        'PROCEED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Arial, Regular',
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
