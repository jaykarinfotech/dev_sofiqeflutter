// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/screens/delivery_details_screen.dart';
import 'package:sofiqe/screens/order_confirmation_screen.dart';
import 'package:sofiqe/screens/payment_details_screen.dart';
import 'package:sofiqe/utils/api/shipping_address_api.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'package:sofiqe/widgets/catalog/checkout/checkout_button.dart';

import 'package:sofiqe/widgets/png_icon.dart';

enum PaymentOptions { ApplePay, CreditCardPay, PayPalPay }

//! All the commented code are left for future use just in case
class PaymentOptionsList extends StatefulWidget {
  const PaymentOptionsList({Key? key}) : super(key: key);

  @override
  _PaymentOptionsListState createState() => _PaymentOptionsListState();
}

class _PaymentOptionsListState extends State<PaymentOptionsList> {
  @override
  void initState() {
    super.initState();
    _tryLocal();
  }

  List<Widget> paymentOptions = [
    _ApplePay(),
    _CreditCardPay(),
    _PayPalPay(),
  ];

  PaymentOptions selectedOption = PaymentOptions.CreditCardPay;
  void onTap(PaymentOptions selectedOption) {
    setState(() {
      this.selectedOption = selectedOption;
    });
  }

  Widget paymentButtonContent(PaymentOptions paymentOption) {
    switch (paymentOption) {
      case PaymentOptions.ApplePay:
        return paymentButton('assets/icons/apple-pay-logo.png', "PAY");
      case PaymentOptions.CreditCardPay:
        return paymentButton(
            'assets/icons/credit-card-logo.png', "Credit Card");
      case PaymentOptions.PayPalPay:
        return paymentButton('assets/icons/paypal-logo.png', "PayPal");
    }
  }

  Widget paymentButton(String asset, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PngIcon(image: asset, color: Colors.white),
        SizedBox(width: 6.6),
        Text(
          text,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String country = '';
  String countryName = '';
  String region = '';
  String street = '';
  String zip = '';
  String city = '';
  String name = '';
  String phoneNumber = '';
  String email = '';

  String address = '';
  bool addressAvailable = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.5, vertical: 9),
            child: Text(
              'PAYMENT',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: 13,
                    letterSpacing: 0.55,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 9),
          _OptionsList(
            onTap: onTap,
            paymentOptions: paymentOptions,
            selectedOption: selectedOption,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext _) {
                  return DeliveryDetailsScreen();
                }));
              },
              child: Text(
                '$address',
                textAlign: TextAlign.end,
                softWrap: true,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.black,
                      fontSize: size.height * 0.014,
                      letterSpacing: 0,
                    ),
              ),
            ),
          ),
          CheckoutButton(
            paymentOption: paymentButtonContent(selectedOption),
            callback: () async {
              if (addressAvailable) {
                Map<String, dynamic> addressInfo = {
                  "addressInformation": {
                    "shippingAddress": {
                      "region": '$region',
                      "region_id": 0,
                      "country_id": '$country',
                      "street": ['$street'],
                      "company": "Revered-Tech",
                      "telephone": phoneNumber,
                      "postcode": "$zip",
                      "city": city,
                      "firstname": name.split(' ')[0],
                      "lastname":
                          name.split(' ').length > 1 ? name.split(' ')[1] : " ",
                      "email": email,
                      "prefix": "",
                      "region_code": '$region',
                      "sameAsBilling": 1
                    },
                    "billingAddress": {
                      "region": '$region',
                      "region_id": 0,
                      "country_id": '$country',
                      "street": ['$street'],
                      "company": "Revered-Tech",
                      "telephone": phoneNumber,
                      "postcode": "$zip",
                      "city": city,
                      "firstname": name.split(' ')[0],
                      "lastname":
                          name.split(' ').length > 1 ? name.split(' ')[1] : " ",
                      "email": email,
                      "prefix": "",
                      "region_code": '$region'
                    },
                    "shipping_method_code": "flatrate",
                    "shipping_carrier_code": "flatrate"
                  }
                };

                try {
                  sfAPIAddShippingAddressForGuest(addressInfo);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _) {
                        return PaymentDetailsScreen(
                          callback: (Map<String, String> cardDetails) async {
                            print(cardDetails);
                            try {
                              // String orderId = await sfApiPlaceOrder();
                              String orderId = '1';
                              await Provider.of<CartProvider>(context,
                                      listen: false)
                                  .deleteCart();
                              Provider.of<CartProvider>(context, listen: false)
                                  .initializeCart();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext _) {
                                  return OrderConfirmationScreen(
                                    orderId: orderId,
                                  );
                                }),
                              );
                            } catch (e) {
                              print(
                                  'Error setting payment information _NextButton: $e');
                              Get.showSnackbar(
                                GetBar(
                                  message:
                                      'An error occurred while saving the payment details',
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } catch (e) {
                  print(e);
                  rethrow;
                }
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext _) {
                  return DeliveryDetailsScreen();
                }));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _tryLocal() async {
    Map<String, dynamic> resultCountryCode = await sfQueryForSharedPrefData(
        fieldName: 'country', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultCountryName = await sfQueryForSharedPrefData(
        fieldName: 'country_name', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultRegionCode = await sfQueryForSharedPrefData(
        fieldName: 'region', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultStreet = await sfQueryForSharedPrefData(
        fieldName: 'street', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultPostcode = await sfQueryForSharedPrefData(
        fieldName: 'postcode', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultCity = await sfQueryForSharedPrefData(
        fieldName: 'city', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultName = await sfQueryForSharedPrefData(
        fieldName: 'name', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultPhoneNumber = await sfQueryForSharedPrefData(
        fieldName: 'phone-number', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultEmail = await sfQueryForSharedPrefData(
        fieldName: 'email', type: PreferencesDataType.STRING);

    if (resultCountryCode['found'] &&
        resultRegionCode['found'] &&
        resultStreet['found'] &&
        resultPostcode['found'] &&
        resultCity['found'] &&
        resultName['found'] &&
        resultPhoneNumber['found'] &&
        resultEmail['found']) {
      country = resultCountryCode['country'];
      countryName = resultCountryName['country_name'];
      region = resultRegionCode['region'];
      street = json.decode(resultStreet['street'])[0];
      zip = resultPostcode['postcode'];
      city = resultCity['city'];
      name = resultName['name'];
      phoneNumber = resultPhoneNumber['phone-number'];
      email = resultEmail['email'];
      addressAvailable = true;
      address = 'Delivery address: $street, $city, $zip, $countryName';
      setState(() {});
    }
  }
}

class _OptionsList extends StatelessWidget {
  final List<Widget> paymentOptions;
  final PaymentOptions selectedOption;
  final Function(PaymentOptions) onTap;

  const _OptionsList(
      {Key? key,
      required this.paymentOptions,
      required this.selectedOption,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: PaymentOptions.values
              .map((e) => _PaymentOption(
                  active: e == selectedOption, child: e, onTap: onTap))
              .toList() /* [
          _PaymentOption(
            ,
            child: _ApplePay(),
          ),
          _PaymentOption(
            backgroundColor: ,
            child: _CreditCardPay(),
          ),
          _PaymentOption(
            backgroundColor: Colors.white,
            child: _PayPalPay(),
          )
        ], */
          ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final bool active;
  final Function(PaymentOptions) onTap;
  final PaymentOptions child;
  _PaymentOption({
    Key? key,
    required this.active,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  Widget getPaymentOption(PaymentOptions paymentOptions) {
    switch (paymentOptions) {
      case PaymentOptions.ApplePay:
        return _ApplePay();
      case PaymentOptions.CreditCardPay:
        return _CreditCardPay();
      case PaymentOptions.PayPalPay:
        return _PayPalPay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(child);
      },
      child: AnimatedContainer(
        key: ValueKey(child),
        duration: Duration(milliseconds: 500),
        height: 147,
        width: 106,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: active ? Color(0xFFF2CA8A) : Colors.white,
        ),
        child: Center(
          child: getPaymentOption(child),
        ),
      ),
    );
  }
}

// Temporary

class _ApplePay extends StatelessWidget {
  const _ApplePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PngIcon(image: 'assets/icons/apple-pay-logo.png'),
              SizedBox(width: 6.6),
              Text(
                'PAY',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 27),
          Text(
            'APPLE PAY',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 11,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }
}

class _CreditCardPay extends StatelessWidget {
  const _CreditCardPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PngIcon(
              image: 'assets/icons/credit-card-logo.png',
              width: 30,
              height: 24),
          SizedBox(width: 6.6),
          SizedBox(height: 27),
          Text(
            'CREDIT CARD',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 11,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }
}

class _PayPalPay extends StatelessWidget {
  const _PayPalPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PngIcon(image: 'assets/icons/paypal-logo.png', width: 30, height: 24),
          SizedBox(width: 6.6),
          SizedBox(height: 27),
          Text(
            'PAYPAL',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 11,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }
}
