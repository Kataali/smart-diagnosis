class Vital {
  final String vitalSign;
  final String value;
  final String time;

  Vital({
    required this.vitalSign,
    required this.value,
    required this.time,
  });

  factory Vital.fromJson(Map<String, dynamic> json) {
    return Vital(
      vitalSign: json['name'],
      value: json['value'],
      time: json['time'],
    );
  }
}
