import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mobile/base/base_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../logs/logger_interceptor.dart';
import '../../model/confirm_user.dart';
import '../../model/create_bill_model.dart';
import '../../model/product_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../prefs_util.dart';

class HomeBloc extends BaseBloc {
  late Dio _dio;
  final List<ProductModel> _products = [];
  static const MethodChannel _channel = MethodChannel('open_settings');
  final _productsController = BehaviorSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get productStream => _productsController.stream;

  HomeBloc() {
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

  Future<void> getInfoBarcode(String? barCode) async {
    showLoading();
    if (barCode != null && barCode.isNotEmpty) {
      try {
        Response response = await _dio.get('/rest/products/$barCode');

        if (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.created) {
          List<ProductModel> _listData = (response.data as List)
              .map((x) => ProductModel.fromJson(x))
              .toList();

          if (_listData.isEmpty) {
            showMsgFail('Không tìm thấy thông tin Barcode');
          } else {
            if (_products.isNotEmpty) {
              for (final item in _listData) {
                int _index = _products
                    .indexWhere((element) => element.barCode == item.barCode);
                if (_index != -1) {
                  _products[_index].qty += 1;
                } else {
                  _products.add(item);
                }
              }
            } else {
              _products.addAll(_listData);
            }
          }
        }

        _productsController.sink.add(_products);
        hiddenLoading();
      } catch (error, stacktrace) {
        hiddenLoading();
        throw Exception("Exception occured: $error stackTrace: $stacktrace");
      }
    } else {
      showMsgFail('Barcode không hợp lệ.');
    }
  }

  void decreaseQty(int index) {
    _products[index].qty--;
    _productsController.sink.add(_products);
  }

  void increaseQty(int index) {
    _products[index].qty++;
    _productsController.sink.add(_products);
  }

  void remove(int index) {
    _products.removeAt(index);
    _productsController.sink.add(_products);
  }

  void changeQty(int index, int qty){
    _products[index].qty = qty;
  }

  String getTotal() {
    int _totalCost = 0;
    if (_products.isNotEmpty) {
      for (final item in _products) {
        String? _text = item.priceNumber?.replaceAll('.', '');

        int value = int.parse(_text ?? '0');
        _totalCost = _totalCost + value * item.qty;
      }
    }
    return getCurrencyText(_totalCost);
  }

  static String getCurrencyText(dynamic money) {
    return NumberFormat.currency(locale: 'vi', name: 'đ', decimalDigits: 0)
        .format(money);
  }

  void addProduct(ProductModel value) {
    if (_products.isNotEmpty) {
      int _index =
          _products.indexWhere((element) => element.barCode == value.barCode);

      if (_index != -1) {
        _products[_index].qty += 1;
      } else {
        _products.add(value);
      }
    } else {
      _products.add(value);
    }
    _productsController.sink.add(_products);
  }

  Future<void> createBill(ConfirmUser user) async {
    showLoading();
    String? _token = PrefsUtil.getString('TOKEN');
    _dio.options.headers = {'X-CSRF-Token': _token};

    final _listProducts = [];
    for (final item in _products) {
      _listProducts.add({"value": item.body});
    }

    try {
      Response response = await _dio.post('/node?_format=json', data: {
        "type": [
          {"target_id": "demo_bill"}
        ],
        "title": [
          {
            "value":
                "Bill ${Random().nextInt(100)} create by ${user.name} - ${user.phone} - ${getNowDateMs()}"
          }
        ],
        "body": jsonEncode(_listProducts)
      });

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        CreateBillModel createBillModel =
            CreateBillModel.fromJson(response.data);
        showMsgSuccess('Tạo đơn thành công');

        String _msg =
            'https://stg-demo-da.eton.vn/node/${createBillModel.nid?[0].value}';

        // List<String>? _history = PrefsUtil.getStringList('HISTORY');
        // if (_history == null) {
        //   PrefsUtil.putStringList('HISTORY', [_msg]);
        // } else {
        //   _history.add(_msg);
        //   PrefsUtil.clear();
        //   PrefsUtil.putStringList('HISTORY', _history);
        // }
        Future.delayed(const Duration(seconds: 1), (){
        _sendSMS(user.phone, _msg);
        });

        _products.clear();
        _productsController.sink.add(_products);
      } else {
        showMsgFail('Tạo đơn thất bại');
      }
      hiddenLoading();
    } catch (error, stacktrace) {
      showMsgFail('Tạo đơn thất bại');
      hiddenLoading();
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  static Future<void> _sendSMS(String number, String msg) async {
    _channel.invokeMethod('send_sms', <String, String?>{
      'phoneNumber': number,
      'mgs': msg,
    });
  }

  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    super.dispose();
    _productsController.close();
  }
}
