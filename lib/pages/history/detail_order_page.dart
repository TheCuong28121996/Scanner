import 'package:flutter/material.dart';
import 'package:mobile/model/order_model.dart';
import 'package:mobile/routers/screen_arguments.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({Key? key, required this.arguments}) : super(key: key);
  final ScreenArguments arguments;
  static const routeName = '/DetailOrderPage';

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    orderModel = widget.arguments.arg1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Tổng SKU: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('${orderModel.orderItems?.length ?? 0}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red)),
                  const Spacer(),
                  const Text('Tổng SL: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(_getTotalQty(orderModel),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      OrderItem data = orderModel.orderItems![index];
                      return Column(
                        children: [
                          Text(data.title ?? '')
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: orderModel.orderItems?.length ?? 0),
              )
            ],
          )),
    );
  }

  String _getTotalQty(OrderModel orderModel) {
    double totalQty = 0;
    if (orderModel.orderItems != null && orderModel.orderItems!.isNotEmpty) {
      for (final item in orderModel.orderItems!) {
        totalQty = totalQty + item.quantity;
      }
    }

    return totalQty.toString();
  }
}
