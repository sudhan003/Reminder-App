import 'package:flutter/material.dart';

import '../colors/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  const CustomTextField({Key? key, required this.hintText,required this.iconData, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 5,right: 20,left: 20,bottom: 5),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        // width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color:appBarColor,
          borderRadius: BorderRadius.circular(29),
        ),
        child:  TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.start,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.white),
            icon:  Icon(iconData,
              color: Colors.white,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
