import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../Map/trackService_screen.dart';
import 'reschedule_screen.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail();

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  final myController = TextEditingController();
  final _instructions = <Widget>[];
  @override
  void initState() {
    _instructions.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Icon(
                Icons.stop,
                size: 14,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  "Do your job carefully and close the door before leaving.",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Details",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: HexColor("#CBCBCB"), width: 2),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Order ID"),
                            Text("ORD69837614501"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Service Provider"),
                            Text("Not assigned"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Date"),
                            Text("12-13-2022"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Service"),
                            Text("Lawn Mowing"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Lawn size"),
                            Text(".25 - .50 Acres"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Lawn height"),
                            Text("10 - 12 Inches"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Corner lot"),
                            Text("Yes"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lawn Images",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "images/image1.png",
                          height: 80,
                        ),
                        Image.asset(
                          "images/image1.png",
                          height: 80,
                        ),
                        Image.asset(
                          "images/image1.png",
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Service location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: HexColor("#CBCBCB"),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                              child: Image.asset(
                                'images/image1.png',
                                height: 100,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Address:"),
                                      TextButton(
                                        onPressed: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 0.5,
                                            ),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            "View on map",
                                            style: TextStyle(
                                              color: HexColor("#0275D8"),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "12805 Garland Ave, Cleveland, OH 44125, USA 12805 Garland Ave, Cleveland",
                                          style: TextStyle(
                                            color: HexColor("#24B550"),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Instructions",
                            style: TextStyle(
                              color: HexColor("#0275D8"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: TextFormField(
                                        autofocus: true,
                                        onChanged: (value) {
                                          setState(() {
                                            myController.text = value;
                                          });
                                        },
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.grey,
                                            ),
                                          ),
                                          child: const Text('CANCEL'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _instructions.add(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 20, 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.stop,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          myController.text,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text('SUBMIT'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                            label: const Text('Instructions'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: _instructions,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: HexColor("#E8E8E8"),
                          filled: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: HexColor("#CBCBCB"),
                            ),
                          ),
                          suffix: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor("#E8E8E8"),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                "\$120.97",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        initialValue: 'Total Price',
                        enabled: false,
                        autofocus: false,
                        onTap: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#24B550"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  // 3
                                  child: const Reschedule(),
                                ),
                              );
                            },
                            child: const Text('Reschedule'),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.rightToLeftWithFade,
                              //     // 3
                              //     child: const TrackService(),
                              //   ),
                              // );
                            },
                            child: const Text('Decline'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
