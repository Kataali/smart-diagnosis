import 'package:flutter/material.dart';

class ConsultationPage extends StatelessWidget {
  ConsultationPage({super.key});
  final complaintsController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final complaints = <String>[
      'Sore Throat',
      'Vomiting',
    ];
    final notes = <String>[
      'mostly evenings. 3 days today',
      '5 last night',
    ];

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
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
}
