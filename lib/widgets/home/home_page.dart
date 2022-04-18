import 'package:flutter/material.dart';
import 'package:sofiqe/widgets/home/h1a.dart';
import 'package:sofiqe/widgets/home/h1b.dart';
import 'package:sofiqe/widgets/home/h1c.dart';
import 'package:sofiqe/widgets/home/h1de.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return PageView(
    //   scrollDirection: Axis.vertical,
    //   children: [
    //     Container(
    //       height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
    //       child: H1A(),
    //     ),
    //     Container(
    //       height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
    //       child: H1B(),
    //     ),
    //     Container(
    //       height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
    //       child: H1C(),
    //     ),
    // Container(
    //   height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
    //   child: H1DE(),
    // ),
    //   ],
    // );
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
              color: Color(0xFFF8F8F8),
              child: H1A(),
            ),
            Container(
              height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
              color: Colors.green,
              child: H1B(),
            ),
            Container(
              height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
              color: Colors.blue,
              child: H1C(),
            ),
            Container(
              height: size.height - AppBar().preferredSize.height - 56 - MediaQuery.of(context).padding.bottom,
              child: H1DE(),
            ),
          ],
        ),
      ),
    );
  }
}
