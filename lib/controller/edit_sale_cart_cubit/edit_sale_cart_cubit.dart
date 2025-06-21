import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';

class OrderEditCubit extends Cubit<EditSaleCartState> {
  OrderEditCubit()
      : super(
          EditSaleCartState(
              remark: "",
              items: [],
              menu: null,
              spicyLevel: null,
              athoneLevel: null,
              octopusCount: 0,
              prawnCount: 0,
              tableNumber: 0,
              dineInOrParcel: 1,
              orderNo: "",
              date: ""),
        );

  ///add menu model
  void addData({
    MenuModel? menu,
    String? remark,
    int? dineInOrParcel,
    int? tableNumber,
    List<CartItem>? items,
    SpicyLevelModel? spicyLevel,
    AhtoneLevelModel? htoneLevel,
    int? octopusCount,
    int? prawnCount,
    String? orderNo,
    String? date,
  }) {
    emit(
      EditSaleCartState(
        dineInOrParcel: dineInOrParcel ?? state.dineInOrParcel,
        remark: remark ?? state.remark,
        tableNumber: tableNumber ?? state.tableNumber,
        items: items ?? state.items,
        menu: menu ?? state.menu,
        spicyLevel: spicyLevel ?? state.spicyLevel,
        athoneLevel: htoneLevel ?? state.athoneLevel,
        octopusCount: octopusCount ?? state.octopusCount,
        prawnCount: prawnCount ?? state.prawnCount,
        orderNo: orderNo ?? state.orderNo,
        date: date ?? state.date,
      ),
    );
  }

  // Method to add an item to the cart
  void addToCartByQuantity({
    required CartItem item,
    required int quantity,
  }) async {
    List<CartItem> updatedItems = state.items;

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.name == item.name && cartItem.id == item.id) {
          cartItem.qty = quantity;
          cartItem.totalPrice = (cartItem.qty * cartItem.price);
        }
      }
      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: quantity,
            totalPrice: item.price * quantity,
          ),
        );

      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          athoneLevel: state.athoneLevel,
          spicyLevel: state.spicyLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    }
  }

  // Method to add an item to the cart
  void addToCartByGram({
    required CartItem item,
    required int gram,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    //print("gram per price : ${getPriceByGram(gram).toString()} / ${gram}");

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.id == item.id && cartItem.name == item.name) {
          cartItem.qty = gram;
          cartItem.totalPrice =
              getPriceByGram(weight: gram, priceGap: cartItem.price);
        }
      }
      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: gram,
            totalPrice: getPriceByGram(weight: gram, priceGap: item.price),
          ),
        );

      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    }
  }

  ///to change the quantity of the cart item
  void changeQuantity({
    required CartItem item,
    required int quantity,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.id == item.id && cartItem.name == item.name) {
          cartItem.qty = quantity;
          cartItem.totalPrice = (cartItem.qty * cartItem.price);
        }
      }
      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: 1,
            totalPrice: item.price,
          ),
        );

      emit(
        EditSaleCartState(
          dineInOrParcel: state.dineInOrParcel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
          orderNo: state.orderNo,
          date: state.date,
        ),
      );
    }
  }

  // Method to remove an item from the cart
  void removeFromCart({
    required CartItem item,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    updatedItems.removeWhere(
      (element) => element.id == item.id && element.name == item.name,
    );

    emit(
      EditSaleCartState(
        dineInOrParcel: state.dineInOrParcel,
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: updatedItems,
        menu: state.menu,
        spicyLevel: state.spicyLevel,
        athoneLevel: state.athoneLevel,
        octopusCount: state.octopusCount,
        prawnCount: state.prawnCount,
        orderNo: state.orderNo,
        date: state.date,
      ),
    );
  }

  // Method to remove an item from the cart
  void clearOrder() {
    emit(
      EditSaleCartState(
          dineInOrParcel: 1,
          remark: "",
          tableNumber: 0,
          items: [],
          menu: null,
          spicyLevel: null,
          athoneLevel: null,
          octopusCount: 0,
          prawnCount: 0,
          orderNo: "",
          date: state.date),
    );
  }

  ///to get total amount of cart items
  int getTotalAmount() {
    int totalAmount = 0;
    for (var element in state.items) {
      totalAmount += element.qty * element.price;
      // totalAmount += element.totalPrice;
    }

    return totalAmount;
  }

  ///to checkk if the selected product is existed in the cart
  bool checkIsProductExisted(CartItem item) {
    return state.items.any(
      (p) => p.name == item.name,
    );
  }
}

////class model to mark pending order
class PendingOrderModel {
  final String? mark;
  final DateTime? date;
  final num? orderAmount;

  PendingOrderModel({
    this.date,
    this.mark,
    this.orderAmount,
  });
}
