import 'package:flutter/material.dart';

appBarController(
    BuildContext context, goToUserHandler, name, bgColor, color, textColor) {
  return AppBar(
    elevation: 0,
    backgroundColor: bgColor,
    foregroundColor: color,
    centerTitle: true,
    title: Text(name,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    actions: [
      Container(
        width: 50,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: InkWell(
            onTap: goToUserHandler,
            // child: IconButton(
            //     onPressed: addNewPatient,
            //     icon: const Icon(
            //       Icons.person_add,
            //       color: Colors.blue,
            //     )),
          ),
        ),
      )
    ],
  );
}
