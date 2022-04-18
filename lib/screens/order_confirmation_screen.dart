import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/utils/constants/route_names.dart';
import 'package:sofiqe/widgets/png_icon.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;
  const OrderConfirmationScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: SplashScreenPageColors.backgroundColor,
        appBar: AppBar(
          // toolbarHeight: 97,
          centerTitle: true,
          title: Text(
            'sofiqe',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 16,
                  letterSpacing: 1.6,
                  color: SplashScreenPageColors.textColor,
                ),
          ),
          backgroundColor: Colors.black,
          // shadowColor: SplashScreenPageColors.textColor,
          // elevation: 2,
          shape: Border(bottom: BorderSide(color: AppColors.secondaryColor, width: 0)),
          elevation: 4,
          leading: IconButton(
            icon: Transform.rotate(
              angle: 3.14159,
              child: PngIcon(
                image: 'assets/icons/arrow-2-white.png',
              ),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, RouteNames.homeScreen, (route) => false);
            },
          ),
        ),
        body: Container(
          // height: constraints.maxHeight + 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 170),
              Center(
                child: Container(
                  child: Image.asset(
                    'assets/images/shopping_bag_white.png',
                  ),
                ),
              ),
              SizedBox(
                height: 24.06,
              ),
              Center(
                child: Container(
                  child: Text(
                    'ORDER ID: ${widget.orderId}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 9,
                          letterSpacing: 0.9,
                          color: Color(0XFF584F4F),
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 46,
              ),
              Center(
                child: Container(
                  child: Text(
                    'Thank you!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 18,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.bold,
                          color: SplashScreenPageColors.textColor,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Container(
                  child: Text(
                    'Your order is now confirmed.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: SplashScreenPageColors.textColor,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 59,
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 274,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                      ),
                      primary: SplashScreenPageColors.textColor,
                    ),
                    onPressed: () {
                      // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                      //todo: uncommnet.
                       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                      Navigator.pushNamedAndRemoveUntil(context, RouteNames.homeScreen, (route) => false);
                    },
                    child: Text(
                      'CONTINUE SHOPPING',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 274,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      primary: SplashScreenPageColors.backgroundColor,
                      side: BorderSide(width: 1.5, color: Color(0XFF453C3C)),
                    ),
                    onPressed: () {},
                    child: Text(
                      'TRACK MY ORDER',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: SplashScreenPageColors.textColor,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
