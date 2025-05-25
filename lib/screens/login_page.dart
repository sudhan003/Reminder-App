import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/phone_auth_screen.dart';
import 'package:todo_app/screens/signup.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return Consumer<AuthenticationProvider>(builder: (context, model, _) {
            return Scaffold(
              backgroundColor: bodyColor,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('LOGIN',
                          style: GoogleFonts.kanit(
                              textStyle: const TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  color: redColor))),
                      const SizedBox(
                        height: 70,
                      ),
                      CustomTextField(
                          hintText: 'Name',
                          iconData: Icons.person,
                          controller: model.emailController),
                      CustomTextField(
                        hintText: 'Password',
                        iconData: Icons.lock,
                        controller: model.passwordController,
                      ),
                      CustomButton(
                        text: 'Submit',
                        onPress: () {
                          model.signIn(context);
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => HomePage()));
                        },
                      ),
                      const Text('----------or----------'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              model.signInWithGoogle(context);
                            },
                            backgroundColor: buttonColor,
                            child: Image.asset(
                              'assets/icons/google.png',
                              height: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PhoneAuthScreen()));
                            },
                            backgroundColor: buttonColor,
                            child: Image.asset(
                              'assets/icons/phone1.png',
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dont't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUpPage()));
                            },
                            child: const Text(
                              'Signup',
                              style: TextStyle(color: redColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
