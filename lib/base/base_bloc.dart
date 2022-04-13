import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BaseBloc {
  final _loadingStreamController = BehaviorSubject<bool>();
  final _showMsgSuccessController = BehaviorSubject<String>();
  final _showMsgFailController = BehaviorSubject<String>();

  Stream<bool> get loadingStream => _loadingStreamController.stream;

  Stream<String> get msgSuccessStream => _showMsgSuccessController.stream;

  Stream<String> get msgFailStream => _showMsgFailController.stream;

  void dispose() {
    _loadingStreamController.close();
    _showMsgSuccessController.close();
    _showMsgFailController.close();
  }

  void showLoading() {
    _loadingStreamController.sink.add(true);
  }

  void hiddenLoading() {
    _loadingStreamController.sink.add(false);
  }

  void showMsgSuccess(String? msg) {
    if (msg != null) {
      _showMsgSuccessController.sink.add(msg);
    }
  }

  void showMsgFail(String? msg) {
    if (msg != null) {
      _showMsgFailController.sink.add(msg);
    }
  }
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  const BlocProvider({
    required this.child,
    required this.bloc,
    Key? key,
    this.userDispose = true,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  final bool userDispose;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider!.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  @override
  void dispose() {
    if (widget.userDispose) {
      widget.bloc.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.bloc.msgSuccessStream.listen((msg) {
      _showMsg(msg, Colors.green);
    });
    widget.bloc.msgFailStream.listen((msg) {
      _showMsg(msg, Colors.red);
    });
  }

  void _showMsg(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        StreamBuilder<bool>(
            stream: widget.bloc.loadingStream,
            initialData: false,
            builder: (context, snapshot) {
              return Visibility(
                  visible: snapshot.data!,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF28022),
                    ),
                  ));
            })
      ],
    );
  }
}
