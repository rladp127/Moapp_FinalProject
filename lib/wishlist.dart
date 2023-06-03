import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moapp_teamprj/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

late List<dynamic> products = <dynamic>[];
late List<dynamic> category = <dynamic>[];
late List<dynamic> detail = <dynamic>[];
late List<dynamic> location = <dynamic>[];
late List<dynamic> name = <dynamic>[];
late List<dynamic> owner = <dynamic>[];
late List<dynamic> price = <dynamic>[];
late List<dynamic> url = <dynamic>[];


late List<dynamic> userHeart = <dynamic>[];
late List<dynamic> studyHeart = <dynamic>[];
late List<dynamic> contained = <dynamic>[]; // true false
late List<dynamic> idx = <dynamic>[]; // userHeart와 studyHeart 겹치는 index

class WishListPage extends StatelessWidget {
  WishListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _WishListPageState(),
    );
  }
  // @override
  // _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends StatefulWidget {
  const _WishListPageState({Key? key}) : super(key: key);

  @override
  State<_WishListPageState> createState() => _WishListPageState1();
}

class _WishListPageState1 extends State<_WishListPageState> {
  int _currentIndex = 0;
  final TextEditingController _search = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        print('go to home');
        Navigator.pushNamed(context, '/home');
      } else if (_currentIndex == 1) {
        print('go to heart');
      } else if (_currentIndex == 2) {
        print('go to profile');
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody2(context),
    );
    //   Scaffold(
    //   appBar: AppBar(
    //     title: Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
    //     leading: IconButton(
    //       icon: Icon(
    //         Icons.arrow_back,
    //       ),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance.collection('user').doc().snapshots(),
    //
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       }
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const CircularProgressIndicator();
    //       }
    //
    //       List<Product> products = snapshot.data!.docs.map((doc) {
    //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //         return Product(
    //           name: data['name'],
    //           price: data['price'],
    //           location: data['location'],
    //           url: data['url'],
    //           detail: data['detail'],
    //           owner: data['owner'],
    //         );
    //       }).toList();
    //
    //       if (products.isEmpty) {
    //         return const Text('No products found.');
    //       }
    //
    //       return GridView.count(
    //         crossAxisCount: 2,
    //         padding: const EdgeInsets.all(16.0),
    //         childAspectRatio: 8.0 / 9.0,
    //         children: products.asMap().entries.map((entry) {
    //           int index = entry.key;
    //           Product product = entry.value;
    //           String docId = snapshot.data!.docs[index].id;
    //
    //           return Card(
    //             clipBehavior: Clip.antiAlias,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Expanded(
    //                   child: Padding(
    //                     padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: <Widget>[
    //                         // Text(
    //                         //   '$index, $docId',
    //                         //   maxLines: 1,
    //                         // ),
    //                         Text(
    //                           // data['name'],
    //                           product.name,
    //                           maxLines: 1,
    //                         ),
    //                         Text(
    //                           '${product.price}',
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.end,
    //                           children: [
    //                             TextButton(
    //                               style: TextButton.styleFrom(primary: Colors.blue),
    //                               child: const Text('more', style: TextStyle(fontSize: 15)),
    //                               onPressed: () {
    //                                 Navigator.pushNamed(context, '/detail', arguments: docId);
    //                               },
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         }).toList(),
    //       );
    //     },
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _currentIndex,
    //     onTap: _onItemTapped, // 항목을 눌렀을 때 호출될 콜백 함수
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.favorite),
    //         label: 'Heart',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person),
    //         label: 'Profile',
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildBody2(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    print('my display name: ${auth.currentUser!.displayName}\n');

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.displayName.toString()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildBody(context, snapshot);
      },
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
    FirebaseAuth auth = FirebaseAuth.instance;
    print('userSnapshot ???????? ${userSnapshot}');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs, userSnapshot);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
    // var user = FirebaseAuth.instance.authStateChanges();
    FirebaseAuth auth = FirebaseAuth.instance;

    snapshot.forEach((element) {
      {
        print('우아아아아아아아 이름 ${element["name"]}');
        // name.add(element["name"]);
        // price.add(element["price"]);
        // location.add(element["location"]);
        // detail.add(element["detail"]);
        // owner.add(element["owner"]);
        // url.add(element["url"]);
      }
    });
    print('each price ::::::: $price');

    // userSnapshot.data!["wishlist"].forEach((element) {
    //   for(int i = 0; i < products.length; i++) {
    //     if(products[i].compareTo(element)==0) {
    //       if(!userHeart.contains(products[i])) {
    //         userHeart.add(element);
    //       }
    //     }
    //   }
    // });

    return Text('hi');
  }
}
