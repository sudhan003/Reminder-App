import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/login_page.dart';

import '../colors/color.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // model model = model.instance;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return Consumer<AuthenticationProvider>(
            builder: (context, model, _) {
              return Scaffold(
                backgroundColor: bodyColor,
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sign up',
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
                          controller: nameController,
                        ),
                        CustomTextField(
                          hintText: 'Email',
                          iconData: Icons.email,
                          controller: model.emailController,
                        ),
                        CustomTextField(
                          hintText: 'Password',
                          iconData: Icons.lock,
                          controller: model.passwordController,
                        ),
                        CustomButton(
                          text: 'Submit',
                          onPress: () {
                            model.signUp(context);
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
                              onPressed: () {},
                              backgroundColor: buttonColor,
                              child: Image.asset(
                                'assets/icons/phone1.png',
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => LoginPage()));
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: redColor),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
