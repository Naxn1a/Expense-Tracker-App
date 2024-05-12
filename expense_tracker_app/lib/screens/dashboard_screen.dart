import 'package:expense_tracker_app/api/api.dart';
import 'package:expense_tracker_app/components/user_card.dart';
import 'package:expense_tracker_app/helpers/helper.dart';
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
    }
    username = (await methodGet("users/$userId"))["data"]["Username"];
    return (await methodGet("expenses/$userId"));
  }

  Future<dynamic> fetchTotal() async {}

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
  void initState() {
    super.initState();
    fetchData();
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

  @override
  Widget build(BuildContext context) {
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
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
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
                        title: Text(username,
                            style: const TextStyle(fontSize: 24)),
                        onTap: openRename,
                      ),
                      ListTile(
                          leading: const Icon(
                            IonIcons.log_out,
                            size: 30,
                          ),
                          title: const Text("logout",
                              style: TextStyle(fontSize: 24)),
                          onTap: logout),
                    ],
                  );
                }
              })),
      body: UserCard(
        newFuture: fetchData(),
        newBuilder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          final data = snapshot.data;
          return PopScope(
            canPop: false,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  if (data[index]["type"] == "expense")
                                    const Icon(
                                      FontAwesome.arrow_up_solid,
                                      color: Colors.redAccent,
                                      size: 30,
                                    )
                                  else
                                    const Icon(
                                      FontAwesome.arrow_down_solid,
                                      color: Colors.greenAccent,
                                      size: 30,
                                    ),
                                ],
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data[index]["title"],
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                        DateFormat("dd/MM/yyyy HH:mm").format(
                                            DateTime.parse(
                                                data[index]["date"])),
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (data[index]["type"] == "expense")
                            Text(
                              "${data[index]["amount"].toString()} \$",
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.red),
                            )
                          else
                            Text(
                              "+${data[index]["amount"].toString()} \$",
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.green),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
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
          final amount = convertStringToDouble(amountController.text);
          Map<String, dynamic> body = {
            "title": titleController.text,
            "amount": amount,
            "type": (amount < 0) ? "expense" : "income",
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
          }

          titleController.clear();
        }
      },
      child: const Text("Save"),
    );
  }
}
