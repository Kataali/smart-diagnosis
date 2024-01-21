import 'package:flutter/material.dart';
import 'package:smart_health_diagnosis/pages/user_info_page.dart';
import 'package:smart_health_diagnosis/pages/vitals_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VitalsPage(title: 'Record New Vitals'),
      // home: const UserInfoPage(),
    );
  }
}
