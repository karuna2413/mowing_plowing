import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Legal/legal_screen.dart';
import '../PrivacyPolicy/privacyPolicy_screen.dart';
import '../Profile/myProfile_screen.dart';
import '../Terms&Conditions/termsConditions_screen.dart';
import 'BankDetails/bankDetail_screen.dart';
import 'ChangeEmail/changeEmail_screen.dart';
import 'ChangePhoneNumber/changePhoneNumber_screen.dart';
import 'SetPassword/setPassword_screen.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic>? userMap;
  String? firstName;
  String? lastName;
  String? email;
  String? newEmail;
  String? unverifiedEmail;
  String? image;
  String? phoneNumber;
  String? newPhoneNumber;
  String? lat;
  String? lng;
  String? zipCode;
  String? address;
  String? emailVerifiedAt;

  Future<void> getUserDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    image = userMap!["image"];
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
    email = userMap!["email"];
    newEmail = userMap!["new_email"];
    unverifiedEmail = userMap!["unverified_email"];
    phoneNumber = userMap!["phone_number"];
    newPhoneNumber = userMap!["new_phone_number"];
    lat = userMap!["lat"];
    lng = userMap!["lng"];
    zipCode = userMap!["zip_code"];
    address = userMap!["address"];
    emailVerifiedAt = userMap!["email_verified_at"];
    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    getUserDataFromLocal();
  }

  @override
  void initState() {
    getUserDataFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: MyProfile(
                    firstName: firstName,
                    lastName: lastName,
                    image: image,
                    lat: lat,
                    lng: lng,
                    zipCode: zipCode,
                    address: address,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/edit.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap:
                // emailVerifiedAt == null
                //     ? () {
                //         QuickAlert.show(
                //           context: context,
                //           type: QuickAlertType.info,
                //           title: "Email Verification",
                //           text: 'Kindly verify your email first to proceed.!',
                //           cancelBtnText: "Ok",
                //           confirmBtnColor: Colors.yellow[600]!,
                //           showCancelBtn: false,
                //         );
                //       }
                //     :
                () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const BankDetail(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/bank.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Edit Bank Details",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const SetPassword(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/lock.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Set Password",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: ChangeEmail(
                    email: email,
                    emailVerifiedAt: emailVerifiedAt,
                    newEmail: newEmail,
                    unverifiedEmail: unverifiedEmail,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const ImageIcon(
                    AssetImage("images/email.png"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    emailVerifiedAt == null ? "Verify Email" : "Change Email",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: ChangePhoneNumber(
                    phoneNumber: phoneNumber!,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/change.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Change Phone Number",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const PrivacyPolicy(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          // Divider(
          //   color: Colors.grey[300],
          //   height: 1,
          //   thickness: 3,
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       PageTransition(
          //         type: PageTransitionType.rightToLeftWithFade,
          //         // 3
          //         child: const Legal(),
          //       ),
          //     );
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.all(20),
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         "Legal",
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     ),
          //   ),
          // ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const TermsConditions(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
