String? getTextFromPrompt({required String prompt}) {
  final regex = RegExp(r'<(.*?)>');
  final match = regex.firstMatch(prompt);

  if (match != null) {
    final question = match.group(1);
    return question;
  } else {
    return null;
  }
}
