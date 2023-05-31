import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key? key,
    required this.text,
    required this.press,
    required this.width,
    this.color = kPrimaryColor,
  }) : super(key: key);

  final String text;
  final Function press;
  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: color,
        ),
        onPressed: press as void Function()?,
        child: Text(
          "$text",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
