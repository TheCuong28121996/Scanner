import 'package:mobile/prefs_util.dart';

class OrderModel {
  OrderModel(
      {this.orderItems,
      this.totalPrice,
      this.type,
      this.mail,
      this.orderNumber,
      this.placed,
      this.state,
      this.uid});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderNumber: json['order_number'],
      placed: json['placed'],
      type: json['type'],
      uid: json['uid'],
      mail: json['mail'],
      state: json['state'],
      totalPrice: json['total_price__number_1'],
      orderItems: (json['order_items'] != null)
          ? List<OrderItem>.from(
              json['order_items'].map((x) => OrderItem.fromJson(x)))
          : null,
    );
  }

  String? orderNumber;
  String? placed;
  String? type;
  String? uid;
  String? mail;
  String? state;
  String? totalPrice;
  List<OrderItem>? orderItems;
}

class OrderItem {
  OrderItem(
      {this.sku,
      required this.quantity,
      required this.currentQty,
      this.title,
      this.barcode,
      this.totalPrice,
      this.unitPrice});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        sku: json['sku'],
        barcode: json['barcode'],
        title: json['title'],
        unitPrice: json['unit_price'],
        quantity: checkDouble(json['quantity']) ?? 0,
        totalPrice: json['total_price'],
        currentQty: 0
    );
  }

  String? sku;
  String? barcode;
  String? title;
  String? unitPrice;
  double quantity;
  double currentQty;
  String? totalPrice;
}
