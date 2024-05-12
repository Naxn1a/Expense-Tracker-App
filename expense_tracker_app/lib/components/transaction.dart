import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class Transactions extends StatelessWidget {
  final dynamic data;

  const Transactions({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                                  color: Colors.white, shape: BoxShape.circle),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index]["title"],
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  DateFormat("dd/MM/yyyy HH:mm").format(
                                      DateTime.parse(data[index]["date"])),
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
                        style: const TextStyle(fontSize: 24, color: Colors.red),
                      )
                    else
                      Text(
                        "+${data[index]["amount"].toString()} \$",
                        style:
                            const TextStyle(fontSize: 24, color: Colors.green),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
