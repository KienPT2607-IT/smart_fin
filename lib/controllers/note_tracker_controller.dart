class NoteTrackerController {
  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Amount is required";
    }
    if (",".allMatches(value).length > 1) {
      return "Invalid amount";
    }
    return null;
  }
}