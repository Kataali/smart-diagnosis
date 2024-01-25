import 'package:flutter/material.dart';

class NameData extends ChangeNotifier {
  String username = "";

  void updateName(String newName) {
    username = newName;
    notifyListeners();
  }
}
