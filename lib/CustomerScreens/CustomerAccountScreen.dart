import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fryes_customer/localstorage_canteen/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => new ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, theme, child) => MaterialApp(
            theme: theme.getTheme(),
            home: Scaffold(
              appBar: AppBar(
                title: Text('Hybrid Theme'),
              ),
              body: Row(
                children: [
                  Container(
                    child: FlatButton(
                      onPressed: () => {
                        print('Set Light Theme'),
                        theme.setLightMode(),
                      },
                      child: Text('Set Light Theme'),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: () => {
                        print('Set Dark theme'),
                        theme.setDarkMode(),
                      },
                      child: Text('Set Dark theme'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CustomerAccountScreen extends StatefulWidget {
  @override
  _CustomerAccountScreenState createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
  bool isSwitched = false;
  String name = ' ';
  String email = ' ';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() => {get_details()});
  }

  Future get_details() async {
    final LocalStorage storage = new LocalStorage('user_storage');
    List items = storage.getItem('user_storage');
    items.forEach((element) {
      print(element["name"]);
      setState(() {
        name = element["name"];
        email = element["email"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => new ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, child) => MaterialApp(
          theme: theme.getTheme(),
          home: Scaffold(
            body: Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("account",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w700)),
                      Row(
                        children: <Widget>[
                          Icon(Icons.wb_sunny),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                              if (isSwitched) {
                                print("dark");
                                theme.setDarkMode();
                              }
                              if (!isSwitched) {
                                print("dark");
                                theme.setLightMode();
                              }
                            },
                            activeTrackColor: Colors.red[300],
                            activeColor: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Center(
                          child:
                              Icon(Icons.lens, size: 15, color: Colors.green),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: <Widget>[
                          Text(name,
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(email),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.replay),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("my orders",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.business),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("change institution",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("Invite",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.message),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("feedback",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.info),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("how to use",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 60,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.library_books),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("policies",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[Icon(Icons.arrow_forward_ios)],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.all(20),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: Colors.red[300]),
                        ),
                        onPressed: () async {
                          await Firebase.initializeApp();
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text("Logout",
                            style: TextStyle(
                                color: Colors.red[300],
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
