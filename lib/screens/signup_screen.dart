import 'package:flutter/material.dart';
import 'package:sofiqe/widgets/account/signup_page.dart';
import 'package:sofiqe/widgets/png_icon.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: Transform.rotate(
            angle: 3.14159,
            child: PngIcon(
              image: 'assets/icons/arrow-2.png',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'sofiqe',
          style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Colors.black,
                fontSize: AppBar().preferredSize.height * 0.5,
                letterSpacing: 0.6,
              ),
        ),
      ),
      body: SignupPage(),
    );
  }
}
