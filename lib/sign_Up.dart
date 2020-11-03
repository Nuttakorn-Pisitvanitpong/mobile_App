import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Dialog.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //ประกาศตัวแปลให้เก็บค่าที่เรากรอกใน textfield
  String email, password, confpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          BlackButtonWidget(),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.mail), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    onChanged: (value) => email =
                        value.trim(), //ค่าที่เรากรอกได้เอาไปเก็บในตัวแปล
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => password = value.trim(),
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    onChanged: (value) => confpassword = value.trim(),
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Confirm password'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 60,
                child: RaisedButton(
                  //ปุ่มกด ใส่เงือนไขเอง
                  onPressed: () {
                    if (password == null ||
                        password.isEmpty ||
                        email == null ||
                        email.isEmpty ||
                        confpassword == null ||
                        confpassword.isEmpty) {
                      normalDialog(context,
                          'Please fill in all fields.'); // normalDialog ดึงมาจากหน้าอื่น สร้างคลาสแยกไว้ ตรง nuility
                    } else if (password != confpassword ||
                        confpassword != password && password.length >= 6) {
                      normalDialog(context, 'Password mismatch.');
                    } else {
                      checksighin(); //เรียกใช้ฟังค์ชันที่เชื่อมต่อ Firebase
                    }
                  },
                  color: Colors.orange[900],
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //ฟังค์ชันเชือม Firebase ของ SignUp ตอนสมัคร
  Future<void> checksighin() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print("Sign up user successful.");
      MaterialPageRoute
          materialPageRoute = //  4 บรรทัดนี้  เวลาสมัครเสร็จจะให้กลับไปหน้า Login ใหม่
          MaterialPageRoute(builder: (BuildContext context) => Login()); //
      Navigator.of(context).pushAndRemoveUntil(
          //
          materialPageRoute,
          (Route<dynamic> route) => false); //
    }).catchError((error) {
      normalDialog(context, 'กรุณากรอกข้อมูลใหม่');
    });
  }
}

class BlackButtonWidget extends StatelessWidget {
  const BlackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'images/gggggg.jpg'))), // รูปภาพต้องเอาไปใส่หน้้า pubspec.yaml ก่อนนะ
      child: Positioned(
          //  ข้างซ้ายล่างอ่ะ บรรทัด 57 อ่ะ
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        MaterialPageRoute route =
                            MaterialPageRoute(builder: (value) => Login());
                        Navigator.push(context, route);
                      })
                ],
              )),
          Positioned(
            bottom: 20,
            child: Text(
              '  Create New Account',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      )),
    );
  }
}
