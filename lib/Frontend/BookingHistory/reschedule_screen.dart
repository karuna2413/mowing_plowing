import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'bookingHistory_screen.dart';

enum Reschedules { weather, emergency, request }

class Reschedule extends StatefulWidget {
  const Reschedule();

  @override
  State<Reschedule> createState() => _RescheduleState();
}

class _RescheduleState extends State<Reschedule> {
  Reschedules? _character = Reschedules.weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: HexColor("#000000"),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          "Reschedule",
          style: TextStyle(color: HexColor("#000000"), fontSize: 18),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 20),
            child: Text(
              "Are you sure you want to reschedule the customer's\nservice? Tell us reason.",
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: ListTile(
              title: const Text(
                'Weather',
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<Reschedules>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: Reschedules.weather,
                  groupValue: _character,
                  onChanged: (Reschedules? value) {
                    setState(
                      () {
                        _character = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: ListTile(
              title: const Text(
                'Emergency',
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<Reschedules>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: Reschedules.emergency,
                  groupValue: _character,
                  onChanged: (Reschedules? value) {
                    setState(
                      () {
                        _character = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: ListTile(
              title: const Text(
                'Request to customer',
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<Reschedules>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: Reschedules.request,
                  groupValue: _character,
                  onChanged: (Reschedules? value) {
                    setState(
                      () {
                        _character = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  backgroundColor: HexColor("#0275D8")),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// pop up

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    insetPadding: EdgeInsets.zero,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Congratulations! The service is",
          style: TextStyle(
            color: HexColor("#000000"),
            fontSize: 15,
          ),
        ),
        Text(
          "rescheduled.",
          style: TextStyle(color: HexColor("#000000"), fontSize: 15),
        ),
        const SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                // 1
                child: const BookingHistory(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: HexColor("#24B550"),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
            child: Text(
              "OK",
              style: TextStyle(color: HexColor("#FFFFFF"), fontSize: 13),
            ),
          ),
        ),
      ],
    ),
  );
}
