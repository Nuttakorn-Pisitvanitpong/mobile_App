import 'dart:io';
import 'dart:math';
import 'package:dev_Bet/model/model.dart';
import 'package:dev_Bet/model/product_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_Bet/home.dart';
import 'package:dev_Bet/widget/list_pd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddListProduct extends StatefulWidget {
  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  // Field
  File file;
  String p_name, p_detail, urlPicture, user_name, p_price, p_id;
  var p_timeBet;
  DateTime dateTime;
  // Method

  checkMail() async {
    String user_n;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser.uid);
      user_n = auth.currentUser.uid;
      user_name = user_n;
    }
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: Colors.red,
            onPressed: () {
              if (file == null) {
                showAlert(
                    "Please Choose Picture", "Please Click Icon To Upload");
              } else if (p_name == null ||
                  p_name.isEmpty ||
                  p_detail == null ||
                  p_detail.isEmpty) {
                showAlert("Have Space", "Please Fill Every Blank");
              } else {
                // upload
                uploadPicture();
              }
            },
            icon: Icon(Icons.cloud_upload),
            label: Text("Upload Product"),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPicture() async {
    checkMail();
    Random random = Random();
    int i = random.nextInt(100000);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Product/product$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    insertValue();
  }

  Future<void> insertValue() async {
    CollectionReference foodRef = Firestore.instance.collection('product_Bet');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['p_name'] = p_name;
    map['p_detail'] = p_detail;
    map['p_ImagePath'] = urlPicture;
    map['user_name'] = user_name;
    map['p_price'] = int.parse(p_price);
    map['p_timeBet'] = dateTime;
    map['p_id'] = p_id;
    // Food food;
    // food.p_name = p_name;
    // food.p_detail = p_detail;
    // food.urlPicture = urlPicture;
    // food.user_name = user_name;
    // food.p_price = int.parse(p_price);
    // food.dateTime = dateTime;
    // food.p_id = p_id;
    // DocumentReference docRef = await foodRef.add(food.toMap());
    // food.p_id = docRef.documentID;
    // await docRef
    //     .setData(food.toMap(), SetOptions(merge: true))
    //     .then((value) => {});

    await firebaseFirestore.collection('product_Bet').doc().set(map).then(
      (value) {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (value) => ShowListProduct(),
        );
        Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
      },
    );
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  Widget detailForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) {
          p_detail = value.trim();
        },
        decoration: InputDecoration(
          helperText: "Your Product Detail",
          labelText: "Product Detail",
          icon: Icon(Icons.face),
        ),
      ),
    );
  }

  Widget pickDate() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(dateTime == null
              ? "Noting has been picked yet"
              : dateTime.toString()),
          RaisedButton(
            child: Text('Pick Date Close Bet'),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: dateTime == null ? DateTime.now() : dateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2060))
                  .then((date) {
                setState(() {
                  dateTime = date;
                });
              });
            },
          )
        ],
      ),
    );
  }

  Widget priceForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) {
          p_price = value.trim();
        },
        decoration: InputDecoration(
          helperText: "Your Product Price",
          labelText: "Product Price",
          icon: Icon(Icons.face),
        ),
      ),
    );
  }

  Widget nameForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (String string) {
          p_name = string.trim();
        },
        decoration: InputDecoration(
          helperText: "Your Product Name",
          labelText: "Name Product",
          icon: Icon(Icons.face),
        ),
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      // ignore: deprecated_member_use
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.3,
      child: file == null ? Image.asset("images/gggggg.png") : Image.file(file),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showImage(),
          showButton(),
          nameForm(),
          detailForm(),
          priceForm(),
          pickDate(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pause BET', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => Homepage());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              showContent(),
              uploadButton(),
            ],
          ),
        ));
  }
}
