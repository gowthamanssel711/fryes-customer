import 'package:flutter/material.dart';
import 'package:fryes_customer/ItemScreens/AllItemScreens.dart';
import 'package:fryes_customer/ItemModels/AllItemModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:localstorage/localstorage.dart';

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

PageStorageKey mykey = new PageStorageKey("homepage");

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final PageStorageBucket _bucket = new PageStorageBucket();

  List<AllItemModels> allitems = List<AllItemModels>();
  List<AllItemModels> temp_list = List<AllItemModels>();
  List<AllItemModels> sorted_items = List<AllItemModels>();
  List<AllItemModels> tk_di_sort = List<AllItemModels>();

  DateTime _dateTime = DateTime.now();
  String selecteed_time = "12:00";

  String _categoryselection = 'veg';
  int id = 1;
  int _groupValue = -1;
  String _tk_di = "TK & DI";
  String _points_loco = "canteen";
  String tk_di_st = "dine_in";
  static DateTime utc_fm = DateTime.now();
  String utc_format = utc_fm.hour.toString() + ":" + utc_fm.minute.toString();
  List<String> _locations = ['Point A', 'Point B', 'Point C']; // Option 2
  String _selectedLocation;
  String order_loco = ' ';
  bool exp_status = false;
  bool _dinein = true;
  bool _takeaway = true;

  List<String> dinein_list = ["dinein"];
  List<String> takeaway_list = ["takeaway"];

  @override
  void initState() {
    super.initState();
    final LocalStorage storage = new LocalStorage('fryes');
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      final firestore = FirebaseFirestore.instance;
      getAllItems().then((value) {});
    });
    List items = storage.getItem('fryes');
    items.forEach((element) {
      print(element["institution"]);
      setState(() {
        order_loco = element["institution"] + " - " + element["canteen"];
      });
    });
  }

  Future getAllItems() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("psgtech").get();
    qn.docs.forEach((element) {
      print(element.data()["price"]);
      if (!element.data()["take_away"]) {
        print("take away working");
      }
      setState(() {
        allitems.add(
          AllItemModels(
              type: element.data()["type"],
              text: element.data()["name"],
              number: "0",
              dinein: element.data()["dine_in"],
              takeaway: element.data()["take_away"],
              price: element.data()["price"],
              tk_di: element.data()["take_away"],
              from: element.data()["from"],
              to: element.data()["to"]),
        );
      });

      setState(() {
        temp_list = allitems;
      });
    });
  }

  Future sortbytk_di() async {
    setState(() {
      tk_di_sort = [];
      if (_dinein & !_takeaway) {
        _tk_di = "Dine in";
      }
      if (_takeaway && !_dinein) {
        _tk_di = "Takeaway";
      }

      if (_takeaway && _dinein) {
        _tk_di = "TK & DI";
      }
    });

    temp_list.forEach((element) {
      if (_dinein && _takeaway) {
        print("dish sorted  " + element.text);

        setState(() {
          tk_di_sort.add(AllItemModels(
              type: element.type,
              text: element.text,
              number: "0",
              dinein: element.dinein,
              takeaway: element.takeaway,
              price: element.price,
              tk_di: element.tk_di,
              from: element.from,
              to: element.to));
        });
      }

      if (_dinein && !_takeaway) {
        print("dish sorted  " + element.text);

        if (element.dinein) {
          setState(() {
            tk_di_sort.add(AllItemModels(
                type: element.type,
                text: element.text,
                number: "0",
                dinein: element.dinein,
                takeaway: element.takeaway,
                price: element.price,
                tk_di: element.tk_di,
                from: element.from,
                to: element.to));
          });
        }
      }

      if (!_dinein && _takeaway) {
        print("dish sorted  " + element.text);
        if (element.takeaway) {
          setState(() {
            tk_di_sort.add(AllItemModels(
                type: element.type,
                text: element.text,
                number: "0",
                dinein: element.dinein,
                takeaway: element.takeaway,
                price: element.price,
                tk_di: element.tk_di,
                from: element.from,
                to: element.to));
          });
        }
      }
    });

    sortitems("time");
  }

  Future sortitems(String time) async {
    print(" pop up selected time   " + utc_format);
    List<AllItemModels> sorted_items = List<AllItemModels>();
    DateFormat dateFormat = DateFormat("HH:mm");
    DateTime user_time = dateFormat.parse("14:40");

    DateTime present_time = dateFormat.parse(utc_format);
    tk_di_sort.forEach((element) {
      DateTime from_time = dateFormat.parse(element.from);

      DateTime to_time = dateFormat.parse(element.to);

      if (present_time.isAfter(from_time) && present_time.isBefore(to_time)) {
        print("dish sorted  " + element.text);

        setState(() {
          sorted_items.add(AllItemModels(
              type: element.type,
              text: element.text,
              number: "0",
              dinein: element.dinein,
              takeaway: element.takeaway,
              price: element.price,
              tk_di: element.tk_di,
              from: element.from,
              to: element.to));
        });
      }
    });

    setState(() {
      allitems = sorted_items;
    });

    sorted_items.forEach((element) {
      print("sorted dishes " + element.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        key: mykey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            // child: SingleChildScrollView(
            //   physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        exp_status = !exp_status;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              leading: Icon(Icons.location_city),
                              title: Text(
                                "ORDERING TO " + order_loco,
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
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                              child: InkWell(
                                            onTap: () {
                                              print("select time");
                                              select_category();
                                            },
                                            child: Icon(Icons.restaurant_menu,
                                                size: 25, color: Colors.black),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                _tk_di,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                              child: InkWell(
                                            onTap: () {
                                              print("select time");
                                              select_category();
                                            },
                                            child: Icon(Icons.location_on,
                                                size: 25, color: Colors.black),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                _points_loco,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                              child: InkWell(
                                            onTap: () {
                                              print("select time");
                                              showAlertDialog(context);
                                            },
                                            child: Icon(Icons.timer,
                                                size: 25, color: Colors.black),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                selecteed_time,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                      ),
                    ]),
                Container(
                  child: Column(
                    children: <Widget>[
                      DefaultTabController(
                        length: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                tabs: [
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Fav",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Rice",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Roti",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                ],
                                labelColor: Colors.black,
                                indicatorColor: Colors.red[300],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                //Add this to give height
                                height:
                                    MediaQuery.of(context).size.height - 325,
                                child: TabBarView(children: [
                                  Container(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: allitems.length,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.only(left: 16),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return AllItemScreen(
                                            itemVeg: allitems[index]);
                                      },
                                    ),
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
                                        return AllItemScreen(
                                            itemVeg: allitems[index]);
                                      },
                                    ),
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
                                          return AllItemScreen(
                                              itemVeg: allitems[index]);
                                        }),
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
                                        return AllItemScreen(
                                            itemVeg: allitems[index]);
                                      },
                                    ),
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
                                          return AllItemScreen(
                                              itemVeg: allitems[index]);
                                        }),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget hourMinute15Interval() {
    return new TimePickerSpinner(
      spacing: 40,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the list options

    Widget hourMinute12H() {
      return new TimePickerSpinner(
        spacing: 20,
        minutesInterval: 5,
        is24HourMode: false,
        onTimeChange: (time) {
          setState(() {
            _dateTime = time;
          });
        },
      );
    }

    Widget hourMinuteSecond() {
      return new TimePickerSpinner(
        isShowSeconds: true,
        onTimeChange: (time) {
          setState(() {
            _dateTime = time;
          });
        },
      );
    }

    Widget hourMinute15Interval() {
      return new TimePickerSpinner(
        spacing: 40,
        minutesInterval: 15,
        onTimeChange: (time) {
          setState(() {
            _dateTime = time;
          });
        },
      );
    }

    Widget hourMinute12HCustomStyle() {
      return new TimePickerSpinner(
        is24HourMode: false,
        normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
        highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
        spacing: 50,
        itemHeight: 80,
        isForce2Digits: true,
        minutesInterval: 15,
        onTimeChange: (time) {
          setState(() {
            _dateTime = time;
          });
        },
      );
    }

    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      children: <Widget>[
        hourMinute12H(),
        Row(
          children: <Widget>[
            SizedBox(
              width: 45,
            ),
            RaisedButton(
              color: Colors.red[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Navigator.pop(context);
                print(_dateTime.toUtc());

                setState(() {
                  utc_format = _dateTime.hour.toString() +
                      ":" +
                      _dateTime.minute.toString();
                });
                sortitems("time");
                if (_dateTime.hour >= 12) {
                  if (_dateTime.hour - 12 == 0) {
                    setState(() {
                      selecteed_time =
                          (1).toString() + " : " + _dateTime.minute.toString();
                    });
                  } else {
                    setState(() {
                      selecteed_time = (_dateTime.hour - 12).toString() +
                          " : " +
                          _dateTime.minute.toString();
                    });
                  }
                }

                if (_dateTime.hour < 12) {
                  setState(() {
                    selecteed_time = _dateTime.hour.toString() +
                        " : " +
                        _dateTime.minute.toString();
                  });
                }
              },
              child: Text("ok",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              width: 20,
            ),
            RaisedButton(
              color: Colors.red[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            )
          ],
        )
        // hourMinute15Interval(),
//            hourMinuteSecond(),
//            hourMinute12HCustomStyle(),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Future select_category() async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Row(
              children: <Widget>[
                Text("Select Your Option "),
              ],
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        children: dinein_list
                            .map((t) => CheckboxListTile(
                                  title: Text(t),
                                  value: _dinein,
                                  onChanged: (val) {
                                    setState(() {
                                      _dinein = val;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        children: takeaway_list
                            .map((t) => CheckboxListTile(
                                  title: Text(t),
                                  value: _takeaway,
                                  onChanged: (val) {
                                    setState(() {
                                      _takeaway = val;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  hint: Text('Choose Point'), // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                      _points_loco = newValue;
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        child: Text("set"),
                        // submitstatus == "disable" ? null : () => getrequest()
                        onPressed: () {
                          //String not_vull = widget.canteendb.demo("ab");
                          Navigator.pop(context);
                          sortbytk_di();
                        }),
                    FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ]);
            }),
          );
        });
  }
}
