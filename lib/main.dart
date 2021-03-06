import 'package:flutter/material.dart';
import 'pages/splash/splash_page.dart';
import 'pages/start_page.dart';
import 'prefs_util.dart';
import 'routers/custom_router.dart';

void main() async{
  Widget app = await initializeApp();
  runApp(app);
}

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsUtil.getInstance();
  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Eton Scanner',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.allRoutes,
      initialRoute: SplashPage.routeName,
    );
  }
}
