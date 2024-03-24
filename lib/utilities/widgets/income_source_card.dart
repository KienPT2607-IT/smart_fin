import 'package:flutter/material.dart';

class IncomeSouseCard extends StatelessWidget {
  const IncomeSouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 150,
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
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income source",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
