import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/model/product_model.dart';

import '../base/base_bottom_sheet.dart';
import '../widgets/button_submit_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/confirm_user.dart';

class ConfirmBottomSheet {
  ConfirmBottomSheet._internal();

  static final ConfirmBottomSheet _instance = ConfirmBottomSheet._internal();

  factory ConfirmBottomSheet() {
    return _instance;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController();
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();

  void show(
      {required BuildContext context, required Function(ConfirmUser) onBack}) {
    BaseBottomSheet().show(
        context: context,
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerWidget(context: context, title: 'Xác nhận'),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            const SizedBox(height: 16),
            _itemInput(
                hintText: 'Nhập tên',
                controller: _nameController,
                focusNode: _focusNodeName,
                autoFocus: false,
                onSubmit: (value) {
                  _focusNodeName.unfocus();
                  _focusNodePhone.requestFocus();
                }),
            _itemInput(
                hintText: 'Nhập số điện thoại',
                controller: _phoneCodeController,
                focusNode: _focusNodePhone,
                autoFocus: false,
                keyboardType: TextInputType.phone,
                onSubmit: (value) {}),
            Align(
              alignment: Alignment.center,
              child: ButtonSubmitWidget(
                onPressed: () {
                  if (_nameController.text.isNotEmpty ||
                      _phoneCodeController.text.isNotEmpty) {
                    Navigator.pop(context);
                    ConfirmUser _model = ConfirmUser(
                        name: _nameController.text,
                        phone: _phoneCodeController.text);
                    onBack(_model);
                    _nameController.clear();
                    _phoneCodeController.clear();

                  } else {
                    _showMsg('Có trường dữ liệu còn bỏ trống', Colors.red);
                  }
                },
                title: 'Xác nhận',
                colorDefaultText: Colors.white,
                width: 250,
                height: 50,
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
