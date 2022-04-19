// ignore_for_file: deprecated_member_use

import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/screens/premium_subscription_screen.dart';
import 'package:sofiqe/screens/shopping_bag_screen.dart';
import 'package:sofiqe/utils/constants/route_names.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/screens/splash_screen.dart';
import 'package:sofiqe/screens/wizard_screen.dart';
import 'package:sofiqe/screens/home_screen.dart';
import 'package:sofiqe/screens/make_over_screen.dart';
import 'package:sofiqe/screens/catalog_screen.dart';
import 'package:sofiqe/widgets/scaffold/scaffold_template.dart';
import 'package:get/get.dart';


GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

//Root class
class Sofiqe extends StatelessWidget {
  Sofiqe({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => MultiProvider(
              providers: [
                ChangeNotifierProvider<AccountProvider>(
                  lazy: false,
                  create: (_) {
                    return AccountProvider();
                  },
                ),
                ChangeNotifierProvider<CartProvider>(
                  lazy: false,
                  create: (_) {
                    return CartProvider();
                  },
                ),
                // ChangeNotifierProvider<MakeOverProvider>(
                //   lazy: true,
                //   create: (_) {
                //     return MakeOverProvider();
                //   },
                // ),
                // ChangeNotifierProvider<WishListProvider>(
                //   lazy: false,
                //   create: (_) {
                //     return WishListProvider();
                //   },
                // ),
                // ChangeNotifierProxyProvider<FIRST, SECOND>(
                //   lazy: false,
                //   create: (_) {},
                //   update: (_, first, second) {},
                // ),
              ],
              builder: (ctx, _) {
                // SystemChrome.setEnabledSystemUIOverlays([]);

                ///todo: uncomment
                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  supportedLocales: [
                    Locale("en"),
                  ],
                  localizationsDelegates: [
                    CountryLocalizations.delegate,
                  ],
                  theme: ThemeData(
                    textTheme: TextTheme(
                      headline1: TextStyle(
                        fontFamily: 'SkarpaRegular',
                        letterSpacing: 3,
                        color: Colors.black,
                      ),
                      headline2: TextStyle(
                        fontFamily: 'Arial',
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  initialRoute: RouteNames.splashScreen,
                  routes: {
                    RouteNames.splashScreen: (BuildContext _) {
                      return SplashScreen();
                    },
                    RouteNames.wizardScreen: (BuildContext _) {
                      return WizardScreen();
                    },
                    RouteNames.homeScreen: (BuildContext _) {
                      return ScaffoldTemplate(
                        child: HomeScreen(),
                        index: 0,
                      );
                    },
                    RouteNames.premiumSubscriptionScreen: (BuildContext _) {
                      return PremiumSubscriptionScreen();
                    },
                    RouteNames.catalogScreen: (BuildContext _) {
                      return ScaffoldTemplate(
                        child: CatalogScreen(),
                        index: 2,
                      );
                    },
                    RouteNames.makeOverScreen: (BuildContext _) {
                      return ScaffoldTemplate(
                        child: MakeOverScreen(),
                        index: 3,
                      );
                    },
                    RouteNames.cartScreen: (BuildContext _) {
                      return ShoppingBagScreen();
                    }
                  },
                );
              },
            ));
  }
}
