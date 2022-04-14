import 'package:flutter/material.dart';
import 'package:mobile/model/order_model.dart';
import 'package:mobile/routers/screen_arguments.dart';

import '../../base/base_bloc.dart';
import '../../base/base_dialog.dart';
import '../../widgets/button_submit_widget.dart';
import '../../widgets/scanner_page.dart';
import 'detail_order_bloc.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({Key? key, required this.arguments}) : super(key: key);
  final ScreenArguments arguments;
  static const routeName = '/DetailOrderPage';

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late DetailOrderBloc _bloc;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<DetailOrderBloc>(context);
    _bloc.initData(widget.arguments.arg1);
  }

  void _showDialogConfirm(OrderModel orderModel) {
    showDialog(
        context: context,
        barrierDismissible: false,
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
                            _bloc.submit();
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
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScanPage(onScanner: (value) {
                        _bloc.updateQty(value!);
                      })));
        },
        child: const Icon(Icons.qr_code_scanner),
        backgroundColor: const Color(0xFFF28022),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<OrderModel>(
              stream: _bloc.orderStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Container();
                }
                OrderModel orderModel = snapshot.data!;

                int _totalCurrent = _getCurrentQty(orderModel);
                int _totalQty = _getTotalQty(orderModel);

                if (_totalCurrent == _totalQty) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    _showDialogConfirm(orderModel);
                  });
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _headerWidget(
                            'SKU: ', '${orderModel.orderItems?.length ?? 0}'),
                        _headerWidget('SL: ', '$_totalCurrent/$_totalQty'),
                        _headerWidget(
                            'Giá: ', '${orderModel.totalPrice ?? 0}đ'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            OrderItem data = orderModel.orderItems![index];
                            _controllers.add(TextEditingController());
                            _controllers[index].text =
                                '${data.currentQty.toInt()}';
                            _controllers[index].selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _controllers[index].text.length));
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                    color: data.currentQty == data.quantity
                                        ? Colors.grey[300]!
                                        : const Color(0xFFFFF1E5),
                                    border: Border.all(
                                        color: data.currentQty == data.quantity
                                            ? Colors.grey[300]!
                                            : const Color(0xFFF28022)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        _titleWidget(
                                            'Barcode: ', data.barcode ?? ''),
                                        const Spacer(),
                                        _titleWidget('SL: ',
                                            '${data.currentQty.toInt()}/${data.quantity.toInt()}'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        _titleWidget('SKU: ', data.sku ?? ''),
                                        const Spacer(),
                                        _increaseDecreaseWidget(index, data)
                                      ],
                                    ),
                                    const Divider(),
                                    _titleWidget('Giá: ', data.unitPrice ?? ''),
                                    const Divider(),
                                    Text(data.title ?? ' ',
                                        style: const TextStyle(
                                            color: Color(0xFF131312))),
                                  ],
                                ));
                          },
                          itemCount: orderModel.orderItems?.length ?? 0),
                    ),
                    ButtonSubmitWidget(
                      width: 250,
                      onPressed: () {
                        _bloc.submit();
                      },
                      title: 'XÁC NHẬN',
                    ),
                  ],
                );
              })),
    );
  }

  Widget _headerWidget(String title, String value) => Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red)),
        ],
      );

  Widget _titleWidget(String title, String value) => Row(
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF666462))),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF131312), fontWeight: FontWeight.w500))
        ],
      );

  Widget _increaseDecreaseWidget(int index, OrderItem data) {
    TextEditingController _controller = _controllers[index];
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle,
              color: data.currentQty > 0 ? const Color(0xFFF28022) : null),
          onPressed: () {
            if (data.currentQty > 0) {
              _bloc.decreaseQty(index);
            }
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 50,
          height: 35,
          child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _bloc.changeQty(index, double.parse(value));
              },
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
        const SizedBox(width: 5),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.add_circle_outlined,
              color: data.currentQty < data.quantity
                  ? const Color(0xFFF28022)
                  : null),
          onPressed: () {
            if (data.currentQty < data.quantity) {
              _bloc.increaseQty(index);
            }
          },
        ),
      ],
    );
  }

  int _getTotalQty(OrderModel orderModel) {
    double totalQty = 0;
    if (orderModel.orderItems != null && orderModel.orderItems!.isNotEmpty) {
      for (final item in orderModel.orderItems!) {
        totalQty = totalQty + item.quantity;
      }
    }

    return totalQty.toInt();
  }

  int _getCurrentQty(OrderModel orderModel) {
    double currentQty = 0;

    if (orderModel.orderItems != null && orderModel.orderItems!.isNotEmpty) {
      for (final item in orderModel.orderItems!) {
        currentQty = currentQty + item.currentQty;
      }
    }

    return currentQty.toInt();
  }
}
