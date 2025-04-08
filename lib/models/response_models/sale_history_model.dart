import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';

class SaleHistoryModel {
  final int id;
  final String orderNo;
  final String tableNumber;
  final int dineInOrParcel;
  final int subTotal;
  final int tax;
  final int discount;
  final int grandTotal;
  final int paidCash;
  final int paidOnline;
  final String createdAt;
  final String updatedAt;
  final MenuModel menu;
  final SpicyLevelModel spicyLevel;
  final AhtoneLevel ahtoneLevel;
  final String remark;
  final List<SaleProduct> products;
  final int octopusCount;
  final int prawnCount;

  SaleHistoryModel({
    required this.id,
    required this.orderNo,
    required this.tableNumber,
    required this.dineInOrParcel,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.grandTotal,
    required this.paidCash,
    required this.paidOnline,
    required this.createdAt,
    required this.updatedAt,
    required this.menu,
    required this.spicyLevel,
    required this.ahtoneLevel,
    required this.remark,
    required this.products,
    required this.octopusCount,
    required this.prawnCount,
  });

  factory SaleHistoryModel.fromMap(Map<String, dynamic> map) {
    return SaleHistoryModel(
      id: map['id'] ?? 0,
      orderNo: map['order_no'] ?? '',
      // paymentTypeId: map['payment_type_id'],
      tableNumber: map['table_number'] ?? '',
      dineInOrParcel: map['dine_in_or_percel'] ?? 0,
      subTotal: map['sub_total'] ?? 0,
      tax: map['tax'] ?? 0,
      discount: map['discount'] ?? 0,
      grandTotal: map['grand_total'] ?? 0,
      paidCash: map['paid_cash'] ?? 0,
      paidOnline: map['paid_online'] ?? 0,
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      menu: MenuModel.fromMap(map['menu']),
      spicyLevel: SpicyLevelModel.fromMap(map['spicy_level']),
      ahtoneLevel: AhtoneLevel.fromMap(map['ahtone_level']),
      remark: map['remark'] ?? '',
      octopusCount: map["octopus_count"] ?? 0,
      prawnCount: map["pawn_count"] ?? 0,
      products: List<SaleProduct>.from(
        map['products']?.map((x) => SaleProduct.fromMap(x)) ?? [],
      ),
    );
  }
}

class AhtoneLevel {
  final int id;
  final String name;

  AhtoneLevel({
    required this.id,
    required this.name,
  });

  factory AhtoneLevel.fromMap(Map<String, dynamic> map) {
    return AhtoneLevel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class SaleProduct {
  final int productId;
  final String name;
  final int qty;
  final bool isGram;
  final int price;
  final int totalPrice;

  SaleProduct({
    required this.productId,
    required this.name,
    required this.qty,
    required this.isGram,
    required this.price,
    required this.totalPrice,
  });

  factory SaleProduct.fromMap(Map<String, dynamic> map) {
    return SaleProduct(
      productId: map['product_id'] ?? 0,
      name: map['name'] ?? '',
      qty: map['qty'] ?? 0,
      isGram: map['is_gram'],
      price: map['price'] ?? 0,
      totalPrice: map['total_price'] ?? 0,
    );
  }
}
