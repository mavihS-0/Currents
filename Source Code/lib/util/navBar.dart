import 'package:currents/screens/feed.dart';
import 'package:currents/screens/home.dart';
import 'package:currents/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  //declaring variables
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );
  //setting initial index as My Feed page
  int index =1;
  final screens = [
    HomePage(),
    FeedPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle ,
        padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
        shape: bottomBarShape,

        ///configuration for SnakeNavigationBar.color
        backgroundColor: DarkShade,
        snakeViewColor: SuperLightShade,
        selectedItemColor: TextColor,
        unselectedItemColor: Colors.white,

        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Feed'),
        ],
      ),
    );
  }
}
