import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marine_manager/presentation/pages/account_page.dart';
import 'package:marine_manager/presentation/pages/containers_page.dart';
import 'package:marine_manager/presentation/pages/routes_page.dart';
import 'package:marine_manager/presentation/pages/ships_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        onPageChanged: _onPageChanged,
        children: const [
          ContainersPage(),
          ShipsPage(),
          RoutesPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Containers',
            icon: Icon(LineIcons.box),
          ),
          BottomNavigationBarItem(
            label: 'Ships',
            icon: Icon(LineIcons.ship),
          ),
          BottomNavigationBarItem(
            label: 'Routes',
            icon: Icon(LineIcons.route),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(LineIcons.user),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _controller.jumpToPage(
      index,
      // duration: const Duration(milliseconds: 200),
      // curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
