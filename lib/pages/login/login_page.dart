import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/base_bloc.dart';
import '../../widgets/button_submit_widget.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _bloc;
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _passwordVisible = false;
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final RegExp regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _passController.clear();
    _phoneController.clear();
    _focusNodePhoneNumber.unfocus();
    _focusNodePassword.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 80),
          children: [
            const Text('Đăng nhập', style: TextStyle(fontSize: 30)),
            _itemPadding(12),
            const Text('Vui lòng nhập số điện thoại và mât khẩu để đăng nhập.',
                style: TextStyle(fontSize: 14)),
            _itemPadding(32),
            const Text('Số điện thoại', style: TextStyle(fontSize: 18)),
            _itemPadding(12),
            _itemInput(
                hintText: 'Nhập số điện thoại.',
                autoFocus: false,
                focusNode: _focusNodePhoneNumber,
                obscureText: false,
                globalKey: _formKeyPhone,
                onSubmit: (value) {
                  _focusNodePhoneNumber.unfocus();
                  _focusNodePassword.requestFocus();
                },
                controller: _phoneController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Số điện thoại không được để trống';
                  } else if (value.length != 10 || !regExp.hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                }),
            _itemPadding(20),
            const Text('Mật khẩu', style: TextStyle(fontSize: 18)),
            _itemPadding(12),
            _itemInput(
                hintText: 'Mật khẩu',
                autoFocus: false,
                focusNode: _focusNodePassword,
                obscureText: !_passwordVisible,
                onSubmit: (value) {},
                controller: _passController,
                globalKey: _formKeyPass,
                suffixIcon: IconButton(
                  icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mật khẩu không được để trống';
                  }
                  return null;
                }),
            _itemPadding(80),
            ButtonSubmitWidget(
              onPressed: () {
                if (_formKeyPhone.currentState!.validate() &&
                    _formKeyPass.currentState!.validate()) {
                  _bloc.login(_phoneController.text, _passController.text, context);
                }
              },
              title: 'ĐĂNG NHẬP',
              colorDefaultText: Colors.white,
              height: 44,
            ),
            _itemPadding(32),
          ],
        ));
  }

  Widget _itemPadding(double size) {
    return SizedBox(height: size);
  }

  Widget _itemInput(
      {required String hintText,
      required bool autoFocus,
      required FocusNode focusNode,
      required ValueChanged<String?> onSubmit,
      required TextEditingController controller,
      required bool obscureText,
      required GlobalKey globalKey,
      required FormFieldValidator<String> validator,
      TextInputType? keyboardType,
      Widget? suffixIcon}) {
    return Form(
      key: globalKey,
      child: TextFormField(
        autofocus: autoFocus,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmit,
        controller: controller,
        obscureText: obscureText,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            suffixIcon: suffixIcon),
        validator: validator,
      ),
    );
  }
}
