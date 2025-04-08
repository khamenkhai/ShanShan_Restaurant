import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/models/response_models/sale_history_model.dart';
import 'package:shan_shan/view/update_sale_ui/edit_sale_checkkout_dialog.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/product_row_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/quantity_dialog_control.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/taste_level_dialog.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/weight_dialog_control.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class EditSaleScreen extends StatefulWidget {
  const EditSaleScreen({
    super.key,
    required this.orderNo,
    required this.saleHistory,
  });

  final String orderNo;
  final SaleHistoryModel saleHistory;

  @override
  State<EditSaleScreen> createState() => _EditSaleScreenState();
}

class _EditSaleScreenState extends State<EditSaleScreen> {
  final TextEditingController _pendingOrderController = TextEditingController();
  ScrollController scrollController = ScrollController();

  ScrollController categoryScrollController = ScrollController();

  ///bar code
  late bool visible;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///payment type
  bool onlinePayment = false;
  bool paidCash = true;

  bool isParcel = false;

  FocusNode searchFocusNode = FocusNode();

  CartItem? defaultItem;

  TextEditingController tableController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {});
    });

    context.read<MenuCubit>().getMenu();
    context.read<SpicyLevelCubit>().getAllLevels();
    context.read<HtoneLevelCubit>().getAllLevels();

    context.read<EditSaleCartCubit>().addAllData(
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
          tableNumber: int.parse(widget.saleHistory.tableNumber),
          remark: widget.saleHistory.remark,
          spicyLevel: widget.saleHistory.spicyLevel,
          athoneLevel: AhtoneLevelModel(
            id: widget.saleHistory.ahtoneLevel.id,
            name: widget.saleHistory.ahtoneLevel.name,
          ),
        );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _pendingOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    var screenSize = MediaQuery.of(context).size;

    if (cartCubit.state.tableNumber == 0) {}

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leadingWidth: 160,
          leading: appBarLeading(
            onTap: () {
              context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
              Navigator.pop(context);
            },
          ),
          title: Text(
            "အော်ဒါ ${widget.orderNo} ကိုပြန်ပြင်ရန်",
            style: TextStyle(
              fontFamily: "",
            ),
          ),
        ),
        body: InternetCheckWidget(
          child: _form(screenSize: screenSize, cartCubit: cartCubit),
          onRefresh: () {
            context.read<ProductsCubit>().getAllProducts();
            context.read<CategoryCubit>().getAllCategories();
          },
        ),
      ),
    );
  }

  ///main form of the home screen
  Row _form({required Size screenSize, required EditSaleCartCubit cartCubit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /**
         * left side of the screen
         */
        _productsAndCategoriesForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),

        /**
         * right side of the screen
         */
        _receiveForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),
      ],
    );
  }

  // ignore: unused_element
  SizedBox _searchBox() {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: SizeConst.kBorderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: SizeConst.kBorderRadius,
            borderSide:
                BorderSide(width: 1.5, color: ColorConstants.primaryColor),
          ),
          hintText: "Search...",
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  ///receive form (show cart items with payment buttons) right part of the home sreen
  Widget _receiveForm({
    required Size screenSize,
    required EditSaleCartCubit cartCubit,
  }) {
    return BlocBuilder<EditSaleCartCubit, EditSaleCartState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height + 100,
            margin: EdgeInsets.only(
              right: SizeConst.kHorizontalPadding,
              top: 5,
              bottom: 10,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: SizeConst.kBorderRadius,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(IconlyLight.bookmark),
                        SizedBox(width: 10),
                        Text(
                          "မှာယူမှု",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryColor,
                            fontSize: 20 - 3,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context.read<EditSaleCartCubit>().clearOrderr();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: SizeConst.kBorderRadius,
                              border: Border.all(
                                width: 0.5,
                                color: ColorConstants.primaryColor,
                              ),
                              color: Colors.white,
                            ),
                            child: Text(
                              "မှာယူမှုကို ပယ်ဖျက်ရန်",
                              //"Clear Order",
                              style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 14 - 4,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                  ///cart item list widget
                  _cartItemListWidget(
                    screenSize: screenSize,
                    state: state,
                    context: context,
                  ),

                  ///total price,tax and grand total widgt
                  _totalAndTaxWidget(cartCubit: cartCubit),
                  SizedBox(height: 25),

                  ///payment buttons widget
                  _paymentButtonsWidget(),

                  //place order
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: SizeConst.kBorderRadius,
                          ),
                        ),
                        onPressed: () {
                          showEditCheckoutDialog(
                              cartCubit, context, screenSize);
                        },
                        child: Text("အော်ဒါပြန်တင်ရန်"),
                        //child: Text("Place Order"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showEditCheckoutDialog(
    EditSaleCartCubit cartCubit,
    BuildContext context,
    Size screenSize,
  ) {
    if (cartCubit.state.items.isNotEmpty) {
      if (paidCash == false && onlinePayment == false) {
        showCustomSnackbar(
          message: "ငွေပေးချေမှုနည်းလမ်းကို ရွေးချယ်ရပါမည်",
          context: context,
        );
      } else {
        List<String> productNameList = [];
        for (var element in cartCubit.state.items) {
          productNameList.add(element.name);
        }

        if (cartCubit.state.menu != null) {
          showDialog(
            context: context,
            builder: (context) {
              return EditSaleCheckoutDialog(
                dineInOrParcel: widget.saleHistory.dineInOrParcel,
                date: widget.saleHistory.createdAt.toString(),
                octopusCount: widget.saleHistory.octopusCount,
                prawnCount: widget.saleHistory.prawnCount,
                orderNo: widget.orderNo,
                width: screenSize.width / 3,
                onlinePayment: onlinePayment,
                paidCash: paidCash,
              );
            },
          );
        } else {
          if (productNameList.contains("ငါး")) {
            cartCubit.addMenu(
              menu: MenuModel(
                isFish: true,
                id: 3,
                name: "ငါးကင်",
              ),
            );
            showDialog(
              context: context,
              builder: (context) {
                return EditSaleCheckoutDialog(
                  dineInOrParcel: widget.saleHistory.dineInOrParcel,
                  date: widget.saleHistory.createdAt.toString(),
                  octopusCount: widget.saleHistory.octopusCount,
                  prawnCount: widget.saleHistory.prawnCount,
                  orderNo: widget.orderNo,
                  width: screenSize.width / 3,
                  onlinePayment: onlinePayment,
                  paidCash: paidCash,
                );
              },
            );
          } else {
            showCustomSnackbar(
              context: context,
              message: "Menu ကိုရွေးချယ်ရပါမယ်။",
            );
          }
        }
      }
    } else {
      showCustomSnackbar(
        message: "ပစ္စည်းများ ထည့်မထားပါ။",
        context: context,
      );
    }
  }

  ///payment buttons widget
  Container _paymentButtonsWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  paidCash = !paidCash;
                });
              },
              child: PaymentButton(
                isSelected: paidCash,
                title: "Cash",
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  onlinePayment = !onlinePayment;
                });
              },
              child: PaymentButton(
                isSelected: onlinePayment,
                title: "Online Pay",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// cart item list widget
  SizedBox _cartItemListWidget({
    required Size screenSize,
    required EditSaleCartState state,
    required BuildContext context,
  }) {
    return SizedBox(
      height: screenSize.height * 0.48,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: SizeConst.kHorizontalPadding),
              child: Text("စားပွဲနံပါတ် : ${state.tableNumber}"),
            ),
            state.menu == null
                ? Container()
                : CartMenuWidget(
                    tapDisabled: false,
                    menu: state.menu!,
                    spicyLevel: state.spicyLevel,
                    athoneLevel: state.athoneLevel,
                    onDelete: () {
                      context.read<EditSaleCartCubit>().removeMenu();
                    },
                    onEdit: () {},
                  ),
            ...state.items.map(
              (e) => CartItemWidget(
                ontapDisable: false,
                cartItem: e,
                onEdit: () {
                  ///show cart item quantity control
                  if (e.isGram) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CartItemWeightControlDialog(
                          screenSizeWidth: screenSize.width,
                          weightGram: e.qty,
                          cartItem: e,
                          isEditState: true,
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CartItemQtyDialogControl(
                          screenSizeWidth: screenSize.width,
                          quantity: e.qty,
                          cartItem: e,
                          isEditState: true,
                        );
                      },
                    );
                  }
                },
                onDelete: () {
                  context.read<EditSaleCartCubit>().removeFromCart(item: e);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///widget that shows total and tax
  Widget _totalAndTaxWidget({required EditSaleCartCubit cartCubit}) {
    num grandTotal =
        get5percentage(cartCubit.getTotalAmount()) + cartCubit.getTotalAmount();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15, top: 5),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: ColorConstants.greyColor,
            ),
          ),

          SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Subtotal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${NumberFormat('#,##0').format(cartCubit.getTotalAmount())} MMK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),

          ///tax
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Tax",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${formatNumber(get5percentage(cartCubit.getTotalAmount()))}(5%)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),

          ///grand total
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Grand Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${NumberFormat('#,##0').format(grandTotal)} MMK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///widgets that show products and menu items
  Widget _productsAndCategoriesForm({
    required Size screenSize,
    required EditSaleCartCubit cartCubit,
  }) {
    double maxWidth = screenSize.width * 0.71;
    return Container(
      width: maxWidth,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: SizeConst.kHorizontalPadding, top: 6),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return LoadingWidget();
          } else if (state is CategoryLoadedState) {
            return SingleChildScrollView(
              child: Wrap(
                runSpacing: SizeConst.kHorizontalPadding,
                spacing: SizeConst.kHorizontalPadding,
                alignment: WrapAlignment.start,
                children: [
                  ///categories box row
                  ...state.categoryList.map(
                    (e) => _categoryBoxWidget(
                      maxWidth: maxWidth,
                      category: e,
                    ),
                  ),

                  ///menu list
                  _menuBoxWidget(
                    maxWidth: maxWidth,
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  ///category box widget
  Widget _categoryBoxWidget({
    required double maxWidth,
    required CategoryModel category,
  }) {
    return Material(
      borderRadius: SizeConst.kBorderRadius,
      color: Colors.white,
      child: Container(
        width: (maxWidth / 2) - (SizeConst.kHorizontalPadding),
        height: 500,
        decoration: BoxDecoration(
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: Center(
                child: Text(
                  "${category.name}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(
                height: 0,
                thickness: 1,
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoadingState) {
                    return LoadingWidget();
                  } else if (state is ProductsLoadedState) {
                    try {
                      ProductModel? defaultProduct = state.products
                          .where((element) => element.isDefault == true)
                          .first;

                      // ignore: unnecessary_null_comparison
                      if (defaultProduct != null) {
                        defaultItem = CartItem(
                          id: defaultProduct.id!,
                          name: defaultProduct.name.toString(),
                          price: defaultProduct.price ?? 0,
                          qty: 1,
                          totalPrice: defaultProduct.price ?? 0,
                          isGram: defaultProduct.isGram ?? false,
                        );
                      }
                    } catch (e) {
                      customPrint("error : ${e}");
                    }

                    List<ProductModel> productList = state.products
                        .where((element) =>
                            element.category == category.name &&
                            element.isGram == false)
                        .toList();

                    return _productListScrollBar(
                        productList: productList,
                        context: context,
                        tableController: tableController,
                        scrollController: scrollController,
                        isEditState: true);
                  } else {
                    return Text("hello world");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///menu box widget
  Widget _menuBoxWidget({
    required double maxWidth,
  }) {
    return Material(
      borderRadius: SizeConst.kBorderRadius,
      color: Colors.white,
      child: Container(
        width: (maxWidth / 2) - (SizeConst.kHorizontalPadding),
        height: 500,
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: Center(
                child: Text(
                  "မီနူး",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(
                height: 0,
                thickness: 1,
              ),
            ),
            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuLoadingState) {
                    return LoadingWidget();
                  } else if (state is MenuLoadedState) {
                    List<MenuModel> menuList = state.menuList;

                    return Padding(
                      padding: const EdgeInsets.only(right: 0, bottom: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: menuList
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.only(bottom: 100),
                                  child: _menuRowWidget(
                                    menu: e,
                                    context: context,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///product row widget
  Widget _menuRowWidget({
    required MenuModel menu,
    required BuildContext context,
  }) {
    return InkWell(
      // ignore: deprecated_member_use
      highlightColor: ColorConstants.primaryColor.withOpacity(0.3),
      onTap: () async {
        if (menu.isFish == true) {
          context.read<EditSaleCartCubit>().addMenu(menu: menu);

          context.read<EditSaleCartCubit>().addSpicy(
                athoneLevel: null,
                spicyLevel: null,
              );

          if (defaultItem != null) {
            context.read<EditSaleCartCubit>().addToCartByQuantity(
                  item: defaultItem!,
                  quantity: 1,
                );
          }
        } else {
          await showDialog(
            context: context,
            builder: (context) {
              return TasteChooseDialog();
            },
          ).then(
            (value) {
              if (value != null) {
                if (!context.mounted) return;
                context.read<EditSaleCartCubit>().addMenu(menu: menu);
                context.read<EditSaleCartCubit>().addSpicy(
                      athoneLevel: value["athoneLevel"],
                      spicyLevel: value["spicyLevel"],
                    );

                context.read<EditSaleCartCubit>().addToCartByQuantity(
                      item: defaultItem!,
                      quantity: 1,
                    );
              }
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${menu.name}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///product list widget (display with scrollbar)
  Widget _productListScrollBar({
    required List<ProductModel> productList,
    required ScrollController scrollController,
    required TextEditingController tableController,
    required BuildContext context,
    required bool isEditState,
  }) {
    return Container(
      padding: EdgeInsets.only(right: 0, bottom: 10),
      child: Scrollbar(
        //thumbVisibility: true,
        thickness: 4,
        controller: scrollController,
        radius: Radius.circular(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: productList
                .map(
                  (e) => productRowWidget(
                    product: e,
                    context: context,
                    tableController: tableController,
                    isEditState: isEditState,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
