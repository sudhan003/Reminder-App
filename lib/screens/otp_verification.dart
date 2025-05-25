import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/getx_operations/auth_controller.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/signup.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  // model model = model.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, model, _) {
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
                Text('OTP',
                    style: GoogleFonts.kanit(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: redColor))),
                SizedBox(
                  height: 70,
                ),
                CustomTextField(
                  hintText: 'OTP',
                  iconData: Icons.key,
                  controller: model.otpNumberController,
                ),
                CustomButton(
                  text: 'Submit',
                  onPress: () {
                    model.signinWithPhone(context);
                  },
                ),
                CustomButton(
                  text: 'Resend OTP',
                  onPress: () {
                    model.resendOTP(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
