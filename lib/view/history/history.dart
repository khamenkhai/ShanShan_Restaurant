import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_state.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/sale_history_model.dart';
import 'package:shan_shan/view/history/edit_sale_page.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/voucher_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initializePrinter();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
  }

  Future<void> _initializePrinter() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.paperSize();
    await SunmiPrinter.printerVersion();
    await SunmiPrinter.serialNumber();
  }

  void _handleRefresh() async {
    _currentPage = 1;
    await context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
    _refreshController.refreshCompleted();
  }

  void _handleLoading() async {
    _currentPage += 1;

    if (_searchController.text.isEmpty) {
      await context
          .read<SalesHistoryCubit>()
          .loadMoreHistory(page: _currentPage, requestBody: {});
    }

    _refreshController.loadComplete();
  }

  void _searchHistory(String value) {
    if (value.isEmpty) {
      _loadInitialData();
    } else {
      context.read<SalesHistoryCubit>().searchHistory(query: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 200,
        leading: AppBarLeading(
          onTap: () => Navigator.pop(context),
        ),
        title: Text(tr(LocaleKeys.saleHistory)),
      ),
      body: InternetCheckWidget(
        onRefresh: _loadInitialData,
        child: _buildHistoryContent(),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConst.kHorizontalPadding,
      ),
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: SizeConst.kBorderRadius),
              child: Column(
                children: [
                  const _HistoryHeaderRow(),
                  const SizedBox(height: 25),
                  _buildHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextField(
        controller: _searchController,
        decoration: customTextDecoration2(
            labelText: tr(LocaleKeys.searchSaleHistory),
            primaryColor: Theme.of(context).primaryColor),
        onChanged: _searchHistory,
      ),
    );
  }

  Widget _buildHistoryList() {
    return BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
      builder: (context, state) {
        if (state is SalesHistoryLoadingState) {
          return _buildShimmerLoading();
        } else if (state is SalesHistoryLoadedState) {
          return _buildSmartRefresher(state.history);
        } else if (state is SalesHistoryErrorState) {
          return _buildErrorState();
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Expanded(
      child: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) => _buildHistoryShimmer(),
      ),
    );
  }

  Widget _buildSmartRefresher(List<SaleHistoryModel> histories) {
    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _handleRefresh,
        onLoading: _handleLoading,
        enablePullDown: true,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: histories.length,
          itemBuilder: (context, index) => _buildHistoryRow(
            history: histories[index],
            index: index + 1,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("History Not Found"),
            const SizedBox(height: 5),
            IconButton(
              onPressed: () {
                _currentPage = 1;
                _loadInitialData();
                setState(() => _searchController.clear());
              },
              icon: const Icon(Icons.refresh, size: 35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(color: Colors.grey),
        child: const Row(
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

  Widget _buildHistoryRow({
    required SaleHistoryModel history,
    required int index,
  }) {
    return InkWell(
      onTap: () => _showHistoryDetails(history),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                history.orderNo,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                history.tableNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                "${formatNumber(history.grandTotal)}  MMK ",
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              width: 50,
              child: Visibility(
                visible: _getPaymentMethod(
                      paidCash: history.paidCash,
                      paidOnline: history.paidOnline,
                    ) ==
                    "kpay",
                child: Text(
                  "(${_getPaymentMethod(
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
                  _buildPrintButton(history),
                  const SizedBox(width: 10),
                  _buildEditButton(history),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintButton(SaleHistoryModel history) {
    return InkWell(
      onTap: () => _printReceipt(history),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(Icons.print),
      ),
    );
  }

  Widget _buildEditButton(SaleHistoryModel history) {
    return InkWell(
      onTap: () => _navigateToEditScreen(history),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showHistoryDetails(SaleHistoryModel history) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
        child: _buildHistoryDialogContent(history),
      ),
    );
  }

  Widget _buildHistoryDialogContent(SaleHistoryModel history) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Icon(Icons.clear),
                  ),
                ),
              ],
            ),
            VoucherWidget(
              cashAmount: history.paidCash,
              bankAmount: history.paidOnline,
              refund: history.refund,
              paymentType: _getPaymentType(history),
              subTotal: history.subTotal,
              grandTotal: history.grandTotal,
              date: history.createdAt,
              orderNumber: history.orderNo,
              ahtoneLevel: AhtoneLevelModel(name: history.ahtoneLevel.name),
              spicyLevel: SpicyLevelModel(name: history.spicyLevel.name),
              cartItems: history.products.map(_mapToCartItem).toList(),
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
    );
  }

  CartItem _mapToCartItem(dynamic e) {
    return CartItem(
      id: e.productId,
      name: e.name,
      price: e.price,
      qty: e.qty,
      totalPrice: e.totalPrice,
      isGram: false,
    );
  }

  Future<void> _printReceipt(SaleHistoryModel history) async {
    await printReceipt(
      customerTakevoucher: false,
      tableNumber: int.parse(history.tableNumber),
      orderNumber: history.orderNo,
      date: history.createdAt,
      products: history.products.map(_mapToCartItem).toList(),
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
      paymentType: _getPaymentType(history),
      paidOnline: history.paidOnline,
    );
  }

  void _navigateToEditScreen(SaleHistoryModel history) {
    redirectTo(
      context: context,
      form: EditSalePage(
        saleHistory: history,
        orderNo: history.orderNo,
      ),
    );
  }

  String _getPaymentType(SaleHistoryModel sale) {
    if (sale.paidCash > 0 && sale.paidOnline == 0) return "Cash";
    if (sale.paidCash == 0 && sale.paidOnline >= 0) return "Online Pay";
    return "Cash / Online Pay";
  }

  String _getPaymentMethod({required int paidCash, required int paidOnline}) {
    if (paidCash > 0 && paidOnline == 0) return "";
    if (paidOnline > 0 && paidCash == 0) return "online";
    if (paidCash > 0 && paidOnline > 0) return "cash/online";
    return "unknown";
  }
}

class _HistoryHeaderRow extends StatelessWidget {
  const _HistoryHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            tr(LocaleKeys.slitNumber),
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
              tr(LocaleKeys.tableNumber),
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
            tr(LocaleKeys.total),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 70), // Replaced Container with margin
        Expanded(
          flex: 1,
          child: SizedBox(), // Empty widget for alignment
        ),
      ],
    );
  }
}
