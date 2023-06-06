import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome To', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Handong',
                  style: TextStyle(fontSize: 30, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sell',
                  style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ]
            ),
            SizedBox(
              width: 500,
              height: 300,
              child: Lottie.asset(
                'assets/lottie.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller.addStatusListener((status) {
                    if (status == AnimationStatus.dismissed)
                      _controller.forward();
                    else if (status == AnimationStatus.completed)
                      _controller.reverse();
                  });
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
