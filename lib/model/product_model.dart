class ProductModel {
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        title: json['title'],
        type: json['type'],
        status: json['status'],
        changed: json['changed'],
        barCode: json['field_barcode'],
        body: json['body'],
        brand: json['field_brand'],
        productCategories: json['field_product_categories'],
        priceNumber: json['price__number'],
        priceCurrencyCode: json['price__currency_code'],
        sku: json['sku'],
        qty: 1);
  }

  ProductModel(
      {this.title,
      this.type,
      this.status,
      this.changed,
      this.barCode,
      this.body,
      this.brand,
      this.priceCurrencyCode,
      this.priceNumber,
      this.productCategories,
      this.sku,
      required this.qty});

  String? title;
  String? type;
  String? status;
  String? changed;
  String? barCode;
  String? body;
  String? brand;
  String? productCategories;
  String? priceNumber;
  String? priceCurrencyCode;
  String? sku;
  int qty;

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'status': status,
        'changed': changed,
        'field_barcode': barCode,
        'body': body,
        'field_brand': brand,
        'field_product_categories': productCategories,
        'price__number': priceNumber,
        'price__currency_code': priceCurrencyCode,
        'sku': sku,
      };
}
