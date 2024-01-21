import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String dropDownValue = "male";

  final ageController = TextEditingController();

  final nameController = TextEditingController();

  final items = <String>["male", "female"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          SizedBox(
            width: 350,
            child: TextField(
              decoration: const InputDecoration(labelText: "Full name"),
              controller: nameController,
            ),
          ),
          SizedBox(
            width: 350,
            child: TextField(
              decoration: const InputDecoration(labelText: "Age"),
              controller: ageController,
            ),
          ),
          SizedBox(
            width: 350,
            child: DropdownButton(
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
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () {},
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
        ]),
      ),
    );
  }
}
