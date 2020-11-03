class ProductselectModel {
  // Field

  String p_name, p_detail, p_ImagePath, user_name, p_id;
  var p_price, p_timeBet;
  // Method
  ProductselectModel(this.p_name, this.p_detail, this.p_ImagePath,
      this.user_name, this.p_price, this.p_timeBet, this.p_id);

  ProductselectModel.fromMap(Map<String, dynamic> map) {
    p_name = map['p_name'];
    p_detail = map['p_detail'];
    p_ImagePath = map['p_ImagePath'];
    user_name = map['user_name'];
    p_price = map['p_price'];
    p_timeBet = map['p_timeBet'];
    p_id = map['p_id'];
  }
}
