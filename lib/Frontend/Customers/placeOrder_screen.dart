import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import 'addCustomerCard_screen.dart';

class PlaceOrder extends StatefulWidget {
  final String id;
  final String address;
  final String lat;
  final String lng;
  const PlaceOrder({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  Color selectedColor = Colors.grey;
  Color unSelectedColor = Colors.grey;
  String groupVal = "0";
  String groupValPeriod = "0";
  bool oneSevenFourteen = false;
  TextEditingController phoneNumbController = TextEditingController();
  TextEditingController phoneNumbControllerR = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList;
  String? image0;
  String? image1;
  String? image2;
  String? image3;

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList = [];
      imageFileList!.addAll(selectedImages);
      image0 = imageFileList![0].path;
      image1 = imageFileList!.length > 1 ? imageFileList![1].path : null;
      image2 = imageFileList!.length > 2 ? imageFileList![2].path : null;
      image3 = imageFileList!.length > 3 ? imageFileList![3].path : null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void localStorage() async {
    if (mounted) {
      setState(() {
        selectedColor = Colors.blue;
        unSelectedColor = Colors.grey;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    localStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Place Order",
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
        child: Form(
          key: _form,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Select your service",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      if (mounted) {
                        setState(() {
                          selectedColor = Colors.blue;
                          unSelectedColor = Colors.grey;
                        });
                      }
                    },
                    child: Container(
                      height: 110,
                      width: 135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            // backgroundColor: HexColor("#7CC0FB"),
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: Image.asset(
                              "images/mowing.png",
                              height: 60,
                              // height: 40,
                            ),
                          ),
                          const Text("Lawn Mowing")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (mounted) {
                        setState(() {
                          unSelectedColor = Colors.blue;
                          selectedColor = Colors.grey;
                        });
                      }
                    },
                    child: Container(
                      height: 110,
                      width: 135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: unSelectedColor.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            // backgroundColor: HexColor("#7CC0FB"),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/background.png",
                                    height: 60,
                                    // width: 200,
                                  ),
                                  Image.asset(
                                    "images/plowing.png",
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Text("Snow Plowing")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: selectedColor == Colors.blue ? true : false,
                child: SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Service Schedule",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("One-Time"),
                          Radio(
                            value: "0",
                            groupValue: groupVal,
                            onChanged: (value) async {
                              groupVal = value.toString();
                              oneSevenFourteen = false;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Recurring"),
                          Radio(
                            value: "1",
                            groupValue: groupVal,
                            onChanged: (value) async {
                              groupVal = value.toString();
                              oneSevenFourteen = true;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: oneSevenFourteen && selectedColor == Colors.blue
                    ? true
                    : false,
                child: SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Service Period",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Seven Days    "),
                          Radio(
                            value: "0",
                            groupValue: groupValPeriod,
                            onChanged: (value) async {
                              groupValPeriod = value.toString();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Ten Days         "),
                          Radio(
                            value: "1",
                            groupValue: groupValPeriod,
                            onChanged: (value) async {
                              groupValPeriod = value.toString();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Fourteen Days"),
                          Radio(
                            value: "2",
                            groupValue: groupValPeriod,
                            onChanged: (value) async {
                              groupValPeriod = value.toString();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: phoneNumbController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                      labelText: 'Enter price for service',
                      suffixIcon: Icon(
                        Icons.money,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Please enter price";
                      }

                      return null;
                    },
                  ),
                ),
              ),
              Visibility(
                visible: groupVal == "0" ? false : true,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Material(
                    elevation: 5.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      controller: phoneNumbControllerR,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        labelText: 'Enter recurring price for service',
                        suffixIcon: Icon(
                          Icons.money,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please enter price";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Upload photos optional",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: image0 == null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "images/container.png",
                                    height: 200,
                                    width: 250,
                                  ),
                                  Image.asset(
                                    "images/image1.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                ],
                              )
                            : Image.file(
                                File(image0!),
                                height: 225,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            child: image1 != null
                                ? Image.file(
                                    File(image1!),
                                    height: 70,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        "images/container.png",
                                        height: 65,
                                        width: 80,
                                      ),
                                      Image.asset(
                                        "images/image1.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: image1 != null ? 5 : null,
                          ),
                          SizedBox(
                            child: image2 != null
                                ? Image.file(
                                    File(image2!),
                                    height: 70,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        "images/container.png",
                                        height: 65,
                                        width: 80,
                                      ),
                                      Image.asset(
                                        "images/image1.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: image2 != null ? 5 : null,
                          ),
                          SizedBox(
                            child: image3 != null
                                ? Image.file(
                                    File(image3!),
                                    height: 70,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        "images/container.png",
                                        height: 65,
                                        width: 80,
                                      ),
                                      Image.asset(
                                        "images/image1.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      selectImages();
                    },
                    child: const Text('Browse Files'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        if (!(_form.currentState?.validate() ?? true)) {
                          return;
                        }

                        List? images = [];
                        images.add(image0 ?? image0);
                        images.add(image1 ?? image1);
                        images.add(image2 ?? image2);
                        images.add(image3 ?? image3);
                        var response = await BaseClient().orderForCustomer(
                          "/order-by-provider",
                          widget.id,
                          selectedColor == Colors.blue ? "1" : "2",
                          widget.address,
                          widget.lat,
                          widget.lng,
                          phoneNumbController.text,
                          images,
                          selectedColor == Colors.blue
                              ? groupVal == "0"
                                  ? "one-time"
                                  : "recurring"
                              : null,
                          selectedColor == Colors.blue
                              ? groupValPeriod == "0"
                                  ? "1"
                                  : groupValPeriod == "1"
                                      ? "2"
                                      : "47"
                              : null,
                          selectedColor == Colors.blue
                              ? groupVal == "1"
                                  ? phoneNumbController.text
                                  : null
                              : null,
                        );
                        if (response["success"]) {
                          await EasyLoading.dismiss();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: AddCard(
                                  grandTotal: response["data"]["order"]
                                          ["provider_amount"]
                                      .toString(),
                                  id: widget.id,
                                  orderId: response["data"]["order"]["id"]
                                      .toString(),
                                ),
                              ),
                              (route) => false,
                            );
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Add Card!',
                                message:
                                    'Kindly add card to place order successfully',
                                contentType: ContentType.success,
                              ),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            }
                          }
                        } else {
                          await EasyLoading.dismiss();
                          FocusManager.instance.primaryFocus?.unfocus();
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
                      },
                      child: const Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
