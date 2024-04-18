import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:mowing_plowing_vendorapp/Frontend/JobServiceDetail/photoHero.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Login/login_screen.dart';
import '../Map/trackService_screen.dart';
import '../UploadLawnImages/uploadLawnImages_screen.dart';

class Detail extends StatefulWidget {
  final String fromWhere;
  final String address;
  final String lt;
  final String ln;
  final String jobId;
  final bool statusOfReq;
  final int id;
  final String date;
  final String? service_for;
  final String? period;
  final String grand_total;
  const Detail({
    Key? key,
    required this.fromWhere,
    required this.jobId,
    required this.address,
    required this.lt,
    required this.ln,
    required this.statusOfReq,
    required this.id,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  bool loading = true;
  String point1 = "";
  String point2 = "";
  String point3 = "";
  String point4 = "";
  String point5 = "";
  String point6 = "";
  String point7 = "";
  String point8 = "";
  String point9 = "";
  String point1V = "";
  String point2V = "";
  String point3V = "";
  String point4V = "";
  String point5V = "";
  String point6V = "";
  String point7V = "";
  String point8V = "";
  String point9V = "";
  String scheduleSnow = "";
  String carNo = "";
  String car = "";
  String color = "";

  String propertyLat = "";
  String propertyLng = "";
  String totalPrice = "";
  List lawnImages = [];
  // ===========================================
  final myController = TextEditingController();
  final _instructions = <Widget>[];

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

  Future getJobDetailById() async {
    // 1 api
    var response = await BaseClient().getJobDetail(
      "/jobs/details/${widget.jobId}",
    );
    print('re$response');
    // 1 api
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
      // 1 api
      if (response["success"]) {
        // success
        // 1 api
        if (response["data"]["jobDetails"]["service_for"] == null) {
          response["data"]["jobDetails"]["instructions"] != null
              ? _instructions.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              response["data"]["jobDetails"]["instructions"],
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null;
          totalPrice =
              response["data"]["jobDetails"]["provider_amount"].toString();
          propertyLat = response["data"]["jobDetails"]["lat"];
          propertyLng = response["data"]["jobDetails"]["lng"];
          point1V = response["data"]["jobDetails"]["order_id"];
          point2V = response["data"]["jobDetails"]["assigned_to"] == null
              ? "Not Assigned"
              : "Assigned";
          point3V = response["data"]["jobDetails"]["date"];
          point4V = response["data"]["jobDetails"]["service_for"] == null
              ? "Lawn Mowing"
              : "Snow Plowing ${response["data"]["jobDetails"]["service_for"]}";
          point7V = response["data"]["jobDetails"]["corner_lot_id"] == 1
              ? "Yes"
              : "No";
          lawnImages = response["data"]["jobDetails"]["images"];
          // 2 api
          var responseS = await BaseClient().sizesHeightsPrices(
            "/sizes-heights-prices",
          );
          // 2 api
          if (json.decode(responseS.body)["message"] == "Unauthenticated.") {
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
            // 2 api
            if (json.decode(responseS.body)["success"]) {
              // success
              List sizes = json.decode(responseS.body)["data"]["sizes"];
              var size = sizes
                  .where((e) =>
                      e["id"] == response["data"]["jobDetails"]["lawn_size_id"])
                  .toList();
              // This point error occurs
              //
              //
              point5V = response["data"]["jobDetails"]["lawn_size_id"] == null
                  ? ""
                  : size[0]["name"];
              List heights = json.decode(responseS.body)["data"]["heights"];
              var height = heights
                  .where((e) =>
                      e["id"] ==
                      response["data"]["jobDetails"]["lawn_height_id"])
                  .toList();
              point6V = response["data"]["jobDetails"]["lawn_height_id"] == null
                  ? ""
                  : height[0]["name"];
              if (response["data"]["jobDetails"]["fence_id"] != null) {
                List fences = json.decode(responseS.body)["data"]["fences"];
                var fen = fences
                    .where((e) =>
                        e["id"] == response["data"]["jobDetails"]["fence_id"])
                    .toList();
                point8V = fen[0]["name"];
              } else {
                point8V = "No";
              }
              // 3 api
              if (response["data"]["jobDetails"]["cleanup_id"] == null) {
                point9V = "No";
              } else {
                var res = await BaseClient().lawnSizeCleanupPrice(
                  "/lawn-size-cleanup-price",
                  response["data"]["jobDetails"]["lawn_size_id"].toString(),
                );
                // 3 api
                if (res["message"] == "Unauthenticated.") {
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
                  // 3 api
                  if (res["success"]) {
                    // success
                    List cleanUps = res["data"]["cleanUps"];
                    var clean = cleanUps
                        .where((e) =>
                            e["id"] ==
                            response["data"]["jobDetails"]["cleanup_id"])
                        .toList();
                    // print(res["data"]["cleanUps"]);
                    // print(response["data"]["jobDetails"]["cleanup_id"]);
                    // print(clean);
                    point9V = clean[0]["name"];
                  } else {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Alert!',
                        message: '${res["message"]}',
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
            } else {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Alert!',
                  message: '${json.decode(response.body)["message"]}',
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
          point1 = "Order ID";
          point2 = "Service Provider";
          point3 = "Date";
          point4 = "Service";
          point5 = "Lawn Size";
          point6 = "Lawn Height";
          point7 = "Corner Lot";
          point8 = "Fence";
          point9 = "Yard Clenup";
        } else {
          response["data"]["jobDetails"]["instructions"] != null
              ? _instructions.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              response["data"]["jobDetails"]["instructions"],
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null;
          totalPrice =
              response["data"]["jobDetails"]["provider_amount"].toString();
          propertyLat = response["data"]["jobDetails"]["lat"];
          propertyLng = response["data"]["jobDetails"]["lng"];
          point1V = response["data"]["jobDetails"]["order_id"];
          point2V = response["data"]["jobDetails"]["assigned_to"] == null
              ? "Not Assigned"
              : "Assigned";
          point3V = response["data"]["jobDetails"]["date"];
          point4V = response["data"]["jobDetails"]["service_for"] == null
              ? "Lawn Mowing"
              : "Snow Plowing ${response["data"]["jobDetails"]["service_for"]}";
          lawnImages = response["data"]["jobDetails"]["images"];
          // 2 api
          var responseS = await BaseClient().snowPlowingCatPrSch(
            "/cars-and-schedule",
            response["data"]["jobDetails"]["service_for"] == "Car"
                ? "car"
                : response["data"]["jobDetails"]["service_for"] == "Home"
                    ? "home"
                    : "business",
          );
          // 2 api
          if (responseS["message"] == "Unauthenticated.") {
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
            // 2 api
            if (responseS["success"]) {
              // success
              //
              List snowPlowSch = responseS["data"]["snowPlowingSchedules"];
              var snowPlowingSchedules = snowPlowSch
                  .where((e) =>
                      e["id"] ==
                      response["data"]["jobDetails"]
                          ["snow_plowing_schedule_id"])
                  .toList();
              // point5V = snowPlowingSchedules[0]["name"] +
              //     "  " +
              //     "(${snowPlowingSchedules[0]["time"]})";
              point5V = response["data"]["jobDetails"]
                          ["snow_plowing_schedule_id"] ==
                      null
                  ? ""
                  : snowPlowingSchedules[0]["name"] +
                      "  " +
                      "(${snowPlowingSchedules[0]["time"]})";

              //
              if (response["data"]["jobDetails"]["service_for"] == "Car") {
                //
                point8V = response["data"]["jobDetails"]["car_number"];
                List carPNo = responseS["data"]["carTypes"];
                var plateNo = carPNo
                    .where((e) =>
                        e["id"] ==
                        response["data"]["jobDetails"]["subcategory_id"])
                    .toList();
                point6V = plateNo[0]["name"];
                //
                List col = responseS["data"]["colors"];
                var colors = col
                    .where((e) =>
                        e["id"] == response["data"]["jobDetails"]["color_id"])
                    .toList();
                point7V = response["data"]["jobDetails"]["color_id"] == null
                    ? ""
                    : colors[0]["name"];
                //
              } else {
                //
                List snowD = responseS["data"]["snowDepths"];
                var snowDepth = snowD
                    .where((e) =>
                        e["id"] ==
                        response["data"]["jobDetails"]["snow_depth_id"])
                    .toList();
                point6V =
                    response["data"]["jobDetails"]["snow_depth_id"] == null
                        ? ""
                        : snowDepth[0]["name"];
                //
                point7V = response["data"]["jobDetails"]["driveway"] == null
                    ? ""
                    : response["data"]["jobDetails"]["driveway"].toString();
                point8V =
                    response["data"]["jobDetails"]["sidewalk_sizes"].toString();
                point9V =
                    response["data"]["jobDetails"]["walkway_sizes"].toString();
              }
              //
            } else {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Alert!',
                  message: '$responseS["message"]}',
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
          if (response["data"]["jobDetails"]["service_for"] == "Car") {
            point1 = "Order ID";
            point2 = "Service Provider";
            point3 = "Date";
            point4 = "Service";
            point5 = "Schedule";
            point6 = "Car";
            point7 = "Car Color";
            point8 = "Plate Number";
            point9 = "";
          } else if (response["data"]["jobDetails"]["service_for"] == "Home") {
            point1 = "Order ID";
            point2 = "Service Provider";
            point3 = "Date";
            point4 = "Service";
            point5 = "Schedule";
            point6 = "Snow Depth";
            point7 = "Driveway (Number of cars)";
            point8 = point8V == "null" ? "" : "Sidewalk Size";
            point9 = point9V == "null" ? "" : "Walkway Size";
          } else {
            point1 = "Order ID";
            point2 = "Service Provider";
            point3 = "Date";
            point4 = "Service";
            point5 = "Schedule";
            point6 = "Snow Depth";
            point7 = "Driveway (Number of cars)";
            point8 = point8V == "null" ? "" : "Sidewalk Size";
            point9 = point9V == "null" ? "" : "Walkway Size";
          }
        }
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Alert!',
            message: '${json.decode(response.body)["message"]}',
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

  void completeFunct() {
    getJobDetailById().then((value) async {
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> goBack() async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: BottomNavBar(
            index: 2,
          ),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   PageTransition(
      //     type: PageTransitionType.rightToLeftWithFade,
      //     child: BottomNavBar(
      //       index: 2,
      //     ),
      //   ),
      //   (route) => false,
      // );
    }
  }

  FutureOr onGoBack(dynamic value) {
    goBack();
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
      String? service_for) async {
    Location location = new Location();

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
          ).then(onGoBack);
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
          ).then(onGoBack);
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
          ).then(onGoBack);
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
        ).then(onGoBack);
      }
    }

    // _locationData = await location.getLocation();
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
    completeFunct();
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
          child: SizedBox(
            child: loading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: HexColor("#0275D8"),
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  )
                : Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: HexColor("#CBCBCB"), width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            child: point1.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point1),
                                            Text(point1V),
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
                          ),
                          SizedBox(
                            child: point2.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point2),
                                            Text(point2V),
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
                          ),
                          SizedBox(
                            child: point3.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point3),
                                            Text(point3V),
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
                          ),
                          SizedBox(
                            child: point4.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point4),
                                            Text(point4V),
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
                          ),
                          SizedBox(
                            child: point5.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point5),
                                            Text(point5V),
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
                          ),
                          SizedBox(
                            child: point6.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point6),
                                            Text(point6V),
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
                          ),
                          SizedBox(
                            child: point7.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point7),
                                            Text(point7V),
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
                          ),
                          SizedBox(
                            child: point8.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point8),
                                            Text(point8V),
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
                          ),
                          SizedBox(
                            child: point9.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(point9),
                                            Text(point9V),
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
                          ),
                          Visibility(
                            visible: lawnImages.isEmpty ? false : true,
                            child: const Padding(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: lawnImages.isEmpty
                                ? null
                                : GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: lawnImages.length,
                                    itemBuilder: (context, index) {
                                      // Item rendering
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImageViewer(
                                                  imageUrl +
                                                      lawnImages[index]
                                                          ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl +
                                                lawnImages[index]["image"],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                LoadingAnimationWidget
                                                    .fourRotatingDots(
                                              color: HexColor("#0275D8"),
                                              size: 40,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          //
                          //
                          //
                          //
                          // Visibility(
                          //   visible: widget.fromWhere == "Available" ||
                          //           widget.fromWhere == "Completed"
                          //       ? false
                          //       : true,
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.fromLTRB(10, 15, 10, 20),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         Icon(
                          //           Icons.circle,
                          //           color: HexColor("#58D109"),
                          //         ),
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(bottom: 4),
                          //             child: Column(
                          //               children: [
                          //                 Text(
                          //                   "On his way",
                          //                   style: TextStyle(
                          //                     fontSize: size.width * 0.02,
                          //                   ),
                          //                 ),
                          //                 Divider(
                          //                   color: HexColor("#58D109"),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         Icon(
                          //           Icons.circle,
                          //           color: HexColor("#58D109"),
                          //         ),
                          //         Flexible(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(bottom: 4),
                          //             child: Column(
                          //               children: [
                          //                 Text(
                          //                   "Started Job",
                          //                   style: TextStyle(
                          //                     fontSize: size.width * 0.02,
                          //                   ),
                          //                 ),
                          //                 Divider(
                          //                   color: HexColor("#58D109"),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         Icon(
                          //           Icons.circle,
                          //           color: HexColor("#58D109"),
                          //         ),
                          //         Flexible(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(bottom: 4),
                          //             child: Column(
                          //               children: [
                          //                 Text(
                          //                   "Finished Job",
                          //                   style: TextStyle(
                          //                     fontSize: size.width * 0.02,
                          //                   ),
                          //                 ),
                          //                 Divider(
                          //                   color: HexColor("#58D109"),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         Icon(
                          //           Icons.circle,
                          //           color: HexColor("#58D109"),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //
                          //
                          //
                          //
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/logo3.png',
                                      height: 80,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Address:"),
                                              Icon(
                                                Icons.place,
                                                color: HexColor("#0275D8"),
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
                                                  widget.address,
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
                                Text(
                                  "Customer job instructions",
                                  style: TextStyle(
                                    color: HexColor("#0275D8"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: _instructions.isEmpty
                                ? [
                                    const Text("No instructions added"),
                                  ]
                                : _instructions,
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
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Text(
                                        "\$$totalPrice",
                                        style: const TextStyle(
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
                            child: widget.fromWhere == "Available" &&
                                    widget.statusOfReq == false
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#24B550"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            minimumSize:
                                                const Size.fromHeight(50),
                                          ),
                                          onPressed: () async {
                                            //
                                            var response =
                                                await BaseClient().sendProposal(
                                              "/send-proposal",
                                              widget.jobId.toString(),
                                            );
                                            if (response["message"] ==
                                                "Unauthenticated.") {
                                              if (mounted) {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeftWithFade,
                                                    // 3
                                                    child: const LogIn(),
                                                  ),
                                                  (route) => false,
                                                );
                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: 'Alert!',
                                                    message:
                                                        'To continue, kindly log in again',
                                                    contentType:
                                                        ContentType.help,
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              }
                                            } else {
                                              if (response["success"]) {
                                                //
                                                if (mounted) {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeftWithFade,
                                                      child: BottomNavBar(
                                                        index: null,
                                                      ),
                                                    ),
                                                    (route) => false,
                                                  );
                                                }
                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: 'Sent!',
                                                    message:
                                                        '${response["message"]}',
                                                    contentType:
                                                        ContentType.success,
                                                  ),
                                                );
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(snackBar);
                                                }
                                              } else {
                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: 'Alert!',
                                                    message:
                                                        '${response["message"]}',
                                                    contentType:
                                                        ContentType.failure,
                                                  ),
                                                );
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(snackBar);
                                                }
                                              }
                                            }
                                          },
                                          child: const Text('Accept'),
                                        ),
                                      ),
                                    ],
                                  )
                                : widget.fromWhere == "Available" &&
                                        widget.statusOfReq
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                minimumSize:
                                                    const Size.fromHeight(50),
                                              ),
                                              onPressed: () {},
                                              child: const Text('Accepted'),
                                            ),
                                          ),
                                        ],
                                      )
                                    : widget.fromWhere == "Completed"
                                        ? null
                                        : widget.fromWhere == "ActiveStart"
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      HexColor("#24B550"),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  minimumSize:
                                                      const Size.fromHeight(50),
                                                ),
                                                onPressed: () async {
                                                  //
                                                  //
                                                  var response =
                                                      await BaseClient()
                                                          .activeJobStatus(
                                                    "/active-job/on-my-way/${widget.jobId}",
                                                    null,
                                                    null,
                                                  );
                                                  if (response["success"]) {
                                                    await EasyLoading.dismiss();
                                                    if (mounted) {
                                                      checkPermissionStatus(
                                                        'OnMyWay',
                                                        widget.ln,
                                                        widget.lt,
                                                        widget.address,
                                                        widget.date,
                                                        widget.grand_total,
                                                        widget.id,
                                                        widget.period,
                                                        widget.service_for,
                                                      );
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         TrackService(
                                                      //       address:
                                                      //           widget.address,
                                                      //       date: widget.date,
                                                      //       grand_total: widget
                                                      //           .grand_total,
                                                      //       id: widget.id,
                                                      //       period:
                                                      //           widget.period,
                                                      //       service_for: widget
                                                      //           .service_for,
                                                      //       fromWhere:
                                                      //           'OnMyWay',
                                                      //       ln: widget.ln,
                                                      //       lt: widget.lt,
                                                      //     ),
                                                      //   ),
                                                      // ).then(onGoBack);
                                                    }
                                                  } else {
                                                    await EasyLoading.dismiss();
                                                    final snackBar = SnackBar(
                                                      elevation: 0,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content:
                                                          AwesomeSnackbarContent(
                                                        title: 'Alert!',
                                                        message:
                                                            '${response["message"]}',
                                                        contentType:
                                                            ContentType.failure,
                                                      ),
                                                    );
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                        ..hideCurrentSnackBar()
                                                        ..showSnackBar(
                                                            snackBar);
                                                    }
                                                  }
                                                  //
                                                  //
                                                },
                                                child: const Text('On my way'),
                                              )
                                            : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      HexColor("#24B550"),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  minimumSize:
                                                      const Size.fromHeight(50),
                                                ),
                                                onPressed: () {},
                                                child: const Text(
                                                    'No fromwhere matched'),
                                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
