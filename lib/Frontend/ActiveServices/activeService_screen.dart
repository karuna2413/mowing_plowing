import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Chat/chat_screen.dart';
import '../JobServiceDetail/detail_screen.dart';
import '../Login/login_screen.dart';
import '../Map/trackService_screen.dart';

class ActiveService extends StatefulWidget {
  const ActiveService();

  @override
  State<ActiveService> createState() => _ActiveServiceState();
}

class _ActiveServiceState extends State<ActiveService>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Data>>? futureData;
  Future<List<Data1>>? futureData1;
  Future<List<Data2>>? futureData2;
  List<dynamic> jobs = [];
  late TabController _controller;
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

  Future<List<Data>> getAvailJobFunction() async {
    var response = await BaseClient().getAvailJobs(
      "/jobs",
      "active",
    );
    print('res${response.body}');
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
        List jsonResponse = json.decode(response.body)["data"]["today_jobs"];
        if (mounted) {
          setState(() {});
        }
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      } else {
        activeUser = false;
        List jsonResponse = [];
        if (mounted) {
          setState(() {});
        }
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      }
    }
  }

  Future<List<Data1>> getAvailJobFunction1() async {
    var response = await BaseClient().getAvailJobs(
      "/jobs",
      "active",
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
        activeUser = json.decode(response.body)["success"];
        List jsonResponse = json.decode(response.body)["data"]["week_jobs"];
        return jsonResponse.map((data) => Data1.fromJson(data)).toList();
      } else {
        activeUser = false;
        List jsonResponse = [];
        return jsonResponse.map((data) => Data1.fromJson(data)).toList();
      }
    }
  }

  Future<List<Data2>> getAvailJobFunction2() async {
    var response = await BaseClient().getAvailJobs(
      "/jobs",
      "active",
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
        activeUser = json.decode(response.body)["success"];
        List jsonResponse = json.decode(response.body)["data"]["month_jobs"];
        return jsonResponse.map((data) => Data2.fromJson(data)).toList();
      } else {
        activeUser = false;
        List jsonResponse = [];
        return jsonResponse.map((data) => Data2.fromJson(data)).toList();
      }
    }
  }

  void checkPermissionStatus(
    String fromWhere,
    String ln,
    String lt,
    String address,
    String date,
    String grand_total,
    int id,
    String? period,
    String? service_for,
  ) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _permissionGranted = await location.hasPermission();
    _serviceEnabled = await location.serviceEnabled();
    //
    //
    if (!_serviceEnabled && _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          );
        }
      }
    } else if (_serviceEnabled &&
        _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          );
        }
      }
    } else if (!_serviceEnabled &&
        _permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackService(
              fromWhere: fromWhere,
              ln: ln,
              lt: lt,
              address: address,
              date: date,
              grand_total: grand_total,
              id: id,
              period: period,
              service_for: service_for,
            ),
          ),
        );
      }
    }

    // _locationData = await location.getLocation();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
    );
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      if (_controller.index == 0) {
        futureData = getAvailJobFunction();
        // if (mounted) {
        //   setState(() {});
        // }
      } else if (_controller.index == 1) {
        futureData1 = getAvailJobFunction1();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 2) {
        futureData2 = getAvailJobFunction2();
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
    futureData = getAvailJobFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Active Jobs",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            controller: _controller,
            tabs: [
              SizedBox(
                child: Tab(
                  height: 60,
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                    ),
                  ),
                ),
              ),
              Tab(
                height: 60,
                child: Text(
                  "Week",
                  style: TextStyle(
                    fontSize: size.width * 0.03,
                  ),
                ),
              ),
              Tab(
                height: 60,
                child: Text(
                  "Month",
                  style: TextStyle(
                    fontSize: size.width * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            //
            SingleChildScrollView(
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
                                          "No active jobs for today",
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Material(
                                                    elevation: 5,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#ECECEC"),
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
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            data[index].service_for == null
                                                                                ? "Lawn Mowing"
                                                                                : "Snow Plowing ${data[index].service_for}",
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(
                                                                                color: HexColor("#24B550"),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: Text(
                                                                                "\$${data[index].grand_total}",
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: HexColor(
                                                                                    "#24B550",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              data[index].address,
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[400],
                                                            height: 1,
                                                            thickness: 1,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
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
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            PageTransition(
                                                                              type: PageTransitionType.rightToLeftWithFade,
                                                                              // 3
                                                                              child: Chat(
                                                                                orderId: data[index].id.toString(),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                HexColor("#DCFFE7"),
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                ImageIcon(
                                                                              const AssetImage(
                                                                                "images/chat.png",
                                                                              ),
                                                                              color: HexColor("#24B550"),
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: data[index].on_the_way == null &&
                                                                                data[index].at_location_and_started_job == null &&
                                                                                data[index].finished_job == null
                                                                            ? () {
                                                                                print('detail page');
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Detail(
                                                                                      fromWhere: 'ActiveStart',
                                                                                      address: data[index].address,
                                                                                      date: data[index].date,
                                                                                      grand_total: data[index].grand_total,
                                                                                      id: data[index].id,
                                                                                      period: data[index].period,
                                                                                      service_for: data[index].service_for,
                                                                                      jobId: data[index].id.toString(),
                                                                                      statusOfReq: true,
                                                                                      ln: data[index].ln,
                                                                                      lt: data[index].lt,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? () {
                                                                                    print('permission status onway');

                                                                                    checkPermissionStatus(
                                                                                      'OnMyWay',
                                                                                      data[index].ln,
                                                                                      data[index].lt,
                                                                                      data[index].address,
                                                                                      data[index].date,
                                                                                      data[index].grand_total,
                                                                                      data[index].id,
                                                                                      data[index].period,
                                                                                      data[index].service_for,
                                                                                    );
                                                                                  }
                                                                                // () {
                                                                                //     Navigator.push(
                                                                                //       context,
                                                                                //       MaterialPageRoute(
                                                                                //         builder: (context) => TrackService(
                                                                                //           fromWhere: 'OnMyWay',
                                                                                //           ln: data[index].ln,
                                                                                //           lt: data[index].lt,
                                                                                //           address: data[index].address,
                                                                                //           date: data[index].date,
                                                                                //           grand_total: data[index].grand_total,
                                                                                //           id: data[index].id,
                                                                                //           period: data[index].period,
                                                                                //           service_for: data[index].service_for,
                                                                                //         ),
                                                                                //       ),
                                                                                //     );
                                                                                //   }
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                    ? () {
                                                                                        print('jobstart page');

                                                                                        checkPermissionStatus(
                                                                                          'jobStarted',
                                                                                          data[index].ln,
                                                                                          data[index].lt,
                                                                                          data[index].address,
                                                                                          data[index].date,
                                                                                          data[index].grand_total,
                                                                                          data[index].id,
                                                                                          data[index].period,
                                                                                          data[index].service_for,
                                                                                        );
                                                                                      }
                                                                                    // () {
                                                                                    //     Navigator.push(
                                                                                    //       context,
                                                                                    //       MaterialPageRoute(
                                                                                    //         builder: (context) => TrackService(
                                                                                    //           fromWhere: 'jobStarted',
                                                                                    //           ln: data[index].ln,
                                                                                    //           lt: data[index].lt,
                                                                                    //           address: data[index].address,
                                                                                    //           date: data[index].date,
                                                                                    //           grand_total: data[index].grand_total,
                                                                                    //           id: data[index].id,
                                                                                    //           period: data[index].period,
                                                                                    //           service_for: data[index].service_for,
                                                                                    //         ),
                                                                                    //       ),
                                                                                    //     );
                                                                                    //   }
                                                                                    : null,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.blue,
                                                                              width: 0.5,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              5,
                                                                            ),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              Text(
                                                                            data[index].on_the_way == null && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? "Start Now"
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                    ? "On my way"
                                                                                    : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                        ? "Job Started"
                                                                                        : "to be continued",
                                                                            style:
                                                                                TextStyle(
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
                                                Visibility(
                                                  visible:
                                                      data[index].period == null
                                                          ? false
                                                          : true,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
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
            //
            //
            SingleChildScrollView(
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
                        ? FutureBuilder<List<Data1>>(
                            future: futureData1,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && mounted) {
                                List<Data1>? data = snapshot.data;
                                return data!.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          "No active jobs for this week",
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Material(
                                                    elevation: 5,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#ECECEC"),
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
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            data[index].service_for == null
                                                                                ? "Lawn Mowing"
                                                                                : "Snow Plowing ${data[index].service_for}",
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(
                                                                                color: HexColor("#24B550"),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: Text(
                                                                                "\$${data[index].grand_total}",
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: HexColor(
                                                                                    "#24B550",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              data[index].address,
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[400],
                                                            height: 1,
                                                            thickness: 1,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
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
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            PageTransition(
                                                                              type: PageTransitionType.rightToLeftWithFade,
                                                                              // 3
                                                                              child: Chat(
                                                                                orderId: data[index].id.toString(),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                HexColor("#DCFFE7"),
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                ImageIcon(
                                                                              const AssetImage(
                                                                                "images/chat.png",
                                                                              ),
                                                                              color: HexColor("#24B550"),
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: data[index].on_the_way == null &&
                                                                                data[index].at_location_and_started_job == null &&
                                                                                data[index].finished_job == null
                                                                            ? () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Detail(
                                                                                      fromWhere: 'ActiveStart',
                                                                                      address: data[index].address,
                                                                                      date: data[index].date,
                                                                                      grand_total: data[index].grand_total,
                                                                                      id: data[index].id,
                                                                                      period: data[index].period,
                                                                                      service_for: data[index].service_for,
                                                                                      jobId: data[index].id.toString(),
                                                                                      statusOfReq: true,
                                                                                      ln: data[index].ln,
                                                                                      lt: data[index].lt,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? () {
                                                                                    checkPermissionStatus(
                                                                                      'OnMyWay',
                                                                                      data[index].ln,
                                                                                      data[index].lt,
                                                                                      data[index].address,
                                                                                      data[index].date,
                                                                                      data[index].grand_total,
                                                                                      data[index].id,
                                                                                      data[index].period,
                                                                                      data[index].service_for,
                                                                                    );
                                                                                  }
                                                                                // () {
                                                                                //     Navigator.push(
                                                                                //       context,
                                                                                //       MaterialPageRoute(
                                                                                //         builder: (context) => TrackService(
                                                                                //           fromWhere: 'OnMyWay',
                                                                                //           ln: data[index].ln,
                                                                                //           lt: data[index].lt,
                                                                                //           address: data[index].address,
                                                                                //           date: data[index].date,
                                                                                //           grand_total: data[index].grand_total,
                                                                                //           id: data[index].id,
                                                                                //           period: data[index].period,
                                                                                //           service_for: data[index].service_for,
                                                                                //         ),
                                                                                //       ),
                                                                                //     );
                                                                                //   }
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                    ? () {
                                                                                        checkPermissionStatus(
                                                                                          'jobStarted',
                                                                                          data[index].ln,
                                                                                          data[index].lt,
                                                                                          data[index].address,
                                                                                          data[index].date,
                                                                                          data[index].grand_total,
                                                                                          data[index].id,
                                                                                          data[index].period,
                                                                                          data[index].service_for,
                                                                                        );
                                                                                      }
                                                                                    // () {
                                                                                    //     Navigator.push(
                                                                                    //       context,
                                                                                    //       MaterialPageRoute(
                                                                                    //         builder: (context) => TrackService(
                                                                                    //           fromWhere: 'jobStarted',
                                                                                    //           ln: data[index].ln,
                                                                                    //           lt: data[index].lt,
                                                                                    //           address: data[index].address,
                                                                                    //           date: data[index].date,
                                                                                    //           grand_total: data[index].grand_total,
                                                                                    //           id: data[index].id,
                                                                                    //           period: data[index].period,
                                                                                    //           service_for: data[index].service_for,
                                                                                    //         ),
                                                                                    //       ),
                                                                                    //     );
                                                                                    //   }
                                                                                    : null,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.blue,
                                                                              width: 0.5,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              5,
                                                                            ),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              Text(
                                                                            data[index].on_the_way == null && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? "Start Now"
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                    ? "On my way"
                                                                                    : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                        ? "Job Started"
                                                                                        : "to be continued",
                                                                            style:
                                                                                TextStyle(
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
                                                Visibility(
                                                  visible:
                                                      data[index].period == null
                                                          ? false
                                                          : true,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
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
            //
            //
            SingleChildScrollView(
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
                        ? FutureBuilder<List<Data2>>(
                            future: futureData2,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && mounted) {
                                List<Data2>? data = snapshot.data;
                                return data!.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          "No active jobs for this month",
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Material(
                                                    elevation: 5,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#ECECEC"),
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
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            data[index].service_for == null
                                                                                ? "Lawn Mowing"
                                                                                : "Snow Plowing ${data[index].service_for}",
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(
                                                                                color: HexColor("#24B550"),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: Text(
                                                                                "\$${data[index].grand_total}",
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: HexColor(
                                                                                    "#24B550",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              data[index].address,
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[400],
                                                            height: 1,
                                                            thickness: 1,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
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
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            PageTransition(
                                                                              type: PageTransitionType.rightToLeftWithFade,
                                                                              // 3
                                                                              child: Chat(
                                                                                orderId: data[index].id.toString(),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                HexColor("#DCFFE7"),
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                ImageIcon(
                                                                              const AssetImage(
                                                                                "images/chat.png",
                                                                              ),
                                                                              color: HexColor("#24B550"),
                                                                              size: 25,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: data[index].on_the_way == null &&
                                                                                data[index].at_location_and_started_job == null &&
                                                                                data[index].finished_job == null
                                                                            ? () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Detail(
                                                                                      fromWhere: 'ActiveStart',
                                                                                      address: data[index].address,
                                                                                      date: data[index].date,
                                                                                      grand_total: data[index].grand_total,
                                                                                      id: data[index].id,
                                                                                      period: data[index].period,
                                                                                      service_for: data[index].service_for,
                                                                                      jobId: data[index].id.toString(),
                                                                                      statusOfReq: true,
                                                                                      ln: data[index].ln,
                                                                                      lt: data[index].lt,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? () {
                                                                                    checkPermissionStatus(
                                                                                      'OnMyWay',
                                                                                      data[index].ln,
                                                                                      data[index].lt,
                                                                                      data[index].address,
                                                                                      data[index].date,
                                                                                      data[index].grand_total,
                                                                                      data[index].id,
                                                                                      data[index].period,
                                                                                      data[index].service_for,
                                                                                    );
                                                                                  }
                                                                                // () {
                                                                                //     Navigator.push(
                                                                                //       context,
                                                                                //       MaterialPageRoute(
                                                                                //         builder: (context) => TrackService(
                                                                                //           fromWhere: 'OnMyWay',
                                                                                //           ln: data[index].ln,
                                                                                //           lt: data[index].lt,
                                                                                //           address: data[index].address,
                                                                                //           date: data[index].date,
                                                                                //           grand_total: data[index].grand_total,
                                                                                //           id: data[index].id,
                                                                                //           period: data[index].period,
                                                                                //           service_for: data[index].service_for,
                                                                                //         ),
                                                                                //       ),
                                                                                //     );
                                                                                //   }
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                    ? () {
                                                                                        checkPermissionStatus(
                                                                                          'jobStarted',
                                                                                          data[index].ln,
                                                                                          data[index].lt,
                                                                                          data[index].address,
                                                                                          data[index].date,
                                                                                          data[index].grand_total,
                                                                                          data[index].id,
                                                                                          data[index].period,
                                                                                          data[index].service_for,
                                                                                        );
                                                                                      }
                                                                                    // () {
                                                                                    //     Navigator.push(
                                                                                    //       context,
                                                                                    //       MaterialPageRoute(
                                                                                    //         builder: (context) => TrackService(
                                                                                    //           fromWhere: 'jobStarted',
                                                                                    //           ln: data[index].ln,
                                                                                    //           lt: data[index].lt,
                                                                                    //           address: data[index].address,
                                                                                    //           date: data[index].date,
                                                                                    //           grand_total: data[index].grand_total,
                                                                                    //           id: data[index].id,
                                                                                    //           period: data[index].period,
                                                                                    //           service_for: data[index].service_for,
                                                                                    //         ),
                                                                                    //       ),
                                                                                    //     );
                                                                                    //   }
                                                                                    : null,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.blue,
                                                                              width: 0.5,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              5,
                                                                            ),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              Text(
                                                                            data[index].on_the_way == null && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                ? "Start Now"
                                                                                : data[index].on_the_way == "1" && data[index].at_location_and_started_job == null && data[index].finished_job == null
                                                                                    ? "On my way"
                                                                                    : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == null
                                                                                        ? "Job Started"
                                                                                        : "to be continued",
                                                                            style:
                                                                                TextStyle(
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
                                                Visibility(
                                                  visible:
                                                      data[index].period == null
                                                          ? false
                                                          : true,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
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
            //
          ],
        ),
      ),
    );
  }
}

class Data {
  final int id;
  final String address;
  final String lt;
  final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  String? on_the_way;
  String? at_location_and_started_job;
  String? finished_job;

  Data({
    required this.id,
    required this.address,
    required this.lt,
    required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    required this.on_the_way,
    required this.at_location_and_started_job,
    required this.finished_job,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      address: json['property']['address'],
      lt: json['property']['lat'].toString(),
      ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      on_the_way:
          json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      at_location_and_started_job: json['at_location_and_started_job'] == null
          ? null
          : json['at_location_and_started_job'].toString(),
      finished_job:
          json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}

class Data1 {
  final int id;
  final String address;
  final String lt;
  final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  String? on_the_way;
  String? at_location_and_started_job;
  String? finished_job;

  Data1({
    required this.id,
    required this.address,
    required this.lt,
    required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    required this.on_the_way,
    required this.at_location_and_started_job,
    required this.finished_job,
  });

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      id: json['id'],
      address: json['property']['address'],
      lt: json['property']['lat'].toString(),
      ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      on_the_way:
          json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      at_location_and_started_job: json['at_location_and_started_job'] == null
          ? null
          : json['at_location_and_started_job'].toString(),
      finished_job:
          json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}

class Data2 {
  final int id;
  final String address;
  final String lt;
  final String ln;
  final String date;
  String? service_for;
  String? period;
  final String grand_total;
  String? on_the_way;
  String? at_location_and_started_job;
  String? finished_job;

  Data2({
    required this.id,
    required this.address,
    required this.lt,
    required this.ln,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    required this.on_the_way,
    required this.at_location_and_started_job,
    required this.finished_job,
  });

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      id: json['id'],
      address: json['property']['address'],
      lt: json['property']['lat'].toString(),
      ln: json['property']['lng'].toString(),
      date: json['date'],
      service_for: json['service_for'],
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      grand_total: json['provider_amount'].toString(),
      on_the_way:
          json['on_the_way'] == null ? null : json['on_the_way'].toString(),
      at_location_and_started_job: json['at_location_and_started_job'] == null
          ? null
          : json['at_location_and_started_job'].toString(),
      finished_job:
          json['finished_job'] == null ? null : json['finished_job'].toString(),
    );
  }
}
