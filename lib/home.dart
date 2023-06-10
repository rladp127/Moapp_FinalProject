import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

final List<String> category = [
  'fashion',
  'electronics',
  'book',
  'household',
  'grocery'
];

List<double> value = [
  0,
  0,
  0,
  0,
  0,
];

int total = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<PieChartSectionData> _chartSections() {
  final List<PieChartSectionData> list = [];

  for (int i = 0; i < category.length; i++) {
    const double radius = 40.0;
    final data = PieChartSectionData(
      title: category[i],
      value: value[i],
      radius: radius,
    );
    list.add(data);
  }

  return list;
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   _buildBody2(context);
  //   print("initState!!!!!!!!");
  // }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
      } else if (_currentIndex == 1) {
        Navigator.pushNamed(context, '/wish');
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
    final TextEditingController _search = TextEditingController();

    FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    total = 0;
    for (int i = 0; i < category.length; i++) {
      value[i] = 0;
    }
    snapshot.forEach((element) {
      {
        total++;
        for (int i = 0; i < category.length; i++) {
          if (element["category"].compareTo(category[i]) == 0) {
            value[i]++;
          }
        }
      }
    });

    for (int i = 0; i < category.length; i++) {
      value[i] = (value[i] / total) * 100;
    }

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
          child: ListView(
            children: [
              Column(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        '${_auth.currentUser!.displayName.toString()}님 반갑습니다!',
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    totalRepeatCount: 4,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
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
                              Navigator.pushNamed(context, '/donation');
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/category',
                              arguments: {'category': 'fashion'});
                        },
                        child: Container(
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
                                  Text('Fashion'),
                                ],
                              )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/category',
                              arguments: {'category': 'electronics'});
                        },
                        child: Container(
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
                                  Image.asset('assets/electronic.png',
                                      height: 45),
                                  Text('Electronics'),
                                ],
                              )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/category',
                              arguments: {'category': 'book'});
                        },
                        child: Container(
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
                                  Image.asset('assets/books.png', height: 45),
                                  Text('Books'),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/category',
                              arguments: {'category': 'grocery'});
                        },
                        child: Container(
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
                                  Image.asset('assets/grocery.png', height: 45),
                                  Text('Grocery'),
                                ],
                              )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/category',
                              arguments: {'category': 'household'});
                        },
                        child: Container(
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
                                  Image.asset('assets/household.png',
                                      height: 45),
                                  Text('Household'),
                                ],
                              )),
                        ),
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
                              Navigator.pushNamed(context, '/add');
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
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: PieChart(PieChartData(
                        sections: _chartSections(),
                        centerSpaceRadius: 48.0,
                      ))),
                ],
              ),
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
}
