import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// String uri = "https://staging.mowingandplowing.com";
String uri = "https://mowingandplowing.com";
// String uri = "https://mowing-plowing.mangoitsol.com";
// http://masterbranch-env.us-east-1.elasticbeanstalk.com/login

// ++++++++++++++++++++++++++++++++++++ Base URL ++++++++++++++++++++++++++++++++++++
//****
// String baseUrl = "http://192.168.100.10/mowing-and-plowing/public/api";
//****
// String baseUrl = "http://masterbranch-env.us-east-1.elasticbeanstalk.com/api";
//****
String baseUrl = "$uri/api";
// String baseUrl = "https://staging.mowingandplowing.com/api";
//****
// ++++++++++++++++++++++++++++++++++++ End of Base URL ++++++++++++++++++++++++++++++++++++

// ++++++++++++++++++++++++++++++++++++ Base URL Provider ++++++++++++++++++++++++++++++++++++
//****
// String baseUrlProvider =
//     "http://192.168.100.10/mowing-and-plowing/public/api/provider";
//****
String baseUrlProvider = "$uri/api/provider";
// String baseUrlProvider = "https://staging.mowingandplowing.com/api/provider";
//****
// String baseUrlProvider =
//     "http://masterbranch-env.us-east-1.elasticbeanstalk.com/api/provider";
//****
// ++++++++++++++++++++++++++++++++++++ End of Base URL Provider ++++++++++++++++++++++++++++++++++++

// ++++++++++++++++++++++++++++++++++++ Image URL ++++++++++++++++++++++++++++++++++++
//****
// String imageUrl = "http://192.168.100.10/mowing-and-plowing/public";
//****
// String imageUrl = "http://masterbranch-env.us-east-1.elasticbeanstalk.com";
//****
String imageUrl = uri;
// String imageUrl = "https://staging.mowingandplowing.com";
//****
// ++++++++++++++++++++++++++++++++++++ End of Image URL ++++++++++++++++++++++++++++++++++++

class BaseClient {
  var client = http.Client();
  var headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var token;
  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
  }

// Email and Phone Number
//
  Future<dynamic> emailPhoneNumber(
    String api,
    String email,
    String phoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrlProvider + api);
    var requestData = {
      "email": email,
      "phone_number": phoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// OTP Verify Number
//
  Future<dynamic> otpVerifyNumber(
    String api,
    String phoneNumber,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrlProvider + api);
    var requestData = {
      "phone_number": phoneNumber,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// OTP
//
  Future<dynamic> otp(
    String api,
    String phoneNumber,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Sign Up
//
  Future<dynamic> signUp(
    String api,
    String phone_number,
    String first_name,
    String last_name,
    String password,
    String password_confirmation,
    // String countryCode,
    String address,
    String zip_code,
    String latitude,
    String longitude,
    File? image,
    String company_name,
    String company_size,
    String industry_type,
    String? company_website,
    String company_address,
    String lat,
    String lng,
    List<XFile>? portfolioImg,
    List<XFile>? license_image,
    List<XFile>? insuranceImg,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrlProvider + api);
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(headers);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    if (portfolioImg != null && portfolioImg.isNotEmpty) {
      for (XFile item in portfolioImg) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item.path),
        );
      }
    }
    if (license_image != null && license_image.isNotEmpty) {
      for (XFile item in license_image) {
        request.files.add(
          await http.MultipartFile.fromPath('license_images[]', item.path),
        );
      }
    }
    if (insuranceImg != null && insuranceImg.isNotEmpty) {
      for (XFile item in insuranceImg) {
        request.files.add(
          await http.MultipartFile.fromPath('insurance_images[]', item.path),
        );
      }
    }
    request.fields['phone_number'] = phone_number;
    request.fields['first_name'] = first_name;
    request.fields['last_name'] = last_name;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password_confirmation;
    request.fields['country_code'] = "pk";
    request.fields['address'] = address;
    request.fields['zip_code'] = zip_code;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;
    request.fields['company_name'] = company_name;
    request.fields['company_size'] = company_size;
    request.fields['industry_type'] = industry_type;
    request.fields['company_website'] = company_website!;
    request.fields['company_address'] = company_address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }
  //

// Login
//
  Future<dynamic> login(
    String api,
    String phoneNumber,
    String password,
    String userType,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "password": password,
      "user_type": userType,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    return json.decode(response.body);
  }
  //

// Log Out
//
  Future<dynamic> logOut(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Forget Password Otp
//
  Future<dynamic> forgetPassword(
    String api,
    String phoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// New Password
//
  Future<dynamic> newPassword(
    String api,
    String phoneNumber,
    String password,
    String confirmPassword,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "password": password,
      "password_confirmation": confirmPassword,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Change Password
//
  Future<dynamic> changePassword(
    String api,
    String currentPassword,
    String password,
    String confirmPassword,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_password": currentPassword,
      "password": password,
      "password_confirmation": confirmPassword,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Edit Profile Detail
//
  Future<dynamic> editProfileDetail(
    String api,
    String firstName,
    String lastName,
    File? image,
    String address,
    String latitude,
    String longitude,
    String zip_code,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['zip_code'] = zip_code;
    request.fields['address'] = address;
    request.fields['lat'] = latitude;
    request.fields['lng'] = longitude;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }
  //

// Verify Email
//
  Future<dynamic> verifyEmail(
    String api,
    String email,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "email": email,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Verify Email Otp
//
  Future<dynamic> verifyEmailOtp(
    String api,
    String email,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "email": email,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Edit Email
//
  Future<dynamic> editEmail(
    String api,
    String currentEmail,
    String newEmail,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_email": currentEmail,
      "new_email": newEmail,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// edit Email Otp
//
  Future<dynamic> editEmailOtp(
    String api,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// New Phone Number
//
  Future<dynamic> newPhoneNumber(
    String api,
    String currentPhoneNumber,
    String newPhoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_phone_number": currentPhoneNumber,
      "new_phone_number": newPhoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Change Phone Number Otp
//
  Future<dynamic> newPhoneNumberOtp(
    String api,
    String otp,
    // String countryCode,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "otp": otp,
      "country_code": "pk",
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Get Jobs
//
  Future<http.Response> get2AvailJobs(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Get Available Jobs
//
  Future<http.Response> getAvailJobs(
    String api,
    String type,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "type": type,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return response;
  }
  //

// Get Job Details
//
  Future<dynamic> getJobDetail(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Get Lawn Mowing Sizes Heights Fence
//
  Future<http.Response> sizesHeightsPrices(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Lawn Size Cleanup Price
//
  Future<dynamic> lawnSizeCleanupPrice(
    String api,
    String lawn_size_id,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "lawn_size_id": lawn_size_id,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Get Snow-Plowing related category prices and schedule timing
//
  Future<dynamic> snowPlowingCatPrSch(
    String api,
    String type,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "type": type,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }
  //

// Get Snow-Plowing related category prices and schedule timing
//
  Future<dynamic> sendProposal(
    String api,
    String order_id,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();

    return json.decode(response.body);
  }
  //

// Get Available Jobs
//
  Future<http.Response> getreviews(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Active services
//
  Future<dynamic> activeJobStatus(
    String api,
    String? checked_questions,
    List<XFile>? portfolioImg,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);

    if (portfolioImg != null && portfolioImg.isNotEmpty) {
      for (XFile item in portfolioImg) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item.path),
        );
      }
    }
    if (checked_questions != null) {
      request.fields['checked_questions'] = checked_questions;
    }
    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }
  //

// Provider location update
//
  Future<dynamic> updateProviderLoc(
    String api,
    String order_id,
    String lat,
    String lng,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "lat": lat,
      "lng": lng,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }
  //

// Get Available Jobs
//
  Future<http.Response> getEarnings(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Provider location update
//
  Future<dynamic> getChat(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }
  //

// Send message
//
  Future<dynamic> sendMessagePress(
    String api,
    String order_id,
    String message,
    String user_id,
    String order_no,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "message": message,
      "user_id": user_id,
      "order_no": order_no,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    // print(response.body);
    return json.decode(response.body);
  }
  //

// Get FAQ
//
  Future<http.Response> getFaqs(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "type": "provider",
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return response;
  }
  //

// Get about
//
  Future<http.Response> getAbout(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Help
//
  Future<dynamic> help(
    String api,
    String detail,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "detail": detail,
    };
    var body = json.encode(requestData);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return json.decode(response.body);
  }
  //

// Add Profile Detail
//
  Future<dynamic> addProfileDetail(
    String api,
    String phoneNumber,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
    String? referralLink,
    File? image,
    // String countryCode,
    String address,
    String latitude,
    String longitude,
    String zip_code,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(headers);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['phone_number'] = phoneNumber;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = confirmPassword;
    // request.fields['country_code'] = countryCode;
    request.fields['country_code'] = "pk";
    request.fields['address'] = address;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;
    request.fields['zip_code'] = zip_code;
    request.fields['referral_link'] = referralLink!;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }
  //

// Email and Phone Number
//
  Future<dynamic> emailPhoneNumberCP(
    String api,
    String email,
    String phoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "email": email,
      "phone_number": phoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// OTP
//
  Future<dynamic> otpCP(
    String api,
    String phoneNumber,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Add Profile Detail
//
  Future<dynamic> addProfileDetailCP(
    String api,
    String phoneNumber,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
    String? referralLink,
    File? image,
    // String countryCode,
    String address,
    String latitude,
    String longitude,
    String zip_code,
    String created_by,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(headers);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['phone_number'] = phoneNumber;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = confirmPassword;
    // request.fields['country_code'] = countryCode;
    request.fields['country_code'] = "pk";
    request.fields['address'] = address;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;
    request.fields['zip_code'] = zip_code;
    if (referralLink != null || referralLink!.isNotEmpty) {
      request.fields['referral_link'] = referralLink;
    }
    request.fields['created_by'] = created_by;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }
  //

// Get customer list
//
  Future<http.Response> getCustList(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// Order Summary
//
  Future<dynamic> orderForCustomer(
    String api,
    String? user_id,
    String? category_id,
    String? address,
    String? lat,
    String? lng,
    String? amount,
    List? images,
    String? service_delivery,
    String? service_period_id,
    String? recurring_amount,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    // print(images);
    List? img = images?.where((e) => e != null).toList();
    bool imgIsEmpty = img?.isEmpty ?? true;
    if (!imgIsEmpty) {
      for (String item in img!) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item),
        );
      }
    }
    user_id != null ? request.fields['user_id'] = user_id : null;
    category_id != null ? request.fields['category_id'] = category_id : null;
    address != null ? request.fields['address'] = address : null;
    lat != null ? request.fields['lat'] = lat : null;
    lng != null ? request.fields['lng'] = lng : null;
    amount != null ? request.fields['amount'] = amount : null;
    service_delivery != null
        ? request.fields['service_delivery'] = service_delivery
        : null;
    service_period_id != null
        ? request.fields['service_period_id'] = service_period_id
        : null;
    recurring_amount != null
        ? request.fields['recurring_amount'] = recurring_amount
        : null;

    var response = await request.send();

    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }
  //

// Order Summary
//
  Future<dynamic> cardForCustomer(
    String api,
    String? user_id,
    String? card_number,
    String? exp_month,
    String? exp_year,
    String? cvv,
    String? order_id,
    String? grandTotal,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    user_id != null ? request.fields['user_id'] = user_id : null;
    card_number != null ? request.fields['card_number'] = card_number : null;
    exp_month != null ? request.fields['exp_month'] = exp_month : null;
    exp_year != null ? request.fields['exp_year'] = exp_year : null;
    cvv != null ? request.fields['cvv'] = cvv : null;
    order_id != null ? request.fields['order_id'] = order_id : null;
    grandTotal != null ? request.fields['grandTotal'] = grandTotal : null;

    var response = await request.send();

    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }
  //

// Get notifications list
//
  Future<http.Response> getNotification(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }
  //

// delete Notifications
//
  Future<dynamic> deleteNotification(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.delete(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }
  //

// Get customer list
//
  Future<dynamic> getBankAcc(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }
  //

// Add Bank Account using Stripe
//
  Future<dynamic> addBankAccStripe(
    String api,
    String ssn_last_4,
    String routing_number,
    String account_number,
    String city,
    String state,
    String postal_code,
    String dob,
    String address,
  ) async
  //
  {
    await getToken();
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrlProvider + api);
    var requestData = {
      "ssn_last_4": ssn_last_4,
      "routing_number": routing_number,
      "account_number": account_number,
      "city": city,
      "state": state,
      "postal_code": postal_code,
      "dob": dob,
      "address": address,
    };
    var body = json.encode(requestData);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Delete Bank Account using Stripe
//
  Future<dynamic> deleteBankAccStripe(
    String api,
  ) async
  //
  {
    await getToken();
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.delete(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
  //

// Delete Account
//
  Future<dynamic> deleteAccount(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();

    return json.decode(response.body);
  }
  //

  // get service detail
  //
  Future<dynamic> getServiceDetail(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    var jobData = json.decode(response.body);
    return jobData['data']['jobs'][0];
  }
}
