import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fryes_customer/CustomerScreens/AddOnsScreen.dart';
import 'package:fryes_customer/ItemModels/AddOnsModel.dart';
import 'OrderdItemsScreen.dart';
import 'package:fryes_customer/ItemModels/CartModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:localstorage/localstorage.dart';

class CustomerCartScreen extends StatefulWidget {
  final int index;

  CustomerCartScreen({@required this.index});

  @override
  _CustomerCartScreenState createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  List<CartModel> ordermodel = [];

  String canteen = ' ';
  String can_blo = ' ';
  int total_price = 0;

  List<AddOnsModel> addonsmodel = [
    AddOnsModel(text: "Idli", number: "0", price: 'rs. 20'),
    AddOnsModel(text: "Idli", number: "0", price: 'rs. 20'),
    AddOnsModel(text: "Idli", number: "0", price: 'rs. 20'),
  ];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("fubction called");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index > 0) {
      print("called index " + widget.index.toString());
    }

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      get_cart();
    });

    final LocalStorage db_details = new LocalStorage('fryes');
    List items = db_details.getItem('fryes');
    items.forEach((element) {
      print(element["institution"]);
      setState(() {
        canteen = element["canteen"];
        can_blo = element["institution"] + " - " + element["canteen"];
      });
    });
  }

  Future get_cart() async {
    FirebaseDatabase db = new FirebaseDatabase();
    QuerySnapshot qn = await db
        .reference()
        .child("psg_itech")
        .child("student2_email")
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          ordermodel.add(
            CartModel(
              text: values['name'],
              number: values['number'],
              price: values['price'],
            ),
          );
          total_price = 50 + (int.parse(values['number']));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text("Ordering to ",
                          style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 15),
                      Text(can_blo,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text("Items",
                          style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 15),
                      Text("Rs.230",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text("Ordered Items",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 175,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 200,
                child: ListView.builder(
                  itemCount: ordermodel.length,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(left: 16),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return OrderItemsScreen(cartmodel: ordermodel[index]);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text("add-ons",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: ListView.builder(
                  itemCount: ordermodel.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AddOnsScreen(addonsmodel: addonsmodel[index]);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("bill details",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    Row(
                      children: <Widget>[
                        Text("[Dine in ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red[300],
                                fontWeight: FontWeight.w700)),
                        Text(" @ ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        Text(" 12:30 PM ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red[300],
                                fontWeight: FontWeight.w700)),
                        Text(" in ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        Text(canteen + " ]",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red[300],
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Items ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    Text(total_price.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Packaging ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    Text(" rs.200 ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Service Charge ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    Text(" rs.200 ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.7,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" total ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    Text(" rs.200 ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
                height: 40,
                margin: EdgeInsets.all(20),
                child: RaisedButton(
                  color: Colors.red[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Checkout",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future generate_qr() async {}
}
