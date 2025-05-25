import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/otp_verification.dart';

class AuthenticationProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  String? uid;

  void saveUidToFirebase() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    }
  }

  String? userNumber;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  UserCredential? userCredential;

  signUp(BuildContext context) async {
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await userCredential?.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.message!),
      //     backgroundColor: Colors.greenAccent,
      //   ),
      // );
    }
  }

  signIn(BuildContext context) async {
    try {
      debugPrint("🚨🚨🚨 email signin ${emailController.text}");

      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("user-email", emailController.text);
      String? email = pref.getString("user-email");
      debugPrint("🚨🚨🚨 email signin ${email}");
      debugPrint("🚨🚨🚨 email signin ${emailController.text}");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.greenAccent,
      ));
    }
  }

  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  String? verificationId;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber:
              countryCodeController.text + phoneNumberController.text.trim(),
          timeout: const Duration(seconds: 50),
          verificationCompleted: (AuthCredential authCredential) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("verification Completed"),
                backgroundColor: Colors.greenAccent,
              ),
            );
          },
          verificationFailed: (FirebaseException exception) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("verification failed"),
                  backgroundColor: Colors.redAccent),
            );
          },
          codeSent: (String? verId, int? forceCodeResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Code sent successfully"),
                  backgroundColor: Colors.greenAccent),
            );

            verificationId = verId;
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OtpVerification()));
          },
          codeAutoRetrievalTimeout: (verId) {});
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message!), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> resendOTP(BuildContext context) async {
    resendCode();
    try {
      await auth.verifyPhoneNumber(
          phoneNumber:
              countryCodeController.text + phoneNumberController.text.trim(),
          timeout: const Duration(seconds: 50),
          verificationCompleted: (AuthCredential authCredential) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text("verification Completed"),
                  backgroundColor: Colors.greenAccent),
            );
          },
          verificationFailed: (FirebaseException exception) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text("verification failed"),
                  backgroundColor: Colors.redAccent),
            );
          },
          codeSent: (String? verId, int? forceCodeResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text("Code sent successfully"),
                  backgroundColor: Colors.redAccent),
            );
            verificationId = verId;
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => HomePage()));
          },
          codeAutoRetrievalTimeout: (verId) {});
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message!), backgroundColor: Colors.redAccent),
      );
    }
  }

  resendCode() {
    _invalidCodeCount = 0;
  }

  signOut() async {
    await auth.signOut();
  }

  int _invalidCodeCount = 0;
  bool _isTimerRunning = false;
  Timer? _timer;

  void _showInvalidCodeSnackbar(BuildContext context) {
    _invalidCodeCount++;

    if (_invalidCodeCount >= 5 && !_isTimerRunning) {
      _isTimerRunning = true;

      // start timer
      _timer = Timer(const Duration(seconds: 10), () {
        _isTimerRunning = false;
        _invalidCodeCount = 0;
        _stopTimer();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: timerSnackbar(
        context: context,
        contentText: "Too many attempts. Try again later",
        afterTimeExecute: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text(
                "Enter otp now",
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.greenAccent),
        ),
        second: 10,
      )));
    } else {
      String message = "Invalid code. ";
      int remainingAttempts = 5 - _invalidCodeCount;
      if (remainingAttempts <= 0) {
        return;
      } else if (remainingAttempts == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(message += '1 attempt remaining.'),
              backgroundColor: Colors.redAccent),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(message += '$remainingAttempts attempts remaining.'),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    _invalidCodeCount = 0;
  }

  String? name;
  String? emailId;

  Future<void> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      try {
        GoogleSignInAuthentication? googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential? authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await auth.signInWithCredential(authCredential);
        name = googleSignInAccount.displayName;
        emailId = googleSignInAccount.email;
        // final prefs = await SharedPreferences.ScaffoldMessenger.of(context).(showSnaInstance();
        // await prefs.setString('name', name ?? '');
        // await prefs.setString('emailId', emailId ?? '');
        print(googleSignInAccount.photoUrl);
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      Fluttertoast.showToast(msg: "No account Selected");
    }
  }

  var otpNumberController = TextEditingController();

  void signinWithPhone(BuildContext context) async {
    try {
      await auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otpNumberController.text));
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _showInvalidCodeSnackbar(context);
      } else {
        _showInvalidCodeSnackbar(context);
      }
    }
  }
}
