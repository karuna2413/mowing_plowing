import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ServiceCompleted extends StatefulWidget {
  const ServiceCompleted();

  @override
  State<ServiceCompleted> createState() => _ServiceCompletedState();
}

class _ServiceCompletedState extends State<ServiceCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Completed",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "images/image4.png",
              height: 250,
            ),
          ),
          const Text(
            "Congratulations",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Text("You have completed your job."),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
