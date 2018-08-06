abstract class Escape {
  static final RegExp replaceRegExp = new RegExp(r'&#(\d+?);');
  static String decode(String string) => string.replaceAllMapped(
      replaceRegExp, (match) => String.fromCharCode(int.parse(match.group(1))));
}
