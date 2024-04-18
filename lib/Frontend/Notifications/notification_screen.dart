import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Chat/chat_screen.dart';
import '../JobServiceDetail/detail_screen.dart';
import '../Login/login_screen.dart';
import '../TotalRating/reviewsRating_screen.dart';

class Notifications extends StatefulWidget {
  const Notifications();

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<Notifies>> futureData;

  Future<List<Notifies>> getNotifiesFunction() async {
    var response = await BaseClient().getNotification(
      "/notifications",
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
        List jsonResponse = json
            .decode(response.body)["data"]["allNotifications"]
            .where((data) => data['flag'] != 'Order cancelled')
            .toList();
        return jsonResponse.map((data) => Notifies.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  readNotifiesFunction() async {
    var response = await BaseClient().getNotification(
      "/notifications/update-status",
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
    } else {
      if (!json.decode(response.body)["success"]) {
        if (mounted) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Alert!',
              message: 'Kindly refresh the page again...',
              contentType: ContentType.help,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    }
  }

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

  void completeFunct() {
    futureData = getNotifiesFunction();
    if (mounted) {
      readNotifiesFunction();
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                FutureBuilder<List<Notifies>>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && mounted) {
                      List<Notifies>? data = snapshot.data;
                      return ListView.builder(
                        itemCount: data!.length,
                        // itemCount: _properties.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (data[index].flag == 'Chat') {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    // 3
                                    child: Chat(
                                      orderId: data[index].order_id.toString(),
                                    ),
                                  ),
                                );
                              } else if (data[index].flag ==
                                  'New Job Available') {
                                var response = await BaseClient().getServiceDetail(
                                    "/provider/jobs/${data[index].order_id.toString()}/available");
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      // 1
                                      child: Detail(
                                        address: response['property'],
                                        date: response['date'],
                                        grand_total:
                                            response['grand_total'].toString(),
                                        id: response['id'],
                                        period: response['period'].toString(),
                                        service_for: response['service_for'],
                                        fromWhere: "Available",
                                        jobId: response['id'].toString(),
                                        statusOfReq:
                                            response['proposals'].isEmpty
                                                ? false
                                                : true,
                                        ln: response['lng'],
                                        lt: response['lat'],
                                      ),
                                    ),
                                  );
                                }
                              } else if (data[index].flag ==
                                  'Customer rated your job') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReviewsRatings(),
                                  ),
                                );
                              } else if (data[index].flag ==
                                  'Job has completed') {
                                var response = await BaseClient().getServiceDetail(
                                    "/provider/jobs/${data[index].order_id.toString()}/complete");
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      // 1
                                      child: Detail(
                                        address: response['property'],
                                        date: response['date'],
                                        grand_total:
                                            response['grand_total'].toString(),
                                        id: response['id'],
                                        period: response['period'].toString(),
                                        service_for: response['service_for'],
                                        fromWhere: "Completed",
                                        jobId: response['id'].toString(),
                                        statusOfReq:
                                            response['proposals'].isEmpty
                                                ? false
                                                : true,
                                        ln: response['lng'],
                                        lt: response['lat'],
                                      ),
                                    ),
                                  );
                                }
                              } else if (data[index].flag ==
                                  'Proposal Accepted') {
                                var response = await BaseClient().getServiceDetail(
                                    "/provider/jobs/${data[index].order_id.toString()}/active");
                                print(response);
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      // 1
                                      child: Detail(
                                        address: response['property'],
                                        date: response['date'],
                                        grand_total:
                                            response['grand_total'].toString(),
                                        id: response['id'],
                                        period: response['period'].toString(),
                                        service_for: response['service_for'],
                                        fromWhere: "ActiveStart",
                                        jobId: response['id'].toString(),
                                        statusOfReq: true,
                                        ln: response['lng'],
                                        lt: response['lat'],
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data[index].content,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.more_horiz),
                                            iconSize: 15,
                                            onPressed: () {
                                              showMaterialModalBottomSheet(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                // expand: true,
                                                context: context,
                                                backgroundColor: Colors.white,
                                                builder: (context) =>
                                                    SingleChildScrollView(
                                                  controller:
                                                      ModalScrollController.of(
                                                          context),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      var response =
                                                          await BaseClient()
                                                              .deleteNotification(
                                                        "/notifications/delete/${data[index].id}",
                                                      );
                                                      if (response["success"]) {
                                                        if (mounted) {
                                                          Navigator.pop(
                                                              context);
                                                          data.removeWhere(
                                                              (e) =>
                                                                  e.id ==
                                                                  data[index]
                                                                      .id);
                                                          setState(() {});
                                                        }
                                                      } else {
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Alert!',
                                                            message:
                                                                '${response["message"]}',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
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
                                                    },
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                            10,
                                                            0,
                                                            10,
                                                            0,
                                                          ),
                                                          child: Row(
                                                            children: const [
                                                              Icon(Icons
                                                                  .dangerous),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "Remove this notification",
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data[index].created_at,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Notifies {
  final String id;
  final String receiver_id;
  final String sender_id;
  final String title;
  final String content;
  final String status;
  final String created_at;
  final String flag;
  final String order_id;

  Notifies(
      {required this.id,
      required this.receiver_id,
      required this.sender_id,
      required this.title,
      required this.content,
      required this.status,
      required this.created_at,
      required this.flag,
      required this.order_id});

  factory Notifies.fromJson(Map<String, dynamic> json) {
    return Notifies(
      id: json['id'].toString(),
      receiver_id: json['receiver_id'].toString(),
      sender_id: json['sender_id'].toString(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      status: json['status'].toString(),
      created_at: json['created_at'].toString(),
      flag: json['flag'].toString(),
      order_id: json['order_id'].toString(),
    );
  }
}
