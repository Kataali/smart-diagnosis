import 'package:flutter/material.dart';

class NameData extends ChangeNotifier {
  String username = "";
  String userId = "";

  void updateName(String newName) {
    username = newName;
    notifyListeners();
  }

  void updateId(String id) {
    userId = id;
    notifyListeners();
  }
}
