import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7,),
                Text('Price', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                Text('Price won') // firebase
              ],
            ),
            ElevatedButton(
              onPressed: () {
                print('pay complete');
                Navigator.pushNamed(context, '/paycomplete');
              },
              child: Text('Pay Now!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: Text('Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
      SingleChildScrollView(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              Container(
                width: 370,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              child: Center(
                  child: Column (
                    children: [
                      SizedBox(height: 38),
                      Image.network(
                        'https://picsum.photos/250?image=9',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 50),
                      Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          // firebase
                          Text('Product name', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                          SizedBox(height: 7),
                          Text('category'), // firebase
                        ],
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DETAILS', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 160,),
                          Text('Product price won') // firebase
                        ],
                      ),
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOCATION', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 136,),
                          Text('Product Location') // firebase
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 30),
                      Text('CHAT ROOM URL', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('kakao opt chat url ...'), // firebase
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
          )
      ),
    );
  }
}