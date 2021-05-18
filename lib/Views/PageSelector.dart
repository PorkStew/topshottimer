import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:topshottimer/Views/Subscription/pricing.dart';
// import 'package:noise_meter/noise_meter.dart';
import 'Timer/timer.dart';
import 'Scores/Profile.dart';
import 'Settings/Settings.dart';


class pageSelector extends StatefulWidget {
  @override
  _pageSelectorState createState() => _pageSelectorState();
}

class _pageSelectorState extends State<pageSelector> {

  bool paidMember = false;
  int _selectedPage = 0;
  final _pageOptions = [
    TimerPage(),
    Profile(),
    Settings(),
  ];

  // StreamSubscription<NoiseReading> _noiseSubscription;
  // NoiseMeter _noiseMeter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;

            //Checks if user is paid when selecting the scores page
            if (paidMember == false && _selectedPage == 1 ){
              _selectedPage = 0;
              //Get.to(() => pricing(), arguments: {'pop': true});
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => pricing()));
            }

          });

        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Scores',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
          ),
        ],
      ),
    );
  }
}
