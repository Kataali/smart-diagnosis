import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health_diagnosis/pages/prediction_page.dart';
import 'package:smart_health_diagnosis/providers/complaints_provider.dart';

import '../models/complaint_model.dart';
import '../models/name_data.dart';
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

  late String userId;

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<NameData>(context).userId;
    var provider = Provider.of<ComplaintsProvider>(context);

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
                onPressed: () async {
                  fileComplaint();
                  complaintsController.clear();
                  notesController.clear();
                  final List<Complaint> retrievedComplaints =
                      await getComplaints();
                  provider.emptyComplaintsList();
                  provider.mergeWithComplaintsList(retrievedComplaints);
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
                  child: provider.complaintsListLength != 0
                      ? Consumer<ComplaintsProvider>(
                          builder: (BuildContext context,
                              ComplaintsProvider value, Widget? child) {
                            return DataTable(
                                headingRowColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                                headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                columns: const [
                                  DataColumn(
                                    label: Expanded(child: Text("Complaint")),
                                  ),
                                  DataColumn(
                                    label: Text("Note"),
                                  ),
                                ],
                                rows: List.generate(
                                  provider.complaintsListLength,
                                  (index) {
                                    Complaint complaint =
                                        provider.getComplaintByIndex(index);
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(complaint.complaintName),
                                        ),
                                        DataCell(
                                          Text(complaint.note),
                                        ),
                                      ],
                                    );
                                  },
                                ));
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.speaker_notes_off_outlined,
                                size: 200,
                              ),
                              Text(
                                "No Logged Complaints Yet",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
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
      'patientid': userId,
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost/smart_health/add_exam.php"),
        headers: {},
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

  Future<List<Complaint>> getComplaints() async {
    List<Complaint> interimComplaints = [];

    final queryParams = {
      'param1': userId,
      // 'param1': '47',
    };
    const url = "http://localhost/smart_health/get_logged_complaints.php";
    try {
      final res =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      final resData = jsonDecode(res.body);
      // print(resData);
      // print(resData.length);
      // return Vital.fromJson(resData[0]);
      resData.forEach((i) {
        Complaint complaint = Complaint.fromJson(i);
        interimComplaints.add(complaint);
      });
      return interimComplaints;
    } catch (e) {
      // print("Error: $e");
      throw "Unable to get logged complaints";
    }
  }
}
