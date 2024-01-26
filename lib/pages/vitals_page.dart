import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health_diagnosis/models/name_data.dart';
import 'package:smart_health_diagnosis/pages/consultation_page.dart';
import 'package:smart_health_diagnosis/pages/user_info_page.dart';
import 'package:smart_health_diagnosis/providers/vitals_provider.dart';
import 'package:smart_health_diagnosis/widgets/route_button.dart';

import '../models/vital_data.dart';

class VitalsPage extends StatefulWidget {
  static const routeName = "/vitals_page";

  const VitalsPage({
    super.key,
  });

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  String dropDownValue = 'Weight';
  late String userName;
  late String userId;
  final resultController = TextEditingController();

  final items = <String>[
    'Weight',
    'Height',
    'Blood Pressure',
    'Body Temperature',
    'Pulse',
    'Body Mass Index',
    'Respiratory Rate'
  ];

  @override
  void dispose() {
    resultController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showModalBottomSheet(
          isDismissible: true,
          enableDrag: false,
          context: context,
          builder: (BuildContext context) {
            return const UserInfoPage();
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userName = Provider.of<NameData>(context).username;
    userId = Provider.of<NameData>(context).userId;
    var provider = Provider.of<VitalsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Record New Vitals'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Text(Provider.of<NameData>(context).userId),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Vital Sign:"),
                    DropdownButton(
                        value: dropDownValue,
                        items: items
                            .map(
                              (String items) => DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            dropDownValue = newVal!;
                          });
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 35, 0, 25),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Results'),
                    controller: resultController,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: RouteButton(onPressed: () {
                      Navigator.pushNamed(context, ConsultationPage.routeName);
                    }),
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    addVitals();
                    final retrievedVital = await getVitals();
                    // print([
                    //   retrievedVital.vitalSign,
                    //   retrievedVital.value,
                    //   retrievedVital.time
                    // ]);
                    resultController.clear();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.inversePrimary),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 35.0),
                child: Text(
                  "Recorded Vitals",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Consumer<VitalsProvider>(
                        builder: (BuildContext context, VitalsProvider value,
                            Widget? child) {
                          return DataTable(
                            headingRowColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.inversePrimary),
                            headingTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Text("Time")),
                              ),
                              DataColumn(
                                label: Text("Vital Sign"),
                              ),
                              DataColumn(
                                label: Text("Result"),
                              )
                            ],
                            rows: List.generate(
                              provider.vitalListLength,
                              (index) {
                                Vital vital = provider.getVitalByIndex(index);
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(vital.time),
                                    ),
                                    DataCell(
                                      Text(vital.vitalSign),
                                    ),
                                    DataCell(Text(vital.value))
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addVitals() async {
    Map<String, String> vitals = {
      'name': dropDownValue,
      'value': resultController.value.text,
      'patientid': userId,
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost/smart_health/add_vitals.php"),
        headers: {},
        body: jsonEncode(vitals),
      );

      if (res.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Vitals Successfully recorded"),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to record Vitals"),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }
    }
  }

  Future<Vital> getVitals() async {
    final queryParams = {
      'param1': userId,
    };
    const url = "http://localhost/smart_health/get_logged_vitals.php";
    try {
      final res =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (res.statusCode == 200) {
        final resData = jsonDecode(res.body);
        print(resData);
        print(resData.length);
        return Vital.fromJson(resData[0]);
      }
      throw "Unable to get recorded vitals";
    } on Exception {
      throw "Unable to get recorded vitals";
    }
  }

  // saveVitals() {
  //   if (kDebugMode) {
  //     print("Pressed");
  //   }
  //   DateTime dateTime = DateTime.now();
  //   String actualDateTime =
  //       "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  //   String currentVital = dropDownValue;
  //   String currentResult = resultController.value.text;
  //
  //   setState(() {
  //     timeOfRecording.add(actualDateTime);
  //     vitalSigns.add(currentVital);
  //     results.add(currentResult);
  //     listCount = timeOfRecording.length;
  //   });
  //   // print(listCount);
  // }
}
