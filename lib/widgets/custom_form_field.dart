import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double height;
  final double width;
  final Color backgroundColor;
  final Widget? prefix;
  final Widget? backgroundWidget;
  final String placeHolder;
  final bool active;
  final Function? onTap;
  final bool obscure;
  final Function? onChange;
  final double? space;

  const CustomFormField({
    Key? key,
    required this.label,
    required this.controller,
    this.height = 50,
    this.width = 200,
    this.backgroundColor = Colors.white,
    this.prefix,
    this.backgroundWidget,
    this.placeHolder = '',
    this.active = true,
    this.onTap,
    this.obscure = false,
    this.onChange,this.space
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
          ),
          SizedBox(height: space ?? 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              // padding: EdgeInsets.all(10),
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: backgroundColor,
              ),
              child: GestureDetector(
                child: CupertinoTextField(
                  onChanged: onChange == null ? (val) {} : onChange as Function(String),
                  obscureText: obscure,
                  enabled: active,
                  placeholder: '$placeHolder',
                  placeholderStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Color(0xFFD0C5C5),
                        fontSize: size.height * 0.025,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.bold,
                      ),
                  prefix: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Center(
                      child: prefix,
                    ),
                  ),
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: size.height * 0.025,
                        letterSpacing: 0.5,
                      ),
                  controller: controller,
                  decoration: BoxDecoration(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
