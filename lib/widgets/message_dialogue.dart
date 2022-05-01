
// import 'package:flutter/material.dart';

// Future<void> showMessage(
//     context, String message, Icon title, String identity) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: true, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Center(
//           child: title,
//         ),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text(
//                 identity,
//                 style: TextStyle(color: calmSpaceDark(.4)),
//               ),
//               Text(message),
//             ],
//           ),
//         ),
        
//         actions: <Widget>[
//           Container(
//             // padding: EdgeInsets.all(8),
//             decoration: allRound(radius: 16, color: calmSpaceDark(1)),
//             child: TextButton(
//                 child: Text(
//                   'Got it!',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 }),
//           ),
//         ],
//       );
//     },
//   );
// }
