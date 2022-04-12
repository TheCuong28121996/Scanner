import 'package:flutter/material.dart';
import 'package:mobile/pages/home_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        title: const Text('Eton demo'),
      ),
      body: Center(
        child: InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage()));
          },
          child: const CircleAvatar(
            radius: 100,
            backgroundColor: Colors.orange,
            child: Text(
              'Start',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
