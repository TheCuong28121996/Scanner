import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/model/confirm_user.dart';
import 'package:mobile/model/product_model.dart';
import 'package:mobile/pages/scanner_page.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../base/base_dialog.dart';
import '../base/button_submit_widget.dart';
import '../logs/logger_interceptor.dart';
import '../model/create_bill_model.dart';
import 'add_product.dart';
import 'confirm_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TextEditingController> _controllers = [];
  final List<ProductModel> _products = [];
  late Dio _dio;
  static const MethodChannel _channel = MethodChannel('open_settings');

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
    for (final item in _controllers) {
      item.dispose();
    }
  }

  Future<void> _getInfoBarcode(String? barCode) async {
    if (barCode != null && barCode.isNotEmpty) {
      try {
        Response response = await _dio.get('/rest/products/$barCode');

        if (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.created) {
          List<ProductModel> _listData = (response.data as List)
              .map((x) => ProductModel.fromJson(x))
              .toList();

          if (_listData.isEmpty) {
            _showMsg('Không tìm thấy thông tin Barcode', Colors.red);
          } else {
            if (_products.isNotEmpty) {
              for (final item in _listData) {
                int _index = _products
                    .indexWhere((element) => element.barCode == item.barCode);
                if (_index != -1) {
                  int _currentQty = _products[_index].qty += 1;
                  _controllers[_index].text = '$_currentQty';
                } else {
                  _products.add(item);
                }
              }
            } else {
              _products.addAll(_listData);
            }
          }
        }

        setState(() {});
      } catch (error, stacktrace) {
        throw Exception("Exception occured: $error stackTrace: $stacktrace");
      }
    } else {
      _showMsg('Barcode không hợp lệ.', Colors.red);
    }
  }

  Future<void> _getToken(ConfirmUser user) async {
    try {
      Response response = await _dio.get('/session/token');

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        _createBill(response.data, user);
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<void> _createBill(String? token, ConfirmUser user) async {
    String _token = token ?? 'wNH9mb9KzMhS2D9nHGRFly5vb_H27bnwNsohTjQJnLI';
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
        _showMsg('Tạo đơn thành công', Colors.green);
        _sendSMS(user.phone, createBillModel.nid?[0].value);
      } else {
        _showMsg('Tạo đơn thất bại', Colors.red);
      }
    } catch (error, stacktrace) {
      _showMsg('Tạo đơn thất bại', Colors.red);
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  static Future<void> _sendSMS(String number, int? msg) async {
    _channel.invokeMethod('send_sms', <String, String?>{
      'phoneNumber': number,
      'mgs': 'https://stg-demo-da.eton.vn/node/$msg',
    });
  }

  String _getTotal() {
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

  static String getCurrencyText(dynamic? money) {
    return NumberFormat.currency(locale: 'vi', name: 'đ', decimalDigits: 0)
        .format(money);
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

  void _showDialogConfirm(ConfirmUser user) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return BaseDialog(
            isShowClose: false,
            detailWidget: Column(
              children: [
                const Text('Thông báo',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                const SizedBox(height: 5),
                const Text('Bạn có chắc muốn hoàn thành?',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ButtonSubmitWidget(
                        title: 'Hủy',
                        titleSize: 14,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        colorDefaultText: Colors.orange,
                        backgroundColors: false,
                        marginHorizontal: 6,
                      ),
                    ),
                    Expanded(
                      child: ButtonSubmitWidget(
                          title: 'ĐỒNG Ý',
                          titleSize: 14,
                          onPressed: () {
                            Navigator.pop(context);
                            _getToken(user);
                          },
                          marginHorizontal: 6,
                          colorDefaultText: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScanPage(onScanner: (value) {
                              _getInfoBarcode(value);
                            })));
              },
              icon: const Icon(Icons.qr_code_scanner))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            AddProductBottomSheet().show(
                context: context,
                onBack: (value) {
                  if (_products.isNotEmpty) {
                    int _index = _products.indexWhere(
                        (element) => element.barCode == value.barCode);

                    if (_index != -1) {
                      int _currentQty = _products[_index].qty += 1;
                      _controllers[_index].text = '$_currentQty';
                    } else {
                      _products.add(value);
                    }
                  } else {
                    _products.add(value);
                  }

                  setState(() {});
                });
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color(0xFFF28022),
        ),
      ),
      body: SizedBox(
        width: _size.width,
        height: _size.height,
        child: Stack(
          children: [
            _products.isEmpty ? _noItemWidget() : _listItem(),
            Positioned(
              child: _submitWidget(_size),
              bottom: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _noItemWidget() => const Center(
      child: Text('Chưa có sản phẩm', style: TextStyle(fontSize: 18)));

  Widget _listItem() {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.only(top: 8, bottom: 110),
        itemBuilder: (context, index) {
          _controllers.add(TextEditingController());
          _controllers[index].text = '${_products[index].qty}';
          ProductModel _data = _products[index];
          return Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stripHtmlIfNeeded(_data.body ?? ''),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666462),
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SKU: ${_data.sku ?? ''}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Giá: ',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black)),
                              TextSpan(
                                  text:
                                      '${_data.priceNumber} ${_data.priceCurrencyCode ?? 'đ'}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ])),
                          ],
                        ),
                      ),
                      _increaseDecreaseWidget(index)
                    ],
                  ),
                ],
              ));
        },
        itemCount: _products.length);
  }

  Widget _increaseDecreaseWidget(int index) {
    ProductModel _productModel = _products[index];
    TextEditingController _controller = _controllers[index];
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle,
              color: _productModel.qty > 0 ? const Color(0xFFF28022) : null),
          onPressed: () {
            if (0 < _productModel.qty) {
              setState(() {
                _productModel.qty -= 1;
                _controller.text = '${_productModel.qty}';
              });
            }
          },
        ),
        SizedBox(
          width: 50,
          height: 35,
          child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintStyle: const TextStyle(fontSize: 13),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              )),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outlined, color: Color(0xFFF28022)),
          onPressed: () {
            setState(() {
              _productModel.qty += 1;
              _controller.text = '${_productModel.qty}';
            });
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete, color: Color(0xFFF28022)),
          onPressed: () {
            setState(() {
              _products.removeAt(index);
              _controllers.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  Widget _submitWidget(Size size) => Container(
        width: size.width,
        color: const Color(0xFFFFF1E5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tổng tiền:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(_getTotal(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_products.isNotEmpty) {
                  ConfirmBottomSheet().show(
                      context: context,
                      onBack: (value) {
                        _showDialogConfirm(value);
                      });
                } else {
                  _showMsg('Chưa có sản phẩm', Colors.red);
                }
              },
              child: const Text('XÁC NHẬN'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFF28022)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ))),
            ),
          ],
        ),
      );
}
