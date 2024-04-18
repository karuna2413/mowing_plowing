import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ScheduleFrog extends StatefulWidget {
  const ScheduleFrog();

  @override
  State<ScheduleFrog> createState() => _ScheduleFrogState();
}

class _ScheduleFrogState extends State<ScheduleFrog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Schedule Frog",
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
            Image.asset(
              'images/image12.png',
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "Your Centralized Hub for everything from job sheets to Invoices, Quotes & CRM. Manage & Streamline every Process of every job with Schedule Frog. Schedule Frog keeps things organized as you move through each stage of a job, and you only enter customer and job details once."),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "With access to customer data like purchase history or loyalty status, you can understand your customers better and make smarter business decisions. Store your customers’ information, analyze how they interact with your business, and engage with them — all in one place."),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'images/image13.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ],
        ),
      ),
    );
  }
}
