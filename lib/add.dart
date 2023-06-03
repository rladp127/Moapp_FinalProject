import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController _name = TextEditingController();
    final TextEditingController _price = TextEditingController();
    final TextEditingController _location = TextEditingController();
    final TextEditingController _url = TextEditingController();
    final TextEditingController _description = TextEditingController();
    String selectedCategory = 'books'; // 초기 선택된 항목
    late String category;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('물품 이름', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                      TextField(
                        controller: _name,
                        decoration: const InputDecoration(hintText: '물품 이름을 입력하세요.'),
                      ),
                      SizedBox(height: 30,),
                      Row (
                        children: [
                          Text('사진 첨부하기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                          IconButton(
                            onPressed: () async {
                              // TODO : image upload (image picker!)
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              semanticLabel: 'camera',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text('상품 가격', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                      TextField(
                        controller: _price,
                        decoration: const InputDecoration(hintText: '상품의 가격을 입력하세요.'),
                      ),

                      SizedBox(height: 30,),
                      Text('카테고리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),

                      DropdownButtonFormField<String?>(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                        ),
                        onChanged: (String? newValue) {
                          category = newValue!;
                          print(newValue);
                        },
                        items: ['books', 'electronics', 'fashion', 'grocery', 'household'].map<DropdownMenuItem<String?>>((String? i) {
                          return DropdownMenuItem<String?> (
                            value: i,
                            child: Text({'books': 'books', 'electronics': 'electronics', 'fashion' : 'fashion', 'grocery' : 'grocery', 'household' : 'household'}[i] ?? '선택'),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 30,),
                      Text('희망 거래 장소', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                      TextField(
                        controller: _location,
                        decoration: const InputDecoration(hintText: '희망하는 거래 장소를 입력하세요.'),
                      ),

                      SizedBox(height: 30,),
                      Text('카카오톡 오픈채팅방 URL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                      TextField(
                        controller: _url,
                        decoration: const InputDecoration(hintText: '오픈채팅방 주소를 입력하세요.'),
                      ),

                      SizedBox(height: 30,),
                      Text('상품 설명', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.brown),),
                      TextField(
                        controller: _description,
                        decoration: const InputDecoration(hintText: '상품의 설명을 입력하세요.'),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            print('Add New Product');
                            // Navigator.pushNamed(context, '/home');
                            // TODO : firebase, go to home!!
                          },
                          child: Text('Add New Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 70),
                            backgroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  )
                ),
              ],
            )
        ),
      ),
    );
  }
}
