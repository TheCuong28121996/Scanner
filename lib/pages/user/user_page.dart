import 'package:flutter/material.dart';

import '../../base/base_dialog.dart';
import '../../prefs_util.dart';
import '../../res.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/button_submit_widget.dart';
import '../splash/splash_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  static const routeName = '/UserPage';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chức năng'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: size.width,
        height: size.height,
        color: const Color(0xFFE5E5E5),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _itemInfoUserWidget(),
              const SizedBox(height: 16),
              _itemLogoutWidget(),
              _itemVersionWidget(),
              _itemBuildByWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemInfoUserWidget() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: ListTile(
          onTap: () {},
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Image.asset(AssetImages.IMG_PLACE_HOLDER,
                fit: BoxFit.cover, width: 45, height: 45),
          ),
          title: const Text(
            'Eton user',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          subtitle: const Text(
            '0 điểm',
            style: TextStyle(fontSize: 14),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey)),
    );
  }

  Widget _itemLogoutWidget() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white
      ),
      margin:
      const EdgeInsets.only(bottom: 24),
      child: _itemFunctionWidget(
          text: 'Đăng xuất',
          imageXML: AssetImages.ICON_MENU_LOGOUT,
          textColor: Colors.red,
          onTap: () {
            showDialog(
                context: context,
                builder: (buildContext) {
                  return BaseDialog(
                    isShowClose: false,
                    detailWidget: Column(
                      children: [
                        const Text('Đăng xuất',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const SizedBox(height: 5),
                        const Text(
                            'Bạn có chắc chin muốn đăng xuất khỏi tài khoản này không ?',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ButtonSubmitWidget(
                                title: 'Bỏ qua',
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
                                  title: 'Đăng xuất',
                                  titleSize: 14,
                                  onPressed: () {
                                    PrefsUtil.clear();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                        SplashPage.routeName,
                                            (Route<dynamic> route) => false);
                                  },
                                  marginHorizontal: 6,),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                });
          }),
    );
  }

  Widget _itemFunctionWidget({required String text,
    required String imageXML,
    required GestureTapCallback onTap,
    Color? textColor}) {
    return ListTile(
      leading: SvgPicture.asset(
        imageXML,
        width: 35,
        height: 34,
      ),
      title: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 14.5),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _itemVersionWidget() {
    return const Text(
      'Phiên bản 1.0.0',
    );
  }

  Widget _itemBuildByWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('© 2020 - Designed by'),
        const SizedBox(width: 5),
        Image.asset(AssetImages.ETONX_LOGO,
            width: 60,
            height: 30)
      ],
    );
  }
}
