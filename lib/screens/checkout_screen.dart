import 'package:flutter/material.dart';

// Custom packages
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/catalog/checkout/checkout_page.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F2F0),
      appBar: AppBar(
        leading: IconButton(
          icon: Transform.rotate(
            angle: 3.14159,
            child: PngIcon(
              image: 'assets/icons/arrow-2-white.png',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'PURCHASE',
          style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 0.6),
        ),
      ),
      body: CheckoutPage(),
    );
  }
}
