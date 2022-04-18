// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/provider/try_it_on_provider.dart';
import 'package:sofiqe/screens/Ms1/ms1_profile.dart';
import 'package:sofiqe/screens/catalog_screen.dart';
import 'package:sofiqe/screens/home_screen.dart';
import 'package:sofiqe/screens/make_over_screen.dart';
import 'package:sofiqe/screens/try_it_on_screen.dart';
import 'package:sofiqe/widgets/scaffold/custom_bottom_navigation_bar.dart';

class ScaffoldTemplate extends StatefulWidget {
  final Widget child;
  final int index;
  ScaffoldTemplate({required this.child, this.index = 0});

  @override
  _ScaffoldTemplateState createState() => _ScaffoldTemplateState();
}

class _ScaffoldTemplateState extends State<ScaffoldTemplate> {
  late int index = widget.index;
  PageController pageController = PageController();
  List<Widget> body = [
    HomeScreen(),
    CatalogScreen(),
    MakeOverScreen(),
    Ms1Profile(),
//   MySofiqe(),
  ];

  final PageProvider pp = Get.find();
  final TryItOnProvider tiop = Get.find();

  @override
  void initState() {
    super.initState();
    pp.onTapCallback = onTap;
  }

  void onTap(int index) async {
    setState(() {
      this.index = index;
    });
    pageController.animateToPage(index,
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    ///todo: uncomment
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          allowImplicitScrolling: false,
          children: body,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: index,
          onTap: onTap,
        ),
      ),
    );
  }
}
