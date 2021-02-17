import 'package:flutter/material.dart';

class AllItemModels {
  String text;
  String price;
  String number;
  bool tk_di;
  String from;
  String to;
  String type;
  bool dinein;
  bool takeaway;

  AllItemModels({
    @required this.text,
    @required this.price,
    @required this.number,
    @required this.tk_di,
    @required this.from,
    @required this.to,
    @required this.type,
    @required this.dinein,
    @required this.takeaway,
  });
}
