import 'package:mobile/base/base_bloc.dart';

import '../../model/order_model.dart';
import 'package:rxdart/rxdart.dart';

class DetailOrderBloc extends BaseBloc{
  late OrderModel _orderModel;
  final _orderController = BehaviorSubject<OrderModel>();
  final _submitController = BehaviorSubject<bool>();

  Stream<OrderModel> get orderStream => _orderController.stream;
  Stream<bool> get submitStream => _submitController.stream;

  void initData(OrderModel orderModel){
    _orderModel = orderModel;
    _orderController.sink.add(_orderModel);
  }

  void increaseQty(int index){
    _orderModel.orderItems![index].currentQty ++;
    _orderController.sink.add(_orderModel);
  }

  void decreaseQty(int index) {
    _orderModel.orderItems![index].currentQty --;
    _orderController.sink.add(_orderModel);
  }

  void changeQty(int index, double qty){
    if(qty > _orderModel.orderItems![index].quantity){
      showMsgFail('Vượt quá số lượng');
    }else{
      _orderModel.orderItems![index].currentQty = qty;
    }
  }

  void updateQty(String barCode){
    for(final item in _orderModel.orderItems!){
      if(item.barcode == barCode){
        if(item.currentQty < item.quantity){
          item.currentQty ++;
          _orderController.sink.add(_orderModel);
        }else{
          showMsgFail('Vượt quá số lượng');
        }
      }
    }
  }

  Future<void> submit()async{

  }

  @override
  void dispose() {
    super.dispose();
    _orderController.close();
    _submitController.close();
  }

}