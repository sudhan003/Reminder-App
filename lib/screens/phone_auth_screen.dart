import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/getx_operations/auth_controller.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/signup.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_code_picker.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  // model model = model.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: appBarColor,
          ),
          backgroundColor: bodyColor,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Phone Number',
                      style: GoogleFonts.kanit(
                          textStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: redColor))),
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: CustomCodePicker(),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            hintText: 'Phone Number',
                            iconData: Icons.phone,
                            controller: model.phoneNumberController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: 'Send OTP',
                    onPress: () {
                      model.verifyPhoneNumber(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
