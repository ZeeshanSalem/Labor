import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labors/Screens/clientRequest.dart';
import 'package:labors/Screens/home.dart';
import 'package:labors/Screens/sideMenu.dart';
import 'package:labors/Shared_Widget/header_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  List<Widget> _screens = [ClientRequest(), CustomMap()];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true, disappearedBackButton: false),
      drawer: SideMenu(),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(onTap: _onItemTapped, items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_from_queue,
              color: _selectedIndex == 0
                  ? Colors.blue
                  : Theme.of(context).primaryColor,
            ),
            title: Text(
              "Client Request",
              style: TextStyle(
                color: _selectedIndex == 0
                    ? Colors.blue
                    : Theme.of(context).primaryColor,
              ),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _selectedIndex == 1
                  ? Colors.blue
                  : Theme.of(context).primaryColor,
            ),
            title: Text(
              "Accepted Requests",
              style: TextStyle(
                color: _selectedIndex == 1
                    ? Colors.blue
                    : Theme.of(context).primaryColor,
              ),
            )),
      ]),
    );
  }
}
