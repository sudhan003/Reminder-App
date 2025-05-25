// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class taskWidget extends StatelessWidget {
//   const taskWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//               const SizedBox(
//                 width: 30,
//               ),
//               IconButton(
//                   onPressed: () async {
//                     await FirebaseFirestore.instance
//                         .collection("tasks")
//                         .doc()
//                         .delete();
//                   },
//                   icon: Icon(Icons.delete))
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 10),
//             child: Column(
//               children: [
//                 Text(taskMod),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
