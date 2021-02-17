class OrderItems {
  String name;
  String quantity;
  String price;
  OrderItems({this.name, this.quantity, this.price});
  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['quantity'] = quantity;
    m['price'] = price;

    return m;
  }
}

class OrderList {
  List<OrderItems> orderitems;
  OrderList() {
    orderitems = new List();
  }
  toJSONEncodable() {
    return orderitems.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
