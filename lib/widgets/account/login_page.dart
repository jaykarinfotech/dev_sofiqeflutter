// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/utils/api/user_account_api.dart';
import 'package:sofiqe/widgets/capsule_button.dart';
import 'package:sofiqe/widgets/custom_form_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // return super.toString(minLevel: DiagnosticLevel.info);
    return 'LOGINPAGE';
  }

  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);

    ///todo: uncomment
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final PageProvider pp = Get.find();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height - AppBar().preferredSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LoginForm(
                userNameController: userNameController,
                passwordController: passwordController,
              ),
            ),
            LoginButton(
              login: () {
                _login(context);
              },
              emailController: userNameController,
              passwordController: passwordController,
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext c) async {
    if (await Provider.of<AccountProvider>(c, listen: false).login(
        '${userNameController.value.text}',
        '${passwordController.value.text}')) {
      makeOverProvider.tryitOn.value = true;
      profileController.screen.value = 0;
      Navigator.pop(c);
      pp.goToPage(Pages.MAKEOVER);
      Provider.of<CartProvider>(context, listen: false).fetchCartDetails();
    } else {
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(
        content: Text('Incorrect Username or Password'),
      ));
    }
  }
}

class LoginForm extends StatelessWidget {
  LoginForm(
      {Key? key,
      required this.userNameController,
      required this.passwordController})
      : super(key: key);
  final TextEditingController userNameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Color(0xFFF4F2F0),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.07),
          Text(
            'WELCOME BACK',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                  letterSpacing: 0.55,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: size.height * 0.07),
          CustomFormField(
            label: 'USER NAME',
            controller: userNameController,
            width: size.width * 0.8,
            height: size.height * 0.07,
          ),
          SizedBox(height: size.height * 0.033),
          CustomFormField(
            obscure: true,
            label: 'PASSWORD',
            controller: passwordController,
            width: size.width * 0.8,
            height: size.height * 0.07,
          ),
          SizedBox(height: size.height * 0.033),
          Container(
            child: GestureDetector(
              onTap: () async {
                if (userNameController.value.text.isEmail) {
                  try {
                    bool success =
                        await sfAPIResetPassword(userNameController.value.text);
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext c) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: ResetPasswordMessage(),
                          );
                        },
                      );
                    }
                  } catch (err) {
                    print('Error resetting password: $err');
                    Map responseBody = json.decode(err as String);
                    if (responseBody['message'].compareTo(
                            'No such entity with %fieldName = %fieldValue, %field2Name = %field2Value') ==
                        0) {
                      Get.showSnackbar(
                        GetBar(
                          message: 'The account doesn\'t exist',
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Get.showSnackbar(
                        GetBar(
                          message: 'An unexpected error occurred',
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                } else {
                  Get.showSnackbar(
                    GetBar(
                      message: 'Enter a valid email address to reset password',
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: size.width * 0.8,
                child: Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.blue,
                        fontSize: size.height * 0.014,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  final Function login;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginButton(
      {Key? key,
      required this.login,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  initState() {
    super.initState();
    widget.emailController.addListener(rebuildOnChange);
    widget.passwordController.addListener(rebuildOnChange);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(rebuildOnChange);
    widget.passwordController.removeListener(rebuildOnChange);
    super.dispose();
  }

  void rebuildOnChange() {
    changed = true;
    setState(() {});
  }

  bool validate() {
    bool email = EmailValidator.validate(widget.emailController.value.text);
    bool password = widget.passwordController.value.text.length >= 8;

    return (email && password);
  }

  bool changed = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Color backgroundColor = Colors.black;
    bool empty = false;
    if (widget.emailController.value.text.isEmpty ||
        widget.passwordController.value.text.isEmpty) {
      backgroundColor = Colors.black38;
      empty = true;
    } else if (!validate()) {
      backgroundColor = Colors.black38;
      empty = true;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: size.width * 0.08),
      child: Center(
        child: CapsuleButton(
          width: size.width * 0.8,
          height: size.width * 0.17,
          backgroundColor: backgroundColor,
          borderColor: Colors.transparent,
          onPress: () {
            if (empty) {
              if (changed) {
                changed = false;
                Get.showSnackbar(GetBar(
                  message: 'Please enter a valid username and password',
                  duration: Duration(seconds: 2),
                ));
              }
            } else {
              if (changed) {
                changed = false;
                widget.login();
              }
            }
          },
          child: Text(
            'LOGIN',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.white, fontSize: 14, letterSpacing: 0.7),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordMessage extends StatelessWidget {
  const ResetPasswordMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.03),
      alignment: Alignment.center,
      height: size.height * 0.2,
      width: size.width * 0.4,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Color(0xFFF2CA8A),
          )),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                Text(
                  'sofiqe',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Color(0xFFF2CA8A),
                        fontSize: size.height * 0.04,
                        height: 1,
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Text(
            'An email has been sent with a link to reset your password',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                  fontSize: size.height * 0.02,
                ),
          ),
        ],
      ),
    );
  }
}
