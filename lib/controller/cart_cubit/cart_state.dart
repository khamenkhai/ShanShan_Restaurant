// ignore_for_file: must_be_immutable
part of 'cart_cubit.dart';

@immutable
class CartState {
  List<CartItem> items;
  MenuModel? menu;
  SpicyLevelModel? spicyLevel;
  AhtoneLevelModel? athoneLevel;
  int octopusCount;
  int prawnCount;
  int tableNumber;
  String remark;
  int dineInOrParcel;

  CartState({
    required this.items,
    this.menu,
    required this.spicyLevel,
    required this.athoneLevel,
    required this.octopusCount,
    required this.prawnCount,
    required this.tableNumber,
    required this.remark,
    required this.dineInOrParcel,
  });
}
