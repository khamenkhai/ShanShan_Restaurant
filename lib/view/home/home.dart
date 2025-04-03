import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/view/home/widget/cart_header_widget.dart';
import 'package:shan_shan/view/home/widget/category_box_widget.dart';
import 'package:shan_shan/view/home/widget/cart_item_list_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/checkout_dialog.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/menu_box_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/total_and_tax_widget.dart';
import 'package:shan_shan/view/widgets/table_number_dialog.dart';
import 'package:shan_shan/view/home/widget/home_drawer.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    _initializeData();
    _showTableNumberDialog();
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
    final screenSize = MediaQuery.of(context).size;
    final cartCubit = BlocProvider.of<CartCubit>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
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

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leadingWidth: 85,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: SizeConst.kHorizontalPadding),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: SizeConst.kBorderRadius,
            ),
            child: Center(
              child: IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu),
              ),
            ),
          ),
        ],
      ),
      actions: [
        // const DateActionWidget(),
        const SizedBox(width: SizeConst.kHorizontalPadding),
      ],
      title: const Text(
        "ရှန်းရှန်း",
        style: TextStyle(
          fontFamily: "Outfit",
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBody(Size screenSize, CartCubit cartCubit) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductsSection(screenSize),
          const SizedBox(width: SizeConst.kHorizontalPadding),
          _buildCartSection(screenSize, cartCubit),
        ],
      ),
    );
  }

  Widget _buildProductsSection(Size screenSize) {
    return Container(
      width: screenSize.width * 0.71,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return LoadingWidget();
                    } else if (state is CategoryLoadedState) {
                      return _buildCategoryList(
                        constraints,
                        state.categoryList,
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          copyRightWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    BoxConstraints constraints,
    List<CategoryModel> categories,
  ) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refresherController,
      onRefresh: _handleRefresh,
      child: Wrap(
        runSpacing: SizeConst.kHorizontalPadding,
        spacing: SizeConst.kHorizontalPadding,
        children: [
          ...categories.map(
            (category) => CategoryBoxWidget(
              constraints: constraints,
              category: category,
              defaultItem: _defaultItem,
              tableController: _tableController,
            ),
          ),
          _buildMenuBox(constraints),
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

  Widget _buildMenuBox(BoxConstraints constraints) {
    return menuBoxWidget(
      constraints: constraints,
      defaultItem: _defaultItem,
    );
  }

  Widget _buildCartSection(Size screenSize, CartCubit cartCubit) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height + 100,
            margin: EdgeInsets.only(
              right: SizeConst.kHorizontalPadding,
              bottom: 10,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: SizeConst.kBorderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 1),
                CartHeaderWidget(onClearOrder: _handleClearOrder),
                const SizedBox(height: 5),
                Expanded(child: CartItemListWidget(screenSize: screenSize, state: state)),
                TotalAndTaxHomeWidget(),
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
        );
      },
    );
  }

  void _handleClearOrder() {
    context.read<CartCubit>().clearOrderr();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          TableNumberDialog(tableController: _tableController),
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
              title: "KBZ Pay",
            ),
          ),
        ),
      ],
    );
  }

  void _handlePlaceOrder(CartCubit cartCubit, Size screenSize) {
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

    if (_shouldShowCheckoutDialog(cartCubit)) {
      showDialog(
        context: context,
        builder: (context) => CheckoutDialog(
          width: screenSize.width / 3,
          paidOnline: _paidOnline,
          paidCash: _paidCash,
        ),
      );
    } else {
      showCustomSnackbar(
        context: context,
        message: "Menu ကိုရွေးချယ်ရပါမယ်။",
      );
    }
  }

  bool _shouldShowCheckoutDialog(CartCubit cartCubit) {
    if (cartCubit.state.menu != null) return true;

    final productNames = cartCubit.state.items.map((e) => e.name).toList();
    if (productNames.contains("ငါး")) {
      cartCubit.addMenu(
        menu: MenuModel(
          is_fish: true,
          id: 3,
          name: "ငါးကင်",
        ),
      );
      return true;
    }
    return false;
  }
}
