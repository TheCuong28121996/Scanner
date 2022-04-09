import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/barcode_model.dart';
import 'package:mobile/scanner_page.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'base_dialog.dart';
import 'button_submit_widget.dart';
import 'logs/logger_interceptor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BarCodeModel> _listBarCode = [];
  final List<TextEditingController> _listController = [];
  bool _showLoading = false;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    final options = BaseOptions(
      baseUrl: 'https://6250e3e7977373573f4301be.mockapi.io',
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
    for (final item in _listController) {
      item.dispose();
    }
  }

  void _handlerBarcode(String? barCode) {
    if (barCode != null && barCode.isNotEmpty) {
      if (_listBarCode.isNotEmpty) {
        int index =
            _listBarCode.indexWhere((element) => element.barCode == barCode);

        if (index != -1) {
          int value = int.parse(_listController[index].text) + 1;
          _listController[index].text = '$value';
        } else {
          _listBarCode.add(BarCodeModel(barCode: barCode, qty: 1));
        }
      } else {
        _listBarCode.add(BarCodeModel(barCode: barCode, qty: 1));
      }

      setState(() {});
    }
  }

  Future<void> _updateBarcode(BarCodeModel barCodeModel) async {
    setState(() {
      _showLoading = true;
    });

    Response response = await _dio.post('/api/scanner',
        data: {'barCode': barCodeModel.barCode, 'qty': barCodeModel.qty});

    _showMsg(response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created);

    setState(() {
      _showLoading = false;
    });
  }

  void _showMsg(bool msg) {
    Fluttertoast.showToast(
        msg: msg ? 'Thành công' : 'Thất bại',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: msg ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showDialogConfirm(BarCodeModel barCodeModel) {
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
                            _updateBarcode(barCodeModel);
                            Navigator.pop(context);
                          },
                          marginHorizontal: 6,
                          colorDefaultText: Colors.black),
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
        title: const Text('Sccaner'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScanPage(
                            onScanner: (value) => _handlerBarcode(value))));
              },
              icon: const Icon(Icons.qr_code_scanner))
        ],
      ),
      body: SizedBox(
        width: _size.width,
        height: _size.height,
        child: Stack(
          children: [
            _listBarCode.isEmpty ? _noItemWidget() : _listItem(),
            Visibility(
                visible: _showLoading,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF28022)),
                ))
          ],
        ),
      ),
    );
  }

  Widget _noItemWidget() => const Center(
      child: Text('Chưa có Barcode', style: TextStyle(fontSize: 18)));

  Widget _listItem() {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.only(top: 8),
        itemBuilder: (context, index) {
          _listController.add(TextEditingController(text: '1'));
          return Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Text(_listBarCode[index].barCode,
                      style: const TextStyle(fontSize: 15)),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: TextField(
                        controller: _listController[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
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
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialogConfirm(BarCodeModel(
                          barCode: _listBarCode[index].barCode,
                          qty: int.parse(_listController[index].text)));
                    },
                    child: const Text('DONE'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFFF28022)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ))),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: _listBarCode.length);
  }
}
