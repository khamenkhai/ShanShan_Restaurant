import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///to get the current language of the app
String getCurrentLanguageCode(BuildContext context) {
  Locale selectedLocale = Localizations.localeOf(context);
  return selectedLocale.languageCode;
}

///remove before first comma
String removeBeforeFirstComma(String input) {
  // Find the index of the first comma
  int commaIndex = input.indexOf(',');

  // If a comma exists, return the part of the string after the comma
  if (commaIndex != -1) {
    return input
        .substring(commaIndex + 1)
        .trim(); // +1 to remove the comma itself
  }

  // If no comma is found, return the input as is
  return input;
}

bool isPlusCode(String address) {
  // Regular expression for detecting Plus Code (Open Location Code)
  final RegExp plusCodePattern = RegExp(r'^[A-Z0-9]{2}\+?[A-Z0-9]+');
  return plusCodePattern.hasMatch(address);
}

///calculate the percentage of a number
num calculatePercentage(num totalAmount, num percentage) {
  return (totalAmount * percentage) / 100;
}

///to get the name of the language by the language code
// String getLanguageName({required String languageCode}) {
//   if (languageCode == "en") {
//     return "${tr(LocaleKeys.lblEnglish)}";
//   } else if (languageCode == "my") {
//     return "${tr(LocaleKeys.lblMyanmar)}";
//   } else {
//     return "${tr(LocaleKeys.lblEnglish)}";
//   }
// }

///generate random id
String generateRandomId(int length) {
  final Random random = Random();
  const int maxDigit = 9;

  String generateDigit() => random.nextInt(maxDigit + 1).toString();

  return List.generate(length, (_) => generateDigit()).join();
}

///main box shadow style
BoxShadow mainBoxShadowStyle() {
  return BoxShadow(
    offset: const Offset(0, 0.5),
    // ignore: deprecated_member_use
    color: Colors.black.withOpacity(0.08),
    blurRadius: 5,
  );
}

///set status bar clor to black color
void statusBarColorToBlack() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

///status bar color to white color
void statusBarColorToWhite() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light, ////white text
      statusBarColor: Colors.transparent,
    ),
  );
}

///initialize device and send device id to the server
// initializeDeviceId() async {
//   String deviceId = await getUniqueIdentifier();
//   SharedPref sharedPref = SharedPref();
//   DioClient dioClient = DioClient(sharedPref: sharedPref);

//   final token = await getFcmToken();

//   ResponseModel response = await dioClient.postRequestWithoutToken(
//     apiUrl: "user/device-token",
//     requestBody: {"device_token": token, "device_id": "${deviceId}"},
//   );
//   print("Device Token ::${response.status}");
// }

String formatNumberWithComma(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
