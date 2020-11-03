class Data {
  final int price;
  final String url;
  final String id;
  final String detail;
  final String pd_name;
  final String time;
  Data({this.url, this.price, this.detail, this.pd_name, this.time, this.id});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["price"] = price;
    data["url"] = this.url;
    data['detail'] = this.detail;
    data['pd_name'] = this.pd_name;
    data['time'] = this.time;
    data['id'] = this.id;
    return data;
  }
}
