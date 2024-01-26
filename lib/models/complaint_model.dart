class Complaint {
  final String complaintName;
  final String note;

  Complaint({
    required this.complaintName,
    required this.note,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      complaintName: json['complaint'],
      note: json['note'],
    );
  }
}
