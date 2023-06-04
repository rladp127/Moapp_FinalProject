import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moapp_teamprj/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moapp_teamprj/profile.dart';
import 'home.dart';
import 'main.dart';
import 'wishlist.dart';

late List<dynamic> productId = <dynamic>[];
late List<dynamic> detail = <dynamic>[];
late List<dynamic> location = <dynamic>[];
late List<dynamic> name = <dynamic>[];
late List<dynamic> likeUser = <dynamic>[];
late List<dynamic> price = <dynamic>[];
late List<dynamic> url = <dynamic>[];
late List<dynamic> buy = <dynamic>[];

late List<dynamic> userWish = <dynamic>[];

class CategoryPage extends StatelessWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _CategoryPageState(),
    );
  }
}

class _CategoryPageState extends StatefulWidget {
  const _CategoryPageState({Key? key}) : super(key: key);

  @override
  State<_CategoryPageState> createState() => _CategoryPageState1();
}

class _CategoryPageState1 extends State<_CategoryPageState> {
  late String category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    if (arguments != null) {
      category = arguments["category"] as String;
      print("===> category:" + category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody2(context),
    );
  }

  Widget _buildBody2(BuildContext context) {
    final TextEditingController _search = TextEditingController();


    FirebaseAuth auth = FirebaseAuth.instance;
    print('my display name: ${auth.currentUser!.displayName}\n');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    FirebaseAuth auth = FirebaseAuth.instance;

    snapshot.forEach((element) {
      {
        if (element["category"].compareTo(category) == 0 &&
            !productId.contains(element.id)) {
          productId.add(element.id);

          name.add(element["name"]);
          price.add(element["price"]);
          location.add(element["location"]);
          detail.add(element["detail"]);
          likeUser.add(element["likeUser"]);
          url.add(element["url"]);
          buy.add(element["buy"]);
        }
      }
    });

    print("category🥰 productId: " + productId.toString());
    print("likeUser👍 " + likeUser.toString());

    int current_index = 2;
    final List<Widget> _children = [HomePage(), WishListPage(), ProfilePage()];

    Future<String> getIamge(String name) async {
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child(name);

      try {
        final url = await reference.getDownloadURL();
        return url;
      } catch (e) {
        print('Failed to load image: $e');
        return 'https://handong.edu/site/handong/res/img/logo.png';
      }
    }

    int _currentIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
        if (_currentIndex == 0) {
          print('go to home');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else if (_currentIndex == 1) {
          print('go to heart');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/wish', (Route<dynamic> route) => false);
        } else if (_currentIndex == 2) {
          print('go to profile');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/profile', (Route<dynamic> route) => false);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        itemCount: productId.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print('${productId[index]}');
              Navigator.pushNamed(context, '/detail',
                  arguments: {'docId': productId[index]});

            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                              width: 100,
                              height: 40,
                              child: FutureBuilder(
                                future: getIamge('images/${name[index]}'),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.network(snapshot.data!);
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Image.asset(
                                      'assets/logo.png',
                                      fit: BoxFit.fill,
                                    );
                                  }
                                },
                              )),
                          IconButton(
                            icon: Icon(
                              likeUser[index].contains(auth.currentUser!.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: likeUser[index]
                                  .contains(auth.currentUser!.uid)
                                  ? Colors.red
                                  : null,
                              semanticLabel: likeUser[index]
                                  .contains(auth.currentUser!.uid)
                                  ? 'Remove from saved'
                                  : 'Save',
                            ),
                            onPressed: () {
                              if (likeUser[index]
                                  .contains(auth.currentUser!.uid)) {
                                likeUser[index].remove(auth.currentUser!.uid);

                                final heartCollectionReference =
                                FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(auth.currentUser!.displayName
                                    .toString());
                                heartCollectionReference.update({
                                  'wishlist':
                                  FieldValue.arrayRemove([name[index]])
                                });

                                FirebaseFirestore.instance
                                    .collection('product')
                                    .doc(productId[index])
                                    .update({
                                  'likeUser': FieldValue.arrayRemove(
                                      [auth.currentUser!.uid.toString()]),
                                });
                              } else {
                                likeUser[index]
                                    .add(auth.currentUser!.uid.toString());
                                FirebaseFirestore.instance
                                    .collection('product')
                                    .doc(productId[index])
                                    .update({
                                  'likeUser': FieldValue.arrayUnion(
                                      [auth.currentUser!.uid.toString()]),
                                });

                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(auth.currentUser!.displayName
                                    .toString())
                                    .update({
                                  'wishlist':
                                  FieldValue.arrayUnion([name[index]]),
                                });
                              }
                            },
                          ),
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          name[index],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text('${price[index]}'),
                        SizedBox(
                          height: 6,
                        ),
                        Text(category),
                        if (buy[index]) Text('판매 완료') else Text('판매중'),
                      ], //children
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped, // 항목을 눌렀을 때 호출될 콜백 함수
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Heart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
