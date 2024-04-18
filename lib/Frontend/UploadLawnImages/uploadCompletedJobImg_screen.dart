import 'dart:async';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mowing_plowing_vendorapp/Frontend/UploadLawnImages/serviceCompleted_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';

class UploadCompletedJobImages extends StatefulWidget {
  final int id;

  const UploadCompletedJobImages({
    required this.id,
  });

  @override
  State<UploadCompletedJobImages> createState() =>
      _UploadCompletedJobImagesState();
}

class _UploadCompletedJobImagesState extends State<UploadCompletedJobImages> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFileList1;
  XFile? imageFileList2;
  XFile? imageFileList3;
  List<XFile>? imageFileList = [];
  bool closed = false;
  bool clean = false;
  bool upload = false;
  bool provided = false;
  bool perform = false;

  Future<void> goBack() async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: BottomNavBar(
            index: null,
          ),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   PageTransition(
      //     type: PageTransitionType.rightToLeftWithFade,
      //     child: BottomNavBar(
      //       index: null,
      //     ),
      //   ),
      //   (route) => false,
      // );
    }
  }

  FutureOr onGoBack(dynamic value) {
    goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Lawn Images",
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
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 30, 30),
              child: Text(
                "Upload images of completed job",
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Minimum 3 images",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: imageFileList1 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages1();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        decoration: BoxDecoration(
                                          color: HexColor("#E7F7EC"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(imageFileList1!.path),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            imageFileList1 = null;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            SizedBox(
                              child: imageFileList2 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages2();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        decoration: BoxDecoration(
                                          color: HexColor("#E7F7EC"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(imageFileList2!.path),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            imageFileList2 = null;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            SizedBox(
                              child: imageFileList3 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages3();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        decoration: BoxDecoration(
                                          color: HexColor("#E7F7EC"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(imageFileList3!.path),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            imageFileList3 = null;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Image should not be more than 10MB",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Allowed formats are jpg, png",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verifications",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Did you close the door?"),
                              ],
                            ),
                            Checkbox(
                              value: closed,
                              onChanged: (bool? value) {
                                setState(() {
                                  closed = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Did you clean accurate?"),
                              ],
                            ),
                            Checkbox(
                              value: clean,
                              onChanged: (bool? value) {
                                setState(() {
                                  clean = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Did you uploaded pictures?"),
                              ],
                            ),
                            Checkbox(
                              value: upload,
                              onChanged: (bool? value) {
                                setState(() {
                                  upload = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Did you provided your best?"),
                              ],
                            ),
                            Checkbox(
                              value: provided,
                              onChanged: (bool? value) {
                                setState(() {
                                  provided = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Did you perform well?"),
                              ],
                            ),
                            Checkbox(
                              value: perform,
                              onChanged: (bool? value) {
                                setState(() {
                                  perform = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
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
                              onPressed: imageFileList!.length > 2 &&
                                      closed &&
                                      clean &&
                                      upload &&
                                      provided &&
                                      perform
                                  ? () async {
                                      var response =
                                          await BaseClient().activeJobStatus(
                                        "/active-job/job-completed/${widget.id}",
                                        "1",
                                        imageFileList,
                                      );
                                      if (response["message"] ==
                                              "Job has been completed successfully." &&
                                          response["success"]) {
                                        imageFileList = [];
                                        await EasyLoading.dismiss();
                                        if (mounted) {
                                          setState(() {});
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ServiceCompleted(),
                                            ),
                                          ).then(onGoBack);
                                        }
                                      } else {
                                        await EasyLoading.dismiss();
                                        final snackBar = SnackBar(
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title: 'Alert!',
                                            message: 'ERrrorrrrr',
                                            contentType: ContentType.failure,
                                          ),
                                        );
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                      }

                                      //
                                      //
                                    }
                                  : null,
                              child: const Text('Submit'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectImages1() async {
    if (mounted) {
      bool? isCamera = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Camera"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Gallery "),
              ),
            ],
          ),
        ),
      );

      if (isCamera == null) return;
      final XFile? selectedImages = await imagePicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList1 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages2() async {
    if (mounted) {
      bool? isCamera = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Camera"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Gallery "),
              ),
            ],
          ),
        ),
      );

      if (isCamera == null) return;
      final XFile? selectedImages = await imagePicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList2 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages3() async {
    if (mounted) {
      bool? isCamera = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Camera"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Gallery "),
              ),
            ],
          ),
        ),
      );

      if (isCamera == null) return;
      final XFile? selectedImages = await imagePicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList3 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }
}
