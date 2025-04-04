part of 'cart_cubit.dart';

@immutable
class CartState {
  final List<CartItem> items;
  final MenuModel? menu;
  final SpicyLevelModel? spicyLevel;
  final AhtoneLevelModel? athoneLevel;
  final int octopusCount;
  final int prawnCount;
  final int tableNumber;
  final String remark;
  final int dineInOrParcel;

  const CartState({
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

  CartState copyWith({
    List<CartItem>? items,
    MenuModel? menu,
    SpicyLevelModel? spicyLevel,
    AhtoneLevelModel? athoneLevel,
    int? octopusCount,
    int? prawnCount,
    int? tableNumber,
    String? remark,
    int? dineInOrParcel,
  }) {
    return CartState(
      items: items ?? this.items,
      menu: menu ?? this.menu,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      athoneLevel: athoneLevel ?? this.athoneLevel,
      octopusCount: octopusCount ?? this.octopusCount,
      prawnCount: prawnCount ?? this.prawnCount,
      tableNumber: tableNumber ?? this.tableNumber,
      remark: remark ?? this.remark,
      dineInOrParcel: dineInOrParcel ?? this.dineInOrParcel,
    );
  }
}
