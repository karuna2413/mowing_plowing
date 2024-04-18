import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../JobServiceDetail/detail_screen.dart';
import '../Login/login_screen.dart';

class TotalJob extends StatefulWidget {
  const TotalJob();

  @override
  State<TotalJob> createState() => _TotalJobState();
}

class _TotalJobState extends State<TotalJob> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Data>>? futureData;
  List<dynamic> compJobs = [];

  showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Alert!',
        message: '$msg',
        contentType: ContentType.failure,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  bool? activeUser;

  Future<List<Data>> getAvailJobFunction() async {
    var response = await BaseClient().getAvailJobs(
      "/jobs",
      "complete",
    );
    // print(json.decode(response.body));
    if (json.decode(response.body)["message"] == "Unauthenticated.") {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            // 3
            child: const LogIn(),
          ),
          (route) => false,
        );
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Alert!',
            message: 'To continue, kindly log in again',
            contentType: ContentType.help,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        activeUser = json.decode(response.body)["success"];
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        if (mounted) {
          setState(() {});
        }
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      } else {
        activeUser = false;
        List jsonResponse = [];
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      }
    }
  }

  void completeFunc() {
    futureData = getAvailJobFunction();
    setState(() {});
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
    );
    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    completeFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Total Jobs",
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
        physics: const ScrollPhysics(),
        child: Center(
          child: activeUser == null
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      LoadingAnimationWidget.fourRotatingDots(
                        color: HexColor("#0275D8"),
                        size: 80,
                      ),
                    ],
                  ),
                )
              : activeUser == true
                  ? FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && mounted) {
                          List<Data>? data = snapshot.data;
                          return data!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No completed jobs yet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("#ECECEC"),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Image.asset(
                                                          'images/logo3.png',
                                                          height: 80,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              5,
                                                              10,
                                                              10,
                                                              10,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index].service_for ==
                                                                              null
                                                                          ? "Lawn Mowing"
                                                                          : "Snow Plowing ${data[index].service_for}",
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          5,
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                          5,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "\$${data[index].grand_total}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                HexColor(
                                                                              "#24B550",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .address,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[400],
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        10,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Due date: ${data[index].date}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 3
                                                                        child:
                                                                            Detail(
                                                                          date:
                                                                              data[index].date,
                                                                          grand_total:
                                                                              data[index].grand_total,
                                                                          id: data[index]
                                                                              .id,
                                                                          period:
                                                                              data[index].period,
                                                                          service_for:
                                                                              data[index].service_for,
                                                                          fromWhere:
                                                                              'Completed',
                                                                          address:
                                                                              data[index].address,
                                                                          jobId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                          statusOfReq:
                                                                              true,
                                                                          ln: data[index]
                                                                              .ln,
                                                                          lt: data[index]
                                                                              .lt,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        5,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      "See Details",
                                                                      style:
                                                                          TextStyle(
                                                                        color: HexColor(
                                                                            "#0275D8"),
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
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
                                        ],
                                      ),
                                    );
                                  },
                                );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            LoadingAnimationWidget.fourRotatingDots(
                              color: HexColor("#0275D8"),
                              size: 80,
                            ),
                          ],
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "You can not view jobs as your account is not approved. Kindly wait for the admin to approve it. For any queries call/email at 877-331-6188/hello@mowingandplowing.com",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

class Data {
  final int id;
  final String address;
  final String date;
  String? service_for;
  final String grand_total;
  final String lt;
  final String ln;
  String? period;
  Data({
    required this.id,
    required this.address,
    required this.date,
    required this.service_for,
    required this.grand_total,
    required this.lt,
    required this.ln,
    required this.period,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      lt: json['property']['lat'].toString(),
      ln: json['property']['lng'].toString(),
      address: json['property']['address'],
      date: json['date'],
      service_for: json['service_for'],
      grand_total: json['provider_amount'].toString(),
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
    );
  }
}
