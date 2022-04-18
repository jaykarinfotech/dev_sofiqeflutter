import 'package:flutter/material.dart';

// 3rd party packages
import 'package:provider/provider.dart';

// Provider
import 'package:sofiqe/provider/cart_provider.dart';

// Custom packages
import 'package:sofiqe/widgets/custom_radio_button.dart';

List<Map<String, dynamic>> _shippingOptions = [
  {
    'id': 0,
    'type': 'Standard Delivery',
    'estimated-time': 'Delivery estimated Wed 11 March',
    'price': 3.95,
  },
  {
    'id': 1,
    'type': 'Express Delivery',
    'estimated-time': 'Delivery estimated before Mon 9 March',
    'price': 6.95,
  }
];

int _currentOption = 0;

class ShippingOptionsCheckBoxList extends StatefulWidget {
  const ShippingOptionsCheckBoxList({Key? key}) : super(key: key);

  @override
  _ShippingOptionsCheckBoxListState createState() => _ShippingOptionsCheckBoxListState();
}

class _ShippingOptionsCheckBoxListState extends State<ShippingOptionsCheckBoxList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          SizedBox(height: 10),
          ..._shippingOptions.map<_ShippingOptionTemplate>((Map<String, dynamic> o) {
            return _ShippingOptionTemplate(
              option: o,
              rebuild: () {
                setState(() {});
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'SHIPPING',
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black,
              fontSize: 13,
              letterSpacing: 0.55,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ShippingOptionTemplate extends StatelessWidget {
  final Map<String, dynamic> option;
  final Function rebuild;
  const _ShippingOptionTemplate({Key? key, required this.option, required this.rebuild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
      child: Row(
        children: [
          CustomRadioButton<int>(
            size: 30,
            value: option['id'],
            groupValue: _currentOption,
            onChanged: (int value) {
              _currentOption = value;
              Provider.of<CartProvider>(context, listen: false).setDeliverCharges(option['price']);

              rebuild();
            },
          ),
          SizedBox(width: 13.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${option['type']}',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        letterSpacing: 0.55,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${option['estimated-time']}',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: 10,
                        letterSpacing: 0.4,
                      ),
                ),
              ],
            ),
          ),
          Text('${option['price']}'),
        ],
      ),
    );
  }
}
