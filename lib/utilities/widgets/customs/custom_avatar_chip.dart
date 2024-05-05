import 'package:flutter/material.dart';

class CustomAvatarChip extends StatelessWidget {
  final String avatar;
  final String name;
  final Color borderColor;
  final double width;
  const CustomAvatarChip({
    super.key,
    required this.avatar,
    required this.name,
    this.borderColor = Colors.black,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 135,
      ),
      child: Chip(
        padding: const EdgeInsets.all(6),
        avatar: CircleAvatar(
          radius: 12,
          child: Text(avatar),
        ),
        labelPadding: const EdgeInsets.all(5),
        label: Text(name),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: width),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
