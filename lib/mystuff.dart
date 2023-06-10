import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
late List<dynamic> buy = <dynamic>[];
late List<dynamic> productId = <dynamic>[];


late List<dynamic> userWish = <dynamic>[];
late List<dynamic> studyHeart = <dynamic>[];
late List<dynamic> contained = <dynamic>[]; // true false
late List<dynamic> idx = <dynamic>[]; // userHeart와 studyHeart 겹치는 index

class MyStuffPage extends StatelessWidget {
  MyStuffPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MyStuffPageState(),
    );
  }
}

class _MyStuffPageState extends StatefulWidget {
  const _MyStuffPageState({Key? key}) : super(key: key);

  @override
  State<_MyStuffPageState> createState() => _MyStuffPageState1();
}

class _MyStuffPageState1 extends State<_MyStuffPageState> {
  int _currentIndex = 0;
  final TextEditingController _search = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else if (_currentIndex == 1) {
      } else if (_currentIndex == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody2(context),
    );
  }

  Widget _buildBody2(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(auth.currentUser!.displayName.toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildBody(context, snapshot);
      },
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs, userSnapshot);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      AsyncSnapshot<DocumentSnapshot> userSnapshot) {
    FirebaseAuth auth = FirebaseAuth.instance;

    snapshot.forEach((element) {
      {
        productId.add(element.id);

        name.add(element["name"]);
        price.add(element["price"]);
        location.add(element["location"]);
        detail.add(element["detail"]);
        owner.add(element["owner"]);
        url.add(element["url"]);
        category.add(element["category"]);
        buy.add(element["buy"]);
      }
    });

    userSnapshot.data!["addlist"].forEach((element) {
      for (int i = 0; i < name.length; i++) {
        if (name[i].compareTo(element) == 0) {
          if (!userWish.contains(name[i])) {
            userWish.add(element);
          }
        }
      }
    });

    idx = findIndex(context, name, userWish);

    Future<String> getIamge(String name) async {
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child(name);

      try {
        final url = await reference.getDownloadURL();
        return url;
      } catch (e) {
        return 'https://handong.edu/site/handong/res/img/logo.png';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 등록한 물건',
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
      body: ListView.builder(
        itemCount: idx.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/detail',
                  arguments: {'docId': productId[idx[index]]});
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      child: FutureBuilder(
                        future: getIamge('images/${userWish[index]}'),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Image.network(snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.fill,
                              width: 700,
                            );
                          }
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userWish[index],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${price[idx[index]]}'),
                        SizedBox(
                          height: 7,
                        ),
                        Text('${category[idx[index]]}'),
                        if (buy[idx[index]]) Text('판매 완료') else Text('판매중')
                        // SizedBox(
                        //   width: width,
                        //   child: Text(
                        //     '${member[idx[index]]}/${number[idx[index]]}',
                        //     style: TextStyle(
                        //         fontSize: 15, color: Colors.grey[500]),
                        //   ),
                        // ),
                      ], //children
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

List<dynamic> findIndex(
    BuildContext context, List<dynamic> name, List<dynamic> userWish) {
  List<dynamic> index = <dynamic>[];
  for (int i = 0; i < userWish.length; i++) {
    contained.add(true);
    index.add(name.indexOf(userWish[i]));
  }
  return index;
}
