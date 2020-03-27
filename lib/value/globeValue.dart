class DirectoryStack {
  static List<String> stack = List();

  static bool get isEmpty => stack.isEmpty;

  static void push(String value) {
    stack.add(value);
  }

  static String pop() {
    if (!isEmpty) {
      String result = stack.last;
      stack.removeLast();
      return result;
    }
    return null;
  }
}
