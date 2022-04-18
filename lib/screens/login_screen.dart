import 'package:flutter/material.dart';
import 'package:sofiqe/widgets/account/login_page.dart';
import 'package:sofiqe/widgets/png_icon.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Login',
          style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 0.6),
        ),
      ),
      body: LoginPage(),
    );
  }
}
