import 'package:flutter/material.dart';
import 'package:mowing_plowing_vendorapp/Frontend/SignUpCustomerByProvider/verifyPhoneNumberOTP_screenCP.dart';
import 'package:page_transition/page_transition.dart';

import '../Login/login_screen.dart';

class VerifyPhoneNumberCP extends StatefulWidget {
  final String email;
  final String phoneNumber;
  const VerifyPhoneNumberCP({
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<VerifyPhoneNumberCP> createState() => _VerifyPhoneNumberCPState();
}

class _VerifyPhoneNumberCPState extends State<VerifyPhoneNumberCP> {
  final GlobalKey<FormState> _form = GlobalKey();
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(pattern);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
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
                "Verify your customer phone number",
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
                  const Text(
                    "We'll text a code to verify your customer phone number",
                    style: TextStyle(fontSize: 12),
                  ),
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
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Your customer phone number',
                          suffixIcon: Icon(Icons.phone),
                        ),
                        initialValue: widget.phoneNumber,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter customer phone number";
                          } else if (!regExp.hasMatch(value)) {
                            return "Please enter valid customer phone number";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              // email = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                    onPressed: () {
                      if (!(_form.currentState?.validate() ?? true)) {
                        return;
                      }
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: VerifyPhoneNumberOTPCP(
                            phoneNumber: widget.phoneNumber,
                            email: widget.email,
                          ),
                        ),
                      );
                    },
                    child: const Text('NEXT'),
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
