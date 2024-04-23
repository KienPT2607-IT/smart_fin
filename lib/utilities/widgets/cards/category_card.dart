import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/data/models/category.dart';
import 'package:smart_fin/utilities/constants/constants.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(category.color),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            (category.icon.isNotEmpty)
                ? category.icon
                : Constant.defaultLightIcons["tag"]!,
            width: 16,
            color: Color(category.color),
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
