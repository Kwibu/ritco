import 'package:flutter/material.dart';

class FeedInterest extends StatelessWidget {
  const FeedInterest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            child: Row(
              children: const [
                Text(
                  "Interest",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(161, 103, 165, 1)),
                ),
                Text(
                  " |Technology",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(161, 103, 165, 1)),
                )
              ],
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                child: Image.asset("assets/avatars/Rectangle 17.png"),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.74,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Accusamus qui quos eligendi minima doloremque sapiente modi, voluptates consequuntur rependerit optio ea perspiciatiseos aperiam? Soluta.",
                  style: TextStyle(height: 1.5),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            height: 1,
            color: Colors.black45,
          )
        ],
      ),
    );
  }
}
