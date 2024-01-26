import 'package:flutter/material.dart';

import '../models/vital_data.dart';

class VitalsProvider extends ChangeNotifier {
  List<Vital> _vitalList = [
    Vital(
      vitalSign: "Weight",
      value: '12',
      time: "12-01-2024 13:09",
    ),
    Vital(
      vitalSign: 'Height',
      value: '13',
      time: "13-01-2024 13:09",
    ),
    Vital(
      vitalSign: 'Blood Pressure',
      value: '14',
      time: "13-01-2024 13:09",
    )
  ];

  void addVital(Vital vital) {
    _vitalList.add(vital);
    notifyListeners();
  }

  // void mergeWithVitalList(List){
  //
  // }
  Vital getVitalByIndex(int index) => _vitalList[index];
  int get vitalListLength => _vitalList.length;
}
