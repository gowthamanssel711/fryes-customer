import 'package:flutter/material.dart';
import 'CustomerAccountScreen.dart';
import 'CustomerCartScreen.dart';
import 'CustomerHomeScreen.dart';
import 'CustomerOrderDetailsScreen.dart';

class CustomerMainScreen extends StatefulWidget {
  @override
  _CustomerMainScreenState createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _currentindex = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageList.add(CustomerHomeScreen());
    pageList.add(CustomerCartScreen(index: _currentindex));
    pageList.add(CustomerOrderDetailsScreen());
    pageList.add(CustomerAccountScreen());

    print("indexed stack lenght " + pageList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   body: IndexedStack(
      //      index: _currentindex,
      ///      children: pageList,
      //    ),

      body: getbodywidget(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        currentIndex: _currentindex,
        onTap: (index) {
          if (_currentindex == 1) {
            print("cart screen called ");
          }
          setState(() {
            _currentindex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "order"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), label: "Order Details"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "settings"),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  getbodywidget() {
    if (_currentindex == 0) {
      return CustomerHomeScreen();
    }
    if (_currentindex == 1) {
      return CustomerCartScreen(index: _currentindex);
    }
    if (_currentindex == 2) {
      return CustomerOrderDetailsScreen();
    }
    if (_currentindex == 3) {
      return CustomerAccountScreen();
    }
  }
}
