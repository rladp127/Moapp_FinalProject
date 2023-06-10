import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var student = [36.10248912130572, 129.38941396568254];
var chapel = [36.10430542742288, 129.39038773873145];
var yuya = [36.080521649536884, 129.39952335287012];
var e1 = [36.080521649536884, 129.39952335287012];

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
  late GoogleMapController mapController;
  List<Marker> _markers = [];
  late final docId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late List<dynamic>? likeUser = <dynamic>[];
  late List<String> wishlist = <String>[];

  late LatLng _center = LatLng(36.10147564919173, 129.39098752933234);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.pushNamed(context, '/');
      } else if (_currentIndex == 1) {
        Navigator.pushNamed(context, '/wish');
      } else if (_currentIndex == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      docId = arguments['docId'];
    }
  }

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
            } on StateError catch (e) {}

            if (snapshot.data!["location"].compareTo("student") == 0) {
              _markers.add(Marker(
                  markerId: MarkerId("1"),
                  draggable: true,
                  position: LatLng(student[0], student[1])));
              _center = LatLng(student[0], student[1]);
            } else if (snapshot.data!["location"].compareTo("chapel") == 0) {
              _markers.add(Marker(
                  markerId: MarkerId("1"),
                  draggable: true,
                  position: LatLng(chapel[0], chapel[1])));
              _center = LatLng(chapel[0], chapel[1]);
            } else if (snapshot.data!["location"].compareTo("yuya") == 0) {
              _markers.add(Marker(
                  markerId: MarkerId("1"),
                  draggable: true,
                  position: LatLng(yuya[0], yuya[1])));
              _center = LatLng(yuya[0], yuya[1]);
            } else {
              _markers.add(Marker(
                  markerId: MarkerId("1"),
                  draggable: true,
                  position: LatLng(e1[0], e1[1])));
              _center = LatLng(e1[0], e1[1]);
            }
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
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.create,
                      semanticLabel: 'modify',
                    ),
                    onPressed: () {
                      if (doc['owner']
                          .compareTo("${_auth.currentUser!.uid}") ==
                          0) {
                        Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: {'docId': doc.id, 'docName': doc['name']},
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      semanticLabel: 'delete',
                    ),
                    onPressed: () {
                      if (doc['owner']
                          .compareTo("${_auth.currentUser!.uid}") ==
                          0) {
                        Navigator.pop(context);
                        Future.delayed(Duration(milliseconds: 500), () {
                          FirebaseFirestore.instance
                              .collection('product')
                              .doc(docId)
                              .delete();

                          final addCollection = FirebaseFirestore
                              .instance
                              .collection("user")
                              .doc(
                              _auth.currentUser!.displayName.toString());
                          String sName = doc['name'];
                          addCollection.update({
                            'addlist': FieldValue.arrayRemove([sName])
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
              body: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    width: 400,
                                    height: 100,
                                    child: FutureBuilder(
                                      future: getIamge('images/${doc["name"]}'),
                                      builder: (context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.network(snapshot.data!);
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                                        icon: likeUser!.contains(
                                            _auth.currentUser!.uid)
                                            ? const Icon(Icons.favorite)
                                            : const Icon(Icons.favorite_border),
                                        color: Colors.red,
                                        onPressed: () {
                                          if (likeUser!.contains(
                                              "${_auth.currentUser!.uid}")) {
                                            isValid = false;
                                          }
                                          if (isValid) {
                                            FirebaseFirestore.instance
                                                .collection('product')
                                                .doc(docId)
                                                .update({
                                              'likeUser':
                                              FieldValue.arrayUnion([
                                                _auth.currentUser!.uid
                                                    .toString()
                                              ]),
                                            });

                                            FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(_auth
                                                .currentUser!.displayName
                                                .toString())
                                                .update({
                                              'wishlist': FieldValue.arrayUnion(
                                                  [doc["name"]]),
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
                                                .doc(_auth
                                                .currentUser!.displayName
                                                .toString());
                                            String sName = doc['name'];

                                            Reference.update({
                                              'wishlist':
                                              FieldValue.arrayRemove(
                                                  [sName])
                                            });

                                            final ProductReference =
                                            FirebaseFirestore.instance
                                                .collection("product")
                                                .doc(docId);
                                            String pName = _auth
                                                .currentUser!.uid
                                                .toString();

                                            ProductReference.update({
                                              'likeUser':
                                              FieldValue.arrayRemove(
                                                  [pName])
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
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
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
                            SizedBox(height: 40),
                            Text('위치',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            SizedBox(height: 10),
                            Container(
                              width: 400,
                              height: 300,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                markers: Set.from(_markers),
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 16.5,
                                ),
                                myLocationButtonEnabled: false,
                              ),
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/pay',
                                          arguments: {'docId': docId});
                                    },
                                    child: Text('Buy Now',
                                        style: TextStyle(color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                    )),
                              ],
                            )
                          ]),
                    ],
                  )),
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
