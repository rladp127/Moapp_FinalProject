import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main.dart';
String username = '';
String url = '';

Future<String> getGoogleProfilePhotoUrl() async {
  final User? user = FirebaseAuth.instance.currentUser;
  username = user!.displayName!;


  if (user != null) {
    return user.photoURL ?? '';
  } else {
    throw Exception('사용자가 로그인되어 있지 않습니다.');
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _photoUrl;
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else if (_currentIndex == 1) {
        Navigator.of(context).pushNamedAndRemoveUntil('/wish', (Route<dynamic> route) => false);
      } else if (_currentIndex == 2) {
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _photoUrl = getGoogleProfilePhotoUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              semanticLabel: 'logout',
            ),
            onPressed: () {
              Future<void> signOut() async {
                await Firebase.initializeApp();
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, '/login');
                } catch (e) {
                  print(e.toString());
                }
              }
              signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 50.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<String>(
                  future: _photoUrl,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final photoUrl = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              photoUrl!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 30,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 6,),
                              Text(
                                '$username',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/myorder');
                            },
                            child: Container(
                              width: 370,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Row (
                                  children: [
                                    SizedBox(width: 20),
                                    Icon(Icons.wallet),
                                    SizedBox(width: 20),
                                    Column (
                                      children: [
                                        SizedBox(height: 25),
                                        Text('View Orders', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                        Text('view your complete order list')
                                      ],
                                    )
                                  ],
                                )
                              ),
                            )
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/mystuff');
                              },
                              child: Container(
                                width: 370,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                    child: Row (
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.stadium_outlined),
                                        SizedBox(width: 20),
                                        Column (
                                          children: [
                                            SizedBox(height: 25),
                                            Text('View My Stuffs', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                            Text('view all stuffs you uploaded')
                                          ],
                                        )
                                      ],
                                    )
                                ),
                              )

                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ],
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
