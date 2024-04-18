import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';
import 'searchAddress_screen.dart';
import 'searchCompAddress_screen.dart';
import 'uploadPortfolio_sreen.dart';

class EditCompAddress extends StatefulWidget {
  final String companyName;
  final String companySize;
  final String industryType;
  final String website;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final File? image;
  final String? address;
  final double? latNaved;
  final double? longNaved;
  const EditCompAddress({
    required this.website,
    required this.companyName,
    required this.companySize,
    required this.industryType,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.image,
    required this.address,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<EditCompAddress> createState() => _EditCompAddressState();
}

class _EditCompAddressState extends State<EditCompAddress> {
  bool agree = false;
  Color termPolicies = Colors.blue;
  Color checkText = Colors.black;
  TextEditingController zipCodeController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();
  bool error = false;
  bool error2 = false;
  @override
  Widget build(BuildContext context) {
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
                "Edit Company Address",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Select your company address from the search"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: error,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please provide your company address",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            // expand: true,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: SearchCompAddress(
                                phoneNumber: widget.phoneNumber,
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                password: widget.password,
                                confirmPassword: widget.confirmPassword,
                                image: widget.image,
                                companyName: widget.companyName,
                                companySize: widget.companySize,
                                industryType: widget.industryType,
                                website: widget.website,
                              ),
                            ),
                          );
                        },
                        child: TextFormField(
                          enabled: false,
                          initialValue:
                              widget.address ?? 'Search your company address',
                          decoration: const InputDecoration(
                            // isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 13, 0, 0),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: error2,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Please provide zip code",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Zip Code',
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter zip code";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value!;
                            });
                          },
                        ),
                        Text(
                          "I agree with ",
                          style: TextStyle(fontSize: 11, color: checkText),
                        ),
                        Text(
                          "Terms & Condition ",
                          style: TextStyle(fontSize: 12, color: termPolicies),
                        ),
                        Text(
                          "and ",
                          style: TextStyle(fontSize: 11, color: checkText),
                        ),
                        Text(
                          "Privacy policies.",
                          style: TextStyle(fontSize: 12, color: termPolicies),
                        )
                      ],
                    ),
                  ),
                ],
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      if (widget.address == null) {
                        setState(() {
                          error = true;
                        });
                        return;
                      } else if (zipCodeController.text == "") {
                        setState(() {
                          error2 = true;
                        });
                        return;
                      } else if (!agree) {
                        setState(() {
                          checkText = Colors.red;
                          termPolicies = Colors.red;
                        });
                        return;
                      } else if (agree) {
                        setState(() {
                          checkText = Colors.black;
                          termPolicies = Colors.blue;
                        });
                      }
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: UploadPortfolio(
                            companyAdd: widget.address!,
                            companyLat: widget.latNaved.toString(),
                            companyLng: widget.longNaved.toString(),
                            phoneNumber: widget.phoneNumber,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            password: widget.password,
                            confirmPassword: widget.confirmPassword,
                            image: widget.image,
                            companyName: widget.companyName,
                            website: widget.website,
                            companySize: widget.companySize,
                            industryType: widget.industryType,
                          ),
                        ),
                      );
                    },
                    child: const Text('Next'),
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
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const LogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          "  Log in",
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
