import 'package:flutter/material.dart';
import 'package:mobile/pages/history/history_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/routers/screen_arguments.dart';
import '../../base/base_bloc.dart';
import '../../model/order_model.dart';
import 'detail_order_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HistoryBloc>(context);
    _bloc.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<OrderModel>>(
            stream: _bloc.ordersStream,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Chưa có sản phẩm',
                        style: TextStyle(fontSize: 18)));
              }
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    OrderModel orderModel = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DetailOrderPage.routeName,
                            arguments:ScreenArguments(arg1: orderModel));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    'Mã đơn hàng: ${orderModel.orderNumber ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Text(orderModel.totalPrice ?? '',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(convertTimeStamp(orderModel.placed) ?? '',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF666462))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data?.length ?? 0);
            }),
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
