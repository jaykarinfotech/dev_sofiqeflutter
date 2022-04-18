import 'package:flutter/material.dart';

// 3rd party packages
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/utils/states/function.dart';
// Custom packages
import 'package:sofiqe/widgets/horizontal_bar.dart';

class CheckoutItems extends StatelessWidget {
  const CheckoutItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<dynamic> _productList = Provider.of<CartProvider>(context, listen: false).cart!;
    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.2),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._productList.map<_CheckoutItemTemplate>(
              (dynamic p) {
                return _CheckoutItemTemplate(product: p);
              },
            ).toList(),
            SizedBox(height: 5.5),
            HorizontalBar(height: 0.5, width: MediaQuery.of(context).size.width, color: Color(0xFFD3D3D3)),
          ],
        ),
      ),
    );
  }
}

class _CheckoutItemTemplate extends StatelessWidget {
  final Map<String, dynamic> product;
  _CheckoutItemTemplate({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Image.asset('assets/images/lip_1.png', width: 12, height: 20),
              SizedBox(width: 12.5),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Text(
                    '${product['name'].toUpperCase()}',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.black,
                          fontSize: size.height * 0.014,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
              ),
              Text(
                '${(product['price'] as num).toDouble().toProperCurrencyString()}',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.5),
      ],
    );
  }
}
