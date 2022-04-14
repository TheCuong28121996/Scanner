import 'package:mobile/base/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/create_bill_model.dart';
import '../../prefs_util.dart';

class HistoryBloc extends BaseBloc {
  final _historyController = BehaviorSubject<List<CreateBillModel>?>();

  Stream<List<CreateBillModel>?> get historyStream => _historyController.stream;

  Future<void> getHistory() async {
    List<CreateBillModel>? _history =
        PrefsUtil.getObjList('HISTORY', (v) => CreateBillModel.fromJson(v));

    _historyController.sink.add(_history);
  }

  @override
  void dispose() {
    super.dispose();
    _historyController.close();
  }
}
