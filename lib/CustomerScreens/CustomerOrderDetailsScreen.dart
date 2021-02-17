import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemModels/OrderDetailsItemModel.dart';
import 'package:fryes_customer/CustomerScreens/OrderDetailsItemScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:localstorage/localstorage.dart';

class CustomerOrderDetailsScreen extends StatefulWidget {
  @override
  _CustomerOrderDetailsScreenState createState() =>
      _CustomerOrderDetailsScreenState();
}

class _CustomerOrderDetailsScreenState
    extends State<CustomerOrderDetailsScreen> {
  List<OrderDetsilsModel> allitems = [
    OrderDetsilsModel(text: "Idli", number: "x1", price: 'rs. 20'),
    OrderDetsilsModel(text: "Idli", number: "x3", price: 'rs. 20'),
    OrderDetsilsModel(text: "Idli", number: "x2", price: 'rs. 20'),
  ];
  bool exp_status = false;
  String name = "name";
  String email = "email";
  String _qrdata = "name_email";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_details();
  }

  Future get_details() async {
    final LocalStorage storage = new LocalStorage('user_storage');
    List items = storage.getItem('user_storage');
    items.forEach((element) {
      print(element["name"]);
      setState(() {
        name = element["name"];
        email = element["email"];
        _qrdata = name + "_" + email + "_" + "1";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Text("Order Details",
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 300),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      exp_status = !exp_status;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                            leading: Icon(Icons.dinner_dining),
                            title: Text(
                              "PRESENT ORDER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ));
                      },
                      isExpanded: exp_status,
                      body: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(" OrderItems ",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                        Text(" rs.200 ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: QrImage(
                                    data: _qrdata,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                    itemCount: allitems.length,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.only(left: 16),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return OrderDetailsItemScreen(
                                          orderdetails: allitems[index]);
                                    }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.timer),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("12:01 PM",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("A-Block  ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.local_dining),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("Dine-in  ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                        height: 40,
                                        width: 100,
                                        margin: EdgeInsets.all(20),
                                        child: RaisedButton(
                                          color: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            side: BorderSide(
                                                color: Colors.red[300]),
                                          ),
                                          onPressed: () {},
                                          child: Text("cancel",
                                              style: TextStyle(
                                                  color: Colors.red[300],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
