import 'package:flutter/material.dart';

class LoanSelectorCard extends StatelessWidget {
  final String selector;
  const LoanSelectorCard({super.key, required this.selector});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 143,
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Text(selector),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                backgroundImage: const AssetImage(
                  "assets/images/avatars/2.jpg",
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
            ),
            const Text("Add Loan"),
          ],
        ));
  }
}
