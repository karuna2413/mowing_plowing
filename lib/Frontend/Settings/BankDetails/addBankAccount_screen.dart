import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Backend/base_client.dart';
import '../../Login/login_screen.dart';
import '../../SignUp/searchCompAddress_screen.dart';
import 'addresspayment_screeen.dart';

class AddBankAccount extends StatefulWidget {
  String address;
  TextEditingController ssnContr;
  TextEditingController routingContr;
  TextEditingController accNoContr;
  TextEditingController cityContr;
  TextEditingController stateContr;
  TextEditingController postalCodeContr;
  TextEditingController dobContr;
  String countryValue;
  String stateValue;
  String cityValue;
  String initValue;
  bool isDateSelected;
  DateTime? birthDate;
  String birthDateInString;
  AddBankAccount({
    required this.address,
    required this.ssnContr,
    required this.routingContr,
    required this.accNoContr,
    required this.cityContr,
    required this.stateContr,
    required this.postalCodeContr,
    required this.dobContr,
    required this.countryValue,
    required this.stateValue,
    required this.cityValue,
    required this.initValue,
    required this.isDateSelected,
    required this.birthDate,
    required this.birthDateInString,
  });

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  final GlobalKey<FormState> _form = GlobalKey();
  // TextEditingController ssnContr = TextEditingController();
  // TextEditingController routingContr = TextEditingController();
  // TextEditingController accNoContr = TextEditingController();
  // TextEditingController cityContr = TextEditingController();
  // TextEditingController stateContr = TextEditingController();
  // TextEditingController postalCodeContr = TextEditingController();
  // TextEditingController dobContr = TextEditingController();
  // String countryValue = "";
  // String stateValue = "";
  // String cityValue = "";
  // String address = "";
  // String initValue = "Select your Birth Date";
  // bool isDateSelected = false;
  // DateTime? birthDate; // instance of DateTime
  // String birthDateInString = "";

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: _form,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: widget.ssnContr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your ssn last 4 digits',
                          suffixIcon: Icon(
                            Icons.numbers,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter your ssn last 4 digits";
                          } else if (value.length != 4) {
                            return "Please enter valid ssn last 4 digits";
                          }
                          return null;
                        },
                      ),
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
                        controller: widget.routingContr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your routing number',
                          suffixIcon: Icon(
                            Icons.route_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter your routing number of 9 digits";
                          } else if (value.length != 9) {
                            return "Please enter valid routing number of 9 digits";
                          }
                          return null;
                        },
                      ),
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
                        controller: widget.accNoContr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your account number',
                          suffixIcon: Icon(
                            Icons.account_balance,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter your account number";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CSCPicker(
                      layout: Layout.vertical,
                      onCountryChanged: (country) {},
                      onStateChanged: (state) {
                        if (state != null) {
                          widget.stateValue = state;
                          setState(() {});
                        }
                      },
                      onCityChanged: (city) {
                        if (city != null) {
                          widget.cityValue = city;
                          setState(() {});
                        }
                      },
                      defaultCountry: CscCountry.United_States,
                      disableCountry: true,
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
                              child: AddressPayment(
                                address: widget.address,
                                accNoContr: widget.accNoContr,
                                birthDate: widget.birthDate,
                                birthDateInString: widget.birthDateInString,
                                cityContr: widget.cityContr,
                                cityValue: widget.cityValue,
                                countryValue: widget.countryValue,
                                dobContr: widget.dobContr,
                                initValue: widget.initValue,
                                isDateSelected: widget.isDateSelected,
                                postalCodeContr: widget.postalCodeContr,
                                routingContr: widget.routingContr,
                                ssnContr: widget.ssnContr,
                                stateContr: widget.stateContr,
                                stateValue: widget.stateValue,
                              ),
                            ),
                          );
                        },
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.address.isEmpty
                              ? 'Select Address'
                              : widget.address,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: widget.postalCodeContr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter postal code',
                          suffixIcon: Icon(
                            Icons.account_balance,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter postal code";
                          }
                          return null;
                        },
                      ),
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
                        controller: widget.dobContr,
                        decoration: InputDecoration(
                          hintText: widget.isDateSelected
                              ? widget.birthDateInString
                              : widget.initValue,
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          // contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: InputBorder.none,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        readOnly: true,
                        autofocus: false,
                        onTap: () async {
                          final datePick = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              initialEntryMode: DatePickerEntryMode.inputOnly);
                          if (datePick != null &&
                              datePick != widget.birthDate) {
                            setState(() {
                              widget.birthDate = datePick;
                              widget.isDateSelected = true;
                              widget.birthDateInString =
                                  "${widget.birthDate!.day}-${widget.birthDate!.month}-${widget.birthDate!.year}";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    alignment: Alignment.center,
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
                        if (widget.stateValue.isEmpty ||
                            widget.cityValue.isEmpty) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alert!',
                              message: 'Kindly select the state and city',
                              contentType: ContentType.failure,
                            ),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                          return;
                        }
                        if (widget.birthDateInString == null) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alert!',
                              message: 'Kindly select the date',
                              contentType: ContentType.failure,
                            ),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                          return;
                        }
                        var response = await BaseClient().addBankAccStripe(
                          "/add-stripe-account",
                          widget.ssnContr.text,
                          widget.routingContr.text,
                          widget.accNoContr.text,
                          widget.cityValue,
                          widget.stateValue,
                          widget.postalCodeContr.text,
                          widget.birthDateInString,
                          widget.address,
                        );
                        if (response["success"]) {
                          if (mounted) {
                            Navigator.pop(context);
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
                      },
                      child: const Text('Add Bank'),
                    ),
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
}
