// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mowing_plowing_vendorapp/Frontend/SignUp/verifyPhoneNumber_screen.dart';
// import 'package:page_transition/page_transition.dart';

// import '../Login/login_screen.dart';
// import 'company_screen.dart';

// class PersonalInfo extends StatefulWidget {
//   const PersonalInfo({});

//   @override
//   State<PersonalInfo> createState() => _PersonalInfoState();
// }

// class _PersonalInfoState extends State<PersonalInfo> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneNumbController = TextEditingController();
//   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPassController = TextEditingController();
//   TextEditingController aboutController = TextEditingController();
//   bool _isObscure = true;
//   bool _isObscureCp = true;
//   final GlobalKey<FormState> _form = GlobalKey();

//   final ImagePicker imagePicker = ImagePicker();

//   XFile? imageFileList;

//   void selectImages() async {
//     final XFile? selectedImages =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (selectedImages != null) {
//       imageFileList = selectedImages;
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     RegExp regExp = RegExp(pattern);
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const ClampingScrollPhysics(),
//         child: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 10,
//             ),
//             Image.asset(
//               'images/logo.png',
//               width: 300,
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: const Text(
//                 "Sign Up",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Form(
//               key: _form,
//               child: Column(
//                 children: [
//                   const Text("Enter your personal information"),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: Material(
//                             elevation: 5.0,
//                             shadowColor: Colors.grey,
//                             borderRadius: BorderRadius.circular(10),
//                             child: TextFormField(
//                               controller: firstNameController,
//                               decoration: const InputDecoration(
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.all(10),
//                                 border: InputBorder.none,
//                                 labelText: 'First Name',
//                                 suffixIcon: Icon(Icons.badge),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value == "") {
//                                   return "Please enter first name";
//                                 } else if (value.contains(RegExp(r'[0-9]'))) {
//                                   return "Please enter valid name";
//                                 }

//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 setState(() {
//                                   // email = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.only(right: 20),
//                           child: Column(
//                             children: [
//                               Material(
//                                 elevation: 5.0,
//                                 shadowColor: Colors.grey,
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: TextFormField(
//                                   controller: lastNameController,
//                                   decoration: const InputDecoration(
//                                     isDense: true,
//                                     contentPadding: EdgeInsets.all(10),
//                                     border: InputBorder.none,
//                                     labelText: 'Last Name',
//                                     suffixIcon: Icon(Icons.badge),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value == "") {
//                                       return "Please enter last name";
//                                     } else if (value
//                                         .contains(RegExp(r'[0-9]'))) {
//                                       return "Please enter valid name";
//                                     }

//                                     return null;
//                                   },
//                                   onChanged: (value) {
//                                     setState(() {
//                                       // email = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         controller: emailController,
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Enter your email',
//                         ),
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter email";
//                           } else if (!value.contains("@") ||
//                               !value.contains(".com") ||
//                               value.length < 5) {
//                             return "Please enter valid email";
//                           }

//                           return null;
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         controller: phoneNumbController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Enter your phone number',
//                         ),
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter phone number";
//                           } else if (!regExp.hasMatch(value)) {
//                             return "Please enter valid phone number";
//                           }

//                           return null;
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         controller: passwordController,
//                         obscureText: _isObscure,
//                         decoration: InputDecoration(
//                           isDense: true,
//                           contentPadding: const EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Password',
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isObscure
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isObscure = !_isObscure;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter password";
//                           }

//                           return null;
//                         },
//                         onChanged: (value) {
//                           setState(() {
//                             // email = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         controller: confirmPassController,
//                         obscureText: _isObscureCp,
//                         decoration: InputDecoration(
//                           isDense: true,
//                           contentPadding: const EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Confirm Password',
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isObscureCp
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isObscureCp = !_isObscureCp;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter confirm password";
//                           } else if (passwordController.text !=
//                               confirmPassController.text) {
//                             return "Invalid confirm password";
//                           }

//                           return null;
//                         },
//                         onChanged: (value) {
//                           setState(() {
//                             // email = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         controller: aboutController,
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'About',
//                           hintText: 'Tell us something about yourself',
//                         ),
//                         minLines: 1,
//                         maxLines: 5,
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please tell us about yourself";
//                           }

//                           return null;
//                         },
//                         onChanged: (value) {
//                           setState(() {
//                             // email = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: SizedBox(
//                       child: imageFileList == null
//                           ? null
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.file(
//                                     File(imageFileList!.path),
//                                     height: 150,
//                                     width: 200,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     // minimumSize: const Size.fromHeight(50),
//                                   ),
//                                   onPressed: () {
//                                     selectImages();
//                                   },
//                                   child: const Text('Change Picture'),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: imageFileList == null ? true : false,
//                     child: Container(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: Material(
//                         elevation: 5.0,
//                         shadowColor: Colors.grey,
//                         borderRadius: BorderRadius.circular(10),
//                         child: TextFormField(
//                           readOnly: true,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             contentPadding: const EdgeInsets.all(10),
//                             border: InputBorder.none,
//                             enabled: true,
//                             labelText: imageFileList == null
//                                 ? "Upload profile picture (Optional)"
//                                 : imageFileList!.path,
//                             suffixIcon: Padding(
//                               padding: const EdgeInsets.only(right: 5),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   selectImages();
//                                 },
//                                 // icon: const Icon(
//                                 //   Icons.download,
//                                 // ),
//                                 child: const Text('Upload'),
//                               ),
//                             ),
//                           ),
//                           initialValue: "No file choosen",
//                           onChanged: (value) {
//                             setState(() {
//                               // email = value;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 80,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 30, right: 30),
//                     alignment: Alignment.center,
//                     child: Column(
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             minimumSize: const Size.fromHeight(50),
//                           ),
//                           onPressed: () {
//                             if (!(_form.currentState?.validate() ?? true)) {
//                               return;
//                             }
//                             Navigator.push(
//                               context,
//                               PageTransition(
//                                 type: PageTransitionType.rightToLeftWithFade,
//                                 child: const VerifyPhoneNumber(),
//                               ),
//                             );
//                           },
//                           child: const Text('NEXT'),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Already have an account?",
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type:
//                                         PageTransitionType.rightToLeftWithFade,
//                                     child: const Login(),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 "  Log in",
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.blue),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
