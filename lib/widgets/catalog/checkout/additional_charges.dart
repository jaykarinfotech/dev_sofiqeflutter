import 'package:flutter/material.dart';

// 3rd party packages
import 'package:provider/provider.dart';

// Provider
import 'package:sofiqe/provider/cart_provider.dart';

// Custom packages
import 'package:sofiqe/widgets/horizontal_bar.dart';

class AdditionalCharges extends StatelessWidget {
  AdditionalCharges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _chargesList = Provider.of<CartProvider>(context).chargesList;
    return Container(
      child: Column(
        children: [
          ..._chargesList.map<_AdditionalChargeTemplate>(
            (Map<String, dynamic> c) {
              return _AdditionalChargeTemplate(charge: c);
            },
          ).toList(),
          SizedBox(height: 2),
          HorizontalBar(height: 0.5, width: MediaQuery.of(context).size.width, color: Color(0xFFD3D3D3)),
        ],
      ),
    );
  }
}

class _AdditionalChargeTemplate extends StatelessWidget {
  final Map<String, dynamic> charge;
  const _AdditionalChargeTemplate({Key? key, required this.charge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (charge['name'] == 'Total') {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 3.5,
        horizontal: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${charge['name']}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
          ),
          Text(
            '${charge['display']}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}
