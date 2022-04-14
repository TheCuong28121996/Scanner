import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mobile/base/base_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mobile/pages/navigation/navigation_page.dart';

import '../../logs/logger_interceptor.dart';
import '../../model/login_model.dart';
import '../../prefs_util.dart';

class LoginBloc extends BaseBloc {
  LoginBloc() {
    _initDio();
  }

  late Dio _dio;

  Future<void> login(String userName, String pass, BuildContext context) async {
    showLoading();
    try {
      var formData = FormData.fromMap({
        'username': userName,
        'password': pass,
        'client_secret': 'AJZH7tFuz4',
        'grant_type': 'password',
        'client_id': '08b9a1b9-fe89-4119-9da2-92fc7eb0a91b',
        'scope': 'pos_cashier',
      });

      Response response = await _dio.post('/oauth/token', data: formData);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        AuthModel authModel = AuthModel.fromJson(response.data);

        PrefsUtil.putBool('IS_LOGIN', true);
        PrefsUtil.putString('TOKEN', authModel.accessToken);
        showMsgSuccess('Đăng nhập thành công');
        Navigator.pushReplacementNamed(context, NavigationPage.routeName);
      } else {
        showMsgFail('Đăng nhập thất bại');
      }
      hiddenLoading();
    } catch (error, stacktrace) {
      hiddenLoading();
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  void _initDio() {
    final options = BaseOptions(
      baseUrl: 'https://stg-demo-da.eton.vn',
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {},
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    _dio.interceptors.add(LoggerInterceptor());
  }
}
