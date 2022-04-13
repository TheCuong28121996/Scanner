import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/pages/splash/splash_bloc.dart';

import '../../base/base_bloc.dart';
import '../../res.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SplashBloc>(context);
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            AssetImages.bgSplash,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: Lottie.asset(
              AssetImages.splashLottie,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward().whenComplete(() => _bloc.checkLogin(context));
              },
            ),
          )
        ],
      ),
    );
  }
}
