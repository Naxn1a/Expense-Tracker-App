import 'package:expense_tracker_app/api/api.dart';
import 'package:expense_tracker_app/components/user_card.dart';
import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var username = "";
  var userId = 0;
  var total = 0;
  var totalIncome = 0;
  var totalExpense = 0;

  Future<dynamic> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (mounted && token == null) {
      Navigator.popUntil(
        context,
        ModalRoute.withName('/'),
      );
    }
    final res = await methodPost({
      "token": token,
    }, "auth");
    if (res != null) {
      userId = res["data"]["id"];
      username = (await methodGet("users/$userId"))["data"]["Username"];
      return (await methodGet("expenses/$userId"));
    }
    return (await methodGet("expenses/$userId"));
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

  void openRename() async {
    if (mounted) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Rename"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(labelText: "New Username"),
                    ),
                  ],
                ),
                actions: [
                  _cancelButton(),
                  _renameButton(),
                ],
              ));
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
            actions: [
              IconButton(
                onPressed: () {
                  openNewExpenseBox();
                },
                icon: const Icon(FontAwesome.plus_solid),
              ),
            ],
          ),
          drawer: Drawer(
              child: ListView(
            children: [
              const DrawerHeader(
                  child: Center(
                      child: Icon(
                FontAwesome.address_book_solid,
                size: 50,
              ))),
              ListTile(
                leading: const Icon(
                  IonIcons.people,
                  size: 30,
                ),
                title: Text(username, style: const TextStyle(fontSize: 24)),
                onTap: openRename,
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                  leading: const Icon(
                    IonIcons.log_out,
                    size: 30,
                  ),
                  title: const Text("Logout", style: TextStyle(fontSize: 24)),
                  onTap: logout),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
          body: UserCard(
            data: snapshot.data,
          ),
        );
      },
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
          final amount = double.tryParse(amountController.text);
          Map<String, dynamic> body = {
            "title": titleController.text,
            "amount": amount,
            "type": (amount! < 0) ? "expense" : "income",
            "date":
                DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
            "user_id": userId,
          };

          final res = await methodPost(body, "expenses");

          if (res['status'] == 200) {
            setState(() {
              fetchData();
            });
          }

          titleController.clear();
          amountController.clear();
        }
      },
      child: const Text("Save"),
    );
  }

  Widget _renameButton() {
    return MaterialButton(
      onPressed: () async {
        if (titleController.text.isNotEmpty) {
          Navigator.pop(context);

          final res = await methodPut({
            "Username": titleController.text,
          }, "users/$userId");
          if (res["status"] == 200) {
            setState(() {
              fetchData();
            });
          } else {
            if (mounted) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(title: Text(res["msg"])));
            }
          }

          titleController.clear();
        }
      },
      child: const Text("Save"),
    );
  }
}
