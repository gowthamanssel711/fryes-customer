import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fryes_customer/CustomerScreens/CustomerMainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StorageItems {
  String institution;
  String canteen;

  StorageItems({this.institution, this.canteen});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['institution'] = institution;
    m['canteen'] = canteen;

    return m;
  }
}

class StorageList {
  List<StorageItems> details;

  StorageList() {
    details = new List();
  }

  toJSONEncodable() {
    return details.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class CollegeSugg {
  static final List<String> states = [
    'ABC College',
    'PSG TECH',
    'CIT',
    'KCT',
    'SKCIT'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class CanteenService {
  static final List<String> states = [
    'A Block',
    'B Block',
    'C Block',
    'D Block',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final StorageList list = new StorageList();

  final LocalStorage storage = new LocalStorage('fryes');
  final GlobalKey<FormState> _canKey = GlobalKey<FormState>();
  final TextEditingController _institute = TextEditingController();
  final TextEditingController _canteen = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init started");
    Firebase.initializeApp().whenComplete(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //    resizeToAvoidBottomPadding: false,

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "hello " + widget.title,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _canKey,
                  child: Column(
                    children: [
                      Container(
                          height: 47,
                          width: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                hintText: 'Choose your Institution',
                                border: InputBorder.none,
                              ),
                              controller: _institute,
                            ),
                            suggestionsCallback: (pattern) async {
                              return await CollegeSugg.getSuggestions(pattern);
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Choose Institute';
                              }
                            },
                            onSuggestionSelected: (suggestion) {
                              this._institute.text = suggestion;
                            },
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          height: 47,
                          width: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                hintText: 'Choose your Canteen',
                                border: InputBorder.none,
                              ),
                              controller: _canteen,
                            ),
                            suggestionsCallback: (pattern) async {
                              return await CanteenService.getSuggestions(
                                  pattern);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Choose Canteen';
                              }
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              this._canteen.text = suggestion;
                            },
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //  Text("you can change it later inside the app",
                //        style: TextStyle(fontSize: 10)),
                Container(
                  height: 380,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(Icons.lens, size: 15, color: Colors.green),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 47,
                    width: 250,
                    margin: EdgeInsets.all(20),
                    child: RaisedButton(
                      color: Colors.red[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        await storage.clear();
                        if (_canKey.currentState.validate()) {
                          list.details.add(new StorageItems(
                              institution: _institute.text,
                              canteen: _canteen.text));
                          await storage.setItem(
                              'fryes', list.toJSONEncodable());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerMainScreen()));
                          print("working");
                        }
                      },
                      child: Text("get started",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
