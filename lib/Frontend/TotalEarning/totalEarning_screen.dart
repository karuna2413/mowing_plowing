import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';

class TotalEarnings extends StatefulWidget {
  const TotalEarnings();

  @override
  State<TotalEarnings> createState() => _TotalEarningsState();
}

class _TotalEarningsState extends State<TotalEarnings>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Data>>? futureData;
  Future<List<Data1>>? futureData1;
  Future<List<Data2>>? futureData2;
  List<dynamic> jobs = [];
  late TabController _controller;
  String totalEarning = "0";
  String todayEarning = "0";
  String weekEarning = "0";
  String montyhEarning = "0";

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

  Future<List<Data>> getEarningsFunction() async {
    var response = await BaseClient().getEarnings(
      "/earnings",
    );
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
        totalEarning =
            "${json.decode(response.body)["data"]["total_earnings"].toStringAsFixed(2)}";
        todayEarning =
            "${json.decode(response.body)["data"]["today_earnings"].toStringAsFixed(2)}";
        weekEarning =
            "${json.decode(response.body)["data"]["week_earnings"].toStringAsFixed(2)}";
        montyhEarning =
            "${json.decode(response.body)["data"]["month_earnings"].toStringAsFixed(2)}";
        if (mounted) {
          setState(() {});
        }
        List jsonResponse = json.decode(response.body)["data"]["today_jobs"];
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  Future<List<Data1>> getEarningsFunction1() async {
    var response = await BaseClient().getEarnings(
      "/earnings",
    );
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
        List jsonResponse = json.decode(response.body)["data"]["week_jobs"];
        return jsonResponse.map((data) => Data1.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  Future<List<Data2>> getEarningsFunction2() async {
    var response = await BaseClient().getEarnings(
      "/earnings",
    );
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
        List jsonResponse = json.decode(response.body)["data"]["month_jobs"];
        return jsonResponse.map((data) => Data2.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
    );
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      if (_controller.index == 0) {
        futureData = getEarningsFunction();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 1) {
        futureData1 = getEarningsFunction1();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 2) {
        futureData2 = getEarningsFunction2();
        if (mounted) {
          setState(() {});
        }
      }
    });
    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    futureData = getEarningsFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Total Earnings",
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Total Earnings",
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "\$$totalEarning",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: HexColor("#ECECEC"),
                    ),
                    color: Colors.white,
                  ),
                  child: _tabSection(
                    context,
                    _controller,
                    futureData,
                    futureData1,
                    futureData2,
                    showMsg,
                    todayEarning,
                    weekEarning,
                    montyhEarning,
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

Widget _tabSection(
  BuildContext context,
  TabController _controller,
  Future<List<Data>>? futureData,
  Future<List<Data1>>? futureData1,
  Future<List<Data2>>? futureData2,
  dynamic showMsg,
  String todayEarning,
  String weekEarning,
  String montyhEarning,
) {
  Size size = MediaQuery.of(context).size;
  return DefaultTabController(
    length: 3,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: _controller,
          tabs: [
            Tab(
              child: Text(
                "Today \$$todayEarning",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Week \$$weekEarning",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Month \$$montyhEarning",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          //Add this to give height
          height: MediaQuery.of(context).size.height / 1.5,
          child: TabBarView(
            controller: _controller,
            children: [
              //
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Center(
                  child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data>? data = snapshot.data;
                          return data!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No earnings for today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
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
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
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
                                                                const SizedBox(
                                                                  height: 5,
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
                                                        20,
                                                        20,
                                                        20,
                                                        20,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
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
                      }),
                ),
              ),
              //
              //
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Center(
                  child: FutureBuilder<List<Data1>>(
                      future: futureData1,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data1>? data = snapshot.data;
                          return data!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No earnings for week",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
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
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
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
                                                                const SizedBox(
                                                                  height: 5,
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
                                                        20,
                                                        20,
                                                        20,
                                                        20,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
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
                      }),
                ),
              ),
              //
              //
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Center(
                  child: FutureBuilder<List<Data2>>(
                      future: futureData2,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data2>? data = snapshot.data;
                          return data!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No earnings for month",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
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
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
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
                                                                const SizedBox(
                                                                  height: 5,
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
                                                        20,
                                                        20,
                                                        20,
                                                        20,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
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
                      }),
                ),
              ),
              //
              //
            ],
          ),
        ),
      ],
    ),
  );
}

class Data {
  // final int id;
  final String address;
  // final String lt;
  // final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  // String? on_the_way;
  // String? at_location_and_started_job;
  // String? finished_job;
  Data({
    // required this.id,
    required this.address,
    // required this.lt,
    // required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    // required this.on_the_way,
    // required this.at_location_and_started_job,
    // required this.finished_job,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      // id: json['id'],
      address: json['property']['address'],
      // lt: json['property']['lat'].toString(),
      // ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      // on_the_way:
      // json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      // at_location_and_started_job: json['at_location_and_started_job'] == null
      // ? null
      // : json['at_location_and_started_job'].toString(),
      // finished_job:
      // json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}

class Data1 {
  // final int id;
  final String address;
  // final String lt;
  // final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  // String? on_the_way;
  // String? at_location_and_started_job;
  // String? finished_job;
  Data1({
    // required this.id,
    required this.address,
    // required this.lt,
    // required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    // required this.on_the_way,
    // required this.at_location_and_started_job,
    // required this.finished_job,
  });

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      // id: json['id'],
      address: json['property']['address'],
      // lt: json['property']['lat'].toString(),
      // ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      // on_the_way:
      // json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      // at_location_and_started_job: json['at_location_and_started_job'] == null
      // ? null
      // : json['at_location_and_started_job'].toString(),
      // finished_job:
      // json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}

class Data2 {
  // final int id;
  final String address;
  // final String lt;
  // final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  // String? on_the_way;
  // String? at_location_and_started_job;
  // String? finished_job;
  Data2({
    // required this.id,
    required this.address,
    // required this.lt,
    // required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    // required this.on_the_way,
    // required this.at_location_and_started_job,
    // required this.finished_job,
  });

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      // id: json['id'],
      address: json['property']['address'],
      // lt: json['property']['lat'].toString(),
      // ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      // on_the_way:
      // json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      // at_location_and_started_job: json['at_location_and_started_job'] == null
      // ? null
      // : json['at_location_and_started_job'].toString(),
      // finished_job:
      // json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}
