import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Screens/Explore.dart';
import 'package:pet_pal_project/Screens/Home.dart';
import 'package:pet_pal_project/Screens/Pets.dart';
import 'package:pet_pal_project/Screens/Profile.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          HomePage(),
          ExplorePage(),
          PetsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: isLandscape
            ? EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Config.mainColor,
            items: <BottomNavigationBarItem>[
              _buildNavItem(Icons.home, 0, isLandscape),
              _buildNavItem(Icons.search, 1, isLandscape),
              _buildNavItem(Icons.pets, 2, isLandscape),
              _buildNavItem(Icons.person, 3, isLandscape),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white70,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index, bool isLandscape) {
    final bool isSelected = _selectedIndex == index;

    // Adjust padding and icon size based on landscape or portrait mode
    final double iconSize = isLandscape ? 24 : 30;
    final double paddingSize = isLandscape ? 6 : 10;

    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(paddingSize),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white70,
          size: iconSize,
        ),
      ),
      label: '',
    );
  }
}
