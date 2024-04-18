import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:mowing_plowing_vendorapp/Frontend/SignUpCustomerByProvider/verifyPhoneNumber_screenCP.dart';
import 'package:page_transition/page_transition.dart';
import '../../Backend/base_client.dart';
import '../Login/login_screen.dart';

class EmailPhoneCP extends StatefulWidget {
  const EmailPhoneCP();

  @override
  State<EmailPhoneCP> createState() => _EmailPhoneCPState();
}

class _EmailPhoneCPState extends State<EmailPhoneCP> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumbController = TextEditingController(
      // text: "+92",
      // text: "+1",
      );
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
                "Enter email and number",
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
                  Column(
                    children: const [
                      Text("What's your customer email and phone number?"),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
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
                        controller: emailController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your customer email',
                          suffixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter customer email";
                          } else if (!value.contains("@") ||
                              !value.contains(".") ||
                              value.length < 5) {
                            return "Please enter valid customer email";
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
                        controller: phoneNumbController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your customer phone number',
                          suffixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter phone number";
                          } else if (value.length != 10) {
                            return "Please enter valid phone number";
                          }

                          return null;
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
                    onPressed: () async {
                      if (!(_form.currentState?.validate() ?? true)) {
                        return;
                      }

                      var response = await BaseClient().emailPhoneNumberCP(
                        "/verify-email-and-phone-number",
                        emailController.text,
                        "+1${phoneNumbController.text}",
                      );
                      if (response["success"]) {
                        if (mounted) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: VerifyPhoneNumberCP(
                                phoneNumber: phoneNumbController.text,
                                email: emailController.text,
                              ),
                            ),
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
