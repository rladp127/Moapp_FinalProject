import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        print('go to home');
      } else if (_currentIndex == 1) {
        print('go to heart');
      } else if (_currentIndex == 2) {
        print('go to profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 100,
            child: Image.asset(
              'assets/green.jpeg',
              fit: BoxFit.cover,
              width: 800,
            ),
          ),
          SizedBox(height: 40),
          Text('Fashion',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey)),
          Text('아이다스 운동화 270mm',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )),
          Text('5000',
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
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            Text('거래 희망 장소',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                )),
                            SizedBox(width: 10),
                            Text('서운광장 앞'),
                          ],
                        ),
                      ),
                      Text('https://open.kako.com/o/gF'),
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
          Text('거의 안 신은 새 신발입니다!', style: TextStyle(color: Colors.black45)),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  child: Text('Add to WishList'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontWeight: FontWeight.bold))),
              ElevatedButton(
                  onPressed: () {},
                  child: Text('Buy Now'),
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
}
