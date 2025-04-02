import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_state.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/sale_history_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';
import 'package:shan_shan/view/update_sale_ui/edit_sale_home.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:shan_shan/view/widgets/voucher_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TextEditingController searchController = TextEditingController();

  RefreshController refresherController = RefreshController();

  int currentPage = 1;

  int currentHistoryID = 1;

  bool visible = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  bool alreadyPrint = false;

  @override
  void initState() {
    context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);

    ///initialize sunmi printer
    _initializePrinter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 200,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("အရောင်းမှတ်တမ်း"),
      ),
      body: InternetCheckWidget(
        child: _historyForm(screenSize),
        onRefresh: () {
          context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        },
      ),
    );
  }

  ///historm form
  Container _historyForm(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      padding: EdgeInsets.only(
        left: SizeConst.kHorizontalPadding,
        right: SizeConst.kHorizontalPadding,
        top: SizeConst.kHorizontalPadding - 5,
        bottom: SizeConst.kHorizontalPadding,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            child: TextField(
              controller: searchController,
              decoration: customTextDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "အရောင်းမှတ်တမ်းရှာဖွေရန်",
              ),
              onChanged: (value) {
                searchHistory(value: value);
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: SizeConst.kBorderRadius,
              ),
              child: Column(
                children: [
                  _titleRow(),
                  SizedBox(height: 25),
                  BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
                    builder: (context, state) {
                      if (state is SalesHistoryLoadingState) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: 15,
                            itemBuilder: (context, index) {
                              return _historyShimmer();
                            },
                          ),
                        );
                      } else if (state is SalesHistoryLoadedState) {
                        List<SaleHistoryModel> saleHistories = state.history;

                        print("sale history length : ${saleHistories.length}");

                        return Expanded(
                          child: SmartRefresher(
                            controller: refresherController,
                            
                            onRefresh: () async {
                              await context
                                  .read<SalesHistoryCubit>()
                                  .getHistoryByPagination(page: 1);

                              refresherController.refreshCompleted();

                              currentPage = 1;
                              print("current page : ${currentPage}");
                            },
                            onLoading: () async {
                              currentPage += 1;

                              if (mounted) {
                                print("loading page : ${currentPage}");

                                if (searchController.text == "" ||
                                    searchController.text.isEmpty) {
                                  context
                                      .read<SalesHistoryCubit>()
                                      .loadMoreHistory(
                                          page: currentPage, requestBody: {});
                                } else {}

                                refresherController.loadComplete();
                              }
                            },
                            enablePullDown: true,
                            enablePullUp: true,
                            child: ListView.builder(
                              itemCount: state.history.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: _historyRowWidget(
                                    history: state.history[index],
                                    index: index + 1,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else if (state is SalesHistoryErrorState) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("History Not Found"),
                                SizedBox(height: 5),
                                IconButton(
                                  onPressed: () {
                                    currentPage = 1;
                                    context
                                        .read<SalesHistoryCubit>()
                                        .getHistoryByPagination(page: 1);
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.refresh, size: 35),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Someting is wrong"),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///get the payment type
  String getPaymentType(SaleHistoryModel sale) {
    int paidOnline = sale.paidOnline;
    int paidCash = sale.paidCash;
    if (paidCash > 0 && paidOnline == 0) {
      return "Cash";
    } else if (paidCash == 0 && paidOnline >= 0) {
      return "Kpay";
    } else {
      return "Cash / Kpay";
    }
  }

  ///shimmer loading effect for history list
  Shimmer _historyShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(color: Colors.grey),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "category shimer",
              style: TextStyle(
                color: Colors.transparent,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////history row widget
  Widget _historyRowWidget({
    required SaleHistoryModel history,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        print("octopus  : ${history.octopusCount}");
        print("prawnCount  : ${history.prawnCount}");
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: SizeConst.kBorderRadius,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Icon(Icons.clear)),
                          ),
                        ],
                      ),
                      VoucherWidget(
                        cashAmount: history.paidCash,
                        bankAmount: history.paidOnline,
                        change: 0,
                        paymentType: getPaymentType(history),
                        subTotal: history.subTotal,
                        grandTotal: history.grandTotal,
                        date: history.createdAt,
                        orderNumber: history.orderNo,
                        ahtoneLevel: AhtoneLevelModel(
                          name: history.ahtoneLevel.name,
                        ),
                        spicyLevel:
                            SpicyLevelModel(name: history.spicyLevel.name),
                        cartItems: history.products
                            .map(
                              (e) => CartItem(
                                id: e.productId,
                                name: e.name,
                                price: e.price,
                                qty: e.qty,
                                totalPrice: e.totalPrice,
                                is_gram: false,
                              ),
                            )
                            .toList(),
                        octopusCount: history.octopusCount,
                        prawnAmount: history.prawnCount,
                        dineInOrParcel: history.dineInOrParcel,
                        discount: history.discount,
                        remark: history.remark,
                        menu: history.menu.name.toString(),
                        tableNumber: int.parse(history.tableNumber),
                        showEditButton: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${history.orderNo}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${history.tableNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${formatNumber(history.grandTotal)}  MMK ",
                textAlign: TextAlign.right,
                //"${formatNumber(num.parse(history.grand_total ?? "0"))} MMK",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 50,
              child: Visibility(
                visible: getPaymentMethod(
                        paidCash: history.paidCash,
                        paidOnline: history.paidOnline) ==
                    "kpay",
                child: Text(
                  "(${getPaymentMethod(
                    paidCash: history.paidCash,
                    paidOnline: history.paidOnline,
                  )})",
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await printReceipt(
                        customerTakevoucher: false,
                        tableNumber: int.parse(history.tableNumber),
                        orderNumber: history.orderNo,
                        date: history.createdAt,
                        products: history.products
                            .map((e) => CartItem(
                                  id: e.productId,
                                  name: e.name,
                                  price: e.price,
                                  qty: e.qty,
                                  totalPrice: e.totalPrice,
                                  is_gram: e.isGram,
                                ))
                            .toList(),
                        discountAmount: history.discount,
                        subTotal: history.subTotal,
                        grandTotal: history.grandTotal,
                        cashAmount: history.paidCash,
                        remark: history.remark,
                        menu: history.menu.name ?? "",
                        ahtoneLevel: history.ahtoneLevel.name,
                        spicyLevel: history.spicyLevel.name.toString(),
                        octopusCount: history.octopusCount,
                        prawnCount: history.prawnCount,
                        taxAmount: history.tax,
                        dineInOrParcel: history.dineInOrParcel,
                        paymentType: getPaymentType(history),
                        kpayAmount: history.paidOnline,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.print,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      redirectTo(
                        context: context,
                        form: EditSaleScreen(
                          saleHistory: history,
                          orderNo: history.orderNo,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///title row widget
  Row _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "ပြေစာနံပါတ်",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "စားပွဲနံပါတ်",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "စုစုပေါင်း",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          width: 50,
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///search history
  void searchHistory({required String value}) async {
    if (value.isEmpty || value == "") {
      context.read<SalesHistoryCubit>().getHistoryByPagination(
            page: 1,
          );
    } else {
      context.read<SalesHistoryCubit>().searchHistory(
            query: "${searchController.text}",
          );
    }
  }

  void _initializePrinter() {
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });
    });
  }
}

// Add the payment method logic here:
String getPaymentMethod({required int paidCash, required int paidOnline}) {
  if (paidCash > 0 && paidOnline == 0) {
    return "";
  } else if (paidOnline > 0 && paidCash == 0) {
    return "kpay";
  } else if (paidCash > 0 && paidOnline > 0) {
    return "cash/kpay";
  } else {
    return "unknown"; // In case neither condition is met
  }
}
