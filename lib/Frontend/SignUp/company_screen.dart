import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import '../Login/login_screen.dart';
import 'editCompAddress_screen.dart';
import 'uploadPortfolio_sreen.dart';

class Company extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final File? image;
  const Company({
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.image,
  });

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  TextEditingController websiteController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();
  bool me = true;
  bool ten = false;
  bool tenPlus = false;
  bool lawnMower = false;
  bool snowPlower = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              'images/logo.png',
              width: 300,
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  const Text("Tell us about your company"),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: companyNameController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Company name',
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter company name";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            // email = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Company size (Including you)",
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          color: HexColor("#0275D8"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              me = true;
                              ten = false;
                              tenPlus = false;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                                color: me ? HexColor("#D6ECFF") : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "Just me",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              me = false;
                              ten = true;
                              tenPlus = false;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                                color: ten ? HexColor("#D6ECFF") : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "2-10 People",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              me = false;
                              ten = false;
                              tenPlus = true;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                                color: tenPlus
                                    ? HexColor("#D6ECFF")
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "10+ People",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select your industry",
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          color: HexColor("#0275D8"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              lawnMower = lawnMower ? false : true;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                                color: lawnMower
                                    ? HexColor("#D6ECFF")
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "images/lawn.png",
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Lawn Mower",
                                      style: TextStyle(
                                        fontSize: size.width * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              snowPlower = snowPlower ? false : true;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                                color: snowPlower
                                    ? HexColor("#D6ECFF")
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "images/snow.png",
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Snow Plower",
                                      style: TextStyle(
                                        fontSize: size.width * 0.03,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: websiteController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Company website',
                        ),
                        validator: (value) {
                          bool validURL = Uri.parse(value!).isAbsolute;
                          if (value.isNotEmpty) {
                            if (!validURL) {
                              return "Please enter valid website url";
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: lawnMower || snowPlower
                              ? () {
                                  if (!(_form.currentState?.validate() ??
                                      true)) {
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: EditCompAddress(
                                        address: null,
                                        latNaved: null,
                                        longNaved: null,
                                        phoneNumber: widget.phoneNumber,
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        password: widget.password,
                                        confirmPassword: widget.confirmPassword,
                                        image: widget.image,
                                        companyName: companyNameController.text,
                                        website: websiteController.text,
                                        companySize: me
                                            ? "1"
                                            : ten
                                                ? "2"
                                                : "3",
                                        industryType: lawnMower && snowPlower
                                            ? "3"
                                            : !lawnMower && snowPlower
                                                ? "2"
                                                : "1",
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text('NEXT'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: const LogIn(),
                                  ),
                                );
                              },
                              child: const Text(
                                "  Log in",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
    );
  }
}
