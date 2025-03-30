import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';

class EditSaleCartState {
  List<CartItem> items;
  MenuModel? menu;
  SpicyLevelModel? spicyLevel;
  AhtoneLevelModel? athoneLevel;
  int octopusCount;
  int prawnCount;
  int tableNumber;
  String remark;

  EditSaleCartState({
    required this.items,
    this.menu,
    required this.spicyLevel,
    required this.athoneLevel,
    required this.octopusCount,
    required this.prawnCount,
    required this.tableNumber,
    required this.remark,
  });
}
