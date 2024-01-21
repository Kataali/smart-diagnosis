import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_health_diagnosis/pages/user_info_page.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key, required this.title});

  final String title;

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  String dropDownValue = 'Weight';
  final resultController = TextEditingController();
  late int listCount;

  final items = <String>[
    'Weight',
    'Height',
    'Blood Pressure',
    'Body Temperature',
    'Pulse',
    'Body Mass Index',
    'Respiratory Rate'
  ];

  var vitalSigns = <String>[
    'Weight',
    'Height',
    'Blood Pressure',
  ];

  var results = <String>['12', '13', '14'];

  var timeOfRecording = <String>[
    "12-01-2024 13:09",
    "13-01-2024 13:09",
    "13-01-2024 13:09",
  ];

  @override
  void dispose() {
    resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (BuildContext context) {
            return const UserInfoPage();
          });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: saveVitals(),
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
                    child: DataTable(
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
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Text(timeOfRecording[0]),
                            ),
                            DataCell(
                              Text(vitalSigns[0]),
                            ),
                            DataCell(
                              Text(results[0]),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text(timeOfRecording[1]),
                            ),
                            DataCell(
                              Text(vitalSigns[1]),
                            ),
                            DataCell(
                              Text(results[1]),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text(timeOfRecording[2]),
                            ),
                            DataCell(
                              Text(vitalSigns[2]),
                            ),
                            DataCell(
                              Text(results[2]),
                            ),
                          ]),
                        ]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  saveVitals() {
    if (kDebugMode) {
      print("Pressed");
    }
    DateTime dateTime = DateTime.now();
    String actualDateTime =
        "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    String currentVital = dropDownValue;
    String currentResult = resultController.value.text;

    setState(() {
      timeOfRecording.add(actualDateTime);
      vitalSigns.add(currentVital);
      results.add(currentResult);
      listCount = timeOfRecording.length;
    });
    // print(listCount);
  }
}
