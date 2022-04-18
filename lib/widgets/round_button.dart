import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double size;
  final Function onPress;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  const RoundButton({
    Key? key,
    this.size = 24,
    required this.onPress,
    required this.child,
    this.padding,
    this.backgroundColor = Colors.black,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size)),
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Container(
          width: size,
          height: size,
          margin: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size)),
            border: Border.all(color: borderColor != null ? borderColor as Color : backgroundColor as Color),
            color: backgroundColor,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
