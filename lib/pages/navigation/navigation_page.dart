import 'package:flutter/material.dart';
import 'package:mobile/pages/history/history_bloc.dart';
import 'package:mobile/pages/history/history_page.dart';
import 'package:mobile/pages/home/home_page.dart';
import 'package:mobile/pages/user/user_page.dart';

import '../../base/base_bloc.dart';
import '../../res.dart';
import '../../widgets/keep_alive_page.dart';
import '../home/home_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../order/order_bloc.dart';
import '../order/order_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);
  static const routeName = '/NavigationPage';

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  void _updateTabSelection(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 10), curve: Curves.ease);
    });
  }

  void _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBarWidget(),
      body: _pageView(),
    );
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _navigationBarItem(
            icon: AssetImages.ICON_NAVI_ORDER, label: 'Tạo đơn'),
        _navigationBarItem(icon: AssetImages.ICON_NAVI_HOME, label: 'Đơn hàng'),
        _navigationBarItem(icon: AssetImages.ICON_MENU_HISTORY, label: 'Lịch sử'),
        _navigationBarItem(icon: AssetImages.ICON_NAVI_MENU, label: 'Chức năng')
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFFF28022),
      onTap: _updateTabSelection,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _pageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: _pageChanged,
      children: <Widget>[
        KeepAlivePage(
            child: BlocProvider(child: const HomePage(), bloc: HomeBloc())),
        KeepAlivePage(
            child:
                BlocProvider(child: const OrderPage(), bloc: OrderBloc())),
        BlocProvider(child: const HistoryPage(), bloc: HistoryBloc()),
        KeepAlivePage(child: const UserPage()),
      ],
    );
  }

  BottomNavigationBarItem _navigationBarItem(
      {required String icon, required String label}) {
    return BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset(icon, color: Colors.grey),
        label: label,
        activeIcon: SvgPicture.asset(icon, color: const Color(0xFFF28022)));
  }
}
