import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mowing_plowing_vendorapp/Frontend/About/about_screen.dart';
import 'package:mowing_plowing_vendorapp/Frontend/Help/help_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../BookingHistory/bookingHistory_screen.dart';
import '../Customers/customer_screen.dart';
import '../FAQ/faq_screen.dart';
import '../Login/login_screen.dart';
import '../Notifications/notification_screen.dart';
import '../Profile/myProfile_screen.dart';
import '../ReferFreind/referFreind_screen1.dart';
import '../ScheduleFrog/scheduleFrog_screen.dart';
import '../Settings/settings_screen.dart';
import '../TotalEarning/totalEarning_screen.dart';
import '../TotalRating/reviewsRating_screen.dart';
import '../TotalScore/totalScore_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget();

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Map<String, dynamic>? userMap;
  String? totalEarnings;
  String? totalJobs;
  String? totalRatings;
  String? responseOnTime;
  String? totalScore;
  String? completeJobsPerc;
  String? cancelJobsPerc;
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
  String levels = "";
  String notifi = "";
  bool noti = false;

  Future<void> getUserDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    levels = localStorage.getString('level')!;
    notifi = localStorage.getString('noti')!;
    noti = notifi != "0" ? true : false;
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
    responseOnTime = localStorage.getString('responseOnTime');
    totalScore = localStorage.getString('totalScore');
    completeJobsPerc = localStorage.getString('completeJobsPerc');
    cancelJobsPerc = localStorage.getString('cancelJobsPerc');
    totalEarnings = localStorage.getString('totalEarnings');
    totalJobs = localStorage.getString('totalJobs');
    totalRatings = localStorage.getString('totalRatings');
    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    getUserDataFromLocal();
  }

  final ImagePicker imagePicker = ImagePicker();
  File? imageFileList;

  void selectImage() async {
    final XFile? selectedImages =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      imageFileList = File(selectedImages.path);
      var response = await BaseClient().editProfileDetail(
        "/edit-profile-detail",
        firstName!,
        lastName!,
        File(selectedImages.path),
        address!,
        lat!,
        lng!,
        zipCode!,
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
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          await localStorage.remove('user');
          Map<String, dynamic> user = response["data"];
          await localStorage.setString('user', jsonEncode(user));
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Updated!',
              message: 'Profile Picture updated successfully',
              contentType: ContentType.success,
            ),
          );
          if (mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getUserDataFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                        child: imageFileList == null && image == null
                            ? Image.asset(
                                'images/upload.jpg',
                                height: 80,
                              )
                            : imageFileList == null && image != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl + image!,
                                      height: 80,
                                      width: 80,
                                      placeholder: (context, url) =>
                                          LoadingAnimationWidget.inkDrop(
                                        color: HexColor("#0275D8"),
                                        size: 40,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      File(imageFileList!.path),
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                      ),
                      InkWell(
                        onTap: () {
                          if (mounted) {
                            selectImage();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: HexColor("#0275D8"),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$firstName $lastName ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
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
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: HexColor("#0275D8"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "images/level1.png",
                        height: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor("#0275D8"),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "Level $levels",
                            style: TextStyle(
                              color: HexColor("#0275D8"),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      // 3
                      child: TotalScore(
                        responseOnTime: responseOnTime!,
                        totalScore: totalScore!,
                        completeJobsPerc: completeJobsPerc!,
                        cancelJobsPerc: cancelJobsPerc!,
                        totalEarnings: totalEarnings!,
                        totalJobs: totalJobs!,
                        totalRatings: totalRatings!,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Text(
                      "Total Score: ",
                    ),
                    Text(
                      "$totalScore",
                      style: TextStyle(
                        color: HexColor("#24B550"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Image.asset(
              "images/drawer.png",
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Notifications(),
                      ),
                    ).then(onGoBack);
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/notification.png"),
                    color: Colors.white,
                  ),
                  title: Stack(
                    // alignment: AlignmentDirectional.topEnd,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Visibility(
                          visible: noti,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                " $notifi ",
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const BookingHistory(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/bookHistory.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Bookings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                // ListTile(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       PageTransition(
                //         type: PageTransitionType.rightToLeftWithFade,
                //         // 3
                //         child: const ReferFreind1(),
                //       ),
                //     );
                //   },
                //   visualDensity: const VisualDensity(
                //     horizontal: 0,
                //     vertical: -2,
                //   ),
                //   leading: const ImageIcon(
                //     AssetImage("images/referCustomer.png"),
                //     color: Colors.white,
                //   ),
                //   title: const Text(
                //     'Refer a Provider',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const FAQ(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/faq.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'FAQs',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Help(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/help.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Help',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const TotalEarnings(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/earning.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Earnings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const ScheduleFrog(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/scheduleFrog.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Schedule Frog',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const About(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/about.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'About App',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const ReviewsRatings(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/reviewsRating.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Reviews and Rating',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Customers(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/customer.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Customers',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: "Are you sure",
                      text:
                          'You want to delete your account\nYou will not be able to undo this action',
                      cancelBtnText: "Ok",
                      confirmBtnColor: Colors.red,
                      onConfirmBtnTap: () async {
                        var response = await BaseClient().deleteAccount(
                          "/delete-account",
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
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            await localStorage.clear();
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
                      },
                      showCancelBtn: false,
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(
                  color: HexColor("#E8E8E8"),
                ),
                ListTile(
                  onTap: () async {
                    var response = await BaseClient().logOut(
                      "/logout",
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
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        await localStorage.clear();
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
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const ImageIcon(
                    AssetImage("images/logout.png"),
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
