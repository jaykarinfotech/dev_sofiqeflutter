import 'package:flutter/material.dart';

// Custom packages
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/catalog/payment/payment_details_page.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final void Function(Map<String, String>) callback;
  const PaymentDetailsScreen({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Center(child: Text('2/2')),
          ),
        ],
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
          'PAYMENT',
          style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 0.6),
        ),
      ),
      body: PaymentDetailsPage(callback: callback),
    );
  }
}
