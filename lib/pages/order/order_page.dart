import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/routers/screen_arguments.dart';
import '../../base/base_bloc.dart';
import '../../model/order_model.dart';
import '../../utils/constants.dart';
import '../detail_order/detail_order_page.dart';
import 'order_bloc.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<OrderPage> {
  late OrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<OrderBloc>(context);
    _bloc.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _bloc.getHistory();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn hàng'),
          centerTitle: true,
          backgroundColor: const Color(0xFFF28022),
        ),
        backgroundColor: const Color(0xFFE5E5E5),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<List<OrderModel>>(
              stream: _bloc.ordersStream,
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                              child: Text('Chưa có sản phẩm',
                                  style: TextStyle(fontSize: 18))),
                        ),
                      )
                    ],
                  );
                }
                return ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    itemBuilder: (context, index) {
                      OrderModel orderModel = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, DetailOrderPage.routeName,
                              arguments: ScreenArguments(arg1: orderModel));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      'MÃ ĐƠN HÀNG: ${orderModel.orderNumber ?? ''}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFF28022))),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        color: Constants.orderStatusColor[
                                            orderModel.state]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        Constants.orderStatus[
                                                orderModel.state] ??
                                            '',
                                        style: TextStyle(
                                            color:
                                                Constants.orderTextStatusColor[
                                                    orderModel.state],
                                            fontSize: 10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Thời gian',
                                      style: TextStyle(
                                          color: Color(0xFF6C7077),
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                      convertTimeStamp(orderModel.placed) ?? '',
                                      style: const TextStyle(
                                          color: Color(0xFF008D26))),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Tổng SL: ',
                                      style:
                                          TextStyle(color: Color(0xFF6C7077))),
                                  Text(
                                      '${orderModel.orderItems?.length ?? '0'}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  const Spacer(),
                                  const Text('Tổng tiền: ',
                                      style:
                                          TextStyle(color: Color(0xFF6C7077))),
                                  Text('${orderModel.totalPrice ?? '0'} đ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red)),
                                  const SizedBox(width: 16),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data?.length ?? 0);
              }),
        ),
      ),
    );
  }

  static String? convertTimeStamp(String? millis) {
    if (millis == null) {
      return '';
    }

    return DateFormat('HH:mm dd-MM-yyyy')
        .format(getDateTimeByMs(int.parse(millis)));
  }

  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }
}
