import 'dart:async';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Map/trackService_screen.dart';

class UploadLawnImages extends StatefulWidget {
  final String fromWhere;
  final String lt;
  final String ln;
  final int id;
  final String address;
  final String date;
  final String? service_for;
  final String? period;
  final String grand_total;
  const UploadLawnImages({
    required this.id,
    required this.address,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    required this.fromWhere,
    required this.lt,
    required this.ln,
  });

  @override
  State<UploadLawnImages> createState() => _UploadLawnImagesState();
}

class _UploadLawnImagesState extends State<UploadLawnImages> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFileList1;
  XFile? imageFileList2;
  XFile? imageFileList3;
  XFile? imageFileList4;
  XFile? imageFileList5;
  XFile? imageFileList6;
  XFile? imageFileList7;
  XFile? imageFileList8;
  XFile? imageFileList9;
  bool enableButton = true;

  List<XFile>? imageFileList = [];
  Future<void> goBack() async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: BottomNavBar(
            index: 2,
          ),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   PageTransition(
      //     type: PageTransitionType.rightToLeftWithFade,
      //     child: BottomNavBar(
      //       index: 2,
      //     ),
      //   ),
      //   (route) => false,
      // );
    }
  }

  FutureOr onGoBack(dynamic value) {
    goBack();
  }

  void checkPermissionStatus(
      String fromWhere,
      String ln,
      String lt,
      String address,
      String date,
      String grand_total,
      int id,
      String? period,
      String? service_for) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _permissionGranted = await location.hasPermission();
    _serviceEnabled = await location.serviceEnabled();
    //
    //
    if (!_serviceEnabled && _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          ).then(onGoBack);
        }
      }
    } else if (_serviceEnabled &&
        _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          ).then(onGoBack);
        }
      }
    } else if (!_serviceEnabled &&
        _permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackService(
                fromWhere: fromWhere,
                ln: ln,
                lt: lt,
                address: address,
                date: date,
                grand_total: grand_total,
                id: id,
                period: period,
                service_for: service_for,
              ),
            ),
          ).then(onGoBack);
        }
      }
    } else {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackService(
              fromWhere: fromWhere,
              ln: ln,
              lt: lt,
              address: address,
              date: date,
              grand_total: grand_total,
              id: id,
              period: period,
              service_for: service_for,
            ),
          ),
        ).then(onGoBack);
      }
    }

    _locationData = await location.getLocation();
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
                "Upload before images of front and back lawn. Also take a pic of their address for verification. Take quality images as they will be sent to the customer and used in your profile",
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
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: imageFileList4 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages4();
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
                                            File(imageFileList4!.path),
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
                                            imageFileList4 = null;
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
                              child: imageFileList5 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages5();
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
                                            File(imageFileList5!.path),
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
                                            imageFileList5 = null;
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
                              child: imageFileList6 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages6();
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
                                            File(imageFileList6!.path),
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
                                            imageFileList6 = null;
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: imageFileList7 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages7();
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
                                            File(imageFileList7!.path),
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
                                            imageFileList7 = null;
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
                              child: imageFileList8 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages8();
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
                                            File(imageFileList8!.path),
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
                                            imageFileList8 = null;
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
                              child: imageFileList9 == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImages9();
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
                                            File(imageFileList9!.path),
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
                                            imageFileList9 = null;
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
                    ],
                  ),
                ),
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
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#24B550"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: imageFileList!.length > 2 && enableButton
                        ? () async {
                            if (imageFileList!.isNotEmpty) {
                              var response = await BaseClient().activeJobStatus(
                                "/active-job/reached-and-started-job/${widget.id}",
                                null,
                                imageFileList,
                              );
                              if (response["success"]) {
                                enableButton = false;
                                imageFileList = [];
                                if (mounted) {
                                  setState(() {});
                                  // checkPermissionStatus(
                                  //   'jobStarted',
                                  //   widget.ln,
                                  //   widget.lt,
                                  //   widget.address,
                                  //   widget.date,
                                  //   widget.grand_total,
                                  //   widget.id,
                                  //   widget.period,
                                  //   widget.service_for,
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackService(
                                        address: widget.address,
                                        date: widget.date,
                                        grand_total: widget.grand_total,
                                        id: widget.id,
                                        period: widget.period,
                                        service_for: widget.service_for,
                                        fromWhere: 'jobStarted',
                                        ln: widget.ln,
                                        lt: widget.lt,
                                      ),
                                    ),
                                  ).then(onGoBack);
                                }
                                await EasyLoading.dismiss();
                              } else {
                                await EasyLoading.dismiss();
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
                            } else {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Upload Images',
                                  message: 'Kindly upload images to proceed.!',
                                  contentType: ContentType.warning,
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
                    child: const Text('Start Job'),
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

  void selectImages4() async {
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
        imageFileList4 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages5() async {
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
        imageFileList5 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages6() async {
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
        imageFileList6 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages7() async {
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
        imageFileList7 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages8() async {
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
        imageFileList8 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }

  void selectImages9() async {
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
        imageFileList9 = selectedImages;
        imageFileList!.add(selectedImages);
      }
      setState(() {});
    }
  }
}
