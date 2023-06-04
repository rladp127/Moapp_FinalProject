import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

String? getCurrentUserUid() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return null;
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;
  late final docId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late List<dynamic>? likeUser = <dynamic>[];
  late List<String> wishlist = <String>[];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        print('go to home');
        Navigator.pushNamed(context, '/');
      } else if (_currentIndex == 1) {
        print('go to heart');
        Navigator.pushNamed(context, '/wish');
      } else if (_currentIndex == 2) {
        print('go to profile');
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      docId = arguments['docId'];
      print("docId: $docId");
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
  //   if (arguments != null) {
  //     docId = arguments["docID"] as String;
  //     print("===> docId:" + docId);
  //   }
  // }

  bool isValid = true;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('product')
            .doc(docId)
            .snapshots(),
        builder: (BuildContext, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final doc = snapshot.data!;

            try {
              snapshot.data!["likeUser"].forEach((element) {
                if (!likeUser!.contains(element)) {
                  likeUser?.add(element);
                }
              });
              print("likeUser: " + likeUser.toString());
            } on StateError catch (e) {}
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    semanticLabel: 'pop',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                              width: 400,
                              height: 100,
                              child: FutureBuilder(
                                future: getIamge('images/${doc["name"]}'),
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
                                      width: 800,
                                    );
                                  }
                                },
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  alignment: Alignment.centerRight,
                                  icon:
                                  likeUser!.contains(_auth.currentUser!.uid)
                                      ? const Icon(Icons.favorite)
                                      : const Icon(Icons.favorite_border),
                                  color: Colors.red,
                                  onPressed: () {
                                    if (likeUser!.contains(
                                        "${_auth.currentUser!.uid}")) {
                                      isValid = false;
                                      print("isValid: ${isValid}");
                                    }
                                    if (isValid) {
                                      FirebaseFirestore.instance
                                          .collection('product')
                                          .doc(docId)
                                          .update({
                                        'likeUser': FieldValue.arrayUnion([
                                          _auth.currentUser!.uid.toString()
                                        ]),
                                      });

                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(_auth.currentUser!.displayName.toString())
                                          .update({
                                        'wishlist': FieldValue.arrayUnion([doc["name"]]),
                                      });

                                      const snackBar = SnackBar(
                                        content: Text('I LIKE IT!'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isValid = false;
                                    } else {
                                      final Reference = FirebaseFirestore
                                          .instance
                                          .collection("user")
                                          .doc(_auth.currentUser!.displayName.toString());
                                      String sName = doc['name'];

                                      Reference.update({
                                        'wishlist': FieldValue.arrayRemove([sName])
                                      });
                                      print('♥♥♥♥♥♥♥♥♥♥︎$docId');

                                      final ProductReference = FirebaseFirestore
                                          .instance
                                          .collection("product")
                                          .doc(docId);
                                      String pName =  _auth.currentUser!.uid.toString();
                                      print('♥♥♥♥♥♥♥♥♥!!!!!!︎$pName');

                                      ProductReference.update({
                                        'likeUser': FieldValue.arrayRemove([pName])
                                      });
                                      Navigator.pop(context);
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(doc['category'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.grey)),
                      Text(doc['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      Text("${doc['price']}",
                          style: TextStyle(
                            fontSize: 15,
                          )),
                      SizedBox(height: 20),
                      Container(
                        height: 80,
                        color: Colors.grey[200],
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/donate');
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        Text('거래 희망 장소',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            )),
                                        SizedBox(width: 10),
                                        Text(doc['location']),
                                      ],
                                    ),
                                  ),
                                  Text(doc['url']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      SizedBox(height: 5),
                      Text(doc['detail'],
                          style: TextStyle(color: Colors.black45)),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              child: Text('Buy Now', style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                              )),
                        ],
                      )
                    ]),
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
        });
  }
}
