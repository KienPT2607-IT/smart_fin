import 'package:flutter/material.dart';

class IncomeSection extends StatefulWidget {
  Function onSelected;
  IncomeSection({super.key, required this.onSelected});
  
  @override
  State<IncomeSection> createState() => _IncomeSectionState();
}

class _IncomeSectionState extends State<IncomeSection> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
