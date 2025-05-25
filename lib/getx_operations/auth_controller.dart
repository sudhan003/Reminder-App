// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import 'package:timer_snackbar/timer_snackbar.dart';
// import 'package:todo_app/model.dart';
// import 'package:todo_app/screens/home_page.dart';
// import 'package:todo_app/screens/login_page.dart';
// import 'package:todo_app/screens/otp_verification.dart';
//
// class AuthController extends GetxController {
//   static AuthController instance = Get.find();
//
//   late Rx<User?> _user;
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//   GoogleSignIn googleSignIn = GoogleSignIn();
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//   @override
//   void onReady() {
//     _user = Rx<User?>(auth.currentUser);
//     _user.bindStream(auth.userChanges());
//     super.onReady();
//
//     ever(_user, _initialScreen);
//   }
//
//   String? userNumber;
//
//   _initialScreen(User? user) {
//     userNumber = user?.phoneNumber;
//     if (user == null) {
//       Get.offAll(() => const LoginPage());
//     } else {
//       Get.offAll(() => HomePage());
//     }
//   }
//
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   UserCredential? userCredential;
//
//   signUp() async {
//     try {
//       userCredential = await auth.createUserWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//       await userCredential?.user!.sendEmailVerification();
//     } on FirebaseException catch (e) {
//       Get.snackbar(
//         'about user',
//         'usermessage',
//         snackPosition: SnackPosition.BOTTOM,
//         titleText: const Text("verification"),
//         messageText: Text(e.message!),
//         backgroundColor: Colors.greenAccent,
//       );
//     }
//   }
//
//   signIn() async {
//     try {
//       userCredential = await auth.signInWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//     } on FirebaseException catch (e) {
//       Get.snackbar(
//         'about user',
//         'usermessage',
//         snackPosition: SnackPosition.BOTTOM,
//         titleText: const Text("verification"),
//         messageText: Text(e.message!),
//         backgroundColor: Colors.greenAccent,
//       );
//     }
//   }
//
//   var countryCodeController = TextEditingController(text: '+91');
//   var phoneNumberController = TextEditingController();
//   String? verificationId;
//
//   Future<void> verifyPhoneNumber(BuildContext context) async {
//     try {
//       await auth.verifyPhoneNumber(
//           phoneNumber:
//           countryCodeController.text + phoneNumberController.text.trim(),
//           timeout: const Duration(seconds: 50),
//           verificationCompleted: (AuthCredential authCredential) {
//             Get.snackbar(
//               'about user',
//               'usermessage',
//               snackPosition: SnackPosition.BOTTOM,
//               titleText: const Text("verification"),
//               messageText: const Text("verification Completed"),
//               backgroundColor: Colors.greenAccent,
//             );
//           },
//           verificationFailed: (FirebaseException exception) {
//             Get.snackbar('about user', 'usermessage',
//                 snackPosition: SnackPosition.BOTTOM,
//                 titleText: const Text("verification"),
//                 messageText: const Text("verification failed"),
//                 backgroundColor: Colors.redAccent);
//           },
//           codeSent: (String? verId, int? forceCodeResent) {
//             Get.snackbar('about user', 'usermessage',
//                 snackPosition: SnackPosition.BOTTOM,
//                 titleText: const Text("verification"),
//                 messageText: const Text("Code sent successfully"),
//                 backgroundColor: Colors.greenAccent);
//
//             verificationId = verId;
//             Get.to(() => const OtpVerification());
//           },
//           codeAutoRetrievalTimeout: (verId) {});
//     } on FirebaseException catch (e) {
//       Get.snackbar('about user', 'usermessage',
//           snackPosition: SnackPosition.BOTTOM,
//           titleText: const Text("error"),
//           messageText: Text(e.message!),
//           backgroundColor: Colors.redAccent);
//     }
//   }
//
//   Future<void> resendOTP(BuildContext context) async {
//     resendCode();
//     try {
//       await auth.verifyPhoneNumber(
//           phoneNumber:
//           countryCodeController.text + phoneNumberController.text.trim(),
//           timeout: const Duration(seconds: 50),
//           verificationCompleted: (AuthCredential authCredential) {
//             Get.snackbar('about user', 'usermessage',
//                 snackPosition: SnackPosition.BOTTOM,
//                 titleText: const Text("verification"),
//                 messageText: const Text("verification Completed"),
//                 backgroundColor: Colors.greenAccent);
//           },
//           verificationFailed: (FirebaseException exception) {
//             Get.snackbar('about user', 'usermessage',
//                 snackPosition: SnackPosition.BOTTOM,
//                 titleText: const Text("verification"),
//                 messageText: const Text("verification failed"),
//                 backgroundColor: Colors.redAccent);
//           },
//           codeSent: (String? verId, int? forceCodeResent) {
//             Get.snackbar('about user', 'usermessage',
//                 snackPosition: SnackPosition.BOTTOM,
//                 titleText: const Text("verification"),
//                 messageText: const Text("Code sent successfully"),
//                 backgroundColor: Colors.redAccent);
//             TaskModel taskModel;
//             verificationId = verId;
//             Get.to(() => HomePage());
//           },
//           codeAutoRetrievalTimeout: (verId) {});
//     } on FirebaseException catch (e) {
//       Get.snackbar('about user', 'usermessage',
//           snackPosition: SnackPosition.BOTTOM,
//           titleText: const Text("error"),
//           messageText: Text(e.message!),
//           backgroundColor: Colors.redAccent);
//     }
//   }
//
//   resendCode() {
//     _invalidCodeCount = 0;
//   }
//
//   signOut() async {
//     await auth.signOut();
//   }
//
//   int _invalidCodeCount = 0;
//   bool _isTimerRunning = false;
//   Timer? _timer;
//
//   void _showInvalidCodeSnackbar(BuildContext context) {
//     _invalidCodeCount++;
//
//     if (_invalidCodeCount >= 5 && !_isTimerRunning) {
//       _isTimerRunning = true;
//
//       // start timer
//       _timer = Timer(const Duration(seconds: 10), () {
//         _isTimerRunning = false;
//         _invalidCodeCount = 0;
//         _stopTimer();
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: timerSnackbar(
//           context: context,
//           contentText: "Too many attempts. Try again later",
//           afterTimeExecute: () =>
//               Get.snackbar('about user', 'usermessage',
//                   snackPosition: SnackPosition.BOTTOM,
//                   titleText: const Text("permission:"),
//                   messageText: const Text(
//                     "Enter otp now",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   backgroundColor: Colors.greenAccent),
//           second: 10,
//         ),
//       ));
//     } else {
//       String message = "Invalid code. ";
//       int remainingAttempts = 5 - _invalidCodeCount;
//       if (remainingAttempts <= 0) {
//         return;
//       } else if (remainingAttempts == 1) {
//         Get.snackbar('about user', 'usermessage',
//             snackPosition: SnackPosition.BOTTOM,
//             titleText: const Text("Attempts"),
//             messageText: Text(message += '1 attempt remaining.'),
//             backgroundColor: Colors.redAccent);
//       } else {
//         Get.snackbar('about user', 'usermessage',
//             snackPosition: SnackPosition.BOTTOM,
//             titleText: const Text("Attempts"),
//             messageText:
//             Text(message += '$remainingAttempts attempts remaining.'),
//             backgroundColor: Colors.redAccent);
//       }
//     }
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//     _isTimerRunning = false;
//     _invalidCodeCount = 0;
//   }
//
//   String? name;
//   String? emailId;
//
//   Future<void> signInWithGoogle(BuildContext context) async {
//     GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//     if (googleSignInAccount != null) {
//       try {
//         GoogleSignInAuthentication? googleSignInAuthentication =
//         await googleSignInAccount.authentication;
//         AuthCredential? authCredential = GoogleAuthProvider.credential(
//             accessToken: googleSignInAuthentication.accessToken,
//             idToken: googleSignInAuthentication.idToken);
//         await auth.signInWithCredential(authCredential);
//         name = googleSignInAccount.displayName;
//         emailId = googleSignInAccount.email;
//         // final prefs = await SharedPreferences.getInstance();
//         // await prefs.setString('name', name ?? '');
//         // await prefs.setString('emailId', emailId ?? '');
//         print(googleSignInAccount.photoUrl);
//       } on FirebaseException catch (e) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.message!)));
//       }
//     } else {
//       Fluttertoast.showToast(msg: "No account Selected");
//     }
//   }
//
//   var otpNumberController = TextEditingController();
//
//   void signinWithPhone(BuildContext context) async {
//     try {
//       await auth.signInWithCredential(PhoneAuthProvider.credential(
//           verificationId: verificationId!, smsCode: otpNumberController.text));
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-verification-code') {
//         _showInvalidCodeSnackbar(context);
//       } else {
//         _showInvalidCodeSnackbar(context);
//       }
//     }
//   }
// }
