import 'package:flutter/cupertino.dart';

void showDatePickerDialog(BuildContext context ,Widget child) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 400,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
