import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health_diagnosis/models/name_data.dart';

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
    return Center(
      child: Column(children: [
        Text(Provider.of<NameData>(context).username),
        SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(labelText: "Full name"),
            controller: nameController,
            // onChanged: (value) {
            //   Provider.of<NameData>(context, listen: false).updateName(value);
            // },
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
                // addUserInfo();
                setState(() {
                  Provider.of<NameData>(context, listen: false)
                      .updateName(nameController.value.text);
                });
                Navigator.of(context).pop(context);
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
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ]),
    );
  }

  void addUserInfo() async {
    Map<String, String> userInfo = {
      'name': nameController.value.text,
      'age': ageController.value.text,
      'gender': dropDownValue,
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost/smart_health/add_patient.php"),
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
        body: jsonEncode(userInfo),
      );

      print(userInfo);

      if (res.statusCode == 200) {
        print("client added");
        print(res.body);
      } else {
        print("Failed to add client");
        print(res.statusCode);
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
