import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'bookingHistory_screen.dart';

enum CancelService { mind, location, personal }

class CancelBooking extends StatefulWidget {
  const CancelBooking();

  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {
  CancelService? _character = CancelService.mind;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add customer",
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 20),
            child: Text(
              "Are you sure you want to cancel the customer's\nservice? Tell us reason.",
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
                'I changed my mind',
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<CancelService>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: CancelService.mind,
                  groupValue: _character,
                  onChanged: (CancelService? value) {
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
                "Can't find customer's location",
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<CancelService>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: CancelService.location,
                  groupValue: _character,
                  onChanged: (CancelService? value) {
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
                'Personal',
                style: TextStyle(fontSize: 14),
              ),
              leading: Transform.scale(
                scale: 0.8,
                child: Radio<CancelService>(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => HexColor("#000000")),
                  value: CancelService.personal,
                  groupValue: _character,
                  onChanged: (CancelService? value) {
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
        Image.asset(
          'images/image5.png',
          height: 20,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "If you decline the service, your",
          style: TextStyle(
            color: HexColor("#000000"),
            fontSize: 15,
          ),
        ),
        Text(
          "account level will be affected",
          style: TextStyle(color: HexColor("#000000"), fontSize: 15),
        ),
        Text(
          "by down ratings.",
          style: TextStyle(color: HexColor("#000000"), fontSize: 15),
        ),
        const SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingHistory(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: HexColor("#FB4B4B"),
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
