import '../../Maps/MapScreen.dart';
import '../../Orders/CreatOrder.dart';
import '../../Orders/orders.dart';
import 'DriverHomePage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Appnav extends StatefulWidget {
  final int initialIndex;
  final Widget? newScreen;

  Appnav({this.initialIndex = 0, this.newScreen});

  @override
  _AppnavState createState() => _AppnavState();
}

class _AppnavState extends State<Appnav> {
  late PersistentTabController _controller;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  void dispose() {
    for (final element in _scrollControllers) {
      element.dispose();
    }
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [DriverHomepage(), Orders(), CreateOrderScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.green.shade300,
          inactiveColorPrimary: Color(0xFF9FA8DA),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.visibility),
          title: "Manage Orders",
          activeColorPrimary: Colors.green.shade300,
          inactiveColorPrimary: Color(0xFF9FA8DA),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.new_label),
          title: "Order",
          activeColorPrimary: Colors.green.shade300,
          inactiveColorPrimary: Color(0xFF9FA8DA),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.grey.shade200,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 400),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style3,
    );
  }
}
