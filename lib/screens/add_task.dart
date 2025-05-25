// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
// import 'package:firestore_crud/model/user.dart';
// import 'package:todo_app/model.dart';
//
// class AddNewUserScreen extends StatefulWidget {
//   final TaskModel? user;
//   const AddNewUserScreen({Key? key, this.user}) : super(key: key);
//
//   @override
//   State<AddNewUserScreen> createState() => _AddNewUserScreenState();
// }
//
// class _AddNewUserScreenState extends State<AddNewUserScreen> {
//   final _formKey = GlobalKey<FormState>();
//   // final emailRegExp = RegExp(
//   //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//   // TextEditingController usernameController = TextEditingController();
//   // TextEditingController emailController = TextEditingController();
//   // TextEditingController phoneNumberController = TextEditingController();
//   //
//   // bool isLoading = false;
//   // // must call this function and make action on button
//   // sendUserToFirebase() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   final response = await FirebaseFirestore.instance.collection("users").add({
//   //     "name": usernameController.text,
//   //     "email": emailController.text,
//   //     "phone_number": phoneNumberController.text
//   //   });
//   //
//   //   usernameController = TextEditingController();
//   //   emailController = TextEditingController();
//   //   phoneNumberController = TextEditingController();
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   //   print(response.path);
//   //   print(response.id);
//   // }
//   //
//   // updateUser() async{
//   //   try{
//   //     await FirebaseFirestore.instance
//   //         .collection("users")
//   //         .doc(widget.user!.docId)
//   //         .update({
//   //       "name": usernameController.text,
//   //       "email": emailController.text,
//   //       "phone_number": phoneNumberController.text
//   //     });
//   //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Updated successfully'),backgroundColor: Colors.green,));
//   //   }catch(e){
//   //     Text(e.toString());
//   //   }
//   // }
//   // @override
//   // void initState() {
//   //   if (widget.user != null) {
//   //     usernameController = TextEditingController(text: widget.user!.username);
//   //     emailController = TextEditingController(text: widget.user!.email);
//   //     phoneNumberController =
//   //         TextEditingController(text: widget.user!.phoneNumber);
//   //     super.initState();
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add new user',
//           style: (TextStyle(color: Colors.black)),
//         ),
//         backgroundColor: Colors.yellow,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//           child: Column(
//             children: [
//               TextFormField(
//                 // controller: usernameController,
//                 cursorColor: Colors.black,
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   } else {
//                     return null;
//                   }
//                 },
//                 decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.person),
//                     hintText: 'Username',
//                     labelText: 'Username',
//                     filled: true,
//                     fillColor: Colors.black12,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 // controller: emailController,
//                 cursorColor: Colors.black,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   } else if (!emailRegExp.hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   } else {
//                     return null;
//                   }
//                 },
//                 decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.email),
//                     hintText: 'Email',
//                     labelText: 'Email',
//                     filled: true,
//                     fillColor: Colors.black12,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: phoneNumberController,
//                 cursorColor: Colors.black,
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a phone number';
//                   } else if (value.length < 10) {
//                     return 'Enter a valid phone number';
//                   } else {
//                     return null;
//                   }
//                 },
//                 decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.phone),
//                     hintText: 'Phone Number',
//                     labelText: 'Phone Number',
//                     filled: true,
//                     fillColor: Colors.black12,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               ),
//               const SizedBox(height: 20),
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : MaterialButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     if (widget.user != null) {
//                       updateUser();
//                       print('edit user');
//                     } else {
//                       sendUserToFirebase();
//                       print('add new user');
//                     }
//                   } else {}
//                 },
//                 color: Colors.yellow,
//                 child: Text(widget.user != null?'Edit user':'Add user'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
