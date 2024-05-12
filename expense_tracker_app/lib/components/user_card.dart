import 'package:expense_tracker_app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCard extends StatefulWidget {
  final Future<dynamic>? newFuture;
  final Widget Function(BuildContext, AsyncSnapshot<dynamic>) newBuilder;

  const UserCard(
      {super.key, required this.newFuture, required this.newBuilder});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<dynamic> fetchTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var userId = 0;
    final res = await methodPost({
      "token": token,
    }, "auth");
    if (res != null) {
      userId = res["data"]["id"];
    }
    return (await methodGet("users/$userId"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: fetchTotal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 5,
                            offset: const Offset(5, 5))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Total Balance",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 12,
                      ),
                      Text("${data["total"]} \$",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                      color: Colors.white30,
                                      shape: BoxShape.circle),
                                  child: const Center(
                                    child: Icon(
                                      FontAwesome.arrow_down_solid,
                                      size: 16,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Income",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text("${data["income"]} \$",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                        color: Colors.white30,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(FontAwesome.arrow_up_solid,
                                          size: 16, color: Colors.redAccent),
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Expense",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text("${data["expense"]} \$",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recent Transactions",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: FutureBuilder(
                        future: widget.newFuture, builder: widget.newBuilder))
              ],
            ),
          );
        },
      ),
    );
  }
}
