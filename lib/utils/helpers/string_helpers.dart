class StringHelpers {
  static const _diacritics = 'ĂăÂâÎîȘșȚț';
  static const _alternatives = 'AaAaIiSsTt';

  static String removeDiacritics(String input) {
    for (int i = 0; i < _diacritics.length; i++) {
      input = input.replaceAll(_diacritics[i], _alternatives[i]);
    }

    return input;
  }

  static int getIntegerFromString(String input) => int.parse(input.replaceAll(RegExp(r'[^0-9]'), ''));
}
