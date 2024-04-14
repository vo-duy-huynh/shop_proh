import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_proh/features/account/screens/account_screen.dart';
import 'package:shop_proh/features/cart/screens/cart_screen_test.dart';
import 'package:shop_proh/features/cart/screens/wish_list_screen.dart';
import 'package:shop_proh/home/screens/chat_screen.dart';
import 'package:shop_proh/home/screens/home_screen.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:badges/badges.dart' as badge;

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _showSearchOverlay = false;

  void toggleSearchOverlay() {
    setState(() {
      _showSearchOverlay = !_showSearchOverlay;
    });
  }

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const CartScreenTest(),
    const WishListScreen(),
    const AccountScreen(),
    const ChatScreen(),
  ];

  void updatePage(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    final userWishlistLen = context.watch<UserProvider>().user.wishlist.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: const Color(0xFFFD725A),
        unselectedItemColor: Colors.grey,
        currentIndex: _page,
        onTap: updatePage,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
            icon: badge.Badge(
              badgeContent: Text(
                userCartLen.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: badge.BadgePosition.topEnd(top: -13, end: 0),
              child: Icon(Icons.shopping_cart_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: badge.Badge(
              badgeContent: Text(
                userWishlistLen.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: badge.BadgePosition.topEnd(top: -13, end: 0),
              child: Icon(Icons.favorite_border_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: ''),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ChatScreen.routeName);
        },
        backgroundColor: const Color(0xFFFD725A),
        shape: const CircleBorder(),
        child: const Icon(Icons.chat_bubble_outline),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
