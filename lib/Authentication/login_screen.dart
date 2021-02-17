import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fryes_customer/WelcomeScreen/WelcomeScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';

class StorageItems {
  String name;
  String email;

  StorageItems({this.name, this.email});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['email'] = email;

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//4
  final StorageList list = new StorageList();
  final LocalStorage user_storage = new LocalStorage('user_storage');
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Firebase.initializeApp();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _regKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _conformpassword = TextEditingController();

  String pas_st = ' ';
  bool _success;
  String _userEmail;
  bool _passwordstatus = true;
  String reg_status = ' ';
  bool signin_status = false;
  String user_name = ' ';
  // FirebaseAuth _auth = FirebaseAuth.instance;

  void _register() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }

  Future<String> _sigin() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final fire_store = FirebaseFirestore.instance;
    try {
      final UserCredential user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text));

      await fire_store
          .collection("users")
          .doc(_emailController.text)
          .get()
          .then((querySnapshot) async {
        print(querySnapshot.data()["name"]);
        await user_storage.clear();
        if (querySnapshot != null) {
          list.details.add(new StorageItems(
              name: querySnapshot.data()["name"],
              email: querySnapshot.data()["email"]));
          await user_storage.setItem('user_storage', list.toJSONEncodable());
          setState(() {
            user_name = querySnapshot.data()["name"];
          });
        }
      });
      setState(() {
        signin_status = true;
      });
      return "logged in";
    } catch (e) {
      print("login error ");
      setState(() {
        signin_status = false;
      });
      print(e.code);
      return e.code;
    }
  }

  Future<String> _registeruser() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final fire_store = FirebaseFirestore.instance;
    print("register called ");
    print(_name.text + " " + _email.text + "  " + _password.text);

    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ))
          .user;
      if (user != null) {
        fire_store.collection("users").doc(_email.text).set({
          "name": _name.text,
          "email": _email.text,
        });
        setState(() {
          _success = true;
          _userEmail = user.email;
          reg_status = ' Account Created ! ';
        });
      } else {
        setState(() {
          _success = true;
          reg_status = 'Failed Try Again ';
        });
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      print(e.code);
      setState(() {
        reg_status = e.code;
      });
    }

    return "created";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: Text("firebase auth"),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
//5
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                FirebaseAuth _auth = FirebaseAuth.instance;
                final User user = await _auth.currentUser;
                if (user == null) {
//6
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await _auth.signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ), */
      body: Builder(builder: (BuildContext context) {
//7
        return ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(
              height: 300,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.white30,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          CircularProgressIndicator();
                          _sigin().then((value) => {
                                if (signin_status)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WelcomeScreen(
                                                title: user_name))),
                                  },
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(value),
                                )),
                              });
                        }
                      },
                      child: const Text('Sign in '),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () {},
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          print("craete account");
                          _openPopup(context);
                        },
                        child: Text("New User ? Create Account here "),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success
                            ? reg_status + " " + _userEmail
                            : reg_status)),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  _openPopup(context) {
    Alert(
      context: context,
      title: "CREATE ACCOUNT",
      content: Form(
        key: _regKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'name'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter Email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _conformpassword,
              decoration: const InputDecoration(labelText: ' Confirm Password'),
              validator: (String value) {
                if (value.isNotEmpty) {
                  if (_password.text != value) {
                    return 'Password not match';
                  }
                }
                if (value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
            ),
            RaisedButton(
              color: Colors.white30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
                if (_regKey.currentState.validate()) {
                  _registeruser().then((value) => {
                        print("back called"),
                        Navigator.pop(context),
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(reg_status),
                        )),
                      });
                  print("working");
                }
              },
              child: const Text(' Create Account '),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ).show();
  }
}
