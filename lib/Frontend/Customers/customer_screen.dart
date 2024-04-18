import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mowing_plowing_vendorapp/Frontend/SignUpCustomerByProvider/emailPhone_screenCP.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';
import 'placeOrder_screen.dart';

class Customers extends StatefulWidget {
  const Customers();

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<DataCustomer>> futureData;
  bool? activeUser;

  Future<List<DataCustomer>> getFaqsFunction() async {
    var response = await BaseClient().getCustList(
      "/customers-list",
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
        setState(() {});
        List jsonResponse = json.decode(response.body)["data"]["cusstomers"];
        return jsonResponse.map((data) => DataCustomer.fromJson(data)).toList();
      } else {
        activeUser = false;

        List jsonResponse = [];
        setState(() {});
        return jsonResponse.map((data) => DataCustomer.fromJson(data)).toList();
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
    futureData = getFaqsFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customers",
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
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: const EmailPhoneCP(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: HexColor("#0275D8"),
                                ),
                                label: Text(
                                  "Add Customer",
                                  style: TextStyle(
                                    color: HexColor("#0275D8"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FutureBuilder<List<DataCustomer>>(
                            future: futureData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && mounted) {
                                List<DataCustomer>? data = snapshot.data;
                                return ListView.builder(
                                  itemCount: data!.length,
                                  // itemCount: _properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 20),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Material(
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
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                          10,
                                                          10,
                                                          10,
                                                          10,
                                                        ),
                                                        child: data[index]
                                                                    .image ==
                                                                null
                                                            ? ClipOval(
                                                                child:
                                                                    Image.asset(
                                                                  'images/upload.jpg',
                                                                  height: 80,
                                                                  width: 80,
                                                                ),
                                                              )
                                                            : ClipOval(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: imageUrl +
                                                                      data[index]
                                                                          .image!,
                                                                  height: 80,
                                                                  width: 80,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      LoadingAnimationWidget
                                                                          .inkDrop(
                                                                    color: HexColor(
                                                                        "#0275D8"),
                                                                    size: 40,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error),
                                                                ),
                                                              ),
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
                                                                  const Text(
                                                                    "Customer Name",
                                                                  ),
                                                                  Text(
                                                                    "${data[index].first_name!} ${data[index].last_name!}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child: Text(
                                                                      data[index]
                                                                          .address!,
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
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child: Text(
                                                                      data[index]
                                                                          .phone_number!,
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
                                                      10,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PlaceOrder(
                                                              id: data[index]
                                                                  .id
                                                                  .toString(),
                                                              address:
                                                                  data[index]
                                                                      .address!,
                                                              lat: data[index]
                                                                  .lat!,
                                                              lng: data[index]
                                                                  .lng!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 0.5,
                                                          ),
                                                          color: Colors.white,
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
                                                          "Place Order",
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                "#0275D8"),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                            },
                          ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "You can not add customer's as your account is not approved. Kindly wait for the admin to approve it. For any queries call/email at 877-331-6188/hello@mowingandplowing.com",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
          )),
    );
  }
}

class DataCustomer {
  final int id;
  final String? customer_id;
  final String? last_name;
  final String? first_name;
  final String? email;
  final String? new_email;
  final String? unverified_email;
  final String? referral_link;
  final String? referred_by;
  final String? image;
  final String? phone_number;
  final String? new_phone_number;
  final String? type;
  final String? created_by;
  final String? zip_code;
  final String? address;
  final String? lat;
  final String? lng;
  final String? status;

  DataCustomer({
    required this.id,
    required this.customer_id,
    required this.last_name,
    required this.first_name,
    required this.email,
    required this.new_email,
    required this.unverified_email,
    required this.referral_link,
    required this.referred_by,
    required this.image,
    required this.phone_number,
    required this.new_phone_number,
    required this.type,
    required this.created_by,
    required this.zip_code,
    required this.address,
    required this.lat,
    required this.lng,
    required this.status,
  });

  factory DataCustomer.fromJson(Map<String, dynamic> json) {
    return DataCustomer(
      id: json['id'],
      customer_id: json['customer_id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      email: json['email'],
      new_email: json['new_email'],
      unverified_email: json['unverified_email'],
      referral_link: json['referral_link'],
      referred_by: json['referred_by'],
      image: json['image'],
      phone_number: json['phone_number'],
      new_phone_number: json['new_phone_number'],
      type: json['type'],
      created_by: json['created_by'].toString(),
      zip_code: json['zip_code'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      status: json['status'],
    );
  }
}
