class BetPageModel {
  // Field

  String b_name, b_detail, b_ImagePath, user_name, doc;
  var b_price, b_timeBet;
  // Method
  BetPageModel(this.b_name, this.b_detail, this.b_ImagePath, this.user_name,
      this.b_price, this.b_timeBet, this.doc);

  BetPageModel.fromMap(Map<String, dynamic> map) {
    b_name = map['p_name'];
    b_detail = map['p_detail'];
    b_ImagePath = map['p_ImagePath'];
    user_name = map['user_name'];
    b_price = map['p_price'];
    b_timeBet = map['p_timeBet'];
    doc = map['documentID'];
  }
}
