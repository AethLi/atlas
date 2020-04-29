class UserActionStack {
  List<UserAction> stack = [UserAction()];

  bool get isEmpty => stack.isEmpty;

  void push(UserAction value) {
    stack.add(value);
  }

  UserAction pop() {
    if (!isEmpty) {
      UserAction result = stack.last;
      stack.removeLast();
      return result;
    }
    return null;
  }
}

enum UserActionType { FILE, HOST, START }

class UserAction {
  final UserActionType type;
  final String currentPath;

  UserAction({this.type = UserActionType.START, this.currentPath});
}
