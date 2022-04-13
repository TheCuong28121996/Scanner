import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mobile/base/base_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mobile/pages/navigation/navigation_page.dart';

import '../../logs/logger_interceptor.dart';
import '../../prefs_util.dart';

class LoginBloc extends BaseBloc {
  LoginBloc() {
    _initDio();
  }

  late Dio _dio;

  Future<void> login(String phone, String pass, BuildContext context) async {
    showLoading();
    try {
      Response response = await _dio.get('/session/token');

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        PrefsUtil.putBool('IS_LOGIN', true);
        PrefsUtil.putString('TOKEN', response.data);
        showMsgSuccess('Đăng nhập thành công');
        Navigator.pushReplacementNamed(context, NavigationPage.routeName);
      } else {
        showMsgFail('Đăng nhập thất bại');
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }

    hiddenLoading();
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
