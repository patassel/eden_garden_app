import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


/// Button Rect on View with border color

class SimpleBottomBar extends StatelessWidget {

  final String from;
  final Function(int)? onPressed;

  const SimpleBottomBar({Key? key, required this.from, this.onPressed})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: from=="home" ? Colors.greenAccent.shade100 : from=="search" ? Colors.black87: Colors.lightGreen.shade300, width: 5.0))),
        child: BottomNavigationBar(
          currentIndex: global.currentPage,
          selectedItemColor: from=="home" ? Colors.greenAccent.shade100 : from=="search" ? Colors.black87 : Colors.lightGreen.shade300,
          backgroundColor: Colors.green,
          showUnselectedLabels: false,
          iconSize: 32,
          selectedIconTheme: const IconThemeData(size: 44),
          selectedFontSize: 18,

          onTap: onPressed,

          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp),
              label: 'Account',
              tooltip: 'Account',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'SEARCH',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'GARDEN',
            ),
          ],
        ));
  }
}