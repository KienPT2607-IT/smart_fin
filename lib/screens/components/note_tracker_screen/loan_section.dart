import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/friend_card.dart';

class LoanSection extends StatefulWidget {
  final int sectionType;
  final List<FriendCard> friendCardList;
  final Function onSelected;
  const LoanSection({
    super.key,
    required this.sectionType,
    required this.friendCardList,
    required this.onSelected,
  });

  @override
  State<LoanSection> createState() => _LoanSectionState();
}

class _LoanSectionState extends State<LoanSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "decide financial role here",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: () {
                showCustomBottomSheet(
                  context,
                  widget.sectionType,
                  widget.friendCardList,
                );
              },
              icon: const Icon(IconlyLight.category),
            ),
          ],
        ),
        
      ],
    );
  }
}
