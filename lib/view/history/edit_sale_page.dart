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
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/style/app_text_style.dart';
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
import 'package:shan_shan/view/update_sale_ui/edit_checkout_dialog.dart';

import 'package:shan_shan/view/widgets/home_page_widgets/menu_box_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/total_and_tax_widget.dart';
import 'package:shan_shan/view/home/widget/home_drawer.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';
import 'package:shan_shan/view/widgets/table_number_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditSalePage extends StatefulWidget {
  const EditSalePage({
    super.key,
    required this.orderNo,
    required this.saleHistory,
  });

  final String orderNo;
  final SaleHistoryModel saleHistory;

  @override
  State<EditSalePage> createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
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

    context.read<MenuCubit>().getMenu();
    context.read<SpicyLevelCubit>().getAllLevels();
    context.read<HtoneLevelCubit>().getAllLevels();

    context.read<EditSaleCartCubit>().addData(
          menu: widget.saleHistory.menu,
          orderNo: widget.saleHistory.orderNo,
          dineInOrParcel: widget.saleHistory.dineInOrParcel,
          octopusCount: widget.saleHistory.octopusCount,
          prawnCount: widget.saleHistory.prawnCount,
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
    final cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    return Scaffold(
      key: _scaffoldKey,
      // appBar: _buildAppBar(),
      drawer: HomeDrawer(
        onNavigate: () => setState(() => _defaultItem = null),
      ),
      body: InternetCheckWidget(
        onRefresh: _refreshData,
        child: _buildBody(screenSize, cartCubit),
      ),
    );
  }

  Future<void> _refreshData() async {
    context.read<MenuCubit>().getMenu();
    context.read<ProductsCubit>().getAllProducts();
    context.read<CategoryCubit>().getAllCategories();
  }

  Widget _buildBody(Size screenSize, EditSaleCartCubit cartCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductsSection(screenSize),
        const SizedBox(width: SizeConst.kHorizontalPadding),
        _buildCartSection(screenSize, cartCubit),
      ],
    );
  }

  Widget _buildProductsSection(Size screenSize) {
    return Container(
      width: screenSize.width * 0.675,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: SizeConst.kHorizontalPadding),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  /// home drawer
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: SizeConst.kBorderRadius,
                    ),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(IconlyBold.arrow_left_2)),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Order No. ${widget.orderNo}",
                    style: AppTextStyles.kSubTitle(),
                  ),
                  Spacer(),
                  DateActionWidget()
                ],
              ),
            ),
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
            Align(
              alignment: Alignment.bottomCenter,
              // child: copyRightWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    BoxConstraints constraints,
    List<CategoryModel> categories,
  ) {
    return Wrap(
      runSpacing: SizeConst.kHorizontalPadding,
      spacing: SizeConst.kHorizontalPadding,
      children: [
        MenuBoxWidget(
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

  Widget _buildCartSection(Size screenSize, EditSaleCartCubit cartCubit) {
    return BlocBuilder<EditSaleCartCubit, EditSaleCartState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: SizeConst.kBorderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 1),
                CartHeaderWidget(onClearOrder: _handleClearOrder),
                const SizedBox(height: 5),
                Expanded(
                  child: EditCartListWidget(
                    screenSize: screenSize,
                    state: state,
                  ),
                ),
                TotalAndTaxHomeWidget(),
                const SizedBox(height: 15),
                _buildPaymentOptions(),
                const SizedBox(height: 15),
                CustomElevatedButton(
                  width: double.infinity,
                  onPressed: () {
                    _handlePlaceOrder(cartCubit, screenSize);
                  },
                  child: Text("Edit Sale"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleClearOrder() {
    context.read<EditSaleCartCubit>().clearOrder();
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
              title: "Cash",
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _paidOnline = !_paidOnline),
            child: PaymentButton(
              isSelected: _paidOnline,
              title: "Online Pay",
            ),
          ),
        ),
      ],
    );
  }

  void _handlePlaceOrder(EditSaleCartCubit cartCubit, Size screenSize) {
    if (cartCubit.state.items.isEmpty) {
      showCustomSnackbar(
        message: "ပစ္စည်းများ ထည့်မထားပါ။",
        context: context,
      );
      return;
    }

    if (!_paidCash && !_paidOnline) {
      showCustomSnackbar(
        message: "ငွေပေးချေမှုနည်းလမ်းကို ရွေးချယ်ရပါမည်",
        context: context,
      );
      return;
    }

    if (cartCubit.state.menu != null) {
      showDialog(
        context: context,
        builder: (context) => CheckoutDialogEdit(
          orderId: widget.saleHistory.id,
          paidCash: _paidCash,
          paidOnline: _paidOnline,
          width: screenSize.width / 3,
        ),
      );
    } else {
      showCustomSnackbar(
        context: context,
        message: "Menu required!",
      );
    }
  }
}
