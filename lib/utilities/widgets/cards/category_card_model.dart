import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/data/models/category.dart';

class CategoryModelCard extends StatelessWidget {
  final Category category;

  const CategoryModelCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(category.color),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(10),
        color: category.status ? Colors.white : Colors.grey[100],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              category.icon,
              width: 24,
              color: Color(category.color),
            ),
          ),
          const Gap(10),
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              category.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
