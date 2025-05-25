import 'package:flutter/material.dart';
import 'package:todo_app/colors/color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPress;

  const CustomButton({Key? key, required this.text, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      // width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            // primary: buttonColor,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );;
  }
}
