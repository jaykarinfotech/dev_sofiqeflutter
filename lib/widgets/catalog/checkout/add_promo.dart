import 'package:flutter/material.dart';

class AddPromo extends StatelessWidget {
  const AddPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8.5, horizontal: 29),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Do you have a promo code?',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Color(0xFFAFA6A6),
                  fontSize: 11,
                  letterSpacing: 0.55,
                ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'ADD',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: 11,
                    letterSpacing: 0.55,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
