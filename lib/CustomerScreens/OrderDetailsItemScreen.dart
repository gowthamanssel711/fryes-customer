import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemModels/OrderDetailsItemModel.dart';

class OrderDetailsItemScreen extends StatefulWidget {
  OrderDetsilsModel orderdetails;
  OrderDetailsItemScreen({@required this.orderdetails});

  @override
  _OrderDetailsItemScreenState createState() => _OrderDetailsItemScreenState();
}

class _OrderDetailsItemScreenState extends State<OrderDetailsItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Center(
                        child: Icon(Icons.lens, size: 15, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.orderdetails.text,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.orderdetails.price,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(widget.orderdetails.number,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
