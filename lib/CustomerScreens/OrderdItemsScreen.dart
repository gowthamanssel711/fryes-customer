import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemModels/CartModel.dart';

class OrderItemsScreen extends StatefulWidget {
  CartModel cartmodel;
  OrderItemsScreen({@required this.cartmodel});
  @override
  _OrderItemsScreenState createState() => _OrderItemsScreenState();
}

class _OrderItemsScreenState extends State<OrderItemsScreen> {
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
                          widget.cartmodel.text,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.cartmodel.price,
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
                    if (widget.cartmodel.number != "0") ...[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red[300]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.cartmodel.number =
                                  (int.parse(widget.cartmodel.number) - 1)
                                      .toString();
                            });
                          },
                          child: Center(
                            child: Icon(Icons.remove,
                                size: 25, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(
                      width: 30.0,
                    ),
                    if (widget.cartmodel.number != "0") ...[
                      Text(
                        widget.cartmodel.number.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        // border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          print("add test");
                          setState(() {
                            widget.cartmodel.number =
                                (int.parse(widget.cartmodel.number) + 1)
                                    .toString();
                          });
                        },
                        child: Center(
                          child: Icon(Icons.add, size: 25, color: Colors.black),
                        ),
                      ),
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
