import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../Backend/base_client.dart';
import '../Drawer/drawer_widget.dart';
import '../JobServiceDetail/detail_screen.dart';
import '../Login/login_screen.dart';
import '../Requests/requests_screen.dart';
import '../TotalEarning/totalEarning_screen.dart';
import '../TotalJob/totalJob_screen.dart';
import '../TotalRating/reviewsRating_screen.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Data>>? futureData;

  List<_SalesData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  Map<String, dynamic>? userMap;
  String? firstName;
  String? lastName;
  String? totalRatings;
  String? totalJobs;
  String? totalEarnings;
  String? responseOnTime;
  String? totalScore;
  String? completeJobsPerc;
  String? cancelJobsPerc;
  List<dynamic> aJobs = [];
  bool loading = true;
  bool load = false;
  bool noti = false;
  bool? activeUser;

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

  Future<void> getUserDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
  }

  Future<List<Data>> get2AvailJobFunction() async {
    var response = await BaseClient().get2AvailJobs(
      "/available-jobs",
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
      List jsonResponse = [];
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      if (json.decode(response.body)["success"]) {
        activeUser = json.decode(response.body)["success"];
        if (mounted) {
          setState(() {});
        }
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        //
        await localStorage.setString(
            'noti',
            json.decode(response.body)["data"]["unreadNotificationsCount"] ==
                    null
                ? "0"
                : json
                    .decode(response.body)["data"]["unreadNotificationsCount"]
                    .toString());
        //
        await localStorage.setString(
            'level',
            json.decode(response.body)["data"]["level"] == null
                ? "0"
                : json.decode(response.body)["data"]["level"].toString());
        //
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        totalEarnings =
            json.decode(response.body)["data"]["totalEarnings"].toString();
        //
        await localStorage.setString('totalEarnings',
            json.decode(response.body)["data"]["totalEarnings"].toString());
        //
        totalJobs = json.decode(response.body)["data"]["completedJobs"] == null
            ? "0"
            : json.decode(response.body)["data"]["completedJobs"].toString();
        //
        await localStorage.setString(
            'totalJobs',
            json.decode(response.body)["data"]["completedJobs"] == null
                ? "0"
                : json
                    .decode(response.body)["data"]["completedJobs"]
                    .toString());
        //
        totalRatings =
            json.decode(response.body)["data"]["totalRating"].toString();
        //
        await localStorage.setString('totalRatings',
            json.decode(response.body)["data"]["totalRating"].toString());
        //
        await localStorage.setString('responseOnTime',
            json.decode(response.body)["data"]["responseOnTime"].toString());
        //
        await localStorage.setString('totalScore',
            json.decode(response.body)["data"]["totalScore"].toString());
        //
        await localStorage.setString('completeJobsPerc',
            json.decode(response.body)["data"]["completeJobsPerc"].toString());
        //
        await localStorage.setString('cancelJobsPerc',
            json.decode(response.body)["data"]["cancelJobsPerc"].toString());
        //
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      } else {
        activeUser = false;
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        //
        await localStorage.setString('noti', "0");
        //
        await localStorage.setString('level', "1");
        //
        totalEarnings = "0";
        //
        await localStorage.setString('totalEarnings', "0");
        //
        totalJobs = "0";
        //
        await localStorage.setString('totalJobs', "0");
        //
        totalRatings = "0";
        //
        await localStorage.setString('totalRatings', "0");
        //
        await localStorage.setString('responseOnTime', "0");
        //
        await localStorage.setString('totalScore', "0");
        //
        await localStorage.setString('completeJobsPerc', "0");
        //
        await localStorage.setString('cancelJobsPerc', "0");
        //
        List jsonResponse = [];
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      }
    }
  }

  void completeFunc() {
    getUserDataFromLocal().then((value) async {
      futureData = get2AvailJobFunction();
      // _chartData = getChartData();
      // _tooltipBehavior = TooltipBehavior(enable: true);
      loading = false;
    }).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> afterTimeFunc() async {
    futureData = get2AvailJobFunction();
  }

  Timer? timer;

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
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      // afterTimeFunc().then((value) {
      //   if (mounted) {
      //     setState(() {});
      //   }
      // });
      completeFunc();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loading ? "Hi" : "Hi $firstName $lastName!",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: loading
          ? null
          : const Drawer(
              child: DrawerWidget(),
            ),
      body: activeUser == null
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
              ? SingleChildScrollView(
                  child: Center(
                    child: FutureBuilder<List<Data>>(
                        future: futureData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && mounted) {
                            List<Data>? data = snapshot.data;
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Total Ratings",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.03,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Image.asset(
                                                    'images/thumb.png',
                                                    height: 50,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "$totalRatings out of 5",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.04,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ReviewsRatings(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color:
                                                            HexColor("#0275D8"),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          "See more",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                size.width *
                                                                    0.02,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: HexColor("#24B550"),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Total Earnings",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.03,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Image.asset(
                                                    'images/earning.png',
                                                    height: 50,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "$totalEarnings",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.04,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TotalEarnings(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          "See more",
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                "#24B550"),
                                                            fontSize:
                                                                size.width *
                                                                    0.02,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: HexColor("#0275D8"),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Total Jobs",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.03,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Image.asset(
                                                    'images/job.png',
                                                    height: 50,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "$totalJobs Jobs",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.04,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TotalJob(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          "See more",
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                "#0275D8"),
                                                            fontSize:
                                                                size.width *
                                                                    0.02,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      // color: Colors.white,
                                    ),
                                    child: load
                                        ? LoadingAnimationWidget
                                            .fourRotatingDots(
                                            color: HexColor("#0275D8"),
                                            size: 40,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Available Jobs",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                data!.isEmpty
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.5,
                                                            child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "No available jobs yet",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          ListView.builder(
                                                            itemCount:
                                                                data.length,
                                                            // itemCount: 2,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child:
                                                                      Material(
                                                                    elevation:
                                                                        5,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#ECECEC"),
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                'images/logo3.png',
                                                                                height: 80,
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(
                                                                                    5,
                                                                                    10,
                                                                                    10,
                                                                                    10,
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            data[index].service_for == null ? "Lawn Mowing" : "Snow Plowing ${data[index].service_for}",
                                                                                          ),
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              border: Border.all(
                                                                                                color: HexColor("#24B550"),
                                                                                              ),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5),
                                                                                              child: Text(
                                                                                                "\$${data[index].grand_total}",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  color: HexColor("#24B550"),
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
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              data[index].address,
                                                                                              style: const TextStyle(
                                                                                                fontSize: 12,
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
                                                                            color:
                                                                                Colors.grey[400],
                                                                            height:
                                                                                1,
                                                                            thickness:
                                                                                1,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              0,
                                                                              0,
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "Due date: ${data[index].date}",
                                                                                  style: const TextStyle(fontSize: 10),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      TextButton(
                                                                                        onPressed: data[index].proposals.isEmpty
                                                                                            ? () async {
                                                                                                //
                                                                                                var response = await BaseClient().sendProposal(
                                                                                                  "/send-proposal",
                                                                                                  data[index].id.toString(),
                                                                                                );
                                                                                                if (response["message"] == "Unauthenticated.") {
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
                                                                                                } else {
                                                                                                  if (response["success"]) {
                                                                                                    //
                                                                                                    final snackBar = SnackBar(
                                                                                                      elevation: 0,
                                                                                                      behavior: SnackBarBehavior.floating,
                                                                                                      backgroundColor: Colors.transparent,
                                                                                                      content: AwesomeSnackbarContent(
                                                                                                        title: 'Sent!',
                                                                                                        message: '${response["message"]}',
                                                                                                        contentType: ContentType.success,
                                                                                                      ),
                                                                                                    );
                                                                                                    if (mounted) {
                                                                                                      ScaffoldMessenger.of(context)
                                                                                                        ..hideCurrentSnackBar()
                                                                                                        ..showSnackBar(snackBar);
                                                                                                      futureData = get2AvailJobFunction();
                                                                                                      setState(() {});
                                                                                                    }
                                                                                                  } else {
                                                                                                    final snackBar = SnackBar(
                                                                                                      elevation: 0,
                                                                                                      behavior: SnackBarBehavior.floating,
                                                                                                      backgroundColor: Colors.transparent,
                                                                                                      content: AwesomeSnackbarContent(
                                                                                                        title: 'Alert!',
                                                                                                        message: '${response["message"]}',
                                                                                                        contentType: ContentType.failure,
                                                                                                      ),
                                                                                                    );
                                                                                                    if (mounted) {
                                                                                                      ScaffoldMessenger.of(context)
                                                                                                        ..hideCurrentSnackBar()
                                                                                                        ..showSnackBar(snackBar);
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            : () {},
                                                                                        child: data[index].proposals.isEmpty
                                                                                            ? Text(
                                                                                                "Accept",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  color: HexColor("#24B550"),
                                                                                                ),
                                                                                              )
                                                                                            : Text(
                                                                                                "Proposal Sent",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  color: HexColor("#24B550"),
                                                                                                ),
                                                                                              ),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            PageTransition(
                                                                                              type: PageTransitionType.rightToLeftWithFade,
                                                                                              // 1
                                                                                              child: Detail(
                                                                                                address: data[index].address,
                                                                                                date: data[index].date,
                                                                                                grand_total: data[index].grand_total,
                                                                                                id: data[index].id,
                                                                                                period: data[index].period,
                                                                                                service_for: data[index].service_for,
                                                                                                fromWhere: "Available",
                                                                                                jobId: data[index].id.toString(),
                                                                                                statusOfReq: data[index].proposals.isEmpty ? false : true,
                                                                                                ln: data[index].ln,
                                                                                                lt: data[index].ln,
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
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
                                                                                            "See Details",
                                                                                            style: TextStyle(
                                                                                              color: HexColor("#0275D8"),
                                                                                              fontSize: 12,
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
                                                              );
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                              backgroundColor:
                                                                  HexColor(
                                                                      "#08CC06"),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const Requests(),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                                'See more'),
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                // Material(
                                //   elevation: 5,
                                //   child: SfCartesianChart(
                                //     title: ChartTitle(text: "Job History"),
                                //     tooltipBehavior: _tooltipBehavior,
                                //     series: <ChartSeries>[
                                //       LineSeries<_SalesData, double>(
                                //         dataSource: _chartData!,
                                //         xValueMapper: (_SalesData sales, _) => sales.year,
                                //         yValueMapper: (_SalesData sales, _) =>
                                //             sales.sales,
                                //         dataLabelSettings:
                                //             const DataLabelSettings(isVisible: true),
                                //         enableTooltip: true,
                                //       )
                                //     ],
                                //     primaryXAxis: NumericAxis(
                                //       edgeLabelPlacement: EdgeLabelPlacement.shift,
                                //     ),
                                //     primaryYAxis: NumericAxis(
                                //       numberFormat:
                                //           NumberFormat.simpleCurrency(decimalDigits: 0),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
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
                )
              : const Center(
                  child: Padding(
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
    );
  }

  List<_SalesData> getChartData() {
    final List<_SalesData> chartData = [
      _SalesData(2017, 25),
      _SalesData(2018, 20),
      _SalesData(2019, 40),
      _SalesData(2020, 10),
      _SalesData(2021, 80),
    ];
    return chartData;
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final double year;
  final double sales;
}

class Data {
  final int id;
  final String address;
  final String date;
  String? service_for;
  final String grand_total;
  final List proposals;
  final String lt;
  final String ln;
  String? period;
  Data({
    required this.id,
    required this.address,
    required this.date,
    required this.service_for,
    required this.grand_total,
    required this.proposals,
    required this.lt,
    required this.ln,
    required this.period,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      address: json['property']['address'],
      date: json['date'],
      service_for: json['service_for'],
      proposals: json['proposals'],
      grand_total: json['provider_amount'].toString(),
      lt: json['property']['lat'].toString(),
      ln: json['property']['lng'].toString(),
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
    );
  }
}
// -----------Job---------------
// -----------Job---------------
// -----------Job---------------
// -----------Job---------------
// -----------Job---------------
// showDialog(
//   context: context,
//   builder: (BuildContext context) =>
//       CupertinoAlertDialog(
//     content: Column(
//       children: <Widget>[
//         Text(
//           "You have one booking request for",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: size.width * 0.03,
//           ),
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(
//               color: HexColor("#24B550"),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//               10,
//               5,
//               10,
//               5,
//             ),
//             child: Text(
//               "\$-15.25",
//               style: TextStyle(
//                 color: HexColor("#24B550"),
//                 fontSize: size.width * 0.04,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Divider(
//           color: Colors.grey[400],
//           height: 1,
//           thickness: 1,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 "Snow Removal:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "ODR8764320819641fgjj",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 "Date:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "24-10-2022",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 "Address:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "7700 Floyd Curl Drive, San Antonio, TX, USA",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: HexColor("#24B550"),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 'Accept',
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'Decline',
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     actions: [
//       CupertinoDialogAction(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         isDefaultAction: true,
//         child: const Text("View Details"),
//       ),
//     ],
//   ),
// );
//
// -----------Hot Job---------------
// -----------Hot Job---------------
// -----------Hot Job---------------
// -----------Hot Job---------------
// -----------Hot Job---------------
// showDialog(
//   context: context,
//   builder: (BuildContext context) =>
//       CupertinoAlertDialog(
//     title: Image.asset(
//       "images/highjob.png",
//       height: 50,
//     ),
//     content: Column(
//       children: <Widget>[
//         const SizedBox(
//           height: 10,
//         ),
//         Text(
//           "You have one booking request for",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: size.width * 0.03,
//           ),
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(
//               color: HexColor("#24B550"),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//               10,
//               5,
//               10,
//               5,
//             ),
//             child: Text(
//               "\$-15.25",
//               style: TextStyle(
//                 color: HexColor("#24B550"),
//                 fontSize: size.width * 0.04,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Divider(
//           color: Colors.grey[400],
//           height: 1,
//           thickness: 1,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Snow Removal:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "ODR8764320819641fgjj",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.02,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Date:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "24-10-2022",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.02,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Address:",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: size.width * 0.03,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 "7700 Floyd Curl Drive, San Antonio, TX, USA",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.width * 0.02,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: HexColor("#24B550"),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 'Accept',
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'Decline',
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     actions: [
//       CupertinoDialogAction(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         isDefaultAction: true,
//         child: const Text("View Details"),
//       ),
//     ],
//   ),
// );
