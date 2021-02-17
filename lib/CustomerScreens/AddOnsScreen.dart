import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemModels/AddOnsModel.dart';

class AddOnsScreen extends StatefulWidget {
  AddOnsModel addonsmodel;
  AddOnsScreen({@required this.addonsmodel});

  @override
  _AddOnsScreenState createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends State<AddOnsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Center(
                              child: Icon(Icons.lens,
                                  size: 15, color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Text(widget.addonsmodel.text,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.addonsmodel.price),
                              Row(
                                children: <Widget>[
                                  if (widget.addonsmodel.number != "0") ...[
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.red[300]),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.addonsmodel.number =
                                                (int.parse(widget.addonsmodel
                                                            .number) -
                                                        1)
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
                                    width: 5,
                                  ),
                                  if (widget.addonsmodel.number != "0") ...[
                                    Text(
                                      widget.addonsmodel.number.toString(),
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
                                          widget.addonsmodel.number =
                                              (int.parse(widget
                                                          .addonsmodel.number) +
                                                      1)
                                                  .toString();
                                        });
                                      },
                                      child: Center(
                                        child: Icon(Icons.add,
                                            size: 25, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
