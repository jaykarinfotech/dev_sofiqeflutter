import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluateScreen extends StatefulWidget {
  const EvaluateScreen({Key? key}) : super(key: key);

  @override
  _EvaluateScreenState createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Image.asset(
              "assets/icons/Path_11_1.png",
            ),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'EVALUATE',
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.white, fontSize: 25, letterSpacing: 2.5),
        ),
      ),
      body: Container(
        color: Colors.black,
        child:Column(
          children: [
            Container(),
          ],
        )
      ),
    );
  }
}
