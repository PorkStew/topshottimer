import 'package:flutter/material.dart';
import './timer.dart';
import './Profile.dart';
import './Settings.dart';

class pageSelector extends StatefulWidget {
  @override
  _pageSelectorState createState() => _pageSelectorState();
}

class _pageSelectorState extends State<pageSelector> {
  int _selectedPage = 0;
  final _pageOptions = [
    TimerPage(),
    Profile(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });

        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              title: Text('Profile')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          ),
        ],
      ),
    );
  }
}
