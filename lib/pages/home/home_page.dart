import 'package:flutter/material.dart';
import 'package:mobile/model/confirm_user.dart';
import 'package:mobile/model/product_model.dart';
import 'package:mobile/widgets/scanner_page.dart';
import '../../base/base_bloc.dart';
import '../../base/base_dialog.dart';
import '../../widgets/button_submit_widget.dart';
import '../../widgets/add_product.dart';
import '../confirm_page.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TextEditingController> _controllers = [];
  late HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeBloc>(context);
    _bloc.showAddStream.listen((barCode) {
      AddProductBottomSheet().show(
          context: context,
          barCode: barCode,
          onBack: (value) {
            _bloc.addProduct(value);
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (final item in _controllers) {
      item.dispose();
    }
  }

  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
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
                            _bloc.createBill(user);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        actions: [
          IconButton(
              onPressed: () {
                AddProductBottomSheet().show(
                    context: context,
                    onBack: (value) {
                      _bloc.addProduct(value);
                    });
              },
              icon: const Icon(Icons.add_shopping_cart)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanPage(onScanner: (value) {
                          _bloc.getInfoBarcode(value);
                        })));
          },
          child: const Icon(Icons.qr_code_scanner),
          backgroundColor: const Color(0xFFF28022),
        ),
      ),
      body: SizedBox(
        width: _size.width,
        height: _size.height,
        child: StreamBuilder<List<ProductModel>>(
            initialData: const [],
            stream: _bloc.productStream,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  (snapshot.data == null || snapshot.data!.isEmpty)
                      ? _noItemWidget()
                      : _listItem(snapshot.data!),
                  Positioned(
                    child: _submitWidget(_size, snapshot.data),
                    bottom: 0,
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget _noItemWidget() => const Center(
      child: Text('Chưa có sản phẩm', style: TextStyle(fontSize: 18)));

  Widget _listItem(List<ProductModel> product) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.only(top: 8, bottom: 110),
        itemBuilder: (context, index) {
          ProductModel _data = product[index];
          _controllers.add(TextEditingController());
          _controllers[index].text = '${_data.qty}';
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
                      _increaseDecreaseWidget(index, _data)
                    ],
                  ),
                ],
              ));
        },
        itemCount: product.length);
  }

  Widget _increaseDecreaseWidget(int index, ProductModel data) {
    TextEditingController _controller = _controllers[index];
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle,
              color: data.qty > 0 ? const Color(0xFFF28022) : null),
          onPressed: () {
            if (0 < data.qty) {
              _bloc.decreaseQty(index);
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
              onChanged: (value) {
                _bloc.changeQty(index, int.parse(value));
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
        IconButton(
          icon: const Icon(Icons.add_circle_outlined, color: Color(0xFFF28022)),
          onPressed: () {
            _bloc.increaseQty(index);
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete, color: Color(0xFFF28022)),
          onPressed: () {
            _controllers.removeAt(index);
            _bloc.remove(index);
          },
        ),
      ],
    );
  }

  Widget _submitWidget(Size size, List<ProductModel>? products) => Container(
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
                  Text(_bloc.getTotal(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (products != null && products.isNotEmpty) {
                  ConfirmBottomSheet().show(
                      context: context,
                      onBack: (value) {
                        _showDialogConfirm(value);
                      });
                } else {
                  _bloc.showMsgFail('Chưa có sản phẩm');
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
