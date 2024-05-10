import 'dart:convert';

import 'package:expense_tracker_app/api/api.dart';
import 'package:expense_tracker_app/helpers/helper.dart';
import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var userId = 0;

  Future fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (mounted && token == null) {
      Navigator.pop(context, const MainScreen());
    }
    final res = jsonDecode((await methodGet(token, "auth")).body);
    userId = res["data"]["id"];
  }

  @override
  void initState() {
    super.initState();
  }

  void openNewExpenseBox() async {
    if (mounted) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("New Expense"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: "Amount"),
                    ),
                  ],
                ),
                actions: [
                  _cancelButton(),
                  _saveButton(),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchToken();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);

        titleController.clear();
        amountController.clear();
      },
      child: const Text("Cancel"),
    );
  }

  Widget _saveButton() {
    return MaterialButton(
      onPressed: () async {
        if (titleController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Map<String, dynamic> body = {
            "title": titleController.text,
            "amount": convertStringToDouble(amountController.text),
            "date":
                DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
            "user_id": userId,
          };

          final res = jsonDecode((await methodPost(body, "expenses")).body);
          if (res['status'] == 200) {
            print(res);
          }

          titleController.clear();
          amountController.clear();
        }
      },
      child: const Text("Save"),
    );
  }
}
