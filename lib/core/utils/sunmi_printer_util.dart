  import 'package:shan_shan/core/utils/utils.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

///print out
  Future<bool> printReceipt({
    required int cashAmount,
    required int paidOnline,
    required int totalAmount,
    required int taxAmount,
    required int discountAmount,
    required String report,
  }) async {
    try {
      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.printText(
        'ရှန်းရှန်း',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.printText(
        'North Dagon, Yangon',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Report',
          width: 17,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: ':',
          width: 2,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${report}',
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(cashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(paidOnline)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(totalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);

      return true;
    } catch (e) {
      return false;
    }
  }

  ///priint montyly report
  Future<bool> printMontylyReport({
    required int lastMonthcashAmount,
    required int lastMonthpaidOnline,
    required int lastMonthtotalAmount,
    required int currentMonthcashAmount,
    required int currentMonthpaidOnline,
    required int currentMonthtotalAmount,
    required String lastMonthDate,
    required String currentMonthDate,
  }) async {
    try {
      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.printText(
        'ရှန်းရှန်း',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.printText(
        'North Dagon, Yangon',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText(
          "Current Month Report : ${currentMonthDate}");

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(currentMonthcashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(currentMonthpaidOnline)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(currentMonthtotalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      //await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Last Month Report',
          width: 17,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: ':',
          width: 2,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${lastMonthDate}',
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(lastMonthcashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(lastMonthpaidOnline)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(lastMonthtotalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);

      return true;
    } catch (e) {
      return false;
    }
  }
