import 'package:flutter/material.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'package:sofiqe/utils/states/user_account_data.dart';

// Custom packages
import 'package:sofiqe/widgets/capsule_button.dart';
import 'package:sofiqe/widgets/custom_white_cards.dart';
import 'package:sofiqe/widgets/catalog/payment/billing_address_switch.dart';
import 'package:sofiqe/widgets/catalog/payment/card_store_checkbox.dart';
import 'package:sofiqe/widgets/custom_form_field.dart';
import 'package:sofiqe/widgets/catalog/payment/card_scan_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailsPage extends StatelessWidget {
  final void Function(Map<String, String>) callback;
  PaymentDetailsPage({Key? key, required this.callback}) : super(key: key) {
    autoFillIfAvailable();
  }
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _storeCard() {
    sfStoreCardInformation({
      'cardNumber': '${_cardNumberController.value.text}',
      'expiration': '${_expirationController.value.text}',
    });
  }

  void autoFillIfAvailable() async {
    // CardNumber
    Map<String, dynamic> cardNumberMap = await sfQueryForSharedPrefData(
        fieldName: 'card-number', type: PreferencesDataType.STRING);
    if (cardNumberMap['found']) {
      _cardNumberController.text = cardNumberMap['card-number'];
    }

    // Expiration
    Map<String, dynamic> expirationMap = await sfQueryForSharedPrefData(
        fieldName: 'expiration', type: PreferencesDataType.STRING);
    if (expirationMap['found']) {
      _expirationController.text = expirationMap['expiration'];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool storeCard = false;
    Size size = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomWhiteCards(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: [
                Text(
                  'BILLING ADDRESS',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        letterSpacing: 0.55,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 21),
                BillingAddressSwitch(),
                SizedBox(height: 10),
              ],
            ),
            Container(
              height: 7,
              color: Color(0xFFF4F2F0),
            ),
            CustomWhiteCards(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: [
                Text(
                  'CARD DETAILS',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        letterSpacing: 0.55,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFormField(
                      placeHolder: 'CARD NUMBER',
                      label: '',
                      controller: _cardNumberController,
                      backgroundColor: Color(0xFFF4F2F0),
                      width: size.width * 0.84,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomFormField(
                      placeHolder: 'MONTH / YEAR',
                      width: size.width * 0.45,
                      label: '',
                      controller: _expirationController,
                      backgroundColor: Color(0xFFF4F2F0),
                    ),
                    CustomFormField(
                      placeHolder: 'CVC',
                      width: size.width * 0.35,
                      label: '',
                      controller: _cvvController,
                      backgroundColor: Color(0xFFF4F2F0),
                    ),
                  ],
                ),
                SizedBox(height: 29),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardScanButton(),
                    CardStoreCheckBox(
                      callback: (bool val) {
                        storeCard = val;
                      },
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 9,
              color: Color(0xFFF4F2F0),
            ),
            CustomWhiteCards(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              child: [
                CompleteOrder(
                  onPress: () async {
                    if (storeCard) {
                      _storeCard();
                    }
                    Navigator.of(context).pop();
                    callback({
                      "card_number": "${_cardNumberController.value.text}",
                      "expiration_date": "${_expirationController.value.text}",
                      "cvv": "${_cvvController.value.text}",
                    });
                  },
                ),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By continuing you accept Sofiqes ',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.black,
                            fontSize: 10,
                            letterSpacing: 0.4,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL();
                      },
                      child: Text(
                        'sales terms',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.black,
                              fontSize: 10,
                              letterSpacing: 0.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  final String salesPolicyUrl =
      'https://www.apple.com/in/shop/browse/open/salespolicies';

  void _launchURL() async {
    await launch(salesPolicyUrl);
  }
}

class CompleteOrder extends StatefulWidget {
  final Future<void> Function() onPress;
  CompleteOrder({Key? key, required this.onPress}) : super(key: key);

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CapsuleButton(
        onPress: () async {
          try {
            widget.onPress();
          } catch (e) {
            print(e);
            rethrow;
          }
        },
        child: Text(
          'CONFIRM',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
