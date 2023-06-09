import 'package:moapp_teamprj/paycomplete.dart';
import 'package:moapp_teamprj/payment.dart';
import 'package:moapp_teamprj/profile.dart';
import 'package:moapp_teamprj/splash.dart';
import 'package:moapp_teamprj/wishlist.dart';
import 'package:flutter/material.dart';

import 'add.dart';
import 'category.dart';
import 'detail.dart';
import 'donation.dart';
import 'edit.dart';
import 'home.dart';
import 'login.dart';
import 'myorder.dart';
import 'mystuff.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HandongSell',
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: const Splash(),),
        '/login': (BuildContext context) => const LoginPage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/myorder': (BuildContext context) => MyOrderPage(),
        '/pay': (BuildContext context) => PayPage(),
        '/paycomplete': (BuildContext context) => PayCompletePage(),
        '/add': (BuildContext context) => AddPage(),
        '/wish': (BuildContext context) => WishListPage(),
        '/donation': (BuildContext context) => DonationPage(),
        '/': (BuildContext context) => HomePage(),
        '/mystuff' : (BuildContext context) => MyStuffPage(),
        '/detail' : (context) => DetailPage(),
        '/category' : (BuildContext context) => CategoryPage(),
        '/edit': (BuildContext context) => EditPage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
