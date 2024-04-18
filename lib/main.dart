// @dart=2.17

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';
import 'Backend/api_constants.dart';
import 'Backend/base_client.dart';
import 'Frontend/BottomNavBar/bottomNavBar_screen.dart';
import 'Frontend/Home/noti.dart';
import 'Frontend/Splash/splash_screen.dart';
import 'directionWidget.dart';

void main() {
  Noti.initializeNotification();
  // Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
  configLoading();
}

late FlutterPusher pusherClient;
late Echo echo;

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     if (task == "socket_task") {
//       // Open and maintain the socket connection
//       print('background task running');
//       pusherClient = getPusherClient(inputData!['token']);
//       pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
//       echo = echoSetup(inputData!['token'], pusherClient);
//       // listen
//       //
//       echo
//           .private("notifications.$inputData!['providerId']")
//           .listen('.NewNotification', (notification) {
//         // Noti.showNotification(jsonResponse[0]);
//         print('new notification...............................');
//         print(notification);
//         if (notification["notification"]["flag"] != 'Order Cancelled') {
//           Noti.showNotification(notification["notification"]);
//         }
//         // QuickAlert.show(
//         //   context: context,
//         //   type: QuickAlertType.info,
//         //   title: "${notification["notification"]["title"]}",
//         //   text: '${notification["notification"]["content"]}',
//         //   cancelBtnText: "Ok",
//         //   confirmBtnColor: Colors.yellow[600]!,
//         //   showCancelBtn: false,
//         // );
//       });
//
//       // Keep the background task running
//       await Future.delayed(
//           const Duration(minutes: 15)); // Adjust the duration as needed
//
//       // Close the socket when done
//
//       return Future.value(true);
//     }
//
//     return Future.value(false);
//   });
// }

void configLoading() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mowing Plowing Customer App',
      theme: ThemeData(
        scaffoldBackgroundColor: HexColor("#F1F1F1"),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(
              primary: HexColor("#0275D8"),
            )
            .copyWith(error: Colors.red),
        // primarySwatch: HexColor("#0275D8"),
      ),
      home: UpgradeAlert(
        upgrader: Upgrader(
          showReleaseNotes: false,
          dialogStyle: UpgradeDialogStyle.cupertino,
          shouldPopScope: () => true,
        ),
        // child: Maps(),
        child: CheckAuth(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  // pusher
  //
  String token = "";
  Map<String, dynamic>? userMap;
  int? providerId;
  String? firstName;
  String? lastName;
  late var currentContext;

  late FlutterPusher pusherClient;
  late Echo echo;

  getNotifiesFunction() async {
    var response = await BaseClient().getNotification(
      "/notifications",
    );
    if (json.decode(response.body)["success"] != null &&
        json.decode(response.body)["success"]) {
      List jsonResponse =
          json.decode(response.body)["data"]["allNotifications"];
      // Noti.showNotification(jsonResponse[0]);
      for (var data in jsonResponse) {
        if (data['status'] == '0') {
          if (data["flag"] != 'Order Cancelled') {
            Noti.showNotification(data);
          }
        }
      }
      await BaseClient().getNotification(
        "/notifications/update-status",
      );
    } else {
      throw Exception('${json.decode(response.body)["message"]}');
    }
  }

  void onConnectionStateChange(ConnectionStateChange event) {
    print("STATE:${event.currentState}");
    if (event.currentState == 'CONNECTED') {
      print('CONNECTED');
    } else if (event.currentState == 'DISCONNECTED') {
      print('DISCONNECTED');
    }
  }

  //
  //

  // echoSetUp
  //
  void _setUpEcho() {
    pusherClient = getPusherClient(token);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    echo = echoSetup(token, pusherClient);
    // listen
    //
    echo.private("notifications.$providerId").listen('.NewNotification',
        (notification) {
      // Noti.showNotification(jsonResponse[0]);
      print('new notification...............................');
      print(notification);
      if (notification["notification"]["flag"] != 'Order Cancelled') {
        Noti.showNotification(notification["notification"]);
      }
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.info,
      //   title: "${notification["notification"]["title"]}",
      //   text: '${notification["notification"]["content"]}',
      //   cancelBtnText: "Ok",
      //   confirmBtnColor: Colors.yellow[600]!,
      //   showCancelBtn: false,
      // );
    });
  }

  //
  //

  // local storage
  //
  Future localStorageData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token')!;
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    providerId = userMap!["id"];
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
  }

  //
  //

  void completeFunct() {
    localStorageData().then((value) async {
      _setUpEcho();
      if (mounted) {
        setState(() {});
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: "Welcome",
          text: "Welcome to Mowing and Plowing $firstName $lastName",
          cancelBtnText: "Ok",
          confirmBtnColor: Colors.yellow[600]!,
          showCancelBtn: false,
        );
      }
    });
  }

  @override
  void initState() {
    _checkIfLoggedIn();
    // getNotifiesFunction();
    completeFunct();
    // Workmanager().registerOneOffTask(
    //   'socket_task',
    //   "socket_task",
    //   inputData: <String, dynamic>{token: token, "providerId": providerId},
    // );
    currentContext = context;
    setState(() {
      Noti.listenActionStream(currentContext);
    });
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      isAuth = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = BottomNavBar(
        index: null,
      );
    } else {
      child = const Splash();
    }
    return child;
  }
}
