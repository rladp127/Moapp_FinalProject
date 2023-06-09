import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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
  File? _imagefile2;
  bool textScanning = false;
  String scannedText = '';

  final ImagePicker _picker = ImagePicker();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _name = TextEditingController();
  late TextEditingController _price = TextEditingController();
  late TextEditingController _location = TextEditingController();
  late TextEditingController _url = TextEditingController();
  late TextEditingController _description = TextEditingController();
  late TextEditingController _scanned = TextEditingController();
  late String category;
  late String location;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _price = TextEditingController();
    _location = TextEditingController();
    _url = TextEditingController();
    _description = TextEditingController();
    _scanned = TextEditingController();

    _initImage();
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
      return;
    }

    final UploadTask uploadTask = storageRef.putFile(_imagefile!);
    await uploadTask
        .whenComplete(() => print('Image uploaded to Firebase Storage.'));
  }

  @override
  Widget build(BuildContext context) {
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
                          },
                          items: [
                            'book',
                            'electronics',
                            'fashion',
                            'grocery',
                            'household'
                          ].map<DropdownMenuItem<String?>>((String? i) {
                            return DropdownMenuItem<String?>(
                              value: i,
                              child: Text({
                                'book': 'book',
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
                        DropdownButtonFormField<String?>(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xffcfcfcf)),
                          ),
                          onChanged: (String? newValue) {
                            location = newValue!;
                          },
                          items: [
                            '학관',
                            '채플 앞',
                            '커피유야 앞',
                            'E1 주유소'
                          ].map<DropdownMenuItem<String?>>((String? i) {
                            return DropdownMenuItem<String?>(
                              value: i,
                              child: Text({
                                '학관': '학관',
                                '채플 앞': '채플 앞',
                                '커피유야 앞': '커피유야 앞',
                                'E1 주유소': 'E1 주유소',
                              }[i] ??
                                  '선택'),
                            );
                          }).toList(),
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
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '사진의 텍스트를 추출할 수 있습니다.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('스캔을 위해서 버튼을 클릭하세요.'),
                            IconButton(
                              icon: const Icon(
                                Icons.airline_seat_individual_suite_outlined,
                                semanticLabel: 'camera',
                              ),
                              onPressed: () {
                                _takeImageFromCamera2();
                              },
                            ),
                          ]
                        ),
                        Container(
                          height: 100,
                          child: _imagefile2 != null
                              ? Image.file(
                            _imagefile2!,
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
                        Text('scannedText : ${scannedText}'),
                        ElevatedButton(
                            onPressed: () {
                              final updatedText = _scanned.text + scannedText;
                              _scanned.value = _scanned.value.copyWith(
                                text: updatedText,
                                selection: TextSelection.collapsed(offset: updatedText.length),
                              );
                            }
                          ,
                            child: Text('recognized text to field')
                        ),
                        TextField(
                          controller: _scanned,
                          decoration:
                          const InputDecoration(hintText: '스캔된 텍스트 추출하기'),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('product')
                                  .add({
                                'name': _name.text,
                                'price': int.parse(_price.text),
                                'category': category,
                                'location': location,
                                'url': _url.text,
                                'detail': _description.text,
                                'owner': _auth.currentUser?.uid,
                                'likeUser': [],
                                'buy': false,
                              });

                              FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(_auth.currentUser?.displayName)
                                  .update({
                                'addlist': FieldValue.arrayUnion([_name.text]),
                              });
                              _uploadImage();
                              Future.delayed(const Duration(seconds: 1))
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

  Future getText(XFile image) async {
    scannedText = '';
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          setState(() {
            scannedText = scannedText + '  ' + element.text;
            debugPrint(scannedText);
          });
        }
        // scannedText = scannedText + '\n';
      }
    }
    textRecognizer.close();
  }

  _takeImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
          _imagefile = File(image.path);
      });
    }
  }

  _takeImageFromCamera2() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagefile2 = File(image.path);
      });
    }
    await getText(image!);
  }

  _initImage() async {
    ByteData assetData = await rootBundle.load('assets/logo.png');
    Uint8List bytes = assetData.buffer.asUint8List();
    File file = File('images/image.png');
    await file.writeAsBytes(bytes);
  }
}
