import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class PayCompletePage extends StatefulWidget {
  PayCompletePage({Key? key}) : super(key: key);

  @override
  _PayCompletePageState createState() => _PayCompletePageState();
}

class _PayCompletePageState extends State<PayCompletePage> {
  late final docId;
  late final docName;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      docId = arguments['docId'];
      docName = arguments['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 700,
        color: Colors.orangeAccent,
        child: Row (
          children: [
            SizedBox(width: 85),
            Column(
              children: [
                SizedBox(height: 200),
                Icon(Icons.check_circle_outlined, size: 100, color: Colors.white70),
                SizedBox(height: 30),
                Text('Thank You!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
                Text('Your order has been placed.', style: TextStyle(color: Colors.white)),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('product')
                        .doc(docId)
                        .update({
                      'buy': true,
                    });

                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(auth.currentUser!.displayName)
                        .update({
                      'orderlist': FieldValue.arrayUnion(
                          [docName]),
                    });
                    // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    // Navigator.pushNamed(context, '/');
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => route.settings.name == '/',
                    );
                  },
                  child: Text('   Return Home   ', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      )
    );
  }
}
