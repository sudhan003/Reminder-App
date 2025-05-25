import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../colors/color.dart';
import '../getx_operations/auth_controller.dart';

class CustomCodePicker extends StatelessWidget {
  const CustomCodePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _selectedCountryCode;
    return Container(
      width: 50,
      // margin: const EdgeInsets.symmetric(vertical: 10),
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      // width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: CountryCodePicker(
        textStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.white,
        initialSelection: 'IN',
        alignLeft: true,
        favorite: const ['+91', 'IN'],
        onChanged: (countryCode) {
          _selectedCountryCode = countryCode.toString();
          // AuthController.instance.countryCodeController.text =
          //     _selectedCountryCode;
        },
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
      ),
    );
  }
}
