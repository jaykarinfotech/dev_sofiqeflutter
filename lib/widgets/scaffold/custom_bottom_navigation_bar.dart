import 'package:flutter/material.dart';
// Utils
import 'package:sofiqe/utils/constants/app_colors.dart';
// Custom packages
import 'package:sofiqe/widgets/png_icon.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      /* (int newIndex) {
        switch (newIndex) {
          case 0:
            Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
            break;
          case 1:
            break;
          case 2:
            Navigator.pushReplacementNamed(context, RouteNames.catalogScreen);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, RouteNames.makeOverScreen);
            break;
          case 4:
            break;
        }
        // setState(() {
        //   _currentIndex = newIndex;
        // });
       },*/
      selectedFontSize: 12,
      selectedItemColor: AppColors.navigationBarSelectedColor,
      unselectedItemColor: AppColors.navigationBarUnselectedColor,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: PngIcon(image: 'assets/icons/bottom-navigation-bar-home-selected.png'),
          icon: PngIcon(image: 'assets/icons/bottom-navigation-bar-home.png'),
          label: 'HOME',
        ),
        BottomNavigationBarItem(
          activeIcon: PngIcon(image: 'assets/icons/bottom-navigation-bar-shop-selected.png'),
          icon: PngIcon(image: 'assets/icons/bottom-navigation-bar-shop.png'),
          label: 'SHOP',
        ),
        BottomNavigationBarItem(
          activeIcon: PngIcon(image: 'assets/icons/bottom-navigation-bar-makeover-selected.png'),
          icon: PngIcon(image: 'assets/icons/bottom-navigation-bar-makeover.png'),
          label: 'MAKEOVER',
        ),
        BottomNavigationBarItem(
          activeIcon: PngIcon(image: 'assets/icons/bottom-navigation-bar-mysofiqe-selected.png'),
          icon: PngIcon(image: 'assets/icons/bottom-navigation-bar-mysofiqe.png'),
          label: 'MYSOFIQE',
        ),
      ],
    );
  }
}
