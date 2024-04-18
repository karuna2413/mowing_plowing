import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AccountLevel extends StatefulWidget {
  const AccountLevel();

  @override
  State<AccountLevel> createState() => _AccountLevelState();
}

class _AccountLevelState extends State<AccountLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Levels",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Level 1",
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.asset(
                            "images/level1.png",
                            height: 60,
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[400],
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Orders",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Accept requests and complete at least 10 orders.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earn at least \$500 from completed services.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Days without warnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Avoid receiving warnings over the course of 30 days.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Level 2",
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.asset(
                            "images/level2.png",
                            height: 60,
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[400],
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Orders",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Accept requests and complete at least 10 orders.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earn at least \$500 from completed services.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Days without warnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Avoid receiving warnings over the course of 30 days.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Level 3",
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.asset(
                            "images/level3.png",
                            height: 60,
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[400],
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Orders",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Accept requests and complete at least 10 orders.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Earn at least \$500 from completed services.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Days without warnings",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Avoid receiving warnings over the course of 30 days.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
