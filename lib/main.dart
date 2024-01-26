import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_diagnosis/constants/routes.dart';
import 'package:smart_health_diagnosis/pages/vitals_page.dart';
import 'package:smart_health_diagnosis/providers/vitals_provider.dart';

import 'models/name_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NameData()),
        ChangeNotifierProvider(create: (_) => VitalsProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: Routes().getRoutes(),
        home: const VitalsPage(),

        // home: ConsultationPage(),
      ),
    );
  }
}
