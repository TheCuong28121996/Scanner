import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/model/product_model.dart';

import '../base/base_bottom_sheet.dart';
import 'button_submit_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductBottomSheet {
  AddProductBottomSheet._internal();

  static final AddProductBottomSheet _instance =
      AddProductBottomSheet._internal();

  factory AddProductBottomSheet() {
    return _instance;
  }

  final TextEditingController _nameProductController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _focusNodeNameProduct = FocusNode();
  final FocusNode _focusNodeBarcode = FocusNode();
  final FocusNode _focusNodeSKU = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();

  void show({required BuildContext context, required Function(ProductModel) onBack, String? barCode}) {
    if(barCode != null && barCode.isNotEmpty){
      _barCodeController.text = barCode;
    }

    BaseBottomSheet().show(
        context: context,
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerWidget(context: context, title: 'Thêm sản phẩm'),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            const SizedBox(height: 16),
            _itemInput(
                hintText: 'Nhập tên sản phẩm',
                controller: _nameProductController,
                focusNode: _focusNodeNameProduct,
                autoFocus: false,
                onSubmit: (value) {
                  _focusNodeNameProduct.unfocus();
                  _focusNodeBarcode.requestFocus();
                }),
            _itemInput(
                hintText: 'Nhập Barcode',
                controller: _barCodeController,
                focusNode: _focusNodeBarcode,
                autoFocus: false,
                onSubmit: (value) {
                  _focusNodeBarcode.unfocus();
                  _focusNodeSKU.requestFocus();
                }),
            _itemInput(
                hintText: 'Nhập SKU',
                controller: _skuController,
                focusNode: _focusNodeSKU,
                autoFocus: false,
                onSubmit: (value) {
                  _focusNodeSKU.unfocus();
                  _focusNodePrice.requestFocus();
                }),
            _itemInput(
                hintText: 'Nhập giá sản phẩm',
                controller: _priceController,
                focusNode: _focusNodePrice,
                autoFocus: false,
                keyboardType: TextInputType.number,
                onSubmit: (value) {}),
            Align(
              alignment: Alignment.center,
              child: ButtonSubmitWidget(
                onPressed: () {
                  if (_nameProductController.text.isNotEmpty ||
                      _barCodeController.text.isNotEmpty ||
                      _skuController.text.isNotEmpty ||
                      _priceController.text.isNotEmpty) {
                    ProductModel _model = ProductModel(
                      qty: 1,
                      body: _nameProductController.text,
                      barCode: _barCodeController.text,
                      priceNumber: _priceController.text,
                      sku: _skuController.text
                    );
                    onBack(_model);
                    _nameProductController.clear();
                    _barCodeController.clear();
                    _skuController.clear();
                    _priceController.clear();
                    Navigator.pop(context);
                  } else {
                    _showMsg('Có trường dữ liệu còn bỏ trống', Colors.red);
                  }
                },
                title: 'THÊM',
                colorDefaultText: Colors.white,
                width: 250,
                height: 45,
                marginVertical: 30,
              ),
            )
          ],
        ));
  }

  Widget _itemInput(
      {required String hintText,
      required bool autoFocus,
      required FocusNode focusNode,
      required ValueChanged<String?> onSubmit,
      required TextEditingController controller,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        autofocus: autoFocus,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmit,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Color(0x33101010), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Color(0x33101010), width: 1),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
      ),
    );
  }

  void _showMsg(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
