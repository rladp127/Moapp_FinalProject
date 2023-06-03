import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> donationSite = ['green', 'theFellowship', 'saveTheChildren'];
List<String> images = [
  'assets/green.jpeg',
  'assets/theFellowship.png',
  'assets/saveTheChildren.png'
];

class DonationPage extends StatefulWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('물건 기부하기'),
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
      body: ListView(children: [
        SizedBox(height: 20),
        Center(child: Text('안쓰는 물건을 기부할 수 있습니다')),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: donationSite.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    height: 200,
                    margin: EdgeInsets.all(20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 200,
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                                width: 800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
