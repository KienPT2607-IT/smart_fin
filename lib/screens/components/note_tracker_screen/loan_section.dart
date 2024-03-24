import 'package:flutter/material.dart';

class LoanSection extends StatefulWidget {
  Function onSelected;
  LoanSection({super.key, required this.onSelected});

  @override
  State<LoanSection> createState() => _LoanSectionState();
}

class _LoanSectionState extends State<LoanSection> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}