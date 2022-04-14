import 'package:flutter/material.dart';
import 'package:mobile/model/create_bill_model.dart';
import 'package:mobile/pages/history/history_bloc.dart';
import 'package:mobile/widgets/webview_page.dart';
import '../../base/base_bloc.dart';
import '../../routers/screen_arguments.dart';

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
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Lịch sử'),
          centerTitle: true,
          backgroundColor: const Color(0xFFF28022)),
      backgroundColor: const Color(0xFFE5E5E5),
      body: SizedBox(
        width: _size.width,
        height: _size.height,
        child: StreamBuilder<List<CreateBillModel>?>(
            stream: _bloc.historyStream,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return _noItemWidget();
              }
              return _listItem(snapshot.data!);
            }),
      ),
    );
  }

  Widget _noItemWidget() => const Center(
      child: Text('Chưa có lịch sử', style: TextStyle(fontSize: 18)));

  Widget _listItem(List<CreateBillModel> data) {
    return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        itemBuilder: (context, index) {
          CreateBillModel _data = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, WebViewPage.routeName,
                  arguments: ScreenArguments(
                      arg1:
                          'https://stg-demo-da.eton.vn/node/${_data.nid?[0].value}'));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_data.title?[0].value ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF28022))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(_data.createTime?[0].value ?? '',
                          style: const TextStyle(color: Color(0xFF008D26))),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14)
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: data.length);
  }
}
