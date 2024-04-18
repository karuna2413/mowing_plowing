import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mowing_plowing_vendorapp/Frontend/Settings/BankDetails/addBankAccount_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Backend/base_client.dart';
import '../../Login/login_screen.dart';

class BankDetail extends StatefulWidget {
  const BankDetail();

  @override
  State<BankDetail> createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
  bool load = true;
  String dataReceived = "";
  List data = [];

  Future get2AvailJobFunction() async {
    load = true;
    var response = await BaseClient().getBankAcc(
      "/get-account",
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
        data = response["data"];
        if (data.isNotEmpty) {
          var string = response["data"][0]["account_number"].toString();
          dataReceived = string.substring(string.length - 4);
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

  void completeFunct() {
    get2AvailJobFunction().then((value) async {
      if (mounted) {
        load = false;
        setState(() {});
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    completeFunct();
  }

  @override
  void initState() {
    completeFunct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit bank details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: load
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: HexColor("#0275D8"),
                size: 100,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "images/bank.png",
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Bank Account",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#0275D8"),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: dataReceived.isEmpty
                                      ? const Text(
                                          "Bank account not added",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "**** **** **** $dataReceived",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      onPressed: dataReceived.isEmpty
                                          ? () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  child: AddBankAccount(
                                                    address: "",
                                                    accNoContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    birthDate: null,
                                                    birthDateInString: "",
                                                    cityContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    cityValue: "",
                                                    countryValue: "",
                                                    dobContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    initValue:
                                                        "Select your Birth Date",
                                                    isDateSelected: false,
                                                    postalCodeContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    routingContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    ssnContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    stateContr:
                                                        TextEditingController(
                                                            text: ""),
                                                    stateValue: "",
                                                  ),
                                                ),
                                              ).then(onGoBack);
                                            }
                                          : () async {
                                              var response = await BaseClient()
                                                  .deleteBankAccStripe(
                                                "/delete-account/${data[0]['id']}/${data[0]['account_id']}",
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
                                                    behavior: SnackBarBehavior
                                                        .floating,
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
                                                  dataReceived = "";
                                                  data = [];
                                                  setState(() {});
                                                } else {
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
                                                      ..showSnackBar(snackBar);
                                                  }
                                                }
                                              }
                                            },
                                      child: Text(
                                        dataReceived.isEmpty
                                            ? 'Add a bank account'
                                            : 'Delete bank account',
                                        style: TextStyle(
                                          fontSize: size.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 20,
                                  // ),
                                  // Expanded(
                                  //   child: ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(50),
                                  //       ),
                                  //       minimumSize: const Size.fromHeight(50),
                                  //     ),
                                  //     onPressed: () {
                                  //       //   if (!(_form.currentState?.validate() ?? true)) {
                                  //       //     return;
                                  //       //   }
                                  //       //   Navigator.pushAndRemoveUntil(
                                  //       //     context,
                                  //       //     PageTransition(
                                  //       //       type: PageTransitionType.rightToLeftWithFade,
                                  //       //       child: const BottomNavBar(),
                                  //       //     ),
                                  //       //     (route) => false,
                                  //       //   );
                                  //     },
                                  //     child: Text(
                                  //       'Delete a bank account',
                                  //       style: TextStyle(
                                  //         fontSize: size.width * 0.03,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Fill up the method to be able to receive payment",
                        style: TextStyle(
                          color: HexColor("#0275D8"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Powered by"),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          "images/image19.png",
                          height: 25,
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //       ),
                  //       minimumSize: const Size.fromHeight(50),
                  //     ),
                  //     onPressed: () {},
                  //     child: const Text('OK'),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
