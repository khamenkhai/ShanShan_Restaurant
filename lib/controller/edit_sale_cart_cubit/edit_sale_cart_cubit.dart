import 'package:bloc/bloc.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';

class EditSaleCartCubit extends Cubit<EditSaleCartState> {
  EditSaleCartCubit()
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
          ),
        );

  ///add menu model
  void addAllData({
    required MenuModel menu,
    required List<CartItem> items,
    required int tableNumber,
    required String remark,
    required SpicyLevelModel spicyLevel,
    required AhtoneLevelModel athoneLevel,
  }) {
    emit(
      EditSaleCartState(
        remark: remark,
        tableNumber: tableNumber,
        items: items,
        menu: menu,
        spicyLevel: spicyLevel,
        athoneLevel: athoneLevel,
        octopusCount: 0,
        prawnCount: 0,
      ),
    );
  }

  ///add menu model
  void addMenu({required MenuModel menu}) {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: state.items,
        menu: menu,
        spicyLevel: state.spicyLevel,
        athoneLevel: state.athoneLevel,
        octopusCount: state.octopusCount,
        prawnCount: state.prawnCount,
      ),
    );
  }

  void addAdditionalData({
    required int octopusCount,
    required int prawnCount,
    required int tableNumber,
  }) {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: tableNumber,
        items: state.items,
        menu: state.menu,
        spicyLevel: state.spicyLevel,
        athoneLevel: state.athoneLevel,
        octopusCount: octopusCount,
        prawnCount: prawnCount,
      ),
    );
  }

  ///add menu model
  void addSpicy({
    required SpicyLevelModel? spicyLevel,
    required AhtoneLevelModel? athoneLevel,
  }) {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: state.items,
        menu: state.menu,
        spicyLevel: spicyLevel,
        athoneLevel: athoneLevel,
        octopusCount: state.octopusCount,
        prawnCount: state.prawnCount,
      ),
    );
  }

  ///add menu model
  void removeMenu() {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: state.items,
        menu: null,
        spicyLevel: null,
        athoneLevel: null,
        octopusCount: state.octopusCount,
        prawnCount: state.prawnCount,
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
            remark: state.remark,
            tableNumber: state.tableNumber,
            items: updatedItems,
            menu: state.menu,
            spicyLevel: state.spicyLevel,
            athoneLevel: state.athoneLevel,
            octopusCount: state.octopusCount,
            prawnCount: state.prawnCount),
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
            remark: state.remark,
            tableNumber: state.tableNumber,
            items: updatedItems,
            menu: state.menu,
            athoneLevel: state.athoneLevel,
            spicyLevel: state.spicyLevel,
            octopusCount: state.octopusCount,
            prawnCount: state.prawnCount),
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
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
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
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          menu: state.menu,
          spicyLevel: state.spicyLevel,
          athoneLevel: state.athoneLevel,
          octopusCount: state.octopusCount,
          prawnCount: state.prawnCount,
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
            remark: state.remark,
            tableNumber: state.tableNumber,
            items: updatedItems,
            menu: state.menu,
            spicyLevel: state.spicyLevel,
            athoneLevel: state.athoneLevel,
            octopusCount: state.octopusCount,
            prawnCount: state.prawnCount),
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
            remark: state.remark,
            tableNumber: state.tableNumber,
            items: updatedItems,
            menu: state.menu,
            spicyLevel: state.spicyLevel,
            athoneLevel: state.athoneLevel,
            octopusCount: state.octopusCount,
            prawnCount: state.prawnCount),
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
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: updatedItems,
        menu: state.menu,
        spicyLevel: state.spicyLevel,
        athoneLevel: state.athoneLevel,
        octopusCount: state.octopusCount,
        prawnCount: state.prawnCount,
      ),
    );
  }

  // Method to remove an item from the cart
  void clearOrderr() {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: [],
        menu: null,
        spicyLevel: null,
        athoneLevel: null,
        octopusCount: 0,
        prawnCount: 0,
      ),
    );
  }

  ///to get total amount of cart items
  int getTotalAmount() {
    int totalAmount = 0;
    state.items.forEach((element) {
      //totalAmount += element.qty * num.parse(element.price);
      totalAmount += element.totalPrice;
    });

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
