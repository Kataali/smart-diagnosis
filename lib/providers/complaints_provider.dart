import 'package:flutter/foundation.dart';

import '../models/complaint_model.dart';

class ComplaintsProvider extends ChangeNotifier {
  List<Complaint> _complaintsList = [];

  void emptyComplaintsList() {
    _complaintsList.clear();
  }

  void mergeWithComplaintsList(List<Complaint> complaints) {
    _complaintsList.addAll(complaints);
    notifyListeners();
  }

  void addComplaint(Complaint complaint) {
    _complaintsList.add(complaint);
    notifyListeners();
  }

  Complaint getComplaintByIndex(int index) {
    return _complaintsList[index];
  }

  int get complaintsListLength => _complaintsList.length;
}
