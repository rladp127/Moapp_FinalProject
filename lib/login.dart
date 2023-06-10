import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
int n = 0;
String? username;

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        username = user.displayName!;
        n = 1;
        return;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 120.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text('Welcome To', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Handong',
                      style: TextStyle(fontSize: 35, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sell',
                      style: TextStyle(fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text('Let\'s Get Started!', style: TextStyle(fontSize: 16, color: Colors.deepOrangeAccent, fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: 50.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('already Sign In with Google '),
                  onPressed: () {
                    if (username! != '')
                      Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: Text('Sign in with Google')
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       signInWithGoogle;
                //     //   FirebaseFirestore.instance
                //     //       .collection('user')
                //     //       .doc(username)
                //     //       .set({
                //     //     'addlist': [],
                //     //     'orderlist': [],
                //     //     'wishlist': [],
                //     //   });
                //     },
                //     child: Text('Sign in with Google')
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation _animation;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    //Implement animation here
    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('image/start1.png',
                    width: 680,
                    height: 683,
                    fit: BoxFit.fill,
                  ),
                ],
              )
          )
      ),
    );
  }
}