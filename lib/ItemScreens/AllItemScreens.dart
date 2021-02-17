import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemModels/AllItemModels.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:localstorage/localstorage.dart';

class AllItemScreen extends StatefulWidget {
  AllItemModels itemVeg;

  AllItemScreen({@required this.itemVeg});

  @override
  _AllItemScreenState createState() => _AllItemScreenState();
}

class _AllItemScreenState extends State<AllItemScreen> {
  final LocalStorage storage = new LocalStorage('fryes_orderitems');
  final Color redColor = Colors.red;

  String db_coll = '';
  String canteen = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final LocalStorage db_details = new LocalStorage('fryes');
    List items = db_details.getItem('fryes');
    items.forEach((element) {
      print(element["institution"]);
      setState(() {
        canteen = element["canteen"];
        db_coll = element["institution"] + " - " + element["canteen"];
      });
    });
    print("db loco " + db_coll);
  }

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
                    if (widget.itemVeg.type == 'egg') ...[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.yellow),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Center(
                          child:
                              Icon(Icons.lens, size: 15, color: Colors.yellow),
                        ),
                      ),
                    ],
                    if (widget.itemVeg.type == 'non_veg') ...[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Center(
                          child: Icon(Icons.lens, size: 15, color: Colors.red),
                        ),
                      ),
                    ],
                    if (widget.itemVeg.type == 'veg') ...[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Center(
                          child:
                              Icon(Icons.lens, size: 15, color: Colors.green),
                        ),
                      ),
                    ],
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.itemVeg.text,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.itemVeg.price,
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
                    if (widget.itemVeg.number != "0") ...[
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
                              widget.itemVeg.number =
                                  (int.parse(widget.itemVeg.number) - 1)
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
                    if (widget.itemVeg.number != "0") ...[
                      Text(
                        widget.itemVeg.number.toString(),
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
                            widget.itemVeg.number =
                                (int.parse(widget.itemVeg.number) + 1)
                                    .toString();
                          });
                          store_temp_order(widget.itemVeg.text,
                              widget.itemVeg.price, widget.itemVeg.number);
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

  Future store_temp_order(String name, String price, String number) {
    print(name);
    print(price);
    print(number);
    String user_option = "take_away";
    int old_quantity = 0;
    int old_quantity_tk_di = 0;

    FirebaseDatabase db = new FirebaseDatabase();

    db
        .reference()
        .child("date_canteen_name_college")
        .child("tk_and_di")
        .child(name)
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) {
        print(values["quantity"]);
        old_quantity_tk_di = int.parse(values['quantity']);
      });
    });

    db
        .reference()
        .child("date_canteen_name_college")
        .child("take_away")
        .child(name)
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) {
        print(values["quantity"]);
        old_quantity = int.parse(values['quantity']);
      });
    });

    db.reference().child("psg_itech").child("student2_email").child(name).set({
      "name": name,
      "price": price,
      "number": number,
      "time": "12:30",
      "category": "take_away"
    });

    db
        .reference()
        .child("date_cateen_name_college")
        .child("take_away")
        .child(name)
        .set({
      "quantity": old_quantity + int.parse(number),
      "time": "12:30",
      "category": "take_away",
      "static_quan": number,
      "name": name
    });

    db
        .reference()
        .child("date_cateen_name_college")
        .child("tk_and_di")
        .child(name)
        .set({
      "quantity": old_quantity_tk_di + int.parse(number),
      "time": "12:30",
      "category": "take_away",
      "static_quan": number,
      "name": name
    });
  }
}
