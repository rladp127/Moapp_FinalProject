import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'main.dart';

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File? _imagefile;

  final ImagePicker _picker = ImagePicker();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _name = TextEditingController();
  late TextEditingController _price = TextEditingController();
  late TextEditingController _location = TextEditingController();
  late TextEditingController _url = TextEditingController();
  late TextEditingController _description = TextEditingController();
  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _price = TextEditingController();
    _location = TextEditingController();
    _url = TextEditingController();
    _description = TextEditingController();

    _initImage();
    print("init imagefile: ${_imagefile}");
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _location.dispose();
    _url.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('images/${_name.text}');

    if (_imagefile == null) {
      // final UploadTask uploadTask = storageRef.putFile(File(https://handong.edu/site/handong/res/img/logo.png));
      // await uploadTask
      //   .whenComplete(() => print('Image uploaded to Firebase Storage.'));
      return;
    }

    final UploadTask uploadTask = storageRef.putFile(_imagefile!);
    await uploadTask
        .whenComplete(() => print('Image uploaded to Firebase Storage.'));
  }

  @override
  Widget build(BuildContext context) {
    late String category;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
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
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '물품 이름',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        TextField(
                          controller: _name,
                          decoration:
                          const InputDecoration(hintText: '물품 이름을 입력하세요.'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              '사진 첨부하기',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown),
                            ),
                            Container(
                              height: 100,
                              child: _imagefile != null
                                  ? Image.file(
                                _imagefile!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.fill,
                                width: 100,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                semanticLabel: 'camera',
                              ),
                              onPressed: _takeImageFromCamera,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '상품 가격',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        TextField(
                          controller: _price,
                          decoration:
                          const InputDecoration(hintText: '상품의 가격을 입력하세요.'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '카테고리',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        DropdownButtonFormField<String?>(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xffcfcfcf)),
                          ),
                          onChanged: (String? newValue) {
                            category = newValue!;
                            print(newValue);
                          },
                          items: [
                            'books',
                            'electronics',
                            'fashion',
                            'grocery',
                            'household'
                          ].map<DropdownMenuItem<String?>>((String? i) {
                            return DropdownMenuItem<String?>(
                              value: i,
                              child: Text({
                                'books': 'books',
                                'electronics': 'electronics',
                                'fashion': 'fashion',
                                'grocery': 'grocery',
                                'household': 'household'
                              }[i] ??
                                  '선택'),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '희망 거래 장소',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        TextField(
                          controller: _location,
                          decoration: const InputDecoration(
                              hintText: '희망하는 거래 장소를 입력하세요.'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '카카오톡 오픈채팅방 URL',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        TextField(
                          controller: _url,
                          decoration: const InputDecoration(
                              hintText: '오픈채팅방 주소를 입력하세요.'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '상품 설명',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        TextField(
                          controller: _description,
                          decoration:
                          const InputDecoration(hintText: '상품의 설명을 입력하세요.'),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Add New Product');
                              // Navigator.pushNamed(context, '/home');
                              // TODO : firebase, go to home!!
                              FirebaseFirestore.instance
                                  .collection('product')
                                  .add({
                                'name': _name.text,
                                'price': int.parse(_price.text),
                                'category': category,
                                'location': _location.text,
                                'url': _url.text,
                                'detail': _description.text,
                                'owner': _auth.currentUser?.uid,
                                'likeUser': [],
                                'buy': false
                              });
                              _uploadImage();
                              Future.delayed(const Duration(seconds: 2))
                                  .then((val) {
                                Navigator.pop(context);
                              });
                            },
                            child: Text('Add New Product',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
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
                    )),
              ],
            )),
      ),
    );
  }

  _takeImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagefile = File(image!.path);
      });
    }
  }

  _initImage() async {
    ByteData assetData = await rootBundle.load('assets/logo.png');
    Uint8List bytes = assetData.buffer.asUint8List();
    File file = File('images/image.png');
    await file.writeAsBytes(bytes);
  }
}
