class PalindromeModel {
  static bool isPalindrome(String text) {
    final sanitizedText = text.replaceAll(' ', '').toLowerCase();
    final reversedText = sanitizedText.split('').reversed.join('');
    return sanitizedText == reversedText;
  }
}
