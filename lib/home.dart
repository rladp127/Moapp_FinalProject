import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        print('go to home');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [
          Text('Handong',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(255, 139, 7, 0.837))),
          Text('Sell',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ))
        ]),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('학부생 김예인님 반갑습니다!'),
            Container(
              width: 1400,
              height: 120,
              margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/donate');
                      },
                      child: Container(
                        height: 300,
                        child: Image.asset(
                          'assets/donate.png',
                          fit: BoxFit.cover,
                          width: 1400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(children: [
              Text('category',
                  style: TextStyle(
                    fontSize: 20,
                  ))
            ]),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 85,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Image.asset('assets/fashion.png', height: 45),
                          Text('Fsashion'),
                        ],
                      )),
                ),
                Container(
                  width: 85,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Image.asset('assets/green.jpeg', height: 45),
                          Text('Electronics'),
                        ],
                      )),
                ),
                Container(
                  width: 85,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Image.asset('assets/green.jpeg', height: 45),
                          Text('Books'),
                        ],
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 85,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Image.asset('assets/green.jpeg', height: 45),
                          Text('Grocery'),
                        ],
                      )),
                ),
                Container(
                  width: 85,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Image.asset('assets/green.jpeg', height: 45),
                          Text('Household'),
                        ],
                      )),
                ),
              ],
            ),
            Container(
              width: 1400,
              height: 85,
              margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color.fromRGBO(255, 139, 7, 0.837),
                elevation: 3,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/donate');
                      },
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 25),
                            Text('내 물건 등록하기',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
