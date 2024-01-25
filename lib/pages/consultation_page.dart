import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_health_diagnosis/pages/prediction_page.dart';

import '../widgets/route_button.dart';

class ConsultationPage extends StatefulWidget {
  static const routeName = "/consultation_page";

  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final complaintsController = TextEditingController();

  final notesController = TextEditingController();
  final complaints = <String>[
    'Sore Throat',
    'Vomiting',
  ];
  final notes = <String>[
    'mostly evenings. 3 days today',
    '5 last night',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Consultation"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          SizedBox(
            width: 350,
            child: TextField(
              decoration: const InputDecoration(labelText: "Complaint"),
              controller: complaintsController,
            ),
          ),
          SizedBox(
            width: 350,
            child: TextField(
              decoration: const InputDecoration(labelText: "Note"),
              controller: notesController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: RouteButton(onPressed: () {
                  Navigator.pushNamed(context, PredictionPage.routeName);
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  fileComplaint();
                  Navigator.pushNamed(context, PredictionPage.routeName);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.inversePrimary),
                ),
                child: const Text(
                  'File',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 35.0),
            child: Text(
              "Complaints",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.inversePrimary),
                      headingTextStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                      columns: const [
                        DataColumn(
                          label: Expanded(child: Text("Complaint")),
                        ),
                        DataColumn(
                          label: Text("Note"),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text(complaints[0]),
                          ),
                          DataCell(
                            Text(notes[0]),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Text(complaints[1]),
                          ),
                          DataCell(
                            Text(notes[1]),
                          ),
                        ]),
                      ]),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  void fileComplaint() async {
    Map<String, String> vitals = {
      'complaint': complaintsController.value.text,
      'note': notesController.value.text,
      'patientid': "null",
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost/smart_health/add_exam.php"),
        headers: {
          // Add CORS-related header to allow requests from your specific origin
          'Access-Control-Allow-Origin': "*",
          'Access-Control-Allow-Methods': "*",
          'Access-Control-Allow-Headers': 'Content-Type',
          // Specify allowed headers
          'Access-Control-Allow-Credentials': 'true',
          // If credentials are used
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(vitals),
      );

      if (res.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complaint Successfully filed"),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to file complaint"),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
          ),
        );
      }
    }
  }
}
