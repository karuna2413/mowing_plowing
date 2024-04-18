import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';

class About extends StatefulWidget {
  const About();

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<DataAbout>> futureData;

  Future<List<DataAbout>> getAboutFunction() async {
    var response = await BaseClient().getAbout(
      "/about-us",
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
        List jsonResponse = json.decode(response.body)["data"];
        return jsonResponse.map((data) => DataAbout.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
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
    futureData = getAboutFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "About App",
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
          child: FutureBuilder<List<DataAbout>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData && mounted) {
                List<DataAbout>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data!.length,
                  // itemCount: _properties.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                      child: Text(
                        data[index].about,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                  //
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
        ),
      ),
    );
  }
}

class DataAbout {
  final String about;

  DataAbout({
    required this.about,
  });

  factory DataAbout.fromJson(Map<String, dynamic> json) {
    return DataAbout(
      about: json['clean_about_us'],
    );
  }
}
