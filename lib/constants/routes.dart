import 'package:flutter/material.dart';
import 'package:smart_health_diagnosis/pages/consultation_page.dart';
import 'package:smart_health_diagnosis/pages/prediction_page.dart';
import 'package:smart_health_diagnosis/pages/vitals_page.dart';

class Routes {
  Map<String, WidgetBuilder> getRoutes() {
    return {
      ConsultationPage.routeName: (context) => const ConsultationPage(),
      PredictionPage.routeName: (context) => const PredictionPage(),
      VitalsPage.routeName: (context) => const VitalsPage(),
    };
  }
}
