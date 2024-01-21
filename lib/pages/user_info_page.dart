import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String dropDownValue = "Male";

  final ageController = TextEditingController();

  final nameController = TextEditingController();

  final items = <String>["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          SizedBox(
            width: 300,
            child: TextField(
              decoration: const InputDecoration(labelText: "Full name"),
              controller: nameController,
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: const InputDecoration(labelText: "Age"),
              controller: ageController,
            ),
          ),
          SizedBox(
            width: 300,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text("Gender:"),
                ),
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
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.inversePrimary),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const Text(
            "Enter Info to proceed. ",
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
          )
        ]),
      ),
    );
  }
}
