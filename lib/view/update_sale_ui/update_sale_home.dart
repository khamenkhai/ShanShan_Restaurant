import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/scale_on_tap.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
import 'package:shan_shan/models/response_models/sale_history_model.dart';
import 'package:shan_shan/view/home/widget/cart_header_widget.dart';
import 'package:shan_shan/view/home/widget/category_box_widget.dart';
import 'package:shan_shan/view/home/widget/cart_list_widget.dart';
import 'package:shan_shan/view/home/widget/date_action_widget.dart';
import 'package:shan_shan/view/update_sale_ui/edit_sale_checkout_dialog.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/menu_box_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/taste_box_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/total_and_tax_widget.dart';
import 'package:shan_shan/view/home/widget/home_drawer.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';
import 'package:shan_shan/view/widgets/table_number_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditOrderScreen extends StatefulWidget {
  const EditOrderScreen({super.key, required this.saleHistory});
  final SaleHistoryModel saleHistory;

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  // Controllers
  final TextEditingController _pendingOrderController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refresherController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State variables
  CartItem? _defaultItem;
  bool _paidOnline = false;
  bool _paidCash = true;
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _initializeData();

    context.read<MenuCubit>().getMenu();
    context.read<SpicyLevelCubit>().getAllLevels();
    context.read<HtoneLevelCubit>().getAllLevels();

    context.read<OrderEditCubit>().addData(
          menu: widget.saleHistory.menu,
          items: widget.saleHistory.products
              .map(
                (e) => CartItem(
                  id: e.productId,
                  name: e.name,
                  price: e.price,
                  qty: e.qty,
                  totalPrice: e.totalPrice,
                  isGram: e.isGram,
                ),
              )
              .toList(),
          orderNo: widget.saleHistory.orderNo,
          date: widget.saleHistory.createdAt,
          dineInOrParcel: widget.saleHistory.dineInOrParcel,
          octopusCount: widget.saleHistory.octopusCount,
          prawnCount: widget.saleHistory.prawnCount,
          tableNumber: int.parse(widget.saleHistory.tableNumber),
          remark: widget.saleHistory.remark,
          spicyLevel: widget.saleHistory.spicyLevel,
          htoneLevel: AhtoneLevelModel(
            id: widget.saleHistory.ahtoneLevel.id,
            name: widget.saleHistory.ahtoneLevel.name,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pendingOrderController.dispose();
    _tableController.dispose();
    _refresherController.dispose();
    super.dispose();
  }

  void _initializeData() {
    context.read<MenuCubit>().getMenu();
    context.read<SpicyLevelCubit>().getAllLevels();
    context.read<HtoneLevelCubit>().getAllLevels();
    context.read<ProductsCubit>().getAllProducts();
    context.read<CategoryCubit>().getAllCategories();
  }

  // ignore: unused_element
  void _showTableNumberDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: _scaffoldKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => TableNumberDialog(
          tableController: _tableController,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.grey.shade400,
    ));

    final screenSize = MediaQuery.of(context).size;
    final cartCubit = BlocProvider.of<OrderEditCubit>(context);

    return WillPopScope(
      onWillPop: () async {
        context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          onNavigate: () => setState(() => _defaultItem = null),
        ),
        body: SafeArea(
          child: InternetCheckWidget(
            onRefresh: _refreshData,
            child: _buildBody(screenSize, cartCubit),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    context.read<MenuCubit>().getMenu();
    context.read<ProductsCubit>().getAllProducts();
    context.read<CategoryCubit>().getAllCategories();
  }

  Widget _buildBody(Size screenSize, OrderEditCubit cartCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductsSection(screenSize),
        const SizedBox(width: SizeConst.kGlobalPadding),
        _buildCartSection(screenSize, cartCubit),
      ],
    );
  }

  Widget _buildProductsSection(Size screenSize) {
    return Container(
      width: screenSize.width * 0.64,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(
        left: SizeConst.kGlobalPadding,
        top: SizeConst.kGlobalMargin,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// home drawer
                ScaleOnTap(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: SizeConst.kBorderRadius,
                    ),
                    child: Center(
                      child: const Icon(IconlyBold.arrow_left_circle),
                    ),
                  ),
                ),
                const SizedBox(width: SizeConst.kGlobalPadding),
                Text(
                  "Order No : ${widget.saleHistory.orderNo}",
                  style: context.subTitle(),
                ),

                Spacer(),
                DateActionWidget()
              ],
            ),

            ///
            const SizedBox(height: SizeConst.kVerticalSpacing),

            ///
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SmartRefresher(
                    enablePullDown: true,
                    controller: _refresherController,
                    onRefresh: _handleRefresh,
                    child: BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        return Skeletonizer(
                          enabled: state is CategoryLoadingState,
                          child: _buildCategoryList(
                            constraints,
                            state is CategoryLoadedState
                                ? state.categoryList
                                : [],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    BoxConstraints constraints,
    List<CategoryModel> categories,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConst.kVerticalSpacing),
      child: Wrap(
        runSpacing: SizeConst.kGlobalPadding,
        spacing: SizeConst.kGlobalPadding,
        children: [
          MenuBoxWidget(
            constraints: constraints,
            defaultItem: _defaultItem,
            isEditState: true,
          ),
          TasteBoxWidget(
            constraints: constraints,
            defaultItem: _defaultItem,
            isEditState: true,
          ),
          ...categories.map(
            (category) => CategoryBoxWidget(
              constraints: constraints,
              category: category,
              defaultItem: _defaultItem,
              tableController: _tableController,
              isEditState: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    context.read<MenuCubit>().getMenu();
    context.read<CategoryCubit>().getAllCategories();
    context.read<ProductsCubit>().getAllProducts();
    context.read<SpicyLevelCubit>().getAllLevels();
    context.read<HtoneLevelCubit>().getAllLevels();
    _refresherController.refreshCompleted();
    setState(() {});
  }

  Widget _buildCartSection(Size screenSize, OrderEditCubit cartCubit) {
    return BlocBuilder<OrderEditCubit, EditSaleCartState>(
      builder: (context, state) {
        return Expanded(
          child: Card(
            margin: EdgeInsets.only(
              top: SizeConst.kGlobalMargin,
              right: SizeConst.kGlobalMargin,
              bottom: SizeConst.kGlobalMargin,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(
                vertical: SizeConst.kGlobalPadding,
                horizontal: SizeConst.kGlobalPadding * 1.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: SizeConst.kBorderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartHeaderWidget(onClearOrder: _handleClearOrder),
                  const SizedBox(height: 5),
                  Expanded(
                    child: EditCartListWidget(
                      screenSize: screenSize,
                      state: state,
                    ),
                  ),
                  TotalAndTaxHomeWidget(isEditState: true),
                  const SizedBox(height: 15),
                  _buildPaymentOptions(),
                  const SizedBox(height: 15),
                  CustomElevatedButton(
                    width: double.infinity,
                    onPressed: () {
                      _handlePlaceOrder(cartCubit, screenSize);
                    },
                    child: Text("Order"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleClearOrder() {
    context.read<OrderEditCubit>().clearOrder();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TableNumberDialog(
        tableController: _tableController,
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _paidCash = !_paidCash),
            child: PaymentButton(
              isSelected: _paidCash,
              title: tr(LocaleKeys.cash),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _paidOnline = !_paidOnline),
            child: PaymentButton(
              isSelected: _paidOnline,
              title: tr(LocaleKeys.onlinePay),
            ),
          ),
        ),
      ],
    );
  }

  void _handlePlaceOrder(OrderEditCubit cartCubit, Size screenSize) {
    if (cartCubit.state.items.isEmpty) {
      showCustomSnackbar(
        message: "ပစ္စည်းများ ထည့်မထားပါ။",
      );
      return;
    }

    if (!_paidCash && !_paidOnline) {
      showCustomSnackbar(
        message: "ငွေပေးချေမှုနည်းလမ်းကို ရွေးချယ်ရပါမည်",
      );
      return;
    }

    if (cartCubit.state.menu != null) {
      showDialog(
        context: context,
        builder: (context) => EditSaleCheckoutDialog(
          width: screenSize.width / 3,
          paidOnline: _paidOnline,
          paidCash: _paidCash,
        ),
      );
    } else {
      showCustomSnackbar(
        message: "Menu ကိုရွေးချယ်ရပါမယ်။",
      );
    }
  }
}
