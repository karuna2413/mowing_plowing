import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';
import 'accountLevel_screen.dart';

class ReviewsRatings extends StatefulWidget {
  const ReviewsRatings();

  @override
  State<ReviewsRatings> createState() => _ReviewsRatingsState();
}

class _ReviewsRatingsState extends State<ReviewsRatings>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Data>>? futureData;
  List<dynamic> reviews = [];
  Map<String, dynamic>? userMap;
  String? currentProvName;
  String? currentProvImage;
  String? totalRating;
  String? reviewCount;

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

  Future<List<Data>> getRev() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    currentProvName = userMap!["first_name"] + " " + userMap!["last_name"];
    currentProvImage = userMap!["image"];
    var response = await BaseClient().getreviews(
      "/reviews-and-level",
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
      if (json.decode(response.body)["success"] &&
          json.decode(response.body)["success"] != null) {
        List jsonResponse = json.decode(response.body)["data"]["reviewsDetail"];
        reviewCount =
            json.decode(response.body)["data"]["reviewsCount"].toString();
        totalRating =
            json.decode(response.body)["data"]["totalRating"].toString();
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  void completeFunc() {
    futureData = getRev();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reviews and Rating",
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
          child: FutureBuilder<List<Data>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData && mounted) {
                  List<Data>? data = snapshot.data;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 70,
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "$currentProvName",
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 20, 10),
                                          child: RatingBar.builder(
                                            itemSize: 20,
                                            initialRating:
                                                double.parse(totalRating!),
                                            minRating:
                                                double.parse(totalRating!),
                                            maxRating:
                                                double.parse(totalRating!),
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount:
                                                double.parse(totalRating!)
                                                    .round(),
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                        Text(
                                          "$totalRating out of 5.0",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "$reviewCount",
                                          style: TextStyle(
                                            color: HexColor("#24B550"),
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                        Text(
                                          "Reviews",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.03,
                                          ),
                                        ),
                                        SizedBox(
                                          //Add this to give height
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.5,
                                          child: SingleChildScrollView(
                                            physics: const ScrollPhysics(),
                                            child: Column(
                                              children: [
                                                data!.isEmpty
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        child: Text(
                                                          "No reviews yet",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      child: data[index].image ==
                                                                              null
                                                                          ? Image
                                                                              .asset(
                                                                              'images/upload.jpg',
                                                                              height: 100,
                                                                            )
                                                                          : ClipOval(
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: imageUrl + currentProvImage!,
                                                                                height: 40,
                                                                                width: 40,
                                                                                placeholder: (context, url) => LoadingAnimationWidget.inkDrop(
                                                                                  color: HexColor("#0275D8"),
                                                                                  size: 40,
                                                                                ),
                                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${data[index].firstName} ${data[index].firstName}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: size.width * 0.03,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          RatingBar
                                                                              .builder(
                                                                            initialRating:
                                                                                double.parse(data[index].quality_rating),
                                                                            minRating:
                                                                                double.parse(data[index].quality_rating),
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            allowHalfRating:
                                                                                false,
                                                                            itemCount:
                                                                                int.parse(data[index].quality_rating),
                                                                            itemSize:
                                                                                15.0,
                                                                            itemBuilder: (context, _) =>
                                                                                const Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate:
                                                                                (rating) {},
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  data[index].comment ?? '',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: size.width * 0.025,
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
                                                          );
                                                        },
                                                      ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // ElevatedButton(
                                                //   style:
                                                //       ElevatedButton.styleFrom(
                                                //     backgroundColor:
                                                //         HexColor("#24B550"),
                                                //   ),
                                                //   onPressed: () {},
                                                //   child: const Text(
                                                //     'See more reviews',
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: currentProvImage == null
                                  ? Image.asset(
                                      'images/upload.jpg',
                                      height: 100,
                                    )
                                  : ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl + currentProvImage!,
                                        height: 100,
                                        width: 100,
                                        placeholder: (context, url) =>
                                            LoadingAnimationWidget.inkDrop(
                                          color: HexColor("#0275D8"),
                                          size: 40,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                            ),
                            Positioned(
                              right: 20,
                              top: 70,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
                                        // 3
                                        child: const AccountLevel(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      // border: Border.all(
                                      // color: HexColor("#ECECEC"),
                                      // ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "images/arrowstars.png",
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }
}

class Data {
  final String comment;
  final String firstName;
  final String lastName;
  final String quality_rating;
  String? image;
  Data({
    required this.comment,
    required this.firstName,
    required this.quality_rating,
    required this.lastName,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      comment: json['comment'],
      quality_rating: json['quality_rating'],
      firstName: json['user']['first_name'],
      lastName: json['user']['last_name'],
      image: json['user']['image'],
    );
  }
}
