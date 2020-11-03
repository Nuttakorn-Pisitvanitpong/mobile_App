import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String p_id;
  String p_name;
  String p_detail;
  String urlPicture;
  String user_name;
  int p_price;
  DateTime dateTime;

  Food();

  Food.fromMap(Map<String, dynamic> data) {
    p_id = data['p_id'];
    p_name = data['p_name'];
    p_detail = data['p_detail'];
    urlPicture = data['p_ImagePath'];
    user_name = data['user_name'];
    p_price = data['p_price'];
    dateTime = data['p_timeBet'];
    Food food;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': p_id,
      'p_name': p_name,
      'p_detail': p_detail,
      'p_ImagePath': urlPicture,
      'user_name': user_name,
      'p_price': p_price,
      'p_timeBet': dateTime,
    };
  }
}
