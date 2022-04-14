import 'dart:io';

import 'package:mobile/base/base_bloc.dart';

import '../../logs/logger_interceptor.dart';
import '../../model/order_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

import '../../prefs_util.dart';

class OrderBloc extends BaseBloc {
  late Dio _dio;
  final _ordersController = BehaviorSubject<List<OrderModel>>();

  Stream<List<OrderModel>> get ordersStream => _ordersController.stream;

  OrderBloc() {
    String? _token = PrefsUtil.getString('TOKEN');

    final options = BaseOptions(
      baseUrl: 'https://stg-demo-da.eton.vn',
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {'Authorization': 'Bearer $_token'},
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    _dio.interceptors.add(LoggerInterceptor());
  }

  Future<void> getHistory() async {
    showLoading();
    try {
      Response response = await _dio.get('/api/commerce/orders/list');
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        List<OrderModel> _listData =
            (response.data as List).map((x) => OrderModel.fromJson(x)).toList();

        _ordersController.sink.add(_listData);
      }
      hiddenLoading();
    } catch (error, stacktrace) {
      hiddenLoading();
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ordersController.close();
  }
}
