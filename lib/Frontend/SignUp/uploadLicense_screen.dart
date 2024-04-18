import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../Login/login_screen.dart';
import 'uploadInsurance_screen.dart';

class UploadLicense extends StatefulWidget {
  final List<XFile>? imagePortfolio;
  final String companyAdd;
  final String companyLat;
  final String companyLng;
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
  const UploadLicense({
    required this.imagePortfolio,
    required this.companyAdd,
    required this.companyLat,
    required this.companyLng,
    required this.companyName,
    required this.companySize,
    required this.industryType,
    required this.website,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.image,
  });

  @override
  State<UploadLicense> createState() => _UploadLicenseState();
}

class _UploadLicenseState extends State<UploadLicense> {
  final GlobalKey<FormState> _form = GlobalKey();
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages.take(5));
    }
    setState(() {});
  }

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
            Column(
              children: [
                const Text("Upload your license images"),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Text(
                    "Upload your license image. (Front and Back)",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: imageFileList!.isEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "images/container.png",
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 1.2,
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              "images/image1.png",
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Image.file(
                                File(imageFileList![0].path),
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 1.2,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () {
                                  imageFileList!.clear();
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: imageFileList!.length > 1
                            ? Image.file(
                                File(imageFileList![1].path),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 5.5,
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/container.png",
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    "images/image1.png",
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        child: imageFileList!.length > 2
                            ? Image.file(
                                File(imageFileList![2].path),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 5.5,
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/container.png",
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    "images/image1.png",
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        child: imageFileList!.length > 3
                            ? Image.file(
                                File(imageFileList![3].path),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 5.5,
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/container.png",
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    "images/image1.png",
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        child: imageFileList!.length > 4
                            ? Image.file(
                                File(imageFileList![4].path),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 5.5,
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/container.png",
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    "images/image1.png",
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    selectImages();
                  },
                  child: const Text('Browse Files'),
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
                        onPressed: imageFileList!.length > 1
                            ? () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: UploadInsurance(
                                      companyAdd: widget.companyAdd,
                                      companyLat: widget.companyLat,
                                      companyLng: widget.companyLng,
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
                                      imagePortfolio: widget.imagePortfolio,
                                      imageLicense: imageFileList,
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
                                  type: PageTransitionType.rightToLeftWithFade,
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
          ],
        ),
      ),
    );
  }
}
