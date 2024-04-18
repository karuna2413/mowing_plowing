// import 'dart:convert';
// import "package:http/http.dart" as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mowing_plowing_vendorapp/Frontend/SignUp/uploadPortfolio_sreen.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:uuid/uuid.dart';

// import '../Login/login_screen.dart';

// class CompanyAddress extends StatefulWidget {
//   const CompanyAddress({});

//   @override
//   State<CompanyAddress> createState() => _CompanyAddressState();
// }

// class _CompanyAddressState extends State<CompanyAddress> {
//   TextEditingController zipCodeController = TextEditingController();
//   TextEditingController additionalInfoController = TextEditingController();
//   final TextEditingController _controller = TextEditingController();
//   var uuid = const Uuid();
//   String _sessionToken = "122344";
//   List<dynamic> _placesList = [];

//   void onChanged() {
//     if (_sessionToken == null) {
//       setState(() {
//         _sessionToken = uuid.v4();
//       });
//     }
//     getSuggestion(_controller.text);
//   }

//   void getSuggestion(String input) async {
//     String kPLACESAPIKEY = "AIzaSyC5qN37hurCFwbFsZt2nzzwzGcbSt08R5E";
//     String baseURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request =
//         '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';

//     var response = await http.get(Uri.parse(request));
//     // var data = response.body.toString();

//     if (response.statusCode == 200) {
//       setState(() {
//         _placesList = jsonDecode(response.body.toString())["predictions"];
//       });
//     } else {
//       throw Exception("Failed to load data");
//     }
//   }

//   bool visibility = false;
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

//   late FocusNode myFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       onChanged();
//     });
//     myFocusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     myFocusNode.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                   const Text("Tell us about your company address"),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: Focus(
//                         child: TextFormField(
//                           controller: _controller,
//                           decoration: const InputDecoration(
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(10),
//                             border: InputBorder.none,
//                             labelText: 'Search company address',
//                           ),
//                           validator: (value) {
//                             if (value == null || value == "") {
//                               return "Please enter address";
//                             }

//                             return null;
//                           },
//                           onChanged: (value) {
//                             visibility = true;
//                           },
//                         ),
//                         onFocusChange: (hasFocus) {
//                           visibility = false;
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Visibility(
//                       visible: visibility,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.white,
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _placesList.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               onTap: () async {
//                                 _controller.text =
//                                     _placesList[index]["description"];
//                                 visibility = false;
//                                 myFocusNode.requestFocus();
//                                 setState(() {});
//                               },
//                               title: Text(_placesList[index]["description"]),
//                             );
//                           },
//                         ),
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
//                         controller: zipCodeController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Enter zip code',
//                         ),
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter zip code";
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
//                         controller: additionalInfoController,
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Additonal Info (Optional)',
//                           hintText: 'Additonal Information (Optional)',
//                         ),
//                         minLines: 1,
//                         maxLines: 5,
//                         onChanged: (value) {
//                           setState(() {
//                             // email = value;
//                           });
//                         },
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
//                                 child: const UploadPortfolio(),
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
//                                     child: const LogIn(),
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
