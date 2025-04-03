import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_state.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/sale_history_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/view/update_sale_ui/edit_sale_home.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/voucher_widget.dart';

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
    context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _initializePrinter() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.paperSize();
    await SunmiPrinter.printerVersion();
    await SunmiPrinter.serialNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 200,
        leading: appBarLeading(
          onTap: () => Navigator.pop(context),
        ),
        title: const Text("အရောင်းမှတ်တမ်း"),
      ),
      body: InternetCheckWidget(
        child: _buildHistoryContent(),
        onRefresh: _refreshHistory,
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConst.kHorizontalPadding,
        vertical: SizeConst.kHorizontalPadding - 5,
      ),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 20),
          Expanded(child: _buildHistoryList()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _searchController,
        decoration: customTextDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: "အရောင်းမှတ်တမ်းရှာဖွေရန်",
        ),
        onChanged: (value) => _searchHistory(value),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Column(
        children: [
          const _HistoryHeaderRow(),
          const SizedBox(height: 25),
          BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
            builder: (context, state) {
              if (state is SalesHistoryLoadingState) {
                return const Expanded(child: _HistorySkeletonList());
              } else if (state is SalesHistoryLoadedState) {
                return _buildLoadedHistoryList(state.history);
              } else if (state is SalesHistoryErrorState) {
                return _buildErrorState();
              }
              return const Center(child: Text("Something went wrong"));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedHistoryList(List<SaleHistoryModel> histories) {
    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshHistory,
        onLoading: _loadMoreHistory,
        enablePullDown: true,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: histories.length,
          itemBuilder: (context, index) => HistoryRow(
            history: histories[index],
            index: index + 1,
            onPrint: () => _printReceipt(histories[index]),
            onEdit: () => _editSale(histories[index]),
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
              onPressed: _resetHistory,
              icon: const Icon(Icons.refresh, size: 35),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshHistory() async {
    _currentPage = 1;
    await context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
    _refreshController.refreshCompleted();
  }

  Future<void> _loadMoreHistory() async {
    _currentPage += 1;
    if (_searchController.text.isEmpty) {
      await context.read<SalesHistoryCubit>().loadMoreHistory(
        page: _currentPage, 
        requestBody: {}
      );
    }
    _refreshController.loadComplete();
  }

  void _searchHistory(String value) {
    if (value.isEmpty) {
      context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
    } else {
      context.read<SalesHistoryCubit>().searchHistory(query: value);
    }
  }

  void _resetHistory() {
    _currentPage = 1;
    _searchController.clear();
    context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
  }

  void _printReceipt(SaleHistoryModel history) {
    // Implement your print logic here
  }

  void _editSale(SaleHistoryModel history) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSaleScreen(
          saleHistory: history,
          orderNo: history.orderNo,
        ),
      ),
    );
  }

  void _showHistoryDetails(SaleHistoryModel history) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: _buildVoucherDialog(history),
      ),
    );
  }

  Widget _buildVoucherDialog(SaleHistoryModel history) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            VoucherWidget(
              cashAmount: history.paidCash,
              bankAmount: history.paidOnline,
              change: 0,
              paymentType: _getPaymentType(history),
              subTotal: history.subTotal,
              grandTotal: history.grandTotal,
              date: history.createdAt,
              orderNumber: history.orderNo,
              ahtoneLevel: AhtoneLevelModel(name: history.ahtoneLevel.name),
              spicyLevel: SpicyLevelModel(name: history.spicyLevel.name),
              cartItems: history.products
                  .map((e) => CartItem(
                        id: e.productId,
                        name: e.name,
                        price: e.price,
                        qty: e.qty,
                        totalPrice: e.totalPrice,
                        is_gram: false,
                      ))
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
    );
  }

  String _getPaymentType(SaleHistoryModel sale) {
    if (sale.paidCash > 0 && sale.paidOnline == 0) return "Cash";
    if (sale.paidCash == 0 && sale.paidOnline > 0) return "Kpay";
    return "Cash / Kpay";
  }
}

class _HistoryHeaderRow extends StatelessWidget {
  const _HistoryHeaderRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "ပြေစာနံပါတ်",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),),
        Expanded(
          child: Center(
            child: Text(
                "စားပွဲနံပါတ်",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),),
        ),
        Expanded(
          child: Text(
            "စုစုပေါင်း",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),),
        SizedBox(width: 70), // Space for action buttons
      ],
    );
  }
}

class HistoryRow extends StatelessWidget {
  final SaleHistoryModel history;
  final int index;
  final VoidCallback onPrint;
  final VoidCallback onEdit;

  const HistoryRow({
    super.key,
    required this.history,
    required this.index,
    required this.onPrint,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => _showHistoryDetails(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(history.orderNo, style: const TextStyle(fontSize: 16)),),
            Expanded(
              child: Text(history.tableNumber,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),),
            Expanded(
              child: Text(
                "${formatNumber(history.grandTotal)} MMK",
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16)),),
            SizedBox(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: onPrint,
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDetails(BuildContext context) {
    // Implement details dialog if needed
  }
}

class _HistorySkeletonList extends StatelessWidget {
  const _HistorySkeletonList();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) => Container(
          height: 30,
          margin: const EdgeInsets.only(bottom: 25),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Loading...")),
              Expanded(child: Center(child: Text("Loading..."))),
              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: Text("Loading..."))),
              SizedBox(width: 70),
            ],
          ),
        ),
      ),
    );
  }
}