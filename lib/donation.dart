import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> donationSite = ['green', 'theFellowship', 'saveTheChildren'];
List<String> images = [
  'assets/green.jpeg',
  'assets/theFellowship.png',
  'assets/saveTheChildren.png'
];

void openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


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
                            onTap: () {
                              if (index == 0)
                                openLink('https://www.childfund.or.kr/regularSpon/regular.do?mcode=7&utm_source=google_pc&utm_medium=search_ad&utm_campaign=%EC%B4%88%EB%A1%9D%EC%9A%B0%EC%82%B0_%EB%B8%8C%EB%9E%9C%EB%93%9C_pc&utm_content=%EB%B8%8C%EB%9E%9C%EB%93%9C_%EC%9E%90%EC%82%AC%EB%AA%85&utm_term=%EC%B4%88%EB%A1%9D%EC%9A%B0%EC%82%B0%EC%96%B4%EB%A6%B0%EC%9D%B4%EC%9E%AC%EB%8B%A8&gad=1&gclid=Cj0KCQjw7PCjBhDwARIsANo7CglwiWDJHBY5MWqPNRVgU3jKWSBrUsFvedfLXkJTFxDq86P02sGPk6oaAurfEALw_wcB',);
                              else if (index == 2)
                                openLink('https://www.sc.or.kr/program/program.do');
                              else openLink('https://www.ifcj.kr/?utm_source=google&utm_medium=p_sa&utm_campaign=A_%EB%B8%8C%EB%9E%9C%EB%93%9C&utm_content=Broad&utm_term=%EB%8D%94%ED%8E%A0%EB%A1%9C%EC%9A%B0%EC%8B%AD&gclid=Cj0KCQjw7PCjBhDwARIsANo7CgnVFv9-LjJrvM2D0sdu0vf5hQvW43OAsGnaD3Mugdo0iN6IqcRwEPUaAo25EALw_wcB');
                            },
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
