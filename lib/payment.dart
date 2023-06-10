import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late final docId;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      docId = arguments['docId'];
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
            try {} on StateError catch (e) {}
            return Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Price',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text('${doc['price']}') // firebase
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/paycomplete', arguments: {'docId': docId, 'name': doc['name']},);
                      },
                      child: Text('Pay Now!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text(
                  'Payment',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
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
              body: SingleChildScrollView(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    children: [
                      Container(
                        width: 370,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 38),
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
                                SizedBox(width: 50),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 25),
                                    // firebase
                                    Text(
                                      doc['name'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 7),
                                    Text(doc['category']), // firebase
                                  ],
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['detail'],
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PRICE',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Text('${doc['price']}') // firebase
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LOCATION',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 136,
                                  ),
                                  Text(doc['location']) // firebase
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 30),
                              Text(
                                'CHAT ROOM URL',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc['url']), // firebase
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }
        });
  }
}
