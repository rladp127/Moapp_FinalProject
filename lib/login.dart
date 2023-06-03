import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
int n = 0;
String username = '';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      print(FirebaseAuth.instance.currentUser);
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
                    if (username != '')
                      Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: Text('Sign in with Google')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}