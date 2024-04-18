import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/api_constants.dart';
import '../ActiveServices/activeService_screen.dart';
import '../Home/home_screen.dart';
import '../Settings/settings_screen.dart';
import '../TotalEarning/totalEarning_screen.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  final int? index;
  BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selecIndex = 0;
  bool def = true;

  late final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const TotalEarnings(),
    const ActiveService(),
    const Settings(),
  ];

  void onTapped(int index) {
    _selecIndex = index;
    setState(() {});
  }

  // Future<Position> getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     // print("error" + error.toString());
  //   });
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  // pusher
  //
  String token = "";
  Map<String, dynamic>? userMap;
  int? providerId;

  late FlutterPusher pusherClient;
  late Echo echo;
  void onConnectionStateChange(ConnectionStateChange event) {
    // print("2");
    print("STATE:${event.currentState} NewNotification");
    if (event.currentState == 'CONNECTED') {
      // print('2');
      print('connected NewNotification');
    } else if (event.currentState == 'DISCONNECTED') {
      // print('3');
      print('disconnected NewNotification');
    }
  }
  //
  //

  // echoSetUp
  //
  void _setUpEcho() {
    pusherClient = getPusherClient(token);
    echo = echoSetup(token, pusherClient);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    // listen
    //
    echo.private("notifications.$providerId").listen('.NewNotification',
        (notification) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: "${notification["notification"]["title"]}",
        text: '${notification["notification"]["content"]}',
        cancelBtnText: "Ok",
        confirmBtnColor: Colors.yellow[600]!,
        showCancelBtn: false,
      );
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
  }
  //
  //

  void completeFunct() {
    localStorageData().then((value) async {
      // _setUpEcho();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // getUserCurrentLocation();
    completeFunct();
    if (widget.index != null) {
      _selecIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selecIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child:
            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(30.0),
            //     topRight: Radius.circular(30.0),
            //   ),
            //   child:
            BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selecIndex,
          selectedItemColor: HexColor("#707070"),
          unselectedItemColor: HexColor("#707070"),
          // iconSize: 30,
          onTap: (index) => setState(() => _selecIndex = index),
          elevation: 5,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/home.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 0 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 0
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/earning.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 1 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 1
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage(
                      "images/tool.png",
                    ),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 2 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 2
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/setting.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 3 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 3
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
