import 'package:flutter/foundation.dart';

import '../models/vital_model.dart';

class VitalsProvider extends ChangeNotifier {
  List<Vital> _vitalList = [];

  //Class Methods
  void addVital(Vital vital) {
    _vitalList.add(vital);
    notifyListeners();
  }

  void mergeWithVitalList(List<Vital> newVitals) {
    _vitalList.addAll(newVitals);
    notifyListeners();
  }

  void emptyVitalsList() {
    _vitalList.clear();
  }

  //Class Getters
  Vital getVitalByIndex(int index) => _vitalList[index];
  int get vitalListLength => _vitalList.length;
}
