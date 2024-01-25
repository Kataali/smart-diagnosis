import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_diagnosis/pages/vitals_page.dart';

import 'models/name_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NameData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const VitalsPage(title: 'Record New Vitals'),
        // home: ConsultationPage(),
      ),
    );
  }
}
