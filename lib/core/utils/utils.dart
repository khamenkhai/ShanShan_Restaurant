import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

void customPrint(String data){
  if (kDebugMode) {
    print(data);
  }
}

///to navigate to other page
Future<dynamic> redirectTo({
  required BuildContext context,
  bool replacement = false,
  required Widget form,
}) async {
  if (replacement) {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => form));
  } else {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => form));
  }
}

///to remove all the previous page and navigate to new page
pushAndRemoveUntil({required Widget form, required BuildContext context}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => form),
    (route) => false,
  );
}

///show snack bar at the bottom of the page
void showSnackBar({required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 1),
    ),
  );
}

///to get the current language of the app
String getCurrentLanguageCode(BuildContext context) {
  Locale selectedLocale = Localizations.localeOf(context);
  return selectedLocale.languageCode;
}

///calculate the percentage of a number
num calculatePercentage(num totalAmount, num percentage) {
  return (totalAmount * percentage) / 100;
}

int get5percentage(int totalAmount) {
  return (totalAmount * 5) ~/ 100;
}

///show custom snackbar
void showCustomSnackbar({
  required BuildContext context,
  required String message,
}) {
  IconSnackBar.show(
    context,
    snackBarType: SnackBarType.fail,
    label: message,
    behavior: SnackBarBehavior.floating,
  );
}

///generate random id
String generateRandomId(int length) {
  final Random random = Random();
  const int maxDigit = 9;

  String generateDigit() => random.nextInt(maxDigit + 1).toString();

  return List.generate(length, (_) => generateDigit()).join();
}

///to format number with , and remove .0
String formatNumber(num number) {
  String formatted = NumberFormat('#,##0.#').format(number);

  if (formatted.contains('.')) {
    formatted = formatted.replaceAll(RegExp(r'(?<=\d)0*$'), '');
  }

  return formatted;
}

// ///calculate price by grams
// int getPriceByGram(int grams) {
//   if (grams <= 100) {
//     return 400;
//   } else if (grams > 100 && grams <= 200) {
//     return 800;
//   } else if (grams >= 200 && grams < 300) {
//     return 1200;
//   } else if (grams >= 300 && grams < 400) {
//     return 1600;
//   } else if (grams >= 400 && grams < 500) {
//     return 2000;
//   } else if (grams >= 500 && grams < 600) {
//     return 2400;
//   } else if (grams >= 600 && grams < 700) {
//     return 2800;
//   } else if (grams >= 700 && grams < 800) {
//     return 3100;
//   } else if (grams >= 800 && grams < 900) {
//     return 3600;
//   } else if (grams >= 900 && grams < 1000) {
//     return 4000;
//   } else if (grams >= 1900 && grams < 2000) {
//     return 8000;
//   } else {
//     return 0;
//   }
// }

int getPriceByGrama({required int weight, required int priceGap}) {
  int range = (weight / 100).ceil();

  int price = range * priceGap;

  return price;
}

int getPriceByGram({required int weight, required int priceGap}) {
  return ((weight / 100) * priceGap).ceil();
}

///print out
Future<bool> printReceipt({
  required int tableNumber,
  required String orderNumber,
  required String date,
  required List<CartItem> products,
  required int discountAmount,
  required int subTotal,
  required int grandTotal,
  required int cashAmount,
  required int paidOnline,
  required String remark,
  required String menu,
  required String ahtoneLevel,
  required String spicyLevel,
  required int octopusCount,
  required int prawnCount,
  required int taxAmount,
  required int dineInOrParcel,
  required String paymentType,
  required bool customerTakevoucher,
}) async {
  try {
    customPrint("voucher : Tax amount -> $taxAmount");
    customPrint("voucher : Sub total -> $subTotal");
    customPrint("voucher : Grand total -> $grandTotal");
    customPrint("voucher : Cash amount -> $cashAmount");
    customPrint("voucher : Online Pay -> $paidOnline");
    customPrint("voucher : table -> $tableNumber");

    //final converter = ZawGyiConverter();

    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);

    // // await SunmiPrinter.printText(
    // //   'North Dagon, Yangon',
    // //   style: SunmiStyle(
    // //     align: SunmiPrintAlign.CENTER,
    // //   ),
    // // );

    // // await SunmiPrinter.printText("");

    // // await SunmiPrinter.printText(
    // //   'Open Daily : 9 AM To 6 PM',
    // //   style: SunmiStyle(
    // //     align: SunmiPrintAlign.CENTER,
    // //   ),
    // // );
    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Order Number',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: orderNumber,
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Table Number',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: '$tableNumber',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Date',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: date,
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printText("");
    await SunmiPrinter.printText(
      menu,
      style: SunmiStyle(bold: true),
    );

    // //await SunmiPrinter.printText(dineInOrParcel == 0 ? "ပါဆယ်" : "ထိုင်စား");
    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.printRow(cols: [
      dineInOrParcel == 0
          ? ColumnMaker(
              text: "ပါဆယ်",
              width: 35,
              align: SunmiPrintAlign.LEFT,
            )
          : ColumnMaker(
              text: "ထိုင်စား",
              width: 35,
              align: SunmiPrintAlign.LEFT,
            ),
      // ColumnMaker(
      //   text: "မှတ်ချက် :",
      //   width: 40,
      //   align: SunmiPrintAlign.RIGHT,
      // ),
    ]);
    // await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: "a",
    //     width: 20,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "${remark}",
    //     width: 35,
    //     align: SunmiPrintAlign.RIGHT,
    //   ),
    // ]);
    await SunmiPrinter.printText("မှတ်ချက် : $remark");
    await SunmiPrinter.lineWrap(1);

    if (ahtoneLevel == "" && spicyLevel == "") {
      await SunmiPrinter.printText("");
    } else {
      await SunmiPrinter.printText("အထုံ Level    : $ahtoneLevel");
      await SunmiPrinter.printText("အစပ် Level    : $spicyLevel");
    }

    //await SunmiPrinter.printText("");
    await SunmiPrinter.printText(
      "----------------------------------------------",
    );

    await SunmiPrinter.setCustomFontSize(22);

    await SunmiPrinter.printRow(
      cols: [
        ColumnMaker(
          text: "Product",
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "Qty",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: 'Price',
          width: 6,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: "Amount",
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ],
    );

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setCustomFontSize(22);

    // ignore: avoid_function_literals_in_foreach_calls
    products.forEach((e) async {
      // Zawgyi to Unicode
      // String price = formatNumber(e.price);

      // String uniOutput = converter.zawGyiToUnicode('${e.name}');

      //String zawOutput = converter.unicodeToZawGyi('${e.name}');

      ///type 3
      SunmiPrinter.printRow(cols: [
        // ColumnMaker(
        //   text: e.is_gram
        //       ? '${e.name}${e.qty}gram x ${price}'
        //       : '${e.name}${e.qty} x ${price}',
        //   width: 38,
        //   //align: SunmiPrintAlign.LEFT,
        // ),
        // ColumnMaker(
        //   text: '${formatNumber(e.totalPrice)}',
        //   width: 8,
        //   align: SunmiPrintAlign.RIGHT,
        // ),

        ColumnMaker(
          text: e.name,
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: e.isGram ? '${e.qty}g' : '${e.qty}',
          //text: "${e.price}",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "${e.price}",
          //text: e.is_gram ? '${e.qty}g' : '${e.qty}',
          width: 6,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: formatNumber(e.totalPrice),
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    });

    //await SunmiPrinter.setFontSize(SunmiFontSize.MD);
    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      "----------------------------------------------",
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
      ),
    );

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'SubTotal',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(subTotal)} MMK',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Commercial Tax (5%)',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(taxAmount)} MMK',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Grand Total',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(grandTotal)} MMK',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Cash ',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '$cashAmount MMK',
        width: 20,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Kpay ',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '$paidOnline MMK',
        width: 20,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    // await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: 'Kpay ',
    //     width: 25,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: '${paidOnline} MMK',
    //     width: 20,
    //     align: SunmiPrintAlign.RIGHT,
    //   ),
    // ]);

    await SunmiPrinter.printText("");

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.printText(
      "ပုဇွန် : $prawnCount , ရေဘဝဲ : $octopusCount",
    );

    await SunmiPrinter.printText("");
    await SunmiPrinter.printText(
      "----------THANK YOU----------",
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        fontSize: SunmiFontSize.MD,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.cut();
    await SunmiPrinter.exitTransactionPrint(true);

    return true;
  } catch (e) {
    return false;
  }
}


  ///clumn title
 //await SunmiPrinter.setFontSize(SunmiFontSize.SM);
    // SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: "Product",
    //     width: 17,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "Price",
    //     width: 10,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "Qty",
    //     width: 10,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "Amount",
    //     width: 12,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    // ]);


    
         ///type 1
      // SunmiPrinter.printRow(cols: [
      //   ColumnMaker(
      //     text: "${e.name}",
      //     width: 17,
      //     align: SunmiPrintAlign.LEFT,
      //   ),
      //   ColumnMaker(
      //     text: "${e.price}",
      //     width: 10,
      //     align: SunmiPrintAlign.LEFT,
      //   ),
      //   ColumnMaker(
      //     text: e.is_gram ? '${e.qty}gram' : '${e.qty}',
      //     width: 10,
      //     align: SunmiPrintAlign.LEFT,
      //   ),
      //   ColumnMaker(
      //     text: "${formatNumber(e.totalPrice)} MMK",
      //     width: 12,
      //     align: SunmiPrintAlign.LEFT,
      //   ),
      // ]);

      ///type 2
      // SunmiPrinter.printRow(cols: [
      //   ColumnMaker(
      //     text: "${e.name}",
      //     width: 30,
      //     align: SunmiPrintAlign.LEFT,
      //   ),
      //   ColumnMaker(
      //     text: '${formatNumber(e.totalPrice)} MMK',
      //     width: 15,
      //     align: SunmiPrintAlign.RIGHT,
      //   ),
      // ]);

      // SunmiPrinter.printText(
      //   e.is_gram
      //       ? '${e.qty}gram x ${formatNumber(e.price)}'
      //       : '${e.qty} x ${formatNumber(e.price)}',
      // );